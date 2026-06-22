import 'package:verirent/features/home/domain/entities/property_model.dart';

enum VerificationTier { professional, enterprise, starter, pro, basic }

class AgencyModel extends PropertyModel {
  AgencyModel({
    required super.id,
    this.name,
    this.verificationTier,
    super.rating,
    this.transactions,
    this.esvarbon,
    this.phone,
    this.email,
    super.address,
  });

  final String? name;
  final VerificationTier? verificationTier;
  final int? transactions;
  final String? esvarbon;
  final String? phone;
  final String? email;
}
