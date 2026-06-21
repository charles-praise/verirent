// =============================================================================
//  VeriRent NG — LocationPickerPanel
//
//  The actual State → LGA picker UI (two-column list + confirmation banner),
//  extracted so it can be reused in two different chrome contexts:
//    1. LocationDropdown — anchored to a trigger button, for manual editing.
//    2. LocationGateOverlay — full-screen, centered, blurred backdrop, shown
//       automatically when auto-detection completes without a usable
//       state+LGA pair (see LocationState.requiresManualSelection).
//
//  This widget is purely the card content — sizing, shadow, and border.
//  Positioning/backdrop/dismissal are the caller's responsibility.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../theme/agents_theme.dart';
import '../../data/mock.dart';
import '../cubit/location_cubit.dart';
import '../cubit/location_state.dart';

class LocationPickerPanel extends StatelessWidget {
  const LocationPickerPanel({
    super.key,
    required this.onLgaSelected,
    required this.onStateSelected,
    this.width = 300,
    this.maxHeight = 380,
  });

  final void Function(String state, String lga) onLgaSelected;
  final void Function(String state) onStateSelected;
  final double width;
  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return BlocBuilder<LocationCubit, LocationState>(
      buildWhen: (prev, curr) =>
          prev.selectedState != curr.selectedState ||
          prev.selectedLga != curr.selectedLga ||
          prev.isOpen != curr.isOpen ||
          prev.looseLgaSuggestion != curr.looseLgaSuggestion,
      builder: (ctx, state) {
        final states = NigeriaLocations.states;
        final lgas = state.selectedState != null
            ? NigeriaLocations.lgasFor(state.selectedState!)
            : <String>[];

        return Material(
          color: Colors.transparent,
          child: Container(
            width: width,
            constraints: BoxConstraints(maxHeight: maxHeight),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(VeriRentRadius.lg),
              border: Border.all(color: cs.outlineVariant),
              boxShadow: [
                BoxShadow(
                  color: cs.shadow.withOpacity(0.12),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(VeriRentRadius.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (state.requiresManualSelection)
                    _ConfirmationBanner(
                      stateName: state.selectedState,
                      looseSuggestion: state.looseLgaSuggestion,
                      onAcceptSuggestion: () =>
                          ctx.read<LocationCubit>().acceptLooseLgaSuggestion(),
                    ),
                  Flexible(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 5,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const _PanelHeader(label: 'State'),
                              Flexible(
                                child: ListView.builder(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  shrinkWrap: true,
                                  itemCount: states.length,
                                  itemBuilder: (_, i) {
                                    final s = states[i];
                                    return _StateItem(
                                      label: s,
                                      isSelected: state.selectedState == s,
                                      onTap: () {
                                        HapticFeedback.selectionClick();
                                        ctx.read<LocationCubit>().selectState(s);
                                        onStateSelected(s);
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        VerticalDivider(
                          width: 1,
                          thickness: 1,
                          color: cs.outlineVariant,
                        ),
                        Expanded(
                          flex: 6,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _PanelHeader(
                                label: state.selectedState ?? 'Area / LGA',
                              ),
                              if (lgas.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Text(
                                    'Select a state first',
                                    style: VeriRentText.bodySmall.copyWith(
                                      color: cs.onSurfaceVariant,
                                    ),
                                  ),
                                )
                              else
                                Flexible(
                                  child: ListView.builder(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    shrinkWrap: true,
                                    itemCount: lgas.length,
                                    itemBuilder: (_, i) {
                                      final lga = lgas[i];
                                      return _LgaItem(
                                        label: lga,
                                        isSelected: state.selectedLga == lga,
                                        onTap: () {
                                          HapticFeedback.lightImpact();
                                          ctx.read<LocationCubit>().selectLga(lga);
                                          onLgaSelected(state.selectedState!, lga);
                                        },
                                      );
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ── Confirmation Banner ───────────────────────────────────────────────────────
//
// Tailors its copy to whether a state was detected at all (needsLgaConfirmation
// sub-case) or nothing was detected (requiresManualSelection but no state).

class _ConfirmationBanner extends StatelessWidget {
  const _ConfirmationBanner({
    required this.stateName,
    required this.looseSuggestion,
    required this.onAcceptSuggestion,
  });

  final String? stateName;
  final String? looseSuggestion;
  final VoidCallback onAcceptSuggestion;

  @override
  Widget build(BuildContext context) {
    final message = stateName != null
        ? 'We found $stateName but not your area. Please select your LGA to continue.'
        : 'We couldn\'t determine your location. Please select your state and area to continue.';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      color: VeriRentColors.warning500.withOpacity(0.12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 14,
                color: VeriRentColors.warning500,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  message,
                  style: VeriRentText.labelSmall.copyWith(
                    color: VeriRentColors.warning500,
                  ),
                ),
              ),
            ],
          ),
          if (looseSuggestion != null) ...[
            const SizedBox(height: 8),
            GestureDetector(
              onTap: onAcceptSuggestion,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: VeriRentColors.warning500.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(VeriRentRadius.full),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.help_outline_rounded,
                      size: 12,
                      color: VeriRentColors.warning500,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Not sure? Use "$looseSuggestion"',
                      style: VeriRentText.labelSmall.copyWith(
                        color: VeriRentColors.warning500,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Panel Header ──────────────────────────────────────────────────────────────

class _PanelHeader extends StatelessWidget {
  const _PanelHeader({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: cs.outlineVariant)),
        color: cs.surfaceVariant.withOpacity(0.5),
      ),
      child: Text(
        label,
        style: VeriRentText.labelSmall.copyWith(
          color: cs.onSurfaceVariant,
          letterSpacing: 0.6,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

// ── State Item ────────────────────────────────────────────────────────────────

class _StateItem extends StatelessWidget {
  const _StateItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        color: isSelected
            ? cs.primaryContainer.withOpacity(0.5)
            : Colors.transparent,
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: VeriRentText.bodySmall.copyWith(
                  color: isSelected ? cs.primary : cs.onSurface,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            if (isSelected)
              Icon(Icons.chevron_right_rounded, size: 14, color: cs.primary),
          ],
        ),
      ),
    );
  }
}

// ── LGA Item ──────────────────────────────────────────────────────────────────

class _LgaItem extends StatelessWidget {
  const _LgaItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        color: isSelected ? cs.primary.withOpacity(0.1) : Colors.transparent,
        child: Row(
          children: [
            if (isSelected) ...[
              Icon(Icons.check_rounded, size: 13, color: cs.primary),
              const SizedBox(width: 6),
            ],
            Expanded(
              child: Text(
                label,
                style: VeriRentText.bodySmall.copyWith(
                  color: isSelected ? cs.primary : cs.onSurface,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
