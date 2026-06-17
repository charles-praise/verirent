// =============================================================================
//  Agent NG — LocationState
//
//  Immutable state for the LocationCubit.
//
//  Serialization contract
//  ──────────────────────
//  • Only fields that are meaningful to restore across sessions are persisted:
//      - selectedState, selectedLga  → last known manual/auto selection
//      - latitude, longitude         → last known GPS coordinates
//      - country, city               → last known geocode result
//      - detectedStateRaw            → raw geocoder string for debugging
//
//  • Fields that are NOT persisted (reset on every cold start):
//      - phase       → always starts as LocationPhase.initial so the cubit
//                       re-validates permissions on next launch
//      - error       → stale error messages are meaningless next session
//      - permanentlyDenied → re-checked live each session
//      - isOpen      → UI-only; overlay is never open at startup
//
//  developer: charles praise diepriye
// =============================================================================

// ── Phase enum ────────────────────────────────────────────────────────────────

/// Represents the current phase of the location resolution pipeline.
///
/// Transitions:
///   initial → loading → ready
///                    ↘ denied
///                    ↘ permanentlyDenied
///                    ↘ error
enum LocationPhase {
  /// Default state before [LocationCubit.init] is called.
  initial,

  /// GPS / permission resolution is in progress.
  loading,

  /// GPS resolved successfully; [LocationState.latitude] and
  /// [LocationState.longitude] are populated.
  ready,

  /// User denied the location permission (can ask again).
  denied,

  /// User permanently denied the permission; must route to app settings.
  permanentlyDenied,

  /// An unexpected error occurred during permission check or geocoding.
  error,
}

// ── State ─────────────────────────────────────────────────────────────────────

class LocationState {
  // ── Phase & error ──────────────────────────────────────────────────────────

  /// Current step in the location resolution pipeline.
  final LocationPhase phase;

  /// Human-readable error message when [phase] is [LocationPhase.error],
  /// [LocationPhase.denied], or [LocationPhase.permanentlyDenied].
  final String? error;

  /// True when the OS will no longer show the permission dialog for this app.
  /// The UI should show a button that routes to app settings.
  final bool permanentlyDenied;

  // ── Coordinates & geocode ──────────────────────────────────────────────────

  /// WGS-84 latitude returned by [Geolocator].
  final double? latitude;

  /// WGS-84 longitude returned by [Geolocator].
  final double? longitude;

  /// ISO country name from the geocoder (e.g. "Nigeria").
  final String? country;

  /// Raw [administrativeArea] string from the geocoder
  /// (e.g. "Rivers State"). Used for fuzzy state matching and debugging.
  final String? detectedStateRaw;

  /// Locality/city name from the geocoder (e.g. "Port Harcourt").
  final String? city;

  // ── Dropdown UI state ──────────────────────────────────────────────────────

  /// The Nigerian state currently selected in the dropdown,
  /// either auto-detected from GPS or manually picked by the user.
  final String? selectedState;

  /// The LGA currently selected under [selectedState].
  /// Always null when [selectedState] is null.
  final String? selectedLga;

  /// Whether the dropdown overlay is currently visible.
  /// Never persisted — overlay is always closed at startup.
  final bool isOpen;

  // ── Constructor ────────────────────────────────────────────────────────────

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
  });

  // ── Serialization ──────────────────────────────────────────────────────────

  /// Restores a [LocationState] from a JSON map written by [toJson].
  ///
  /// Deliberately resets ephemeral fields:
  ///   - [phase] → [LocationPhase.initial] (cubit always re-runs init)
  ///   - [error], [permanentlyDenied], [isOpen] → defaults
  factory LocationState.fromJson(Map<String, dynamic> json) {
    return LocationState(
      // Phase always resets — permissions must be re-validated each launch.
      phase: LocationPhase.initial,

      // Persisted location data — restored for immediate display while the
      // cubit fetches a fresh position in the background.
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      country: json['country'] as String?,
      city: json['city'] as String?,
      detectedStateRaw: json['detectedStateRaw'] as String?,

      // Persisted selection — user sees their last choice instantly.
      selectedState: json['selectedState'] as String?,
      selectedLga: json['selectedLga'] as String?,

      // Ephemeral — never persisted.
      error: null,
      permanentlyDenied: false,
      isOpen: false,
    );
  }

  /// Serializes only the fields that are meaningful to restore.
  /// Ephemeral fields (phase, error, permanentlyDenied, isOpen) are omitted.
  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'country': country,
      'city': city,
      'detectedStateRaw': detectedStateRaw,
      'selectedState': selectedState,
      'selectedLga': selectedLga,
    };
  }

  // ── copyWith ───────────────────────────────────────────────────────────────

  /// Returns a copy of this state with selected fields replaced.
  ///
  /// [clearLga] — when true, sets [selectedLga] to null regardless of whether
  /// [selectedLga] was provided. Use when changing [selectedState] to avoid
  /// a stale LGA from a previous state remaining selected.
  ///
  /// [error] uses a sentinel [_unset] so that passing `error: null` explicitly
  /// clears the error, while omitting [error] preserves the current value.
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
    );
  }

  /// Private sentinel used by [copyWith] to distinguish an explicit
  /// `error: null` (clear error) from an omitted `error` (keep current).
  static const _unset = Object();

  // ── Convenience getters ────────────────────────────────────────────────────

  /// True when [selectedState] has been set by GPS or manual selection.
  bool get hasSelection => selectedState != null;

  /// True when the location pipeline resolved successfully.
  bool get isReady => phase == LocationPhase.ready;

  /// True while permissions / GPS are being resolved.
  bool get isLoading => phase == LocationPhase.loading;

  /// True when we have restored coordinates from a previous session,
  /// but the current [phase] is still [LocationPhase.initial] or [loading].
  /// Useful for showing a "last known location" label in the UI.
  bool get hasRestoredLocation => latitude != null && longitude != null;

  /// Human-readable label for the trigger button.
  ///
  /// Priority: LGA + State → State only → fallback hint.
  String get displayLabel {
    if (selectedLga != null && selectedState != null) {
      return '$selectedLga, $selectedState';
    }
    if (selectedState != null) return selectedState!;
    return 'Select Location';
  }
}
