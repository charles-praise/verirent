// ─────────────────────────────────────────────────────────────────────────────
// lib/core/services/token_refresh_service.dart
// ─────────────────────────────────────────────────────────────────────────────

import '../../entity/auth_user.dart';

abstract class TokenRefreshService {
  /// Exchanges [refreshToken] for a new [AuthUser] with fresh tokens.
  Future<AuthUser> refresh({
    required String refreshToken,
    AuthUser? existingUser,
  });
}
