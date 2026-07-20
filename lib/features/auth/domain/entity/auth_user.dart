enum UserTier {
  /// Registered but no KYC — browse-only.
  guest,

  /// Phone-verified tenant — can send enquiries.
  tenant,

  /// NIN/BVN verified — can list up to 3 properties.
  verifiedTenant,

  /// ESVARBON/NIESV licensed agent — unlimited listings, badge shown.
  agent,

  /// Property owner, no license needed, up to 5 listings.
  landlord,

  /// Platform administrator.
  admin,
}

class AuthUser {
  const AuthUser({
    required this.uid,
    required this.phoneNumber,
    required this.tier,
    this.fullName,
    this.email,
    this.avatarUrl,
    this.accessToken,
    this.refreshToken,
    this.tokenExpiresAt,
    this.isPhoneVerified = false,
    this.isNinVerified = false,
    this.isLicenseVerified = false,
    this.kycStatus,
    this.licenseNumber,
    this.licenseBody,
  });

  final String uid;
  final String phoneNumber;
  final UserTier tier;
  final String? fullName;
  final String? email;
  final String? avatarUrl;

  // ── Session tokens ──
  final String? accessToken;
  final String? refreshToken;
  final DateTime? tokenExpiresAt;

  // ── Verification flags ──
  final bool isPhoneVerified;
  final bool isNinVerified;
  final bool isLicenseVerified;

  // ── KYC ──
  final String? kycStatus; // 'pending' | 'approved' | 'rejected'
  final String? licenseNumber;
  final String? licenseBody; // 'ESVARBON' | 'NIESV' | 'RICS' etc.

  // ─── Derived helpers ─────────────────────────────────────────────────────

  bool get canCreateListing => tier != UserTier.guest && isPhoneVerified;

  bool get hasActiveSession =>
      accessToken != null &&
      tokenExpiresAt != null &&
      tokenExpiresAt!.isAfter(DateTime.now());

  bool get isAgentOrAdmin => tier == UserTier.agent || tier == UserTier.admin;

  int get maxListings {
    return switch (tier) {
      UserTier.guest => 0,
      UserTier.tenant => 0,
      UserTier.verifiedTenant => 3,
      UserTier.landlord => 5,
      UserTier.agent || UserTier.admin => 999,
    };
  }

  // ─── Serialisation ───────────────────────────────────────────────────────

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      uid: json['uid'] as String,
      phoneNumber: json['phone_number'] as String,
      tier: UserTier.values.firstWhere(
        (e) => e.name == (json['tier'] as String? ?? 'guest'),
        orElse: () => UserTier.guest,
      ),
      fullName: json['full_name'] as String?,
      email: json['email'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      accessToken: json['access_token'] as String?,
      refreshToken: json['refresh_token'] as String?,
      tokenExpiresAt: json['token_expires_at'] != null
          ? DateTime.tryParse(json['token_expires_at'] as String)
          : null,
      isPhoneVerified: json['is_phone_verified'] as bool? ?? false,
      isNinVerified: json['is_nin_verified'] as bool? ?? false,
      isLicenseVerified: json['is_license_verified'] as bool? ?? false,
      kycStatus: json['kyc_status'] as String?,
      licenseNumber: json['license_number'] as String?,
      licenseBody: json['license_body'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'phone_number': phoneNumber,
    'tier': tier.name,
    'full_name': fullName,
    'email': email,
    'avatar_url': avatarUrl,
    'access_token': accessToken,
    'refresh_token': refreshToken,
    'token_expires_at': tokenExpiresAt?.toIso8601String(),
    'is_phone_verified': isPhoneVerified,
    'is_nin_verified': isNinVerified,
    'is_license_verified': isLicenseVerified,
    'kyc_status': kycStatus,
    'license_number': licenseNumber,
    'license_body': licenseBody,
  };

  AuthUser copyWith({
    String? uid,
    String? phoneNumber,
    UserTier? tier,
    String? fullName,
    String? email,
    String? avatarUrl,
    String? accessToken,
    String? refreshToken,
    DateTime? tokenExpiresAt,
    bool? isPhoneVerified,
    bool? isNinVerified,
    bool? isLicenseVerified,
    String? kycStatus,
    String? licenseNumber,
    String? licenseBody,
  }) {
    return AuthUser(
      uid: uid ?? this.uid,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      tier: tier ?? this.tier,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      tokenExpiresAt: tokenExpiresAt ?? this.tokenExpiresAt,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      isNinVerified: isNinVerified ?? this.isNinVerified,
      isLicenseVerified: isLicenseVerified ?? this.isLicenseVerified,
      kycStatus: kycStatus ?? this.kycStatus,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      licenseBody: licenseBody ?? this.licenseBody,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthUser &&
          runtimeType == other.runtimeType &&
          uid == other.uid &&
          accessToken == other.accessToken &&
          tier == other.tier &&
          kycStatus == other.kycStatus;

  @override
  int get hashCode =>
      uid.hashCode ^ accessToken.hashCode ^ tier.hashCode ^ kycStatus.hashCode;
}
