// lib/core/services/impl/auth_service_impl.dart
//
// Concrete implementation of AuthService.
// Uses Dio to talk to your VeriRent NG FastAPI backend.
//
// Expected API endpoints (adjust base URL via ApiClient):
//   POST /auth/otp/send      → { verification_id: string }
//   POST /auth/otp/verify    → { user: {...}, access_token, refresh_token, expires_at }
//   POST /auth/token/revoke  → 204 No Content
//
// ─────────────────────────────────────────────────────────────────────────────

import 'package:dio/dio.dart';

import '../../../../../core/error/auth_exception.dart';
import '../../../../../core/repo/api_client.dart';
import '../../entity/auth_user.dart'; // for AuthUser, UserTier
import 'auth_service.dart';

class AuthServiceImpl implements AuthService {
  const AuthServiceImpl(this._api);

  final ApiClient _api; // GetIt provides this

  // ── Send OTP ────────────────────────────────────────────────────────────────

  @override
  Future<String> sendOtp(String phoneNumber) async {
    try {
      final response = await _api.post(
        baseUrl: '/auth/otp/send',
        data: {'phone_number': phoneNumber},
      );

      final verificationId = response.data['verification_id'] as String?;

      if (verificationId == null) {
        throw const AuthException(
          code: 'MISSING_VERIFICATION_ID',
          userMessage: 'Server returned an invalid response. Please try again.',
        );
      }

      return verificationId;
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  // ── Verify OTP ──────────────────────────────────────────────────────────────

  @override
  Future<AuthUser> verifyOtp({
    required String phone,
    required String otp,
    required String verificationId,
  }) async {
    try {
      final response = await _api.post(
        baseUrl: '/auth/otp/verify',
        data: {
          'phone_number': phone,
          'otp': otp,
          'verification_id': verificationId,
        },
      );

      return _parseAuthUser(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  // ── Revoke Token ────────────────────────────────────────────────────────────

  @override
  Future<void> revokeToken(String refreshToken) async {
    try {
      await _api.post(
        baseUrl: '/auth/token/revoke',
        data: {'refresh_token': refreshToken},
      );
    } on DioException catch (_) {
      // Best-effort — never block sign-out on a network failure.
    }
  }

  // ── Private helpers ─────────────────────────────────────────────────────────

  /// Parses the JSON response from /auth/otp/verify into an [AuthUser].
  /// Adjust field names to match your FastAPI response schema.
  AuthUser _parseAuthUser(Map<String, dynamic> json) {
    // The backend may return user fields at the top level or nested under 'user'.
    final userJson = json.containsKey('user')
        ? json['user'] as Map<String, dynamic>
        : json;

    return AuthUser(
      uid: userJson['uid'] as String,
      phoneNumber: userJson['phone_number'] as String,
      tier: UserTier.values.firstWhere(
        (e) => e.name == (userJson['tier'] as String? ?? 'tenant'),
        orElse: () => UserTier.tenant,
      ),
      fullName: userJson['full_name'] as String?,
      email: userJson['email'] as String?,
      avatarUrl: userJson['avatar_url'] as String?,
      accessToken: json['access_token'] as String?,
      refreshToken: json['refresh_token'] as String?,
      tokenExpiresAt: json['expires_at'] != null
          ? DateTime.tryParse(json['expires_at'] as String)
          : null,
      isPhoneVerified: userJson['is_phone_verified'] as bool? ?? true,
      isNinVerified: userJson['is_nin_verified'] as bool? ?? false,
      isLicenseVerified: userJson['is_license_verified'] as bool? ?? false,
      kycStatus: userJson['kyc_status'] as String?,
      licenseNumber: userJson['license_number'] as String?,
      licenseBody: userJson['license_body'] as String?,
    );
  }

  /// Maps Dio HTTP errors to typed [AuthException]s with user-friendly messages.
  AuthException _mapDioError(DioException e) {
    final statusCode = e.response?.statusCode;
    final serverCode = e.response?.data?['code'] as String?;

    // Use server-provided code when available so AuthCubit logic stays clean.
    if (serverCode != null) {
      return AuthException(
        code: serverCode,
        userMessage: _serverMessage(serverCode),
      );
    }

    return switch (statusCode) {
      400 => const AuthException(
        code: 'INVALID_REQUEST',
        userMessage: 'Invalid request. Please check your details.',
      ),
      401 => const AuthException(
        code: 'INVALID_OTP',
        userMessage: 'Incorrect OTP. Please try again.',
      ),
      403 => const AuthException(
        code: 'ACCOUNT_SUSPENDED',
        userMessage:
            'Your account has been suspended. Contact support@verirent.ng.',
      ),
      404 => const AuthException(
        code: 'USER_NOT_FOUND',
        userMessage: 'No account found for this number.',
      ),
      429 => const AuthException(
        code: 'RATE_LIMITED',
        userMessage: 'Too many attempts. Please wait a moment and try again.',
      ),
      _
          when e.type == DioExceptionType.connectionTimeout ||
              e.type == DioExceptionType.receiveTimeout =>
        const AuthException(
          code: 'NETWORK_ERROR',
          userMessage:
              'Connection timed out. Check your internet and try again.',
        ),
      _ when e.type == DioExceptionType.connectionError => const AuthException(
        code: 'NETWORK_ERROR',
        userMessage: 'No internet connection. Please check your network.',
      ),
      _ => const AuthException(
        code: 'UNKNOWN_ERROR',
        userMessage: 'Something went wrong. Please try again.',
      ),
    };
  }

  String _serverMessage(String code) => switch (code) {
    'INVALID_OTP' => 'Incorrect OTP. Please try again.',
    'OTP_EXPIRED' => 'OTP has expired. Please request a new one.',
    'ACCOUNT_SUSPENDED' =>
      'Your account has been suspended. Contact support@verirent.ng.',
    'KYC_REQUIRED' =>
      'Identity verification is required before you can continue.',
    'TOKEN_EXPIRED' => 'Your session has expired. Please log in again.',
    'INVALID_REFRESH_TOKEN' =>
      'Your session is no longer valid. Please log in again.',
    _ => 'An error occurred. Please try again.',
  };
}
