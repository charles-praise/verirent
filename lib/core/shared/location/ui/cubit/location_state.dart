// ── State ─────────────────────────────────────────────────────────────────────

class LocationDropdownState {
  final String? selectedState;
  final String? selectedLga;
  final bool isOpen;

  const LocationDropdownState({
    this.selectedState,
    this.selectedLga,
    this.isOpen = false,
  });

  LocationDropdownState copyWith({
    String? selectedState,
    bool clearLga = false,
    String? selectedLga,
    bool? isOpen,
  }) => LocationDropdownState(
    selectedState: selectedState ?? this.selectedState,
    selectedLga: clearLga ? null : (selectedLga ?? this.selectedLga),
    isOpen: isOpen ?? this.isOpen,
  );

  String get displayLabel {
    if (selectedLga != null && selectedState != null) {
      return '$selectedLga, $selectedState';
    }
    if (selectedState != null) return selectedState!;
    return 'Select Location';
  }

  bool get hasSelection => selectedState != null;
}
