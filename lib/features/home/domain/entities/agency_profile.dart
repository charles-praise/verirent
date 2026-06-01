class AgencyProfile {
  final String id;
  final String name;
  final String logo;
  final String
  verificationTier; // Basic, Verified, Pro, Professional, Enterprise
  final int yearsInBusiness;
  final double rating;
  final int transactions;
  final String phone;
  final String email;
  final String address;

  AgencyProfile({
    required this.id,
    required this.name,
    required this.logo,
    required this.verificationTier,
    required this.yearsInBusiness,
    required this.rating,
    required this.transactions,
    required this.phone,
    required this.email,
    required this.address,
  });
}
