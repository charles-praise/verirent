// location_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../data/mock.dart'; // NigeriaLocations
import 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(const LocationState());

  // ── Public entry point ────────────────────────────────────────────────────

  /// Called once by MainCubit on app startup.
  /// Runs the full pipeline: permission → position → geocode → dropdown.
  Future<void> init() async {
    emit(state.copyWith(phase: LocationPhase.loading));

    final granted = await _ensurePermission();
    if (!granted) return; // state already emitted inside _ensurePermission

    await _fetchAndApply();
  }

  // ── Permission ────────────────────────────────────────────────────────────

  /// Checks and requests location permission.
  /// Emits appropriate error states and returns false if not granted.
  Future<bool> _ensurePermission() async {
    // Check if the device location service is on at all.
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      emit(
        state.copyWith(
          phase: LocationPhase.error,
          error: 'Location services are disabled.',
        ),
      );
      return false;
    }

    PermissionStatus permission = await Permission.location.status;

    // Request if not yet decided.
    if (permission.isDenied) {
      permission = await Permission.location.request();
    }

    if (permission.isPermanentlyDenied) {
      emit(
        state.copyWith(
          phase: LocationPhase.permanentlyDenied,
          error: 'Location permission permanently denied.',
        ),
      );
      return false;
    }

    if (!permission.isGranted) {
      emit(
        state.copyWith(
          phase: LocationPhase.denied,
          error: 'Location permission denied.',
        ),
      );
      return false;
    }

    return true;
  }

  // ── Position + Geocoding ──────────────────────────────────────────────────

  /// Fetches the device position and reverse-geocodes it.
  /// Pre-selects the matching state in the dropdown.
  Future<void> _fetchAndApply() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      final place = placemarks.isNotEmpty ? placemarks.first : null;

      // Match geocoder result against NigeriaLocations list.
      final detectedState = _matchState(place?.administrativeArea);

      emit(
        state.copyWith(
          phase: LocationPhase.ready,
          error: null,
          permanentlyDenied: false,
          latitude: position.latitude,
          longitude: position.longitude,
          country: place?.country,
          detectedStateRaw: place?.administrativeArea,
          city: place?.locality,
          // Pre-fill dropdown with detected state; clear any stale LGA.
          selectedState: detectedState,
          clearLga: true,
        ),
      );
    } catch (e) {
      emit(state.copyWith(phase: LocationPhase.error, error: e.toString()));
    }
  }

  /// Fuzzy-matches the geocoder's administrativeArea string against
  /// NigeriaLocations.states — handles "Rivers State" vs "Rivers" etc.
  String? _matchState(String? raw) {
    if (raw == null) return null;
    final normalized = raw.toLowerCase().replaceAll(' state', '').trim();
    try {
      return NigeriaLocations.states.firstWhere(
        (s) => s.toLowerCase() == normalized,
      );
    } catch (_) {
      return null; // no match — dropdown stays unselected
    }
  }

  // ── Recovery actions (called from UI) ─────────────────────────────────────

  /// User tapped "Open Settings" after permanent denial.
  Future<void> openSettings() => openAppSettings();

  /// User tapped "Enable Location" after service was disabled.
  Future<void> openLocationSettings() => Geolocator.openLocationSettings();

  /// Retry the full pipeline after user fixes permission/service.
  Future<void> retry() => init();

  // ── Dropdown UI state ─────────────────────────────────────────────────────

  void toggleDropdown() => emit(state.copyWith(isOpen: !state.isOpen));

  void closeDropdown() => emit(state.copyWith(isOpen: false));

  void selectState(String stateName) => emit(
    state.copyWith(selectedState: stateName, clearLga: true, isOpen: true),
  );

  void selectLga(String lga) =>
      emit(state.copyWith(selectedLga: lga, isOpen: false));

  void clearSelection() =>
      emit(state.copyWith(selectedState: null, clearLga: true, isOpen: false));
}
