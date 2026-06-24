// lib/features/auth/cubit/auth_cubit.dart

import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../../../core/error/auth_exception.dart';
import '../../../../core/service/auth_service.dart';
import '../../../../core/service/auth_user.dart';
import '../../../../core/service/secure_storage_service.dart';
import '../../../../core/service/token_refresh.dart';

part 'auth_state.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AuthCubit
// ─────────────────────────────────────────────────────────────────────────────
//
// Responsibilities:
//   • Boot-time session restoration (HydratedCubit)
//   • Phone + OTP registration / login flow
//   • Token refresh with proactive expiry guard
//   • Logout / account suspension handling
//   • OTP resend cooldown ticker
//   • KYC status surface to routing layer
//
// Dependencies (injected via GetIt):
//   • AuthService        — API calls (send OTP, verify OTP, refresh token)
//   • SecureStorageService — stores refresh token in flutter_secure_storage
//   • TokenRefreshService  — background timer that calls refreshToken()
//
// ─────────────────────────────────────────────────────────────────────────────

class AuthCubit extends HydratedCubit<AuthState> {
  AuthCubit({
    required AuthService authService,
    required SecureStorageService secureStorage,
    required TokenRefreshService tokenRefreshService,
  }) : _authService = authService,
       _secureStorage = secureStorage,
       _tokenRefreshService = tokenRefreshService,
       super(const AuthState.initial());

  final AuthService _authService;
  final SecureStorageService _secureStorage;
  final TokenRefreshService _tokenRefreshService;

  Timer? _otpCooldownTimer;
  Timer? _tokenExpiryTimer;

  // ───────────────────────────────────────────────────────────────────────────
  // Boot / Hydration
  // ───────────────────────────────────────────────────────────────────────────

