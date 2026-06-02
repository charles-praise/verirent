enum OverallStatus { verified, unverified, pending }

class DocumentModel {
  DocumentModel({
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
}
