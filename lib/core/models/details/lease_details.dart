/// Short-let / lease-specific terms (Airbnb-style fields). Attaches
/// alongside `residential` (or `office`) details rather than inheriting
/// from them — a property sets whichever combination of detail objects
/// applies to it.
class LeaseDetails {
  const LeaseDetails({
    this.furnishingLevel,
    this.leaseTermMonths,
    this.hasFlexibleDates,
    this.depositAmount,
    this.hasWiFi,
    this.utilitiesIncluded,
    this.hasHousekeeping,
    this.hasParkingIncluded,
    this.hasACIncluded,
    this.hasKitchen,
    this.cancellationPolicy,
    this.guestsAllowed,
    this.petsAllowed,
    this.smokingAllowed,
    this.quietHours,
    this.checkInTime,
    this.checkOutTime,
    this.idealTenantProfile,
  });

  final String? furnishingLevel;
  final String? leaseTermMonths;
  final bool? hasFlexibleDates;
  final double? depositAmount;
  final bool? hasWiFi;
  final bool? utilitiesIncluded;
  final bool? hasHousekeeping;
  final bool? hasParkingIncluded;
  final bool? hasACIncluded;
  final bool? hasKitchen;
  final String? cancellationPolicy;
  final bool? guestsAllowed;
  final bool? petsAllowed;
  final bool? smokingAllowed;
  final String? quietHours;
  final String? checkInTime;
  final String? checkOutTime;
  final String? idealTenantProfile;

  factory LeaseDetails.fromJson(Map<String, dynamic> json) {
    return LeaseDetails(
      furnishingLevel: json['furnishingLevel'] as String?,
      leaseTermMonths: json['leaseTermMonths'] as String?,
      hasFlexibleDates: json['hasFlexibleDates'] as bool?,
      depositAmount: (json['depositAmount'] as num?)?.toDouble(),
      hasWiFi: json['hasWiFi'] as bool?,
      utilitiesIncluded: json['utilitiesIncluded'] as bool?,
      hasHousekeeping: json['hasHousekeeping'] as bool?,
      hasParkingIncluded: json['hasParkingIncluded'] as bool?,
      hasACIncluded: json['hasACIncluded'] as bool?,
      hasKitchen: json['hasKitchen'] as bool?,
      cancellationPolicy: json['cancellationPolicy'] as String?,
      guestsAllowed: json['guestsAllowed'] as bool?,
      petsAllowed: json['petsAllowed'] as bool?,
      smokingAllowed: json['smokingAllowed'] as bool?,
      quietHours: json['quietHours'] as String?,
      checkInTime: json['checkInTime'] as String?,
      checkOutTime: json['checkOutTime'] as String?,
      idealTenantProfile: json['idealTenantProfile'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'furnishingLevel': furnishingLevel,
    'leaseTermMonths': leaseTermMonths,
    'hasFlexibleDates': hasFlexibleDates,
    'depositAmount': depositAmount,
    'hasWiFi': hasWiFi,
    'utilitiesIncluded': utilitiesIncluded,
    'hasHousekeeping': hasHousekeeping,
    'hasParkingIncluded': hasParkingIncluded,
    'hasACIncluded': hasACIncluded,
    'hasKitchen': hasKitchen,
    'cancellationPolicy': cancellationPolicy,
    'guestsAllowed': guestsAllowed,
    'petsAllowed': petsAllowed,
    'smokingAllowed': smokingAllowed,
    'quietHours': quietHours,
    'checkInTime': checkInTime,
    'checkOutTime': checkOutTime,
    'idealTenantProfile': idealTenantProfile,
  };
}
