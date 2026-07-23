/// Fields specific to office/commercial space listings.
class OfficeDetails {
  const OfficeDetails({
    this.officeType,
    this.layoutType,
    this.floorLevel,
    this.parkingSpaces,
    this.hasHVAC,
    this.hasElevator,
    this.hasDisabledAccess,
    this.hasKitchen,
    this.hasConferenceRoom,
    this.hasInternet,
    this.has24HourPower,
    this.hasCCTV,
    this.hasReception,
    this.hasGenerator,
    this.has24HourSecurity,
    this.hasFireSafety,
    this.hasPestControl,
    this.minLeaseMonths,
    this.hasRenewalOption,
    this.escalationPercentage,
  });

  final String? officeType;
  final String? layoutType;
  final int? floorLevel;
  final String? parkingSpaces;
  final bool? hasHVAC;
  final bool? hasElevator;
  final bool? hasDisabledAccess;
  final bool? hasKitchen;
  final bool? hasConferenceRoom;
  final bool? hasInternet;
  final bool? has24HourPower;
  final bool? hasCCTV;
  final bool? hasReception;
  final bool? hasGenerator;
  final bool? has24HourSecurity;
  final bool? hasFireSafety;
  final bool? hasPestControl;
  final int? minLeaseMonths;
  final bool? hasRenewalOption;
  final double? escalationPercentage;

  factory OfficeDetails.fromJson(Map<String, dynamic> json) {
    return OfficeDetails(
      officeType: json['officeType'] as String?,
      layoutType: json['layoutType'] as String?,
      floorLevel: json['floorLevel'] as int?,
      parkingSpaces: json['parkingSpaces'] as String?,
      hasHVAC: json['hasHVAC'] as bool?,
      hasElevator: json['hasElevator'] as bool?,
      hasDisabledAccess: json['hasDisabledAccess'] as bool?,
      hasKitchen: json['hasKitchen'] as bool?,
      hasConferenceRoom: json['hasConferenceRoom'] as bool?,
      hasInternet: json['hasInternet'] as bool?,
      has24HourPower: json['has24HourPower'] as bool?,
      hasCCTV: json['hasCCTV'] as bool?,
      hasReception: json['hasReception'] as bool?,
      hasGenerator: json['hasGenerator'] as bool?,
      has24HourSecurity: json['has24HourSecurity'] as bool?,
      hasFireSafety: json['hasFireSafety'] as bool?,
      hasPestControl: json['hasPestControl'] as bool?,
      minLeaseMonths: json['minLeaseMonths'] as int?,
      hasRenewalOption: json['hasRenewalOption'] as bool?,
      escalationPercentage: (json['escalationPercentage'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'officeType': officeType,
    'layoutType': layoutType,
    'floorLevel': floorLevel,
    'parkingSpaces': parkingSpaces,
    'hasHVAC': hasHVAC,
    'hasElevator': hasElevator,
    'hasDisabledAccess': hasDisabledAccess,
    'hasKitchen': hasKitchen,
    'hasConferenceRoom': hasConferenceRoom,
    'hasInternet': hasInternet,
    'has24HourPower': has24HourPower,
    'hasCCTV': hasCCTV,
    'hasReception': hasReception,
    'hasGenerator': hasGenerator,
    'has24HourSecurity': has24HourSecurity,
    'hasFireSafety': hasFireSafety,
    'hasPestControl': hasPestControl,
    'minLeaseMonths': minLeaseMonths,
    'hasRenewalOption': hasRenewalOption,
    'escalationPercentage': escalationPercentage,
  };
}
