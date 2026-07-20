// ─────────────────────────────────────────────────────────────────────────────
// lib/core/services/secure_storage_service.dart
// ─────────────────────────────────────────────────────────────────────────────

abstract class SecureStorageService {
  Future<void> saveRefreshToken(String token);
  Future<String?> getRefreshToken();
  Future<void> clearTokens();
}
