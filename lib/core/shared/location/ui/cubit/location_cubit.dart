// =============================================================================
//  VeriRent NG — LocationCubit
//
//  Manages GPS permission, position resolution, reverse geocoding, and the
//  State → LGA dropdown selection for the location picker widget.
//
//  Hydration behaviour
//  ───────────────────
//  Extends [HydratedCubit] so that the user's last known location and
//  dropdown selection survive app restarts. On cold start:
//
//    1. [fromJson] restores [selectedState], [selectedLga], and last GPS
//       coordinates — the user sees their previous choice immediately.
//    2. The cubit constructor calls [init], which re-runs the full permission
//       → GPS → geocode pipeline in the background and updates the state
//       with fresh coordinates when ready.
//    3. [phase] is never restored from JSON — it always resets to
//       [LocationPhase.initial] so init() always re-validates permissions.
//
//  Error resilience
//  ────────────────
//  [fromJson] is wrapped in try/catch. Any deserialization failure returns
//  null, causing HydratedCubit to fall back to the default [LocationState],
//  which is safe to operate from.
//
//  developer: charles praise diepriye
// =============================================================================

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../data/mock.dart'; // NigeriaLocations
import 'location_state.dart';

class LocationCubit extends HydratedCubit<LocationState> {
  /// Initializes with the default [LocationState] and immediately kicks off
  /// the permission → GPS → geocode pipeline.
  ///
  /// If [HydratedCubit] restores a previous state from storage, [init] will
  /// still run — refreshing GPS in the background while the restored
  /// [selectedState] / [selectedLga] remain visible to the user.
  LocationCubit() : super(const LocationState()) {
    init();
  }

  // ── Public entry point ────────────────────────────────────────────────────

  /// Runs the full location resolution pipeline:
  ///   permission check → GPS fix → reverse geocode → dropdown pre-fill.
  ///
  /// Safe to call multiple times (e.g. after user fixes permissions).
  /// Previous selection is preserved while loading.
  Future<void> init() async {
    // Retain the existing selection so the UI does not blank out during reload.
    emit(state.copyWith(phase: LocationPhase.loading));

    final granted = await _ensurePermission();
    if (!granted)
      return; // error state already emitted inside _ensurePermission

    await _fetchAndApply();
  }

  // ── Permission ────────────────────────────────────────────────────────────

  /// Checks location permission and requests it if not yet decided.
  ///
  /// Emits the appropriate error phase and returns false if permission
  /// cannot be obtained, so [init] can short-circuit cleanly.
  Future<bool> _ensurePermission() async {
    // Guard: device-level location service toggle (Settings → Location).
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      emit(
        state.copyWith(
          phase: LocationPhase.error,
          error:
              'Location services are disabled. Please enable them in Settings.',
        ),
      );
      return false;
    }

    PermissionStatus permission = await Permission.location.status;

    // First-time or previously denied → show the OS dialog.
    if (permission.isDenied) {
      permission = await Permission.location.request();
    }

    // User ticked "Never ask again" → must send them to app settings.
    if (permission.isPermanentlyDenied) {
      emit(
        state.copyWith(
          phase: LocationPhase.permanentlyDenied,
          permanentlyDenied: true,
          error:
              'Location permission is permanently denied. '
              'Enable it in app settings.',
        ),
      );
      return false;
    }

    // Any other non-granted result (dismissed dialog, etc.).
    if (!permission.isGranted) {
      emit(
        state.copyWith(
          phase: LocationPhase.denied,
          error: 'Location permission was denied.',
        ),
      );
      return false;
    }

