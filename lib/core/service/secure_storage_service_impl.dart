// lib/core/services/impl/secure_storage_service_impl.dart
//
// Stores the refresh token in the device's secure enclave
// (Keychain on iOS, Keystore on Android) via flutter_secure_storage.
//
// pubspec.yaml dependency:
//   flutter_secure_storage: ^9.2.2
//
// Android — add to android/app/src/main/AndroidManifest.xml inside <application>:
//   <application
//     android:allowBackup="false"   ← prevents tokens appearing in ADB backups
//     ...>
//
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'secure_storage_service.dart';

class SecureStorageServiceImpl implements SecureStorageService {
  SecureStorageServiceImpl()
    : _storage = const FlutterSecureStorage(
        aOptions: AndroidOptions(
          encryptedSharedPreferences: true, // AES-256 via Jetpack Security
        ),
        iOptions: IOSOptions(
          accessibility: KeychainAccessibility.first_unlock_this_device,
        ),
      );

  final FlutterSecureStorage _storage;

  // Key constants — keep private so nothing else in the app can guess them.
  static const _kRefreshToken = 'verirent_refresh_token';
  static const _kAccessToken = 'verirent_access_token';

  // ── Refresh token ────────────────────────────────────────────────────────

  @override
  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _kRefreshToken, value: token);
  }

  @override
  Future<String?> getRefreshToken() async {
    return _storage.read(key: _kRefreshToken);
  }

  // ── Optional: cache the access token too (avoids passing it in state) ────
  // AuthCubit keeps the access token in HydratedCubit state (encrypted via
  // the storage path), but if you prefer secure storage for both:

  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _kAccessToken, value: token);
  }

  Future<String?> getAccessToken() async {
    return _storage.read(key: _kAccessToken);
  }

  // ── Clear all ────────────────────────────────────────────────────────────

  @override
  Future<void> clearTokens() async {
    // Delete individually rather than deleteAll() so other stored secrets
    // (e.g. biometric keys) are not wiped on sign-out.
    await Future.wait([
      _storage.delete(key: _kRefreshToken),
      _storage.delete(key: _kAccessToken),
    ]);
  }
}
