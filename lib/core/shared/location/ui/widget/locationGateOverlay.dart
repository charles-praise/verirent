// =============================================================================
//  VeriRent NG — LocationGateOverlay
//
//  Shown by Main (as a Stack layer on top of the shell, NOT a separate
//  route/page) when LocationCubit.state.requiresManualSelection is true —
//  i.e. the auto-detection pipeline completed but did not produce a usable
//  state+LGA pair. Blurs whatever is behind it and forces manual selection
//  via the shared LocationPickerPanel, centered, non-dismissible.
//
//  Deliberately does NOT appear for GPS-layer failures (denied,
//  permanentlyDenied, error) — those are handled by LocationGpsBanner
//  instead, which is non-blocking. See LocationState.hasGpsLayerIssue.
// =============================================================================

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../theme/agents_theme.dart';
import '../cubit/location_cubit.dart';
import 'locationPickerPanel.dart';

class LocationGateOverlay extends StatefulWidget {
  const LocationGateOverlay({super.key});

  @override
  State<LocationGateOverlay> createState() => _LocationGateOverlayState();
}

class _LocationGateOverlayState extends State<LocationGateOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    )..forward();
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _scale = Tween<double>(
      begin: 0.96,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onLgaSelected(String state, String lga) {
    // Nothing to do — once selectedLga is set, isComplete flips true,
    // requiresManualSelection flips false, and the parent (Main) removes
    // this overlay from the tree automatically via its BlocBuilder.
  }

  void _onStateSelected(String state) {
    // No-op for the same reason as above — picking a state alone may still
    // leave requiresManualSelection true (LGA pending), which is exactly
    // right: the overlay should stay up until both are set.
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: GetIt.I<LocationCubit>(),
      child: FadeTransition(
        opacity: _fade,
        child: Stack(
          children: [
            // Blurred, dimmed backdrop over whatever Main is showing
            // underneath (the shell mid-load, or last-known content).
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(color: VeriRentColors.black.withOpacity(0.45)),
              ),
            ),
            // Centered panel — no scrim tap-to-dismiss handler at all,
            // since this must not be dismissible until selection completes.
            Center(
              child: ScaleTransition(
                scale: _scale,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Confirm your location',
                        style: VeriRentText.titleMedium.copyWith(
                          color: VeriRentColors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      LocationPickerPanel(
                        onLgaSelected: _onLgaSelected,
                        onStateSelected: _onStateSelected,
                        width: 320,
                        maxHeight: 420,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
