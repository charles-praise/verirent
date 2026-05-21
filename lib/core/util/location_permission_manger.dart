import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:permission_handler/permission_handler.dart';

/// Strongly-typed result for location permission operations.
enum LocationPermissionResult {
  granted,
  denied,
  permanentlyDenied,
  serviceDisabled,
  restricted, // iOS parental/guided access
  limited, // iOS approximate-only
  unknown,
}

/// Production-ready manager for cross-platform location permission handling.
///
/// Key features:
/// - Verifies GPS service state before requesting permission.
/// - Handles Android 10+ two-step background escalation automatically.
/// - Provides a UX-aware resolver with rationale and settings callbacks.
class LocationPermissionManager {
  LocationPermissionManager._();
  static final LocationPermissionManager _instance =
      LocationPermissionManager._();
  static LocationPermissionManager get instance => _instance;

  /// Whether the OS-level location service (GPS) is currently enabled.
  Future<bool> get isServiceEnabled =>
      geo.Geolocator.isLocationServiceEnabled();

  /// Checks permission status without triggering any request dialog.
  Future<LocationPermissionResult> checkStatus({
    bool background = false,
  }) async {
    final permission = background
        ? Permission.locationAlways
        : Permission.locationWhenInUse;
    return _mapStatus(await permission.status);
  }

  /// Requests permission and returns a resolved result.
  ///
  /// [background] — Request `locationAlways` instead of `locationWhenInUse`.
  /// [enableServiceIfDisabled] — If true and GPS is off, opens location settings
  /// and waits for the user to return before proceeding.
  Future<LocationPermissionResult> request({
    bool background = false,
    bool enableServiceIfDisabled = false,
  }) async {
    // Step 1: Ensure GPS service is active
    if (!await isServiceEnabled) {
      if (enableServiceIfDisabled) {
        await geo.Geolocator.openLocationSettings();
        if (!await isServiceEnabled) {
          return LocationPermissionResult.serviceDisabled;
        }
      } else {
        return LocationPermissionResult.serviceDisabled;
      }
    }

    // Step 2: Handle Android 10+ background escalation quirk
    if (background && Platform.isAndroid) {
      return await _requestAndroidBackground();
    }

    // Step 3: Standard permission request
    final target = background
        ? Permission.locationAlways
        : Permission.locationWhenInUse;
    final result = await target.request();
    return _mapStatus(result);
  }

  /// Full UX flow: rationale dialog → request → settings fallback.
  ///
  /// [onRationaleNeeded] — Called when permission is denied but *not* permanently.
  /// Return `true` to proceed with the system dialog, `false` to abort.
  ///
  /// [onPermanentlyDenied] — Called when the user must be routed to app settings.
  /// Return `true` if settings were opened successfully.
  Future<LocationPermissionResult> resolveWithUX({
    required BuildContext context,
    bool background = false,
    bool enableServiceIfDisabled = true,
    Future<bool> Function()? onRationaleNeeded,
    Future<bool> Function()? onPermanentlyDenied,
  }) async {
    // Ensure GPS is on
    if (!await isServiceEnabled) {
      if (enableServiceIfDisabled) {
        await geo.Geolocator.openLocationSettings();
        if (!await isServiceEnabled) {
          return LocationPermissionResult.serviceDisabled;
        }
      } else {
        return LocationPermissionResult.serviceDisabled;
      }
    }

    final target = background
        ? Permission.locationAlways
        : Permission.locationWhenInUse;
    var status = await target.status;

    if (status.isGranted) return LocationPermissionResult.granted;
    if (status.isPermanentlyDenied) {
      final opened =
          await (onPermanentlyDenied?.call() ?? _defaultOpenSettings());
      if (!opened) return LocationPermissionResult.permanentlyDenied;
      status = await target.status; // Re-check after returning from settings
      return _mapStatus(status);
    }

    // Show rationale if this is not the first denial
    if (status.isDenied && onRationaleNeeded != null) {
      final proceed = await onRationaleNeeded();
      if (!proceed) return LocationPermissionResult.denied;
    }

    return await request(background: background);
  }

  /// Android 10+ requires `WhenInUse` before `Always` can be requested.
  Future<LocationPermissionResult> _requestAndroidBackground() async {
    final whenInUse = await Permission.locationWhenInUse.status;
    if (!whenInUse.isGranted) {
      final step1 = await Permission.locationWhenInUse.request();
      if (!step1.isGranted) return _mapStatus(step1);
    }

    // Allow OEM transition time between dialogs
    await Future.delayed(const Duration(milliseconds: 500));
    final always = await Permission.locationAlways.request();
    return _mapStatus(always);
  }

  LocationPermissionResult _mapStatus(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.granted:
      case PermissionStatus.provisional:
        return LocationPermissionResult.granted;
      case PermissionStatus.denied:
        return LocationPermissionResult.denied;
      case PermissionStatus.permanentlyDenied:
        return LocationPermissionResult.permanentlyDenied;
      case PermissionStatus.restricted:
        return LocationPermissionResult.restricted;
      case PermissionStatus.limited:
        return LocationPermissionResult.limited;
    }
  }

  Future<bool> _defaultOpenSettings() => openAppSettings();
}
