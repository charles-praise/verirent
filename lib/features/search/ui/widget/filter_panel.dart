// ── Filters Panel ─────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';

import '../../../../../core/theme/agents_theme.dart';

// FIX (Bug 2): Removed the BlocProvider wrapper that was creating a second,
// disconnected SearchCubit instance inside this widget.  FiltersPanel is
// intentionally fully stateless — it receives all values via constructor
// parameters and emits changes through callbacks.  The unused
// flutter_bloc import has been removed accordingly.

class FiltersPanel extends StatelessWidget {
  const FiltersPanel({
    super.key,
    this.priceRange,
    this.selectedType,
    this.minBeds,
    this.minBaths,
    this.verifiedOnly,
    this.propertyTypes,
    this.onPriceChanged,
    required this.onTypeChanged,
    required this.onBedsChanged,
    required this.onBathsChanged,
    required this.onVerifiedChanged,
    required this.onReset,
    // FIX (Bug 4): onApply is now a required callback so the Apply button
    // actually triggers the parent's search/filter logic.
    required this.onApply,
    required this.formatPrice,
    this.showFilterOnHomePage = false,
  });

  final RangeValues? priceRange;
  final String? selectedType;
  final int? minBeds;
  final int? minBaths;
  final bool? verifiedOnly;
  final List<String>? propertyTypes;
  final ValueChanged<RangeValues>? onPriceChanged;
  final ValueChanged<String> onTypeChanged;
  final ValueChanged<int> onBedsChanged;
  final ValueChanged<int> onBathsChanged;
  final ValueChanged<bool> onVerifiedChanged;
  final VoidCallback onReset;
  final VoidCallback onApply;
  final String Function(double) formatPrice;
  // FIX: default to false so callers that omit this parameter don't crash
  // with a null-dereference (the original used showFilterOnHomePage! without
  // a default, which would throw when the flag was not supplied).
  final bool showFilterOnHomePage;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final colorSwitch = cs.brightness == Brightness.light
        ? VeriRentColors.primary
        : VeriRentColors.accent400;

    // Use safe fallbacks for all nullable fields so the widget renders
    // correctly even when values are not yet provided by the parent.
    final effectivePriceRange =
        priceRange ?? const RangeValues(100000, 2000000);
    final effectiveType = selectedType ?? 'Any';
    final effectiveBeds = minBeds ?? 0;
    final effectiveBaths = minBaths ?? 0;
    final effectiveVerified = verifiedOnly ?? false;
    final effectiveTypes =
        propertyTypes ??
        const [
          'Any',
          'Apartment',
          'Duplex',
          'Furnished',
          'Corporate',
          'Flat',
          'Bungalow',
        ];

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: showFilterOnHomePage
            ? const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              )
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(color: cs.outlineVariant),
          const SizedBox(height: 14),

          // ── Price Range ──────────────────────────────────────────────
          FilterLabel('Price Range / Year'),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PriceTag(formatPrice(effectivePriceRange.start)),
              PriceTag(formatPrice(effectivePriceRange.end)),
            ],
          ),
          RangeSlider(
            values: effectivePriceRange,
            min: 50000,
            max: 5000000,
            divisions: 99,
            activeColor: colorSwitch,
            inactiveColor: colorSwitch.withOpacity(0.2),
            onChanged: onPriceChanged,
          ),
          const SizedBox(height: 12),

          // ── Property Type ────────────────────────────────────────────
          FilterLabel('Property Type'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: effectiveTypes.map((t) {
              final active = t == effectiveType;
              return GestureDetector(
                onTap: () => onTypeChanged(t),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: active ? cs.surface : cs.surfaceVariant,
                    borderRadius: BorderRadius.circular(VeriRentRadius.full),
                    border: Border.all(
                      color: active ? colorSwitch : cs.outlineVariant,
                    ),
                  ),
                  child: Text(
                    t,
                    style: VeriRentText.labelMedium.copyWith(
                      color: active ? colorSwitch : cs.onSurfaceVariant,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // ── Beds + Baths ─────────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: StepFilter(
                  label: 'Min. Bedrooms',
                  value: effectiveBeds,
                  onDecrement: effectiveBeds > 0
                      ? () => onBedsChanged(effectiveBeds - 1)
                      : null,
                  onIncrement: () => onBedsChanged(effectiveBeds + 1),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: StepFilter(
                  label: 'Min. Bathrooms',
                  value: effectiveBaths,
                  onDecrement: effectiveBaths > 0
                      ? () => onBathsChanged(effectiveBaths - 1)
                      : null,
                  onIncrement: () => onBathsChanged(effectiveBaths + 1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Verified Only ────────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Verified Listings Only',
                      style: VeriRentText.bodyMedium.copyWith(
                        color: cs.onSurface,
                      ),
                    ),
                    Text(
                      'Show only ESVARBON-certified agencies',
                      style: VeriRentText.bodySmall.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(value: effectiveVerified, onChanged: onVerifiedChanged),
            ],
          ),

          const SizedBox(height: 16),

          // ── Action Row ───────────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onReset,
                  child: Text(
                    'Reset',
                    style: VeriRentText.labelLarge.copyWith(color: cs.primary),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  // FIX (Bug 4): onApply is now wired to the callback.
                  onPressed: onApply,
                  child: Text(
                    'Apply',
                    style: VeriRentText.labelLarge.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Helper widgets ─────────────────────────────────────────────────────────────

class FilterLabel extends StatelessWidget {
  const FilterLabel(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: VeriRentText.labelMedium.copyWith(
      color: Theme.of(context).colorScheme.onSurface,
    ),
  );
}

class PriceTag extends StatelessWidget {
  const PriceTag(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: VeriRentColors.primaryDim,
        borderRadius: BorderRadius.circular(VeriRentRadius.xs),
      ),
      child: Text(
        text,
        style: VeriRentText.labelMedium.copyWith(color: VeriRentColors.primary),
      ),
    );
  }
}

class StepFilter extends StatelessWidget {
  const StepFilter({
    super.key,
    required this.label,
    required this.value,
    required this.onDecrement,
    required this.onIncrement,
  });

  final String label;
  final int value;
  final VoidCallback? onDecrement;
  final VoidCallback onIncrement;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: VeriRentText.labelMedium.copyWith(color: cs.onSurface),
        ),
        const SizedBox(height: 8),
        Container(
          height: 40,
          decoration: BoxDecoration(
            color: cs.surfaceVariant,
            borderRadius: BorderRadius.circular(VeriRentRadius.md),
            border: Border.all(color: cs.outlineVariant),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: onDecrement,
                icon: const Icon(Icons.remove_rounded, size: 16),
                color: onDecrement != null
                    ? cs.onSurface
                    : cs.onSurfaceVariant.withOpacity(0.3),
                constraints: const BoxConstraints.tightFor(
                  width: 36,
                  height: 40,
                ),
                padding: EdgeInsets.zero,
              ),
              Expanded(
                child: Text(
                  value == 0 ? 'Any' : '$value+',
                  textAlign: TextAlign.center,
                  style: VeriRentText.titleSmall.copyWith(color: cs.onSurface),
                ),
              ),
              IconButton(
                onPressed: onIncrement,
                icon: const Icon(Icons.add_rounded, size: 16),
                color: cs.onSurface,
                constraints: const BoxConstraints.tightFor(
                  width: 36,
                  height: 40,
                ),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
