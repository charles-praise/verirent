// =============================================================================
//  Agent NG — LocationState
//
//  Immutable state for the LocationCubit.
//
//  Gating contract
//  ────────────────
//  • [isComplete] is the single source of truth for "geographical content
//    may be shown / app may proceed." It requires BOTH [selectedState] and
//    [selectedLga] to be non-null — regardless of whether they were set via
//    GPS or manual selection. The router guard and any screen requiring
//    location should check this, not [hasSelection].
//
//  • [needsLgaConfirmation] is true specifically when GPS resolved a state
//    but could not confidently match an LGA, AND the user has not yet
//    picked one. This drives the forced-open, non-dismissible dropdown
//    behaviour, distinct from the general manual-selection flow.
//
//  Confirmation-pending contract (2-read agreement)
//  ──────────────────────────────────────────────────
//  To avoid GPS jitter near state/LGA borders silently flipping a user's
//  confirmed location, a NEW state/LGA detected by GPS is not applied
//  immediately if the user already has a confirmed selection. Instead it is
//  stored in [pendingState]/[pendingLga]/[pendingDetectedAt]. Only if the
//  *next* GPS read agrees with the pending value does the cubit promote it
//  to [selectedState]/[selectedLga]. A single noisy read is therefore
//  self-correcting and never overwrites the confirmed selection.
//
//  Serialization contract
//  ──────────────────────
//  • Persisted: selectedState, selectedLga, latitude, longitude, country,
//    city, detectedStateRaw, lastConfirmedAt.
//  • NOT persisted (reset on cold start): phase, error, permanentlyDenied,
//    isOpen, pendingState, pendingLga, pendingDetectedAt, looseLgaSuggestion.
//
//  developer: charles praise diepriye
// =============================================================================

enum LocationPhase {
  initial,
  loading,
  ready,
  denied,
  permanentlyDenied,
  error,
}

class LocationState {
  // ── Phase & error ──────────────────────────────────────────────────────────
  final LocationPhase phase;
  final String? error;
  final bool permanentlyDenied;

  // ── Coordinates & geocode ──────────────────────────────────────────────────
  final double? latitude;
  final double? longitude;
  final String? country;
  final String? detectedStateRaw;
  final String? city;

  // ── Confirmed dropdown selection (the only thing that gates content) ───────
  final String? selectedState;
  final String? selectedLga;
  final bool isOpen;

  /// Timestamp of the last time [selectedState]/[selectedLga] were set
  /// (manually or via confirmed GPS promotion). Used to avoid redundant
  /// GPS re-fetches — see [LocationCubit] caching policy.
  final DateTime? lastConfirmedAt;

  // ── Pending GPS read awaiting a second agreeing read ────────────────────────

  /// A state GPS detected that disagrees with [selectedState] and has not
  /// yet been confirmed by a second consecutive matching read.
  final String? pendingState;

  /// The LGA paired with [pendingState], if matched.
  final String? pendingLga;

  /// When [pendingState] was first observed — used to decide whether a
  /// fresh read counts as "the next read" or is too stale to chain.
  final DateTime? pendingDetectedAt;

  /// A loose, unverified LGA guess derived from the geocoder's raw
  /// locality/subAdministrativeArea string when strict fuzzy matching
  /// failed. Offered to the user as a one-tap fallback ("Use Eneka — our
  /// best guess") inside the forced-confirmation prompt. Never auto-applied.
  final String? looseLgaSuggestion;

  const LocationState({
    this.phase = LocationPhase.initial,
    this.error,
    this.permanentlyDenied = false,
    this.latitude,
    this.longitude,
    this.country,
    this.detectedStateRaw,
    this.city,
    this.selectedState,
    this.selectedLga,
    this.isOpen = false,
    this.lastConfirmedAt,
    this.pendingState,
    this.pendingLga,
    this.pendingDetectedAt,
    this.looseLgaSuggestion,
  });

  // ── Serialization ──────────────────────────────────────────────────────────

  factory LocationState.fromJson(Map<String, dynamic> json) {
    return LocationState(
      phase: LocationPhase.initial,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      country: json['country'] as String?,
      city: json['city'] as String?,
      detectedStateRaw: json['detectedStateRaw'] as String?,
      selectedState: json['selectedState'] as String?,
      selectedLga: json['selectedLga'] as String?,
      lastConfirmedAt: json['lastConfirmedAt'] != null
          ? DateTime.tryParse(json['lastConfirmedAt'] as String)
          : null,
      // Ephemeral — never persisted.
      error: null,
      permanentlyDenied: false,
      isOpen: false,
      pendingState: null,
      pendingLga: null,
      pendingDetectedAt: null,
      looseLgaSuggestion: null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'country': country,
      'city': city,
      'detectedStateRaw': detectedStateRaw,
      'selectedState': selectedState,
      'selectedLga': selectedLga,
      'lastConfirmedAt': lastConfirmedAt?.toIso8601String(),
    };
  }

  // ── copyWith ───────────────────────────────────────────────────────────────

