// =============================================================================
//  VeriRent NG — LocationTrigger
//
//  (Formerly LocationDropdown.) Now PURELY a tappable summary button
//  showing the current state/LGA selection. It owns NO overlay/positioning
//  logic anymore — tapping it only flips LocationCubit.isOpen, and the
//  single app-wide LocationModal (mounted once in Main/shell.dart) reacts
//  to that and renders the actual picker, centered + blurred, identical
//  in style to the compulsory startup gate.
//
//  This collapse removed LayerLink/CompositedTransformFollower/
//  OverlayEntry entirely — there is exactly one presentation surface for
//  the picker now (LocationModal), eliminating the class of duplicate-
//  overlay bugs that existed when this widget managed its own separate
//  anchored overlay alongside the gate's full-screen overlay.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../theme/agents_theme.dart';
import '../cubit/location_cubit.dart';
import '../cubit/location_state.dart';

class LocationTrigger extends StatelessWidget {
  const LocationTrigger({
    super.key,
    this.hint = 'Select Location',
    this.onStateSelected,
  });

  final String hint;

  /// Optional — fires whenever selectedState changes for any reason
  /// (GPS or manual), kept for callers that previously relied on
  /// LocationDropdown's onStateSelected callback.
  final void Function(String state)? onStateSelected;

  void _toggle() {
    HapticFeedback.selectionClick();
    GetIt.I<LocationCubit>().toggleDropdown();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LocationCubit, LocationState>(
      bloc: GetIt.I<LocationCubit>(),
      buildWhen: (prev, curr) =>
          prev.selectedState != curr.selectedState ||
          prev.selectedLga != curr.selectedLga ||
          prev.isOpen != curr.isOpen ||
          prev.phase != curr.phase,
      listenWhen: (prev, curr) => prev.selectedState != curr.selectedState,
      listener: (_, state) {
        if (state.selectedState != null) {
          onStateSelected?.call(state.selectedState!);
        }
      },
      builder: (_, state) {
        if (state.phase == LocationPhase.loading) {
          return const _LoadingTrigger();
        }

        return _TriggerButton(
          label: state.hasSelection ? state.displayLabel : hint,
          isOpen: state.isOpen,
          onTap: _toggle,
        );
      },
    );
  }
}

// ── Loading Trigger ───────────────────────────────────────────────────────────

class _LoadingTrigger extends StatelessWidget {
  const _LoadingTrigger();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 25,
      child: Row(
        children: [
          const SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(strokeWidth: 1.5),
          ),
          const SizedBox(width: 8),
          Text(
            'Detecting location…',
            style: VeriRentText.bodyMedium.copyWith(
              color: VeriRentColors.white.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Trigger Button ────────────────────────────────────────────────────────────
//
// Pure tap target now — no inline edit/clear icon. Tapping anywhere opens
// LocationModal in dismissible (manual-edit) mode via isOpen.

class _TriggerButton extends StatelessWidget {
  const _TriggerButton({
    required this.label,
    required this.isOpen,
    required this.onTap,
  });

  final String label;
  final bool isOpen;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 25,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          children: [
            Icon(
              Icons.location_on_rounded,
              size: 18,
              color: VeriRentColors.secondary400,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                style: VeriRentText.bodyMedium.copyWith(
                  color: VeriRentColors.white,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 4),
            AnimatedRotation(
              turns: isOpen ? 0.5 : 0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: VeriRentColors.white,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
