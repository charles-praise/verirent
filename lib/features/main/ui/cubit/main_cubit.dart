import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

part 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(const MainState());

  bool _busy = false;

  Future<void> check({bool background = false}) async {
    if (_busy) return;
    _busy = true;
    emit(
      state.copyWith(
        status: LocationStatus.loading,
        isBackground: background,
        message: null,
      ),
    );

    try {
      final serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(
          state.copyWith(
            status: LocationStatus.serviceDisabled,
            message: 'Location services are disabled.',
          ),
        );
        _busy = false;
        return;
      }

      final permission = background
          ? Permission.locationAlways
          : Permission.locationWhenInUse;
      final status = await permission.status;
      emit(_stateFromPermissionStatus(status, background));
    } catch (e) {
      emit(state.copyWith(status: LocationStatus.error, message: e.toString()));
    } finally {
      _busy = false;
    }
  }

  Future<void> resolve({
    bool background = false,
    bool enableServiceIfDisabled = false,
  }) async {
    if (_busy) return;
    _busy = true;
    emit(
      state.copyWith(
        status: LocationStatus.loading,
        isBackground: background,
        message: null,
      ),
    );

    try {
      var serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (enableServiceIfDisabled) {
          await geo.Geolocator.openLocationSettings();
          serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();
        }
        if (!serviceEnabled) {
          emit(
            state.copyWith(
              status: LocationStatus.serviceDisabled,
              message: 'Please enable location services.',
            ),
          );
          _busy = false;
          return;
        }
      }

      final target = background
          ? Permission.locationAlways
          : Permission.locationWhenInUse;
      final current = await target.status;

      if (current.isGranted || current.isLimited) {
        await _emitGranted();
        _busy = false;
        return;
      }

      if (current.isPermanentlyDenied) {
        emit(
          state.copyWith(
            status: LocationStatus.permanentlyDenied,
            isBackground: background,
            message: 'Permission permanently denied.',
          ),
        );
        _busy = false;
        return;
      }

      if (current.isDenied) {
        emit(
          state.copyWith(
            status: LocationStatus.rationaleRequired,
            isBackground: background,
            message: 'Permission denied; show rationale.',
          ),
        );
        _busy = false;
        return;
      }

      if (current.isRestricted) {
        emit(
          state.copyWith(
            status: LocationStatus.restricted,
            message: 'Permission restricted by OS.',
          ),
        );
        _busy = false;
        return;
      }

      // fallback: request
      await _doRequest(background: background);
    } catch (e) {
      emit(state.copyWith(status: LocationStatus.error, message: e.toString()));
    } finally {
      _busy = false;
    }
  }

  Future<void> requestAfterRationale({bool background = false}) async {
    if (_busy) return;
    await _doRequest(background: background);
  }

  Future<void> recheck({bool background = false}) async =>
      check(background: background);

  Future<void> openAppSettings() async {
    await openAppSettings();
  }

  Future<void> openLocationSettings() async {
    await geo.Geolocator.openLocationSettings();
  }

  Future<void> _doRequest({bool background = false}) async {
    _busy = true;
    emit(
      state.copyWith(
        status: LocationStatus.requesting,
        isBackground: background,
        message: null,
      ),
    );

    try {
      if (background && Platform.isAndroid) {
        await _androidBackgroundEscalation();
        return;
      }

      final target = background
          ? Permission.locationAlways
          : Permission.locationWhenInUse;
      final result = await target.request();
      emit(_stateFromPermissionStatus(result, background));
    } catch (e) {
      emit(state.copyWith(status: LocationStatus.error, message: e.toString()));
    } finally {
      _busy = false;
    }
  }

  Future<void> _androidBackgroundEscalation() async {
    final whenInUse = await Permission.locationWhenInUse.status;
    if (!whenInUse.isGranted) {
      final step1 = await Permission.locationWhenInUse.request();
      if (!step1.isGranted) {
        emit(_stateFromPermissionStatus(step1, true));
        _busy = false;
        return;
      }
    }

    await Future.delayed(const Duration(milliseconds: 500));
    final always = await Permission.locationAlways.request();
    emit(_stateFromPermissionStatus(always, true));
    _busy = false;
  }

  Future<void> _emitGranted() async {
    try {
      final pos = await geo.Geolocator.getCurrentPosition();
      emit(
        state.copyWith(
          status: LocationStatus.granted,
          position: pos,
          message: null,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: LocationStatus.granted, position: null));
    }
  }

  MainState _stateFromPermissionStatus(PermissionStatus ps, bool background) {
    if (ps.isGranted || ps == PermissionStatus.provisional) {
      return state.copyWith(
        status: LocationStatus.granted,
        isBackground: background,
        message: null,
      );
    }
    if (ps.isDenied) {
      return state.copyWith(
        status: LocationStatus.denied,
        isBackground: background,
        message: 'Permission denied.',
      );
    }
    if (ps.isPermanentlyDenied) {
      return state.copyWith(
        status: LocationStatus.permanentlyDenied,
        isBackground: background,
        message: 'Permission permanently denied.',
      );
    }
    if (ps.isRestricted) {
      return state.copyWith(
        status: LocationStatus.restricted,
        isBackground: background,
        message: 'Restricted by OS.',
      );
    }
    if (ps.isLimited) {
      return state.copyWith(
        status: LocationStatus.limited,
        isBackground: background,
        message: 'Limited/approximate location.',
      );
    }
    return state.copyWith(
      status: LocationStatus.error,
      message: 'Unknown permission status.',
    );
  }

  Future<void> fetchPosition() async {
    try {
      final pos = await geo.Geolocator.getCurrentPosition();
      emit(state.copyWith(status: LocationStatus.granted, position: pos));
    } catch (e) {
      emit(
        state.copyWith(
          status: LocationStatus.error,
          message: 'Failed to fetch position: $e',
        ),
      );
    }
  }
}
