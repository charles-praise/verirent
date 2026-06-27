// =============================================================================
//  VeriRent NG — LocationCubit
//
//  Manages GPS permission, position resolution, reverse geocoding, and the
//  State → LGA dropdown selection for the location picker widget.
//
//  Gating
//  ──────
//  Both state AND LGA are compulsory before geographical content may be
//  shown. See [LocationState.isComplete] — that getter is the single
//  source of truth consumed by the router guard.
//
//  Caching policy (avoid unnecessary GPS/network hits)
//  ─────────────────────────────────────────────────────
//  On cold start, [init] does NOT always re-run the full permission → GPS →
//  geocode pipeline. If the cached state is already [LocationState.isComplete]
//  and was confirmed within [_cacheValidity], init() short-circuits and emits
//  [LocationPhase.ready] immediately using cached data — no GPS call, no
//  permission prompt, no geocoding. The pipeline only runs:
//    - on first-ever launch (no confirmed selection yet),
//    - when the cache has expired,
//    - when explicitly forced via [refresh] (e.g. user pulls to refresh,
//      or taps "update my location").
//
//  Anti-jitter: 2 consecutive agreeing reads required to change state
//  ──────────────────────────────────────────────────────────────────
//  GPS near a state/LGA border can jitter between neighbouring values.
//  Once the user has a CONFIRMED selectedState, a fresh GPS read that
//  disagrees with it is never applied immediately. It is stored as
//  [LocationState.pendingState]/[pendingLga]. Only if the *next* read also
//  produces the same disagreeing value is it promoted to selectedState/Lga.
//  A single noisy read therefore self-corrects on the following read instead
//  of silently relocating the user.
//
//  This protection does not apply to a user's first-ever resolution (no
//  confirmed state yet) — there's nothing to protect against overwriting.
//
//  Loose LGA fallback
//  ───────────────────
//  When strict fuzzy matching fails to find an LGA, a secondary, non-strict
//  guess is computed from the raw geocoder locality string and exposed as
//  [LocationState.looseLgaSuggestion]. It is NEVER auto-applied — only
//  offered to the user as a one-tap "not sure? use this" option in the
//  forced confirmation prompt.
//
//  developer: charles praise diepriye
// =============================================================================

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../data/mock.dart'; // NigeriaLocations
import 'location_state.dart';

