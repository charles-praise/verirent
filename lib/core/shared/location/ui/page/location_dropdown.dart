// =============================================================================
//  VeriRent NG — Location Dropdown Widget
//  A premium two-level (State → LGA) animated dropdown with overlay panel.
//
//  Usage:
//    BlocProvider(
//      create: (_) => LocationDropdownCubit(),
//      child: const LocationDropdown(),
//    )
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../theme/agents_theme.dart';
import '../../data/mock.dart';
import '../cubit/location_dropdown_cubit.dart';
import '../cubit/location_dropdown_state.dart';

class LocationDropdown extends StatefulWidget {
  const LocationDropdown({
    super.key,
    this.onLocationSelected,
    this.hint = 'Select Location',
  });

  /// Callback fires with (state, lga) once the user picks an LGA.
  final void Function(String state, String lga)? onLocationSelected;
  final String hint;

  @override
  State<LocationDropdown> createState() => _LocationDropdownState();
}

class _LocationDropdownState extends State<LocationDropdown>
    with SingleTickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  late final AnimationController _animController;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, -0.04),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _removeOverlay();
    _animController.dispose();
    super.dispose();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _showOverlay(BuildContext blocContext) {
    _removeOverlay();
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (_) => BlocProvider.value(
        value: blocContext.read<LocationDropdownCubit>(),
        child: _DropdownOverlay(
          layerLink: _layerLink,
          triggerSize: size,
          fadeAnim: _fadeAnim,
          slideAnim: _slideAnim,
          onLocationSelected: (s, l) {
            widget.onLocationSelected?.call(s, l);
            _closePanel(blocContext);
          },
          onDismiss: () => _closePanel(blocContext),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _animController.forward(from: 0);
  }

  void _closePanel(BuildContext blocContext) async {
    await _animController.reverse();
    _removeOverlay();
    if (blocContext.mounted) {
      blocContext.read<LocationDropdownCubit>().closeDropdown();
    }
  }

  void _toggle(BuildContext blocContext) {
    HapticFeedback.selectionClick();
    final cubit = blocContext.read<LocationDropdownCubit>();
    if (cubit.state.isOpen) {
      _closePanel(blocContext);
    } else {
      cubit.toggleDropdown();
      _showOverlay(blocContext);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LocationDropdownCubit(),
      child: BlocBuilder<LocationDropdownCubit, LocationDropdownState>(
        builder: (blocContext, state) {
          return CompositedTransformTarget(
            link: _layerLink,
            child: _TriggerButton(
              label: state.hasSelection ? state.displayLabel : widget.hint,
              isOpen: state.isOpen,
              hasSelection: state.hasSelection,
              onTap: () => _toggle(blocContext),
              onClear: state.hasSelection
                  ? () {
                      blocContext
                          .read<LocationDropdownCubit>()
                          .clearSelection();
                      if (state.isOpen) _closePanel(blocContext);
                    }
                  : null,
            ),
          );
        },
      ),
    );
  }
}

// ── Trigger Button ─────────────────────────────────────────────────────────────

class _TriggerButton extends StatelessWidget {
  const _TriggerButton({
    required this.label,
    required this.isOpen,
    required this.hasSelection,
    required this.onTap,
    this.onClear,
  });

  final String label;
  final bool isOpen;
  final bool hasSelection;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

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
            Expanded(
              child: Text(
                label,
                style: VeriRentText.bodyMedium.copyWith(
                  color: VeriRentColors.white,
                  fontWeight: hasSelection ? FontWeight.w500 : FontWeight.w400,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (hasSelection && onClear != null)
              GestureDetector(
                onTap: onClear,
                child: Container(
                  width: 20,
                  height: 20,
                  margin: const EdgeInsets.only(right: 4),
                  decoration: BoxDecoration(
                    color: cs.onSurface.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    size: 12,
                    color: VeriRentColors.white,
                  ),
                ),
              ),
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

// ── Dropdown Overlay Panel ────────────────────────────────────────────────────

class _DropdownOverlay extends StatelessWidget {
  const _DropdownOverlay({
    required this.layerLink,
    required this.triggerSize,
    required this.fadeAnim,
    required this.slideAnim,
    required this.onLocationSelected,
    required this.onDismiss,
  });

  final LayerLink layerLink;
  final Size triggerSize;
  final Animation<double> fadeAnim;
  final Animation<Offset> slideAnim;
  final void Function(String state, String lga) onLocationSelected;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Transparent scrim — tap to dismiss
        Positioned.fill(
          child: GestureDetector(
            onTap: onDismiss,
            behavior: HitTestBehavior.translucent,
            child: const SizedBox.expand(),
          ),
        ),

        // Panel positioned below trigger
        CompositedTransformFollower(
          link: layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, triggerSize.height + 6),
          child: FadeTransition(
            opacity: fadeAnim,
            child: SlideTransition(
              position: slideAnim,
              child: _DropdownPanel(onLocationSelected: onLocationSelected),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Dropdown Panel ────────────────────────────────────────────────────────────

class _DropdownPanel extends StatelessWidget {
  const _DropdownPanel({required this.onLocationSelected});

  final void Function(String state, String lga) onLocationSelected;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return BlocBuilder<LocationDropdownCubit, LocationDropdownState>(
      builder: (context, state) {
        final states = NigeriaLocations.states;
        final lgas = state.selectedState != null
            ? NigeriaLocations.lgasFor(state.selectedState!)
            : <String>[];

        return Material(
          color: Colors.transparent,
          child: Container(
            width: 300,
            constraints: const BoxConstraints(maxHeight: 340),
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── States column ─────────────────────────────────
                  Expanded(
                    flex: 5,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _PanelHeader(label: 'State'),
                        Flexible(
                          child: ListView.builder(
                            padding: const EdgeInsets.only(bottom: 8),
                            shrinkWrap: true,
                            itemCount: states.length,
                            itemBuilder: (_, i) {
                              final s = states[i];
                              final selected = state.selectedState == s;
                              return _StateItem(
                                label: s,
                                isSelected: selected,
                                onTap: () {
                                  HapticFeedback.selectionClick();
                                  context
                                      .read<LocationDropdownCubit>()
                                      .selectState(s);
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Divider
                  VerticalDivider(
                    width: 1,
                    thickness: 1,
                    color: cs.outlineVariant,
                  ),

                  // ── LGA column ────────────────────────────────────
                  Expanded(
                    flex: 6,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _PanelHeader(
                          label: state.selectedState != null
                              ? state.selectedState!
                              : 'Area / LGA',
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
                                final selected = state.selectedLga == lga;
                                return _LgaItem(
                                  label: lga,
                                  isSelected: selected,
                                  onTap: () {
                                    HapticFeedback.lightImpact();
                                    context
                                        .read<LocationDropdownCubit>()
                                        .selectLga(lga);
                                    onLocationSelected(
                                      state.selectedState!,
                                      lga,
                                    );
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
          ),
        );
      },
    );
  }
}

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
