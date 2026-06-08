// location_state.dart

enum LocationPhase { initial, loading, ready, denied, permanentlyDenied, error }

class LocationState {
  // ── Phase ─────────────────────────────────────────────────────────────────
  final LocationPhase phase;
  final String? error;
  final bool permanentlyDenied;

  // ── Detected coordinates + geocode result ──────────────────────────────────
  final double? latitude;
  final double? longitude;
  final String? country;
  final String? detectedStateRaw; // raw from geocoder e.g. "Rivers State"
  final String? city;

  // ── Dropdown UI state ─────────────────────────────────────────────────────
  final String? selectedState;
  final String? selectedLga;
  final bool isOpen;

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

  static const _unset = Object();

  // ── Convenience getters ───────────────────────────────────────────────────

  bool get hasSelection => selectedState != null;
  bool get isReady => phase == LocationPhase.ready;
  bool get isLoading => phase == LocationPhase.loading;

  String get displayLabel {
    if (selectedLga != null && selectedState != null) {
      return '$selectedLga, $selectedState';
    }
    if (selectedState != null) return selectedState!;
    return 'Select Location';
  }
}
