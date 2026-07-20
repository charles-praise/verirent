// ─────────────────────────────────────────────────────────────────────────────
// lib/core/services/auth_service.dart  (interface — implement with Dio/http)
// ─────────────────────────────────────────────────────────────────────────────

// ignore_for_file: one_member_abstracts

import '../../entity/auth_user.dart';

abstract class AuthService {
  /// Sends OTP to [phoneNumber] (E.164). Returns server-side [verificationId].
  Future<String> sendOtp(String phoneNumber);

  /// Verifies [otp] and returns a fully-populated [AuthUser] with tokens.
  Future<AuthUser> verifyOtp({
    required String phone,
    required String otp,
    required String verificationId,
  });

  /// Server-side token revocation (best-effort on sign-out).
  Future<void> revokeToken(String refreshToken);
}
