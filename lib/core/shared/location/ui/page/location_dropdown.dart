// =============================================================================
//  VeriRent NG — Location Dropdown Widget
//  Reads from the GetIt-singleton LocationCubit — no private instance.
//  Reacts to GPS auto-detection and supports manual State → LGA selection.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../theme/agents_theme.dart';
import '../../data/mock.dart';
import '../cubit/location_cubit.dart';
import '../cubit/location_state.dart';

class LocationDropdown extends StatefulWidget {
  const LocationDropdown({
    super.key,
    this.hint = 'Select Location',
    this.onStateSelected,
    this.onLgaSelected,
  });

  final String hint;

  /// Fires when a state is selected — either auto-detected from GPS
  /// or manually picked by the user.
  final void Function(String state)? onStateSelected;

  /// Fires when an LGA is manually selected after a state is chosen.
  final void Function(String state, String lga)? onLgaSelected;

  @override
  State<LocationDropdown> createState() => _LocationDropdownState();
}

class _LocationDropdownState extends State<LocationDropdown>
    with SingleTickerProviderStateMixin {
  // ── Overlay ──────────────────────────────────────────────────────────────
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  // ── Animation ────────────────────────────────────────────────────────────
  late final AnimationController _animController;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  // ── Cubit: the singleton, not a new instance ──────────────────────────────
  late final LocationCubit _cubit;

  // Tracks the last state we fired onStateSelected for — avoids duplicate
  // callbacks when unrelated state fields (e.g. isOpen) change.
  String? _lastNotifiedState;

  @override
  void initState() {
    super.initState();

    // Grab the singleton registered in GetIt.
    _cubit = GetIt.I<LocationCubit>();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, -0.04),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));

    // Fire callback if GPS already resolved a state before widget mounted.
    _maybeNotifyState(_cubit.state.selectedState);
  }

  @override
  void dispose() {
    _removeOverlay();
    _animController.dispose();
    super.dispose();
  }

  // ── Callback helpers ──────────────────────────────────────────────────────

  /// Notifies [onStateSelected] only when the state value actually changes.
  void _maybeNotifyState(String? selectedState) {
    if (selectedState != null && selectedState != _lastNotifiedState) {
      _lastNotifiedState = selectedState;
      widget.onStateSelected?.call(selectedState);
    }
  }

  /// Notifies [onLgaSelected] and closes the panel.
  void _onLgaChosen(String state, String lga) {
    widget.onLgaSelected?.call(state, lga);
    _closePanel();
  }

  // ── Overlay lifecycle ─────────────────────────────────────────────────────

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _showOverlay() {
    _removeOverlay();
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (_) => BlocProvider.value(
        // Share the singleton into the overlay's isolated widget tree.
        value: _cubit,
        child: _DropdownOverlay(
          layerLink: _layerLink,
          triggerSize: size,
          fadeAnim: _fadeAnim,
          slideAnim: _slideAnim,
          onLgaSelected: _onLgaChosen,
          onDismiss: _closePanel,
          // Notify parent whenever a state is picked inside the panel.
          onStateSelected: _maybeNotifyState,
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _animController.forward(from: 0);
  }

  Future<void> _closePanel() async {
    await _animController.reverse();
    _removeOverlay();
    _cubit.closeDropdown();
  }

  void _toggle() {
    HapticFeedback.selectionClick();
    if (_cubit.state.isOpen) {
      _closePanel();
    } else {
      _cubit.toggleDropdown();
      _showOverlay();
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: BlocConsumer<LocationCubit, LocationState>(
        // Use the singleton — not a new BlocProvider.
        bloc: _cubit,

        // Only rebuild the trigger button when visible fields change.
        buildWhen: (prev, curr) =>
            prev.selectedState != curr.selectedState ||
            prev.selectedLga != curr.selectedLga ||
            prev.isOpen != curr.isOpen ||
            prev.phase != curr.phase,

        // React to GPS auto-detection setting a state.
        listenWhen: (prev, curr) => prev.selectedState != curr.selectedState,
        listener: (_, state) => _maybeNotifyState(state.selectedState),

        builder: (_, state) {
          // Show a loading indicator while GPS is resolving.
          if (state.phase == LocationPhase.loading) {
            return const _LoadingTrigger();
          }

          return _TriggerButton(
            label: state.hasSelection ? state.displayLabel : widget.hint,
            isOpen: state.isOpen,
            hasSelection: state.hasSelection,
            onTap: _toggle,
            onClear: state.hasSelection
                ? () {
                    _cubit.clearSelection();
                    _lastNotifiedState = null; // reset dedup tracker
                    if (state.isOpen) _closePanel();
                  }
                : null,
          );
        },
      ),
    );
  }
}

// ── Loading Trigger ───────────────────────────────────────────────────────────

/// Shown while GPS auto-detection is in progress.
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

// ── Dropdown Overlay ──────────────────────────────────────────────────────────

class _DropdownOverlay extends StatelessWidget {
  const _DropdownOverlay({
    required this.layerLink,
    required this.triggerSize,
    required this.fadeAnim,
    required this.slideAnim,
    required this.onLgaSelected,
    required this.onDismiss,
    required this.onStateSelected,
  });

  final LayerLink layerLink;
  final Size triggerSize;
  final Animation<double> fadeAnim;
  final Animation<Offset> slideAnim;
  final void Function(String state, String lga) onLgaSelected;
  final void Function(String state) onStateSelected;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Scrim — tap outside to dismiss.
        Positioned.fill(
          child: GestureDetector(
            onTap: onDismiss,
            behavior: HitTestBehavior.translucent,
            child: const SizedBox.expand(),
          ),
        ),

        // Panel anchored below the trigger button.
        CompositedTransformFollower(
          link: layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, triggerSize.height + 6),
          child: FadeTransition(
            opacity: fadeAnim,
            child: SlideTransition(
              position: slideAnim,
              child: _DropdownPanel(
                onLgaSelected: onLgaSelected,
                onStateSelected: onStateSelected,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Dropdown Panel ────────────────────────────────────────────────────────────

class _DropdownPanel extends StatelessWidget {
  const _DropdownPanel({
    required this.onLgaSelected,
    required this.onStateSelected,
  });

  final void Function(String state, String lga) onLgaSelected;
  final void Function(String state) onStateSelected;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return BlocBuilder<LocationCubit, LocationState>(
      // Only rebuild when selection or open state changes — not on GPS updates.
      buildWhen: (prev, curr) =>
          prev.selectedState != curr.selectedState ||
          prev.selectedLga != curr.selectedLga ||
          prev.isOpen != curr.isOpen,

      builder: (ctx, state) {
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
                  // ── States column ───────────────────────────────────────
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
                                  // Notify parent of manual state selection.
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

                  // ── LGA column ──────────────────────────────────────────
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
                                    // Notify parent — triggers close via parent.
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
          ),
        );
      },
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
