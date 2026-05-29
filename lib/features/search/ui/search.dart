// =============================================================================
//  VeriRent NG — Search Page
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/agents_theme.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchCtrl = TextEditingController();
  final _focusNode = FocusNode();

  // Filters state
  RangeValues _priceRange = const RangeValues(100000, 2000000);
  int _minBeds = 0;
  int _minBaths = 0;
  String _selectedType = 'Any';
  bool _verifiedOnly = false;
  bool _filtersExpanded = false;

  final _propertyTypes = [
    'Any',
    'Apartment',
    'Duplex',
    'Flat',
    'Bungalow',
    'Furnished',
    'Corporate',
  ];

  final _recentSearches = [
    'GRA Phase 2 apartments',
    'Trans Amadi furnished flat',
    'Woji 3 bedroom duplex',
    'D/Line self contain',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _focusNode.requestFocus(),
    );
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  String _formatPrice(double value) {
    if (value >= 1000000) {
      return '₦${(value / 1000000).toStringAsFixed(1)}M';
    }
    return '₦${(value / 1000).toStringAsFixed(0)}K';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final topPad = MediaQuery.of(context).padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: cs.brightness == Brightness.light
          ? SystemUiOverlayStyle.dark
          : SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: cs.surfaceVariant,
        body: CustomScrollView(
          slivers: [
            // ── Search Header ──────────────────────────────────────
            SliverToBoxAdapter(
              child: Container(
                color: cs.surface,
                padding: EdgeInsets.fromLTRB(16, topPad + 12, 16, 12),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.maybePop(context),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: cs.surfaceVariant,
                          borderRadius: BorderRadius.circular(
                            VeriRentRadius.sm,
                          ),
                          border: Border.all(color: cs.outlineVariant),
                        ),
                        child: Icon(
                          Icons.arrow_back_rounded,
                          size: 18,
                          color: cs.onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _searchCtrl,
                        focusNode: _focusNode,
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          hintText: 'Search by location, type...',
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            size: 20,
                            color: cs.primary,
                          ),
                          suffixIcon: _searchCtrl.text.isNotEmpty
                              ? GestureDetector(
                                  onTap: () =>
                                      setState(() => _searchCtrl.clear()),
                                  child: Icon(
                                    Icons.close_rounded,
                                    size: 18,
                                    color: cs.onSurfaceVariant,
                                  ),
                                )
                              : null,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              VeriRentRadius.full,
                            ),
                            borderSide: BorderSide(color: cs.outlineVariant),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              VeriRentRadius.full,
                            ),
                            borderSide: BorderSide(color: cs.outlineVariant),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              VeriRentRadius.full,
                            ),
                            borderSide: BorderSide(
                              color: cs.primary,
                              width: 1.5,
                            ),
                          ),
                          filled: true,
                          fillColor: cs.surfaceVariant,
                        ),
                        style: VeriRentText.bodyMedium.copyWith(
                          color: cs.onSurface,
                        ),
                        textInputAction: TextInputAction.search,
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () =>
                          setState(() => _filtersExpanded = !_filtersExpanded),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: _filtersExpanded
                              ? VeriRentColors.primaryDim
                              : cs.surfaceVariant,
                          borderRadius: BorderRadius.circular(
                            VeriRentRadius.sm,
                          ),
                          border: Border.all(
                            color: _filtersExpanded
                                ? VeriRentColors.primary
                                : cs.outlineVariant,
                          ),
                        ),
                        child: Icon(
                          Icons.tune_rounded,
                          size: 18,
                          color: _filtersExpanded
                              ? VeriRentColors.primary
                              : cs.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Filters Panel ──────────────────────────────────────
            if (_filtersExpanded)
              SliverToBoxAdapter(
                child: _FiltersPanel(
                  priceRange: _priceRange,
                  selectedType: _selectedType,
                  minBeds: _minBeds,
                  minBaths: _minBaths,
                  verifiedOnly: _verifiedOnly,
                  propertyTypes: _propertyTypes,
                  onPriceChanged: (v) => setState(() => _priceRange = v),
                  onTypeChanged: (v) => setState(() => _selectedType = v),
                  onBedsChanged: (v) => setState(() => _minBeds = v),
                  onBathsChanged: (v) => setState(() => _minBaths = v),
                  onVerifiedChanged: (v) => setState(() => _verifiedOnly = v),
                  onReset: () => setState(() {
                    _priceRange = const RangeValues(100000, 2000000);
                    _selectedType = 'Any';
                    _minBeds = 0;
                    _minBaths = 0;
                    _verifiedOnly = false;
                  }),
                  formatPrice: _formatPrice,
                ),
              ),

            // ── Content ────────────────────────────────────────────
            if (_searchCtrl.text.isEmpty)
              SliverToBoxAdapter(
                child: _RecentSearches(
                  searches: _recentSearches,
                  onTap: (s) => setState(() {
                    _searchCtrl.text = s;
                    _searchCtrl.selection = TextSelection.collapsed(
                      offset: s.length,
                    );
                  }),
                ),
              )
            else
              SliverToBoxAdapter(
                child: _SearchResults(query: _searchCtrl.text),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
    );
  }
}

