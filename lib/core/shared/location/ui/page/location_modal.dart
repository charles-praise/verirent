// =============================================================================
//  VeriRent NG — LocationModal
//
//  THE single presentation surface for the location picker — replaces what
//  used to be two separate surfaces (LocationGateOverlay's full-screen
//  blur, and LocationDropdown's anchored CompositedTransformFollower
//  overlay). Both the compulsory startup gate and casual manual editing
//  now render through this one widget, in the same centered+blurred style.
//
//  Gating: shown whenever LocationState.showLocationModal is true.
//  Dismissibility: controlled by LocationState.isDismissible — the
//  compulsory case (requiresManualSelection) has no scrim-tap-to-dismiss
//  and no close button; the manual-edit case (isOpen only) has both.
//
//  Mount ONCE near the root of the app (inside Main/shell.dart, stacked
//  on top of the shell) — NOT per-screen. There is exactly one modal
//  instance for the whole app, consistent with there being exactly one
//  LocationCubit singleton.
// =============================================================================

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../theme/agents_theme.dart';
import '../cubit/location_cubit.dart';
import '../cubit/location_state.dart';
import 'location_picker_panel.dart';

class LocationModal extends StatefulWidget {
  const LocationModal({super.key});

  @override
  State<LocationModal> createState() => _LocationModalState();
}

class _LocationModalState extends State<LocationModal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
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

  void _close() {
    GetIt.I<LocationCubit>().closeDropdown();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: GetIt.I<LocationCubit>(),
      child: BlocBuilder<LocationCubit, LocationState>(
        buildWhen: (prev, curr) =>
            prev.showLocationModal != curr.showLocationModal ||
            prev.isDismissible != curr.isDismissible,
        builder: (context, state) {
          if (!state.showLocationModal) {
            if (_controller.value != 0) _controller.value = 0;
            return const SizedBox.shrink();
          }

          if (_controller.status == AnimationStatus.dismissed) {
            _controller.forward();
          }

          return FadeTransition(
            opacity: _fade,
            child: Stack(
              children: [
                Positioned.fill(
                  child: GestureDetector(
                    // Scrim tap only dismisses when allowed. During the
                    // compulsory gate this handler still exists but is a
                    // no-op — deliberately, so an absent handler never
                    // silently lets a stray tap fall through to whatever
                    // is behind the blur.
                    onTap: state.isDismissible ? _close : () {},
                    behavior: HitTestBehavior.opaque,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: Container(
                        color: VeriRentColors.black.withOpacity(0.45),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: ScaleTransition(
                    scale: _scale,
                    child: GestureDetector(
                      // Absorb taps on the panel itself so they don't
                      // bubble to the scrim's dismiss handler underneath.
                      onTap: () {},
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  state.isDismissible
                                      ? 'Change location'
                                      : 'Confirm your location',
                                  style: VeriRentText.titleMedium.copyWith(
                                    color: VeriRentColors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                if (state.isDismissible) ...[
                                  const SizedBox(width: 12),
                                  GestureDetector(
                                    onTap: _close,
                                    child: Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.12),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close_rounded,
                                        size: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 12),
                            LocationPickerPanel(
                              onLgaSelected: (_, __) {},
                              onStateSelected: (_) {},
                              width: 320,
                              maxHeight: 420,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