    return true;
  }

  // ── Position + Geocoding ──────────────────────────────────────────────────

  /// Fetches the current GPS position and reverse-geocodes it to a placemark.
  /// Pre-selects the matching Nigerian state in the dropdown if found.
  ///
  /// On success, emits [LocationPhase.ready] with coordinates and geocode
  /// results. On failure, emits [LocationPhase.error].
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

      final detectedState = _matchState(place?.administrativeArea);

      // Attempt LGA detection only when we have a matched state,
      // since lgasFor() needs a valid state name.
      final detectedLga = detectedState != null
          ? _matchLga(
              stateName: detectedState,
              subAdministrativeArea: place?.subAdministrativeArea,
              locality: place?.locality,
            )
          : null;

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
          selectedState: state.selectedState ?? detectedState,
          // Only auto-fill LGA if user has no existing selection.
          // detectedLga may be null — that's fine, user picks manually.
          selectedLga: state.selectedLga ?? detectedLga,
          clearLga:
              state.selectedState == null &&
              detectedState != null &&
              state.selectedLga == null &&
              detectedLga == null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          phase: LocationPhase.error,
          error: 'Could not determine your location: ${e.toString()}',
        ),
      );
    }
  }

  /// Attempts to match the geocoder's [subAdministrativeArea] and [locality]
  /// against the LGA list for [stateName].
  ///
  /// Tries in order:
  ///   1. Direct match on subAdministrativeArea (e.g. "Obio-Akpor")
  ///   2. Partial/fuzzy match on subAdministrativeArea
  ///   3. Direct match on locality (e.g. "Port Harcourt" → "Port Harcourt")
  ///   4. Partial/fuzzy match on locality
  ///   5. Returns null — user must select manually
  ///
  /// Fuzzy matching strips common suffixes ("Local Government", "LGA", "-Akpor")
  /// and compares lowercase to handle geocoder inconsistencies.
  String? _matchLga({
    required String stateName,
    String? subAdministrativeArea,
    String? locality,
  }) {
    final lgas = NigeriaLocations.lgasFor(stateName);
    if (lgas.isEmpty) return null;

    // Try each geocoder field in priority order.
    for (final raw in [subAdministrativeArea, locality]) {
      if (raw == null || raw.trim().isEmpty) continue;

      final result = _fuzzyMatchLga(raw, lgas);
      if (result != null) return result;
    }

    return null; // no match — dropdown stays unselected
  }

  /// Fuzzy-matches [raw] against [lgas] using two passes:
  ///   Pass 1 — exact match after normalization
  ///   Pass 2 — contains match (raw contains lga name or vice versa)
  String? _fuzzyMatchLga(String raw, List<String> lgas) {
    final normalized = _normalizeLga(raw);

    // Pass 1: exact normalized match.
    for (final lga in lgas) {
      if (_normalizeLga(lga) == normalized) return lga;
    }

    // Pass 2: substring match — catches "Port Harcourt" matching
    // "Port Harcourt" LGA, or "Obio" partially matching "Obio-Akpor".
    for (final lga in lgas) {
      final normalizedLga = _normalizeLga(lga);
      if (normalized.contains(normalizedLga) ||
          normalizedLga.contains(normalized)) {
        return lga;
      }
    }

    return null;
  }

  /// Strips common geocoder noise from an LGA string for comparison.
  String _normalizeLga(String raw) {
    return raw
        .toLowerCase()
        .replaceAll('local government area', '')
        .replaceAll('local government', '')
        .replaceAll(' lga', '')
        .replaceAll('-akpor', '') // Rivers State geocoder artefact
        .trim();
  }

  /// Fuzzy-matches the geocoder's [administrativeArea] string against
  /// [NigeriaLocations.states].
  ///
  /// Handles common geocoder variations such as:
  ///   - "Rivers State" → "Rivers"
  ///   - "FCT" → no match (returns null)
  ///   - "RIVERS" → "Rivers" (case-insensitive)
  String? _matchState(String? raw) {
    if (raw == null) return null;
    final normalized = raw.toLowerCase().replaceAll(' state', '').trim();
    try {
      return NigeriaLocations.states.firstWhere(
        (s) => s.toLowerCase() == normalized,
      );
    } catch (_) {
      return null; // no match — dropdown stays at current value
    }
  }

  // ── Recovery actions ──────────────────────────────────────────────────────

  /// Opens the OS app-settings page so the user can grant permanent permission.
  /// Call this when [state.phase] is [LocationPhase.permanentlyDenied].
  Future<void> openSettings() => openAppSettings();

  /// Opens the device location settings page.
  /// Call this when [state.phase] is [LocationPhase.error] due to
  /// location services being disabled.
  Future<void> openLocationSettings() => Geolocator.openLocationSettings();

  /// Retries the full permission → GPS pipeline.
  /// Typically called after the user returns from settings.
  Future<void> retry() => init();

  // ── Dropdown UI actions ───────────────────────────────────────────────────

  /// Toggles the dropdown overlay open/closed.
  void toggleDropdown() => emit(state.copyWith(isOpen: !state.isOpen));

  /// Closes the dropdown overlay without changing the selection.
  void closeDropdown() => emit(state.copyWith(isOpen: false));

  /// Sets the selected Nigerian state and clears the LGA selection.
  /// [isOpen] stays true so the LGA column becomes visible immediately.
  void selectState(String stateName) => emit(
    state.copyWith(selectedState: stateName, clearLga: true, isOpen: true),
  );

  /// Sets the selected LGA under the current [state.selectedState] and
  /// closes the dropdown overlay.
  void selectLga(String lga) =>
      emit(state.copyWith(selectedLga: lga, isOpen: false));

  /// Clears both [selectedState] and [selectedLga] and closes the dropdown.
  void clearSelection() =>
      emit(state.copyWith(selectedState: null, clearLga: true, isOpen: false));

  // ── HydratedCubit serialization ───────────────────────────────────────────

  /// Restores state from the on-disk JSON written by [toJson].
  ///
  /// Returns null on any failure — HydratedCubit will then use the
  /// default constructor state, which is always safe.
  @override
  LocationState? fromJson(Map<String, dynamic> json) {
    try {
      return LocationState.fromJson(json);
    } catch (_) {
      // Corrupt or incompatible storage (e.g. after a field rename).
      // Fall back to a clean default state rather than crashing.
      return null;
    }
  }

  /// Writes the current state to disk for restoration on next launch.
  ///
  /// Delegates to [LocationState.toJson], which omits ephemeral fields.
  /// Returns null if serialization throws — HydratedCubit will skip writing.
  @override
  Map<String, dynamic>? toJson(LocationState state) {
    try {
      return state.toJson();
    } catch (_) {
      return null;
    }
  }
}
