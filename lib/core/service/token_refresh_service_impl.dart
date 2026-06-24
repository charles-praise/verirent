// lib/core/services/impl/token_refresh_service_impl.dart
//
// Exchanges a stored refresh token for new access + refresh tokens.
//
// Expected API endpoint:
//   POST /auth/token/refresh
//   Body:  { refresh_token: string }
//   Returns: { access_token, refresh_token, expires_at, user?: {...} }
//
// ─────────────────────────────────────────────────────────────────────────────

import 'package:dio/dio.dart';

import '../error/auth_exception.dart';
import '../repo/api_client.dart';
import 'auth_user.dart';
import 'token_refresh.dart'; // AuthUser, UserTier

class TokenRefreshServiceImpl implements TokenRefreshService {
  const TokenRefreshServiceImpl(this._api);

  final ApiClient _api;

  @override
  Future<AuthUser> refresh({
    required String refreshToken,
    AuthUser? existingUser,
  }) async {
    try {
      final response = await _api.post(
        baseUrl: '/auth/token/refresh',
        data: {'refresh_token': refreshToken},
      );

      final json = response.data as Map<String, dynamic>;
      final newAccessToken = json['access_token'] as String?;
      final newRefreshToken = json['refresh_token'] as String?;
      final expiresAt = json['expires_at'] != null
          ? DateTime.tryParse(json['expires_at'] as String)
          : null;

      if (newAccessToken == null || expiresAt == null) {
        throw const AuthException(
          code: 'INVALID_REFRESH_RESPONSE',
          userMessage: 'Session renewal failed. Please log in again.',
        );
      }

      // If the backend returns an updated user object, parse it fresh.
      // Otherwise, graft the new tokens onto the existing user.
      if (json.containsKey('user') && existingUser != null) {
        final userJson = json['user'] as Map<String, dynamic>;
        return existingUser.copyWith(
          tier: UserTier.values.firstWhere(
            (e) =>
                e.name ==
                (userJson['tier'] as String? ?? existingUser.tier.name),
            orElse: () => existingUser.tier,
          ),
          fullName: userJson['full_name'] as String?,
          kycStatus: userJson['kyc_status'] as String?,
          isNinVerified: userJson['is_nin_verified'] as bool?,
          isLicenseVerified: userJson['is_license_verified'] as bool?,
          accessToken: newAccessToken,
          refreshToken: newRefreshToken,
          tokenExpiresAt: expiresAt,
        );
      }

      // Minimal path — just update tokens on the existing user.
      if (existingUser != null) {
        return existingUser.copyWith(
          accessToken: newAccessToken,
          refreshToken: newRefreshToken,
          tokenExpiresAt: expiresAt,
        );
      }

      // Fallback: backend returned a full user object and we have no local copy.
      return AuthUser.fromJson({
        ...json['user'] as Map<String, dynamic>? ?? {},
        'access_token': newAccessToken,
        'refresh_token': newRefreshToken,
        'token_expires_at': expiresAt.toIso8601String(),
      });
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final serverCode = e.response?.data?['code'] as String?;

      if (statusCode == 401 ||
          serverCode == 'TOKEN_EXPIRED' ||
          serverCode == 'INVALID_REFRESH_TOKEN') {
        throw const AuthException(
          code: 'INVALID_REFRESH_TOKEN',
          userMessage: 'Your session has expired. Please log in again.',
        );
      }

      throw const AuthException(
        code: 'NETWORK_ERROR',
        userMessage: 'Could not renew your session. Check your connection.',
      );
    }
  }
}
