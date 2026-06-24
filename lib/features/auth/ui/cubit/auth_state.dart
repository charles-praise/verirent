// lib/features/auth/cubit/auth_state.dart

part of 'auth_cubit.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Auth Status Enum
// ─────────────────────────────────────────────────────────────────────────────

enum AuthStatus {
  /// Cold start — HydratedCubit is re-hydrating stored session.
  initializing,

  /// No stored session or session has been invalidated.
  unauthenticated,

  /// Credentials submitted; waiting for API response.
  loading,

  /// Valid session exists; user object is populated.
  authenticated,

  /// OTP has been sent; waiting for user to verify.
  awaitingOtp,

  /// KYC submitted; account exists but not yet verified by ESVARBON/NIESV.
  pendingKyc,

  /// Account suspended by admin (e.g. regulatory violation).
  suspended,

  /// A non-fatal error occurred (toast-level feedback).
  error,
}

// ─────────────────────────────────────────────────────────────────────────────
// Auth State
// ─────────────────────────────────────────────────────────────────────────────

class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.initializing,
    this.user,
    this.pendingPhone,
    this.otpVerificationId,
    this.otpResendCooldownSeconds = 0,
    this.errorMessage,
    this.errorCode,
  });

  final AuthStatus status;

  /// Populated whenever [status] == [AuthStatus.authenticated].
  final AuthUser? user;

  /// Phone number waiting for OTP confirmation.
  final String? pendingPhone;

  /// Server-side verification reference (Firebase / custom OTP service).
  final String? otpVerificationId;

  /// Countdown seconds shown on the OTP screen's "Resend" button.
  final int otpResendCooldownSeconds;

  /// Human-readable error, displayed as a SnackBar / toast.
  final String? errorMessage;

  /// Machine-readable error code for conditional UI logic.
  /// e.g. 'INVALID_OTP', 'ACCOUNT_SUSPENDED', 'KYC_REQUIRED', 'TOKEN_EXPIRED'
  final String? errorCode;

  // ─── Derived getters ─────────────────────────────────────────────────────

  bool get isInitializing => status == AuthStatus.initializing;
  bool get isAuthenticated =>
      status == AuthStatus.authenticated && user != null;
  bool get isLoading => status == AuthStatus.loading;
  bool get isAwaitingOtp => status == AuthStatus.awaitingOtp;
  bool get isPendingKyc => status == AuthStatus.pendingKyc;
  bool get isSuspended => status == AuthStatus.suspended;
  bool get hasError => status == AuthStatus.error;

  bool get canResendOtp => otpResendCooldownSeconds == 0;

  // ─── Serialisation (for HydratedCubit) ───────────────────────────────────

  factory AuthState.fromJson(Map<String, dynamic> json) {
    return AuthState(
      status: AuthStatus.values.firstWhere(
        (e) => e.name == (json['status'] as String? ?? 'unauthenticated'),
        orElse: () => AuthStatus.unauthenticated,
      ),
      user: json['user'] != null
          ? AuthUser.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      // Transient fields are intentionally NOT restored from storage.
      pendingPhone: null,
      otpVerificationId: null,
      otpResendCooldownSeconds: 0,
      errorMessage: null,
      errorCode: null,
    );
  }

  Map<String, dynamic> toJson() => {
    // Only persist status + user; OTP / error fields are session-transient.
    'status':
        status == AuthStatus.authenticated || status == AuthStatus.pendingKyc
        ? status.name
        : AuthStatus.unauthenticated.name,
    'user': user?.toJson(),
  };

  // ─── copyWith ────────────────────────────────────────────────────────────

  AuthState copyWith({
    AuthStatus? status,
    AuthUser? user,
    bool clearUser = false,
    String? pendingPhone,
    bool clearPendingPhone = false,
    String? otpVerificationId,
    bool clearOtpVerificationId = false,
    int? otpResendCooldownSeconds,
    String? errorMessage,
    bool clearErrorMessage = false,
    String? errorCode,
    bool clearErrorCode = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: clearUser ? null : (user ?? this.user),
      pendingPhone: clearPendingPhone
          ? null
          : (pendingPhone ?? this.pendingPhone),
      otpVerificationId: clearOtpVerificationId
          ? null
          : (otpVerificationId ?? this.otpVerificationId),
      otpResendCooldownSeconds:
          otpResendCooldownSeconds ?? this.otpResendCooldownSeconds,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
      errorCode: clearErrorCode ? null : (errorCode ?? this.errorCode),
    );
  }

  // ─── Named constructors for common transitions ────────────────────────────

  const AuthState.initial() : this(status: AuthStatus.initializing);

  AuthState get loading => copyWith(
    status: AuthStatus.loading,
    clearErrorMessage: true,
    clearErrorCode: true,
  );

  AuthState otpSent({
    required String phone,
    required String verificationId,
    int cooldownSeconds = 60,
  }) => copyWith(
    status: AuthStatus.awaitingOtp,
    pendingPhone: phone,
    otpVerificationId: verificationId,
    otpResendCooldownSeconds: cooldownSeconds,
    clearErrorMessage: true,
    clearErrorCode: true,
  );

  AuthState get otpResendReady => copyWith(otpResendCooldownSeconds: 0);

  AuthState withCooldown(int seconds) =>
      copyWith(otpResendCooldownSeconds: seconds);

  AuthState authenticated(AuthUser authUser) => copyWith(
    status: AuthStatus.authenticated,
    user: authUser,
    clearPendingPhone: true,
    clearOtpVerificationId: true,
    clearErrorMessage: true,
    clearErrorCode: true,
  );

  AuthState get pendingKyc =>
      copyWith(status: AuthStatus.pendingKyc, clearErrorMessage: true);

  AuthState failure({required String message, String? code}) => copyWith(
    status: AuthStatus.error,
    errorMessage: message,
    errorCode: code,
  );

  AuthState get unauthenticated =>
      const AuthState(status: AuthStatus.unauthenticated);

  AuthState get suspended =>
      copyWith(status: AuthStatus.suspended, clearUser: true);

  // ─── Equatable ───────────────────────────────────────────────────────────

  @override
  List<Object?> get props => [
    status,
    user,
    pendingPhone,
    otpVerificationId,
    otpResendCooldownSeconds,
    errorMessage,
    errorCode,
  ];

  @override
  String toString() =>
      'AuthState(status: $status, user: ${user?.uid}, '
      'error: $errorMessage)';
}
