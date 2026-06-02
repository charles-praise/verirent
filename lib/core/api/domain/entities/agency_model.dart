enum VerificationTier { professional, enterprise, starter, pro, basic }

class AgencyModel {
  AgencyModel({
    required this.id,
    this.name,
    this.verificationTier,
    this.rating,
    this.transactions,
    this.esvarbon,
    this.phone,
    this.email,
    this.address,
  });

  final String id;
  final String? name;
  final VerificationTier? verificationTier;
  final double? rating;
  final int? transactions;
  final String? esvarbon;
  final String? phone;
  final String? email;
  final String? address;
}
