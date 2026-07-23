/// Verification status of a property's legal documents.
class DocumentModel {
  const DocumentModel({
    this.overallStatus,
    this.buildingApproval,
    this.landRegistry,
    this.surveyPlan,
    this.titleDeed,
  });

  final OverallStatus? overallStatus;
  final bool? titleDeed;
  final bool? landRegistry;
  final bool? buildingApproval;
  final bool? surveyPlan;

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      overallStatus: json['overallStatus'] != null
          ? OverallStatus.values[json['overallStatus'] as int]
          : null,
      titleDeed: json['titleDeed'] as bool?,
      landRegistry: json['landRegistry'] as bool?,
      buildingApproval: json['buildingApproval'] as bool?,
      surveyPlan: json['surveyPlan'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
    'overallStatus': overallStatus?.index,
    'titleDeed': titleDeed,
    'landRegistry': landRegistry,
    'buildingApproval': buildingApproval,
    'surveyPlan': surveyPlan,
  };
}
