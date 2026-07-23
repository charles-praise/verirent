class AgencyModel {
  final String id;

  final String name;

  final String email;

  final String phone;

  final String avatarUrl;

  final String initials;

  final double rating;

  final int reviewCount;

  final int transactionCount;

  final VerificationTier tier;

  final bool verified;

  final String esvarbon;

  final AddressModel address;

  const AgencyModel({required this.id,required this.name, required this.phone, required this.email, required this.avatarUrl, required this.initials, required this.rating, required this.reviewCount, required this.transactionCount, this.tier, required this.verified, required this.esvarbon, this.address})
}