// ── Filters Panel ─────────────────────────────────────────────────────────────
class _FiltersPanel extends StatelessWidget {
  const _FiltersPanel({
    required this.priceRange,
    required this.selectedType,
    required this.minBeds,
    required this.minBaths,
    required this.verifiedOnly,
    required this.propertyTypes,
    required this.onPriceChanged,
    required this.onTypeChanged,
    required this.onBedsChanged,
    required this.onBathsChanged,
    required this.onVerifiedChanged,
    required this.onReset,
    required this.formatPrice,
  });

  final RangeValues priceRange;
  final String selectedType;
  final int minBeds;
  final int minBaths;
  final bool verifiedOnly;
  final List<String> propertyTypes;
  final ValueChanged<RangeValues> onPriceChanged;
  final ValueChanged<String> onTypeChanged;
  final ValueChanged<int> onBedsChanged;
  final ValueChanged<int> onBathsChanged;
  final ValueChanged<bool> onVerifiedChanged;
  final VoidCallback onReset;
  final String Function(double) formatPrice;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      color: cs.surface,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(color: cs.outlineVariant),

          // Price Range
          _FilterLabel('Price Range / Year'),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _PriceTag(formatPrice(priceRange.start)),
              _PriceTag(formatPrice(priceRange.end)),
            ],
          ),
          RangeSlider(
            values: priceRange,
            min: 50000,
            max: 5000000,
            divisions: 99,
            activeColor: VeriRentColors.primary,
            inactiveColor: VeriRentColors.primary.withOpacity(0.2),
            onChanged: onPriceChanged,
          ),
          const SizedBox(height: 12),

          // Property Type
          _FilterLabel('Property Type'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: propertyTypes.map((t) {
              final active = t == selectedType;
              return GestureDetector(
                onTap: () => onTypeChanged(t),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: active
                        ? VeriRentColors.primaryDim
                        : cs.surfaceVariant,
                    borderRadius: BorderRadius.circular(VeriRentRadius.full),
                    border: Border.all(
                      color: active
                          ? VeriRentColors.primary
                          : cs.outlineVariant,
                    ),
                  ),
                  child: Text(
                    t,
                    style: VeriRentText.labelMedium.copyWith(
                      color: active
                          ? VeriRentColors.primary
                          : cs.onSurfaceVariant,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // Beds + Baths
          Row(
            children: [
              Expanded(
                child: _StepFilter(
                  label: 'Min. Bedrooms',
                  value: minBeds,
                  onDecrement: minBeds > 0
                      ? () => onBedsChanged(minBeds - 1)
                      : null,
                  onIncrement: () => onBedsChanged(minBeds + 1),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _StepFilter(
                  label: 'Min. Bathrooms',
                  value: minBaths,
                  onDecrement: minBaths > 0
                      ? () => onBathsChanged(minBaths - 1)
                      : null,
                  onIncrement: () => onBathsChanged(minBaths + 1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Verified only
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
              Switch(
                value: verifiedOnly,
                activeColor: VeriRentColors.primary,
                onChanged: onVerifiedChanged,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Action row
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
                  onPressed: () {},
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

class _FilterLabel extends StatelessWidget {
  const _FilterLabel(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: VeriRentText.labelMedium.copyWith(
      color: Theme.of(context).colorScheme.onSurface,
    ),
  );
}

class _PriceTag extends StatelessWidget {
  const _PriceTag(this.text);
  final String text;
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
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

class _StepFilter extends StatelessWidget {
  const _StepFilter({
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

// ── Recent Searches ───────────────────────────────────────────────────────────
class _RecentSearches extends StatelessWidget {
  const _RecentSearches({required this.searches, required this.onTap});
  final List<String> searches;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
          child: Row(
            children: [
              Text(
                'Recent Searches',
                style: VeriRentText.titleMedium.copyWith(color: cs.onSurface),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Clear all',
                  style: VeriRentText.labelMedium.copyWith(color: cs.primary),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(VeriRentRadius.lg),
            border: Border.all(color: cs.outlineVariant),
          ),
          child: Column(
            children: List.generate(searches.length, (i) {
              final s = searches[i];
              final isLast = i == searches.length - 1;
              return Column(
                children: [
                  ListTile(
                    onTap: () => onTap(s),
                    leading: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: cs.surfaceVariant,
                        borderRadius: BorderRadius.circular(VeriRentRadius.sm),
                      ),
                      child: Icon(
                        Icons.history_rounded,
                        size: 16,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                    title: Text(
                      s,
                      style: VeriRentText.bodyMedium.copyWith(
                        color: cs.onSurface,
                      ),
                    ),
                    trailing: Icon(
                      Icons.north_west_rounded,
                      size: 14,
                      color: cs.onSurfaceVariant,
                    ),
                    dense: true,
                  ),
                  if (!isLast)
                    Divider(height: 1, color: cs.outlineVariant, indent: 54),
                ],
              );
            }),
          ),
        ),
        const SizedBox(height: 24),
        // Popular areas
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
          child: Text(
            'Popular Areas',
            style: VeriRentText.titleMedium.copyWith(color: cs.onSurface),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                [
                      'GRA Phase 1',
                      'GRA Phase 2',
                      'Trans Amadi',
                      'Woji',
                      'D/Line',
                      'Rumuola',
                      'Peter Odili',
                      'Eliozu',
                    ]
                    .map(
                      (a) => GestureDetector(
                        onTap: () => onTap(a),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: cs.surface,
                            borderRadius: BorderRadius.circular(
                              VeriRentRadius.full,
                            ),
                            border: Border.all(color: cs.outlineVariant),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 13,
                                color: cs.onSurfaceVariant,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                a,
                                style: VeriRentText.bodySmall.copyWith(
                                  color: cs.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
          ),
        ),
      ],
    );
  }
}

// ── Search Results placeholder ────────────────────────────────────────────────
class _SearchResults extends StatelessWidget {
  const _SearchResults({required this.query});
  final String query;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Results for ',
                style: VeriRentText.bodyMedium.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
              Flexible(
                child: Text(
                  '"$query"',
                  style: VeriRentText.titleMedium.copyWith(color: cs.onSurface),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Placeholder — wire up real search results here
          Center(
            child: Column(
              children: [
                const SizedBox(height: 32),
                Icon(
                  Icons.search_off_rounded,
                  size: 52,
                  color: cs.onSurfaceVariant.withOpacity(0.4),
                ),
                const SizedBox(height: 12),
                Text(
                  'No results yet',
                  style: VeriRentText.titleMedium.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Wire up your search use-case here',
                  style: VeriRentText.bodySmall.copyWith(
                    color: cs.onSurfaceVariant.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