  LocationState copyWith({
    LocationPhase? phase,
    Object? error = _unset,
    bool? permanentlyDenied,
    double? latitude,
    double? longitude,
    String? country,
    String? detectedStateRaw,
    String? city,
    String? selectedState,
    bool clearLga = false,
    String? selectedLga,
    bool? isOpen,
    DateTime? lastConfirmedAt,
    Object? pendingState = _unset,
    Object? pendingLga = _unset,
    Object? pendingDetectedAt = _unset,
    Object? looseLgaSuggestion = _unset,
  }) {
    return LocationState(
      phase: phase ?? this.phase,
      error: error == _unset ? this.error : error as String?,
      permanentlyDenied: permanentlyDenied ?? this.permanentlyDenied,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      country: country ?? this.country,
      detectedStateRaw: detectedStateRaw ?? this.detectedStateRaw,
      city: city ?? this.city,
      selectedState: selectedState ?? this.selectedState,
      selectedLga: clearLga ? null : (selectedLga ?? this.selectedLga),
      isOpen: isOpen ?? this.isOpen,
      lastConfirmedAt: lastConfirmedAt ?? this.lastConfirmedAt,
      pendingState:
          pendingState == _unset ? this.pendingState : pendingState as String?,
      pendingLga: pendingLga == _unset ? this.pendingLga : pendingLga as String?,
      pendingDetectedAt: pendingDetectedAt == _unset
          ? this.pendingDetectedAt
          : pendingDetectedAt as DateTime?,
      looseLgaSuggestion: looseLgaSuggestion == _unset
          ? this.looseLgaSuggestion
          : looseLgaSuggestion as String?,
    );
  }

  static const _unset = Object();

  // ── Convenience getters ────────────────────────────────────────────────────

  /// True when [selectedState] has been set by GPS or manual selection.
  bool get hasSelection => selectedState != null;

  /// True when both state AND LGA are set, regardless of source. This is
  /// a DATA-completeness check, not a UI gating signal — use
  /// [requiresManualSelection] / [hasGpsLayerIssue] for deciding what to
  /// show. Geographical content/queries should still check this before
  /// using selectedState/selectedLga.
  bool get isComplete => selectedState != null && selectedLga != null;

  bool get isReady => phase == LocationPhase.ready;
  bool get isLoading => phase == LocationPhase.loading;
  bool get hasRestoredLocation => latitude != null && longitude != null;

  /// True when location is NOT yet complete and the app should be blocked
  /// by the full-screen gate (LocationGateOverlay) — REGARDLESS of why.
  /// This is the single source of truth for "must the user manually set
  /// state+LGA before proceeding." It fires for:
  ///   - phase == ready but state and/or LGA missing (detection ran, came
  ///     up short — e.g. rural area, unmatched geocoder result), AND
  ///   - phase == denied / permanentlyDenied / error (GPS/permission
  ///     failed entirely — manual selection is the ONLY path forward).
  /// Manual selection always remains available via LocationPickerPanel
  /// regardless of phase, so a GPS failure is never a dead end — it just
  /// means the user must pick state+LGA by hand instead of relying on
  /// auto-detection. The moment isComplete becomes true (by any means),
  /// this flips false and the gate clears immediately.
  ///
  /// NOTE: previously this only fired when phase == ready, which meant a
  /// denied/error phase let the user straight into the app with NO
  /// location set at all — an unintended bypass of the compulsory
  /// requirement. That hole is closed here: every non-loading,
  /// non-complete phase blocks.
  bool get requiresManualSelection =>
      phase != LocationPhase.loading &&
      phase != LocationPhase.initial &&
      !isComplete;

  /// True when GPS resolved a state but could not confidently match an
  /// LGA, and the user hasn't picked one manually. A sub-case of
  /// [requiresManualSelection] — when this is true, the overlay is
  /// already up; this getter exists to tailor copy/nudges, not to control
  /// whether blocking happens.
  bool get needsLgaConfirmation =>
      phase == LocationPhase.ready &&
      selectedState != null &&
      selectedLga == null;

  /// True when permission was denied, location services are off, or an
  /// unexpected error occurred during GPS/geocoding. NO LONGER a bypass
  /// of the gate — [requiresManualSelection] already accounts for these
  /// phases and blocks regardless. This getter now exists purely to
  /// tailor copy/actions (e.g. show an "Open Settings" button instead of
  /// "Retry" inside the gate overlay, or to drive the separate
  /// LocationGpsBanner shown once the user IS past the gate but a later
  /// background refresh fails — e.g. they completed manual selection,
  /// then a subsequent refresh() call hit a permission error; isComplete
  /// stays true in that case since selectedState/selectedLga are untouched
  /// by a failed refresh, so the gate correctly does NOT reappear, but the
  /// banner can still inform them the background refresh failed).
  bool get hasGpsLayerIssue =>
      phase == LocationPhase.denied ||
      phase == LocationPhase.permanentlyDenied ||
      phase == LocationPhase.error;

  /// True when a GPS read disagrees with the confirmed selection and is
  /// awaiting a second agreeing read before being promoted.
  bool get hasPendingChange => pendingState != null;

  /// THE single condition that shows the location picker modal — there is
  /// now exactly ONE presentation surface (LocationModal) for both the
  /// compulsory startup gate and casual manual editing. Fires when either:
  ///   - [requiresManualSelection] is true (compulsory — non-dismissible), or
  ///   - the user tapped the trigger to edit ([isOpen], dismissible).
  /// See [isDismissible] to distinguish which case is active for rendering
  /// the close affordance.
  bool get showLocationModal => requiresManualSelection || isOpen;

  /// True when the modal currently showing may be dismissed by the user
  /// without completing a selection. False during the compulsory gate
  /// (requiresManualSelection) — that case has no escape regardless of
  /// isOpen, since closing it would leave location incomplete.
  bool get isDismissible => !requiresManualSelection;


  String get displayLabel {
    if (selectedLga != null && selectedState != null) {
      return '$selectedLga, $selectedState';
    }
    if (selectedState != null) return selectedState!;
    return 'Select Location';
  }
}
