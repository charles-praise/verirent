/// Fields specific to raw/vacant land listings.
class LandDetails {
  const LandDetails({
    this.dimensions,
    this.documentType,
    this.landUse,
    this.surveyPlanNumber,
    this.landRegistryReference,
    this.hasElectricityPoles,
    this.hasWaterLine,
    this.hasDrainage,
    this.hasTarredRoad,
    this.isAccessibleByRoad,
    this.zoningClassification,
    this.maxBuildingHeight,
    this.allowsCommercial,
    this.landCondition,
    this.hasStreetFrontage,
    this.streetFrontageMeters,
    this.hasBoundaryDemarcation,
  });

  final String? dimensions;
  final String? documentType;
  final String? landUse;
  final String? surveyPlanNumber;
  final String? landRegistryReference;
  final bool? hasElectricityPoles;
  final bool? hasWaterLine;
  final bool? hasDrainage;
  final bool? hasTarredRoad;
  final bool? isAccessibleByRoad;
  final String? zoningClassification;
  final double? maxBuildingHeight;
  final bool? allowsCommercial;
  final String? landCondition;
  final bool? hasStreetFrontage;
  final int? streetFrontageMeters;
  final bool? hasBoundaryDemarcation;

  factory LandDetails.fromJson(Map<String, dynamic> json) {
    return LandDetails(
      dimensions: json['dimensions'] as String?,
      documentType: json['documentType'] as String?,
      landUse: json['landUse'] as String?,
      surveyPlanNumber: json['surveyPlanNumber'] as String?,
      landRegistryReference: json['landRegistryReference'] as String?,
      hasElectricityPoles: json['hasElectricityPoles'] as bool?,
      hasWaterLine: json['hasWaterLine'] as bool?,
      hasDrainage: json['hasDrainage'] as bool?,
      hasTarredRoad: json['hasTarredRoad'] as bool?,
      isAccessibleByRoad: json['isAccessibleByRoad'] as bool?,
      zoningClassification: json['zoningClassification'] as String?,
      maxBuildingHeight: (json['maxBuildingHeight'] as num?)?.toDouble(),
      allowsCommercial: json['allowsCommercial'] as bool?,
      landCondition: json['landCondition'] as String?,
      hasStreetFrontage: json['hasStreetFrontage'] as bool?,
      streetFrontageMeters: json['streetFrontageMeters'] as int?,
      hasBoundaryDemarcation: json['hasBoundaryDemarcation'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
    'dimensions': dimensions,
    'documentType': documentType,
    'landUse': landUse,
    'surveyPlanNumber': surveyPlanNumber,
    'landRegistryReference': landRegistryReference,
    'hasElectricityPoles': hasElectricityPoles,
    'hasWaterLine': hasWaterLine,
    'hasDrainage': hasDrainage,
    'hasTarredRoad': hasTarredRoad,
    'isAccessibleByRoad': isAccessibleByRoad,
    'zoningClassification': zoningClassification,
    'maxBuildingHeight': maxBuildingHeight,
    'allowsCommercial': allowsCommercial,
    'landCondition': landCondition,
    'hasStreetFrontage': hasStreetFrontage,
    'streetFrontageMeters': streetFrontageMeters,
    'hasBoundaryDemarcation': hasBoundaryDemarcation,
  };
}
