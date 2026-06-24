// ─────────────────────────────────────────────────────────────────────────────
// lib/core/error/auth_exception.dart
// ─────────────────────────────────────────────────────────────────────────────

class AuthException implements Exception {
  const AuthException({required this.code, required this.userMessage});

  /// Machine-readable code matched in AuthCubit error logic.
  /// e.g. 'INVALID_OTP', 'TOKEN_EXPIRED', 'ACCOUNT_SUSPENDED',
  ///       'NETWORK_ERROR', 'KYC_REQUIRED', 'INVALID_REFRESH_TOKEN'
  final String code;

  /// Displayed directly in UI as a SnackBar/toast.
  final String userMessage;

  @override
  String toString() => 'AuthException($code): $userMessage';
}