  /// Called once from [main.dart] after [HydratedBloc.storage] is ready.
  /// Validates the restored session and kicks off background token refresh.
  Future<void> initialise() async {
    // HydratedCubit already restored state; now validate the session.
    if (state.user == null) {
      emit(state.unauthenticated);
      return;
    }

    final user = state.user!;

    // Attempt to silently refresh if access token is stale or close to expiry.
    if (!user.hasActiveSession || _isNearExpiry(user.tokenExpiresAt)) {
      await _silentRefresh();
      return;
    }

    // Session is healthy — restore authenticated state and arm expiry timer.
    emit(AuthState(status: AuthStatus.authenticated, user: user));
    _scheduleTokenRefresh(user.tokenExpiresAt!);
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Registration — Phone Entry Step
  // ───────────────────────────────────────────────────────────────────────────

  /// Sends an OTP to [phoneNumber] (E.164 format: +2348012345678).
  /// Transitions to [AuthStatus.awaitingOtp] on success.
  Future<void> requestOtp(String phoneNumber) async {
    emit(state.loading);

    try {
      final verificationId = await _authService.sendOtp(phoneNumber);

      emit(
        state.otpSent(
          phone: phoneNumber,
          verificationId: verificationId,
          cooldownSeconds: 60,
        ),
      );

      _startOtpCooldown();
    } on AuthException catch (e) {
      emit(state.failure(message: e.userMessage, code: e.code));
    } catch (_) {
      emit(
        state.failure(
          message: 'Unable to send OTP. Check your connection and try again.',
          code: 'NETWORK_ERROR',
        ),
      );
    }
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Registration / Login — OTP Verification Step
  // ───────────────────────────────────────────────────────────────────────────

  /// Verifies [otp] against the [state.otpVerificationId].
  /// On success the backend returns a full [AuthUser] with tokens.
  Future<void> verifyOtp(String otp) async {
    final verificationId = state.otpVerificationId;
    final phone = state.pendingPhone;

    if (verificationId == null || phone == null) {
      emit(
        state.failure(
          message: 'Session expired. Please request a new OTP.',
          code: 'INVALID_SESSION',
        ),
      );
      return;
    }

    emit(state.loading);

    try {
      final authUser = await _authService.verifyOtp(
        phone: phone,
        otp: otp,
        verificationId: verificationId,
      );

      // Persist refresh token to secure storage — never in SharedPreferences.
      if (authUser.refreshToken != null) {
        await _secureStorage.saveRefreshToken(authUser.refreshToken!);
      }

      _cancelOtpCooldown();

      // Surface KYC-pending state for accounts awaiting agent verification.
      if (authUser.kycStatus == 'pending' && authUser.tier == UserTier.agent) {
        emit(AuthState(status: AuthStatus.pendingKyc, user: authUser));
        return;
      }

      emit(state.authenticated(authUser));
      _scheduleTokenRefresh(authUser.tokenExpiresAt!);
    } on AuthException catch (e) {
      emit(state.failure(message: e.userMessage, code: e.code));
    } catch (_) {
      emit(
        state.failure(
          message: 'OTP verification failed. Please try again.',
          code: 'OTP_VERIFY_ERROR',
        ),
      );
    }
  }

  // ───────────────────────────────────────────────────────────────────────────
  // OTP Resend
  // ───────────────────────────────────────────────────────────────────────────

  Future<void> resendOtp() async {
    if (!state.canResendOtp) return;

    final phone = state.pendingPhone;
    if (phone == null) return;

    await requestOtp(phone);
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Token Refresh
  // ───────────────────────────────────────────────────────────────────────────

  /// Called proactively before token expiry. Also called by [initialise()] if
  /// the restored token is stale.
  Future<void> _silentRefresh() async {
    final storedRefreshToken = await _secureStorage.getRefreshToken();

    if (storedRefreshToken == null) {
      await signOut();
      return;
    }

    try {
      final refreshed = await _tokenRefreshService.refresh(
        refreshToken: storedRefreshToken,
        existingUser: state.user,
      );

      if (refreshed.refreshToken != null) {
        await _secureStorage.saveRefreshToken(refreshed.refreshToken!);
      }

      emit(state.authenticated(refreshed));
      _scheduleTokenRefresh(refreshed.tokenExpiresAt!);
    } on AuthException catch (e) {
      if (e.code == 'TOKEN_EXPIRED' || e.code == 'INVALID_REFRESH_TOKEN') {
        await signOut();
      } else {
        // Non-fatal — keep stale authenticated state, show toast.
        emit(state.failure(message: e.userMessage, code: e.code));
      }
    } catch (_) {
      // Keep existing session on network failures; retry will happen next boot.
      if (state.user != null) {
        emit(AuthState(status: AuthStatus.authenticated, user: state.user));
      } else {
        await signOut();
      }
    }
  }

  // ───────────────────────────────────────────────────────────────────────────
  // KYC Status Update
  // ───────────────────────────────────────────────────────────────────────────

  /// Called from a push-notification handler or polling service when KYC
  /// status changes (e.g. agent licence verified by ESVARBON/NIESV).
  void onKycStatusChanged(String newStatus) {
    if (state.user == null) return;

    final updatedUser = state.user!.copyWith(kycStatus: newStatus);

    if (newStatus == 'approved') {
      emit(AuthState(status: AuthStatus.authenticated, user: updatedUser));
    } else if (newStatus == 'rejected') {
      emit(AuthState(status: AuthStatus.pendingKyc, user: updatedUser));
    } else {
      emit(state.copyWith(user: updatedUser));
    }
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Profile patch (lightweight — full edit goes through ProfileCubit)
  // ───────────────────────────────────────────────────────────────────────────

  /// Syncs tier or name changes propagated from [ProfileCubit] after an
  /// in-app profile update, without requiring a full re-login.
  void patchUser(AuthUser updatedUser) {
    if (!state.isAuthenticated) return;
    emit(state.authenticated(updatedUser));
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Sign Out
  // ───────────────────────────────────────────────────────────────────────────

  Future<void> signOut() async {
    _cancelTokenRefresh();
    _cancelOtpCooldown();

    // Best-effort server-side token revocation — do not block sign-out on fail.
    try {
      final refreshToken = await _secureStorage.getRefreshToken();
      if (refreshToken != null) {
        await _authService.revokeToken(refreshToken);
      }
    } catch (_) {
      /* silent */
    }

    await _secureStorage.clearTokens();
    emit(state.unauthenticated);
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Account Suspension (called by admin push-notification service)
  // ───────────────────────────────────────────────────────────────────────────

  Future<void> onAccountSuspended() async {
    _cancelTokenRefresh();
    _cancelOtpCooldown();
    await _secureStorage.clearTokens();
    emit(state.suspended);
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Error clearance (called after SnackBar/toast has been shown)
  // ───────────────────────────────────────────────────────────────────────────

  void clearError() {
    if (!state.hasError) return;
    // Return to the logical previous status based on context.
    final recoveryStatus = state.pendingPhone != null
        ? AuthStatus.awaitingOtp
        : state.user != null
        ? AuthStatus.authenticated
        : AuthStatus.unauthenticated;

    emit(
      state.copyWith(
        status: recoveryStatus,
        clearErrorMessage: true,
        clearErrorCode: true,
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Private helpers
  // ───────────────────────────────────────────────────────────────────────────

  void _startOtpCooldown() {
    _cancelOtpCooldown();
    _otpCooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final remaining = state.otpResendCooldownSeconds - 1;
      if (remaining <= 0) {
        timer.cancel();
        emit(state.otpResendReady);
      } else {
        emit(state.withCooldown(remaining));
      }
    });
  }

  void _cancelOtpCooldown() {
    _otpCooldownTimer?.cancel();
    _otpCooldownTimer = null;
  }

  void _scheduleTokenRefresh(DateTime expiresAt) {
    _cancelTokenRefresh();

    // Refresh 2 minutes before actual expiry to avoid 401 mid-session.
    final refreshAt = expiresAt.subtract(const Duration(minutes: 2));
    final delay = refreshAt.difference(DateTime.now());

    if (delay.isNegative) {
      // Already expired or about to — refresh immediately.
      _silentRefresh();
      return;
    }

    _tokenExpiryTimer = Timer(delay, _silentRefresh);
  }

  void _cancelTokenRefresh() {
    _tokenExpiryTimer?.cancel();
    _tokenExpiryTimer = null;
  }

  bool _isNearExpiry(DateTime? expiresAt) {
    if (expiresAt == null) return true;
    return expiresAt.difference(DateTime.now()) < const Duration(minutes: 5);
  }

  // ───────────────────────────────────────────────────────────────────────────
  // HydratedCubit — serialisation
  // ───────────────────────────────────────────────────────────────────────────

  @override
  AuthState? fromJson(Map<String, dynamic> json) {
    try {
      return AuthState.fromJson(json);
    } catch (_) {
      return const AuthState(status: AuthStatus.unauthenticated);
    }
  }

  @override
  Map<String, dynamic>? toJson(AuthState state) {
    try {
      return state.toJson();
    } catch (_) {
      return null;
    }
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Lifecycle
  // ───────────────────────────────────────────────────────────────────────────

  @override
  Future<void> close() {
    _cancelOtpCooldown();
    _cancelTokenRefresh();
    return super.close();
  }
}
