import '../models/property/property_type.dart';

/// Fields relevant to houses, duplexes, and apartments. Composed onto
/// `PropertyModel.residential` — never inherited, so a short-let unit can
/// carry BOTH `residential` and `lease` details without needing a fake
/// "lease is-a office is-a residential" chain.
class ResidentialDetails {
  const ResidentialDetails({
    this.furnishing,
    this.condition,
    this.waterSupply,
    this.powerSupply,
    this.hasAC,
    this.hasParking,
    this.hasGarden,
    this.isFenced,
    this.hasSecurityGuard,
    this.hasCCTV,
    this.hasAlarmSystem,
    this.yearBuilt,
    this.hasTitleDocument,
    this.hasBuildingApproval,
  });

  final String? furnishing;
  final PropertyCondition? condition;
  final String? waterSupply;
  final String? powerSupply;
  final bool? hasAC;
  final bool? hasParking;
  final bool? hasGarden;
  final bool? isFenced;
  final bool? hasSecurityGuard;
  final bool? hasCCTV;
  final bool? hasAlarmSystem;
  final int? yearBuilt; // was a double in the original — years are integers
  final bool? hasTitleDocument;
  final bool? hasBuildingApproval;

  factory ResidentialDetails.fromJson(Map<String, dynamic> json) {
    return ResidentialDetails(
      furnishing: json['furnishing'] as String?,
      condition: json['condition'] != null
          ? PropertyCondition.values[json['condition'] as int]
          : null,
      waterSupply: json['waterSupply'] as String?,
      powerSupply: json['powerSupply'] as String?,
      hasAC: json['hasAC'] as bool?,
      hasParking: json['hasParking'] as bool?,
      hasGarden: json['hasGarden'] as bool?,
      isFenced: json['isFenced'] as bool?,
      hasSecurityGuard: json['hasSecurityGuard'] as bool?,
      hasCCTV: json['hasCCTV'] as bool?,
      hasAlarmSystem: json['hasAlarmSystem'] as bool?,
      yearBuilt: json['yearBuilt'] as int?,
      hasTitleDocument: json['hasTitleDocument'] as bool?,
      hasBuildingApproval: json['hasBuildingApproval'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
    'furnishing': furnishing,
    'condition': condition?.index,
    'waterSupply': waterSupply,
    'powerSupply': powerSupply,
    'hasAC': hasAC,
    'hasParking': hasParking,
    'hasGarden': hasGarden,
    'isFenced': isFenced,
    'hasSecurityGuard': hasSecurityGuard,
    'hasCCTV': hasCCTV,
    'hasAlarmSystem': hasAlarmSystem,
    'yearBuilt': yearBuilt,
    'hasTitleDocument': hasTitleDocument,
    'hasBuildingApproval': hasBuildingApproval,
  };
}
