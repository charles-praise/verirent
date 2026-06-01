class DocumentStatus {
  final bool hasOwnershipDoc;
  final bool hasLandRegistry;
  final bool hasCompletionCert;
  final bool hasLandUseCert;
  final bool hasBuiltingApproval;
  final String overallStatus; // Verified, Pending, Unverified

  DocumentStatus({
    required this.hasOwnershipDoc,
    required this.hasLandRegistry,
    required this.hasCompletionCert,
    required this.hasLandUseCert,
    required this.hasBuiltingApproval,
    required this.overallStatus,
  });
}
