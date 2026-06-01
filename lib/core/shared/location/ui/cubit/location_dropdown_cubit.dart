// =============================================================================
//  VeriRent NG — Location Dropdown Cubit
// =============================================================================

import 'package:flutter_bloc/flutter_bloc.dart';

import 'location_dropdown_state.dart';

// ── Cubit ─────────────────────────────────────────────────────────────────────

class LocationDropdownCubit extends Cubit<LocationDropdownState> {
  LocationDropdownCubit() : super(const LocationDropdownState());

  void toggleDropdown() => emit(state.copyWith(isOpen: !state.isOpen));

  void closeDropdown() => emit(state.copyWith(isOpen: false));

  void selectState(String stateName) => emit(
    state.copyWith(selectedState: stateName, clearLga: true, isOpen: true),
  );

  void selectLga(String lga) =>
      emit(state.copyWith(selectedLga: lga, isOpen: false));

  void clearSelection() => emit(const LocationDropdownState());
}