class LocationCubit extends HydratedCubit<LocationState> {
  LocationCubit() : super(const LocationState()) {
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  /// How long a confirmed location stays valid before init() will
  /// silently re-check GPS in the background on next cold start.
  static const _cacheValidity = Duration(hours: 24);

  /// How long a pending (unconfirmed, disagreeing) GPS read remains
  /// eligible to be confirmed by a second read. Past this window a fresh
  /// disagreement starts a new pending cycle rather than chaining.
  static const _pendingWindow = Duration(minutes: 10);

  // ── Public entry point ────────────────────────────────────────────────────

  /// Runs the permission → GPS → geocode pipeline, but SKIPS it entirely
  /// if the cached selection is complete and still within [_cacheValidity].
  /// This is what makes repeat app opens cheap and silent.
  Future<void> init() async {
    if (state.isComplete &&
        state.lastConfirmedAt != null &&
        DateTime.now().difference(state.lastConfirmedAt!) < _cacheValidity) {
      // Cache hit — trust the confirmed selection, no GPS/network call.
      emit(state.copyWith(phase: LocationPhase.ready, error: null));
      return;
    }
    await _run();
  }

  /// Forces a fresh permission → GPS → geocode pass regardless of cache
  /// validity. Call this from an explicit "refresh location" action, or
  /// from a foreground/background lifecycle hook if you want periodic
  /// silent re-validation — NOT from init().
  Future<void> refresh() => _run();

  Future<void> _run() async {
    emit(state.copyWith(phase: LocationPhase.loading));
    try {
      await Future.any([
        _pipeline(),
        Future.delayed(const Duration(seconds: 15), () {
          throw TimeoutException('Location timed out');
        }),
      ]);
    } catch (e) {
      if (!isClosed) {
        emit(
          state.copyWith(
            phase: LocationPhase.error,
            error: 'Could not determine your location. Please select manually.',
          ),
        );
      }
    }
  }

  Future<void> _pipeline() async {
    final granted = await _ensurePermission();
    if (!granted) return;
    await _fetchAndApply();
  }

  Future<void> _pipeLine() async {
    emit(state.copyWith(phase: LocationPhase.loading));
    final granted = await _ensurePermission();
    if (!granted) return;
    await _fetchAndApply();
  }

  // ── Permission ────────────────────────────────────────────────────────────

  Future<bool> _ensurePermission() async {
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

    if (permission.isDenied) {
      permission = await Permission.location.request();
    }

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

  Future<void> _fetchAndApply() async {
    try {
      final position =
          await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
            timeLimit: Duration(seconds: 10),
          ).catchError((_) async {
            // Fallback to last known position on timeout
            return await Geolocator.getLastKnownPosition() ??
                (throw Exception('Could not determine location'));
          });

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      final place = placemarks.isNotEmpty ? placemarks.first : null;

      final detectedState = _matchState(place?.administrativeArea);

      final detectedLga = detectedState != null
          ? _matchLga(
              stateName: detectedState,
              subAdministrativeArea: place?.subAdministrativeArea,
              locality: place?.locality,
            )
          : null;

      // Loose, unverified guess — only used as a suggestion, never applied.
      final looseGuess = detectedState != null && detectedLga == null
          ? _looseLgaGuess(place?.subAdministrativeArea, place?.locality)
          : null;

      _applyDetectedLocation(
        position: position,
        place: place,
        detectedState: detectedState,
        detectedLga: detectedLga,
        looseGuess: looseGuess,
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

  /// Decides whether a freshly detected state/LGA should be applied
  /// immediately (no prior confirmed selection), held as pending awaiting
  /// a second agreeing read (disagrees with a confirmed selection), or
  /// promoted (a second read agreed with the pending value).
  void _applyDetectedLocation({
    required Position position,
    required Placemark? place,
    required String? detectedState,
    required String? detectedLga,
    required String? looseGuess,
  }) {
    final baseFields = state.copyWith(
      phase: LocationPhase.ready,
      error: null,
      permanentlyDenied: false,
      latitude: position.latitude,
      longitude: position.longitude,
      country: place?.country,
      detectedStateRaw: place?.administrativeArea,
      city: place?.locality,
      looseLgaSuggestion: looseGuess,
    );

    // Case 1 — no confirmed selection yet. Apply immediately, no anti-jitter
    // gate needed since there is nothing confirmed to protect.
    if (state.selectedState == null) {
      emit(
        baseFields.copyWith(
          selectedState: detectedState,
          selectedLga: detectedLga,
          clearLga: detectedLga == null,
          lastConfirmedAt: detectedState != null ? DateTime.now() : null,
          pendingState: null,
          pendingLga: null,
          pendingDetectedAt: null,
        ),
      );
      return;
    }

    // Case 2 — detected state agrees with the confirmed state. Nothing to
    // protect against; just refresh coordinates/city and clear any stale
    // pending value. If LGA was previously unmatched and now resolves
    // (e.g. better GPS fix), fill it in — never overwrite an existing LGA.
    if (detectedState == state.selectedState) {
      emit(
        baseFields.copyWith(
          selectedState: state.selectedState,
          selectedLga: state.selectedLga ?? detectedLga,
          pendingState: null,
          pendingLga: null,
          pendingDetectedAt: null,
        ),
      );
      return;
    }

    // Case 3 — detected state DISAGREES with the confirmed state.
    // Anti-jitter gate: require this exact disagreement to repeat on the
    // next read before promoting it.
    final pendingStillFresh =
        state.pendingDetectedAt != null &&
        DateTime.now().difference(state.pendingDetectedAt!) < _pendingWindow;

    final secondReadAgreesWithPending =
        pendingStillFresh &&
        state.pendingState == detectedState &&
        state.pendingLga == detectedLga;

    if (secondReadAgreesWithPending) {
      // Two consecutive reads agree — the user has genuinely moved.
      // Promote pending → confirmed.
      emit(
        baseFields.copyWith(
          selectedState: detectedState,
          selectedLga: detectedLga,
          clearLga: detectedLga == null,
          lastConfirmedAt: DateTime.now(),
          pendingState: null,
          pendingLga: null,
          pendingDetectedAt: null,
        ),
      );
    } else {
      // First disagreeing read (or pending expired/changed) — hold it,
      // keep the existing confirmed selection untouched.
      emit(
        baseFields.copyWith(
          selectedState: state.selectedState,
          selectedLga: state.selectedLga,
          pendingState: detectedState,
          pendingLga: detectedLga,
          pendingDetectedAt: DateTime.now(),
        ),
      );
    }
  }

  /// Strict match — see class docs. Returns null if no confident match.
  String? _matchLga({
    required String stateName,
    String? subAdministrativeArea,
    String? locality,
  }) {
    final lgas = NigeriaLocations.lgasFor(stateName);
    if (lgas.isEmpty) return null;

    for (final raw in [subAdministrativeArea, locality]) {
      if (raw == null || raw.trim().isEmpty) continue;
      final result = _fuzzyMatchLga(raw, lgas);
      if (result != null) return result;
    }
    return null;
  }

  String? _fuzzyMatchLga(String raw, List<String> lgas) {
    final normalized = _normalizeLga(raw);

    for (final lga in lgas) {
      if (_normalizeLga(lga) == normalized) return lga;
    }
    for (final lga in lgas) {
      final normalizedLga = _normalizeLga(lga);
      if (normalized.contains(normalizedLga) ||
          normalizedLga.contains(normalized)) {
        return lga;
      }
    }
    return null;
  }

  /// Non-strict fallback guess for when [_matchLga] fails entirely.
  /// Returns the geocoder's own locality/subAdministrativeArea string,
  /// lightly cleaned — NOT guaranteed to be a valid entry in
  /// [NigeriaLocations.lgasFor]. Purely a "here's our best guess" label
  /// for the user to accept or reject; never written to selectedLga
  /// without the user's explicit confirmation.
  String? _looseLgaGuess(String? subAdministrativeArea, String? locality) {
    final candidate = subAdministrativeArea?.trim().isNotEmpty == true
        ? subAdministrativeArea
        : locality;
    if (candidate == null || candidate.trim().isEmpty) return null;

    // Light cleanup only — title case, strip obvious noise words.
    final cleaned = candidate
        .replaceAll(
          RegExp(r'local government( area)?', caseSensitive: false),
          '',
        )
        .trim();
    return cleaned.isEmpty ? null : cleaned;
  }

  String _normalizeLga(String raw) {
    return raw
        .toLowerCase()
        .replaceAll('local government area', '')
        .replaceAll('local government', '')
        .replaceAll(' lga', '')
        .replaceAll('-akpor', '')
        .trim();
  }

  String? _matchState(String? raw) {
    if (raw == null) return null;
    final normalized = raw.toLowerCase().replaceAll(' state', '').trim();
    try {
      return NigeriaLocations.states.firstWhere(
        (s) => s.toLowerCase() == normalized,
      );
    } catch (_) {
      return null;
    }
  }

  // ── Recovery actions ──────────────────────────────────────────────────────

  Future<void> openSettings() => openAppSettings();
  Future<void> openLocationSettings() => Geolocator.openLocationSettings();

  /// Retries the full pipeline, bypassing cache — same as [refresh].
  Future<void> retry() => refresh();

  // ── Dropdown UI actions ───────────────────────────────────────────────────

  void toggleDropdown() => emit(state.copyWith(isOpen: !state.isOpen));
  void closeDropdown() => emit(state.copyWith(isOpen: false));

  /// Manual state selection — always clears LGA (state+LGA are compulsory
  /// together; changing state invalidates any prior LGA) and confirms
  /// immediately (manual input bypasses the anti-jitter gate by design).
  void selectState(String stateName) => emit(
    state.copyWith(
      selectedState: stateName,
      clearLga: true,
      isOpen: true,
      lastConfirmedAt: DateTime.now(),
      pendingState: null,
      pendingLga: null,
      pendingDetectedAt: null,
    ),
  );

  /// Manual LGA selection — completes the compulsory pair and confirms.
  void selectLga(String lga) => emit(
    state.copyWith(
      selectedLga: lga,
      isOpen: false,
      lastConfirmedAt: DateTime.now(),
    ),
  );

  /// Accepts the loose, unverified suggestion as the confirmed LGA —
  /// the "not sure? use our best guess" escape hatch. Requires an
  /// explicit user tap; never called automatically.
  void acceptLooseLgaSuggestion() {
    final guess = state.looseLgaSuggestion;
    if (guess == null) return;
    emit(
      state.copyWith(
        selectedLga: guess,
        isOpen: false,
        lastConfirmedAt: DateTime.now(),
        looseLgaSuggestion: null,
      ),
    );
  }

  void clearSelection() => emit(
    state.copyWith(
      selectedState: null,
      clearLga: true,
      isOpen: false,
      lastConfirmedAt: null,
      pendingState: null,
      pendingLga: null,
      pendingDetectedAt: null,
    ),
  );

  // ── HydratedCubit serialization ───────────────────────────────────────────

  @override
  LocationState? fromJson(Map<String, dynamic> json) {
    try {
      return LocationState.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(LocationState state) {
    try {
      return state.toJson();
    } catch (_) {
      return null;
    }
  }
}
