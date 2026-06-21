// =============================================================================
//  VeriRent NG — LocationGpsBanner
//
//  Non-blocking, dismissible banner for GPS-layer failures (permission
//  denied, permanently denied, location services off, or an unexpected
//  geocoding error). Deliberately does NOT block the app — the user can
//  dismiss this and proceed; location can be set manually anytime via the
//  LocationDropdown trigger/edit icon.
//
//  Drop this into a screen (Home is the natural place) wherever you want
//  the prompt to surface. It hides itself automatically once the issue
//  resolves (e.g. user grants permission and taps Retry) or the location
//  becomes complete by other means.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../theme/agents_theme.dart';
import '../cubit/location_cubit.dart';
import '../cubit/location_state.dart';

class LocationGpsBanner extends StatefulWidget {
  const LocationGpsBanner({super.key});

  @override
  State<LocationGpsBanner> createState() => _LocationGpsBannerState();
}

class _LocationGpsBannerState extends State<LocationGpsBanner> {
  bool _dismissed = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationCubit, LocationState>(
      bloc: GetIt.I<LocationCubit>(),
      buildWhen: (prev, curr) => prev.phase != curr.phase,
      builder: (context, state) {
        // Reset dismissal if a fresh issue occurs after a prior one was
        // dismissed and resolved — otherwise a denied-then-fixed-then-
        // denied-again sequence would stay silently hidden.
        if (!state.hasGpsLayerIssue) {
          if (_dismissed) _dismissed = false;
          return const SizedBox.shrink();
        }
        if (_dismissed) return const SizedBox.shrink();

        final cubit = GetIt.I<LocationCubit>();
        final isPermanentlyDenied =
            state.phase == LocationPhase.permanentlyDenied;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: VeriRentColors.warning500.withOpacity(0.12),
            borderRadius: BorderRadius.circular(VeriRentRadius.md),
            border: Border.all(
              color: VeriRentColors.warning500.withOpacity(0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.location_off_rounded,
                size: 16,
                color: VeriRentColors.warning500,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  state.error ?? 'We couldn\'t detect your location.',
                  style: VeriRentText.bodySmall.copyWith(
                    color: VeriRentColors.warning500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () {
                  if (isPermanentlyDenied) {
                    cubit.openSettings();
                  } else {
                    cubit.retry();
                  }
                },
                child: Text(
                  isPermanentlyDenied ? 'Settings' : 'Retry',
                  style: VeriRentText.labelSmall.copyWith(
                    color: VeriRentColors.warning500,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => setState(() => _dismissed = true),
                child: Icon(
                  Icons.close_rounded,
                  size: 14,
                  color: VeriRentColors.warning500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
