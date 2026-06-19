import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:verirent/features/search/ui/cubit/search_cubit.dart';
import 'package:verirent/features/search/ui/cubit/search_state.dart';

import '../../../../../core/api/data/mock_data.dart';
import '../../../../../core/theme/agents_theme.dart';
import '../../../home/domain/entities/property_model.dart';
import '../../utils/kFormatPrice.dart';
import '../widget/filter_panel.dart';

/// developer: Charles Praise Diepriye
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // initialize the text controller and focus node
  final _searchCtrl = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Auto-focus the field when the page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    // dispose the search controller and focus node
    _searchCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // build and return the search view widget
    return _SearchView(searchCtrl: _searchCtrl, focusNode: _focusNode);
  }
}

// search view widget
class _SearchView extends StatelessWidget {
  // request the text controller and focus node
  const _SearchView({required this.searchCtrl, required this.focusNode});
  final TextEditingController searchCtrl;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    // color scheme and top padding needed for the appbar
    final cs = Theme.of(context).colorScheme;
    final topPad = MediaQuery.of(context).padding.top;
    // listen and reacts to changes from the search state
    return BlocProvider.value(
      value: GetIt.I<SearchCubit>(),
      child: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: cs.brightness == Brightness.light
                ? SystemUiOverlayStyle.dark
                : SystemUiOverlayStyle.light,
            child: Scaffold(
              backgroundColor: cs.surfaceVariant,
              body: CustomScrollView(
                slivers: [
                  // sticky search header
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _SearchHeader(
                      topPadding: topPad,
                      searchCtrl: searchCtrl,
                      focusNode: focusNode,
                      state: state,
                      onChanged: (value) => context
                          .read<SearchCubit>()
                          .searchProperties(kAllListings, value),
                      onSubmitted: (value) {
                        if (value.trim().isNotEmpty) {
                          context.read<SearchCubit>().saveSearch(value);
                        }
                      },
                      onClear: () {
                        searchCtrl.clear();
                        context.read<SearchCubit>().clearQuery();
                      },
                      onToggleFilters: context
                          .read<SearchCubit>()
                          .toggleFilters,
                    ),
                  ),

                  // collapsible filter panel
                  if (state.filtersExpanded)
                    SliverToBoxAdapter(
                      child: FiltersPanel(
                        priceRange: state.priceRange,
                        selectedType: state.selectedType,
                        minBeds: state.minBeds,
                        minBaths: state.minBaths,
                        verifiedOnly: state.verifiedOnly,
                        propertyTypes: state.propertyTypes,
                        onPriceChanged: context.read<SearchCubit>().updatePrice,
                        onTypeChanged: context.read<SearchCubit>().updateType,
                        onBedsChanged: context.read<SearchCubit>().updateBeds,
                        onBathsChanged: context.read<SearchCubit>().updateBaths,
                        onVerifiedChanged: context
                            .read<SearchCubit>()
                            .updateVerified,
                        onReset: context.read<SearchCubit>().resetFilters,
                        onApply: context.read<SearchCubit>().closeFilters,
                        formatPrice: kFormatPrice,
                        showFilterOnHomePage: false,
                      ),
                    ),

                  // content
                  if (state.query.isEmpty)
                    SliverToBoxAdapter(
                      child: _RecentSearches(
                        searches: state.recentSearches,
                        onClearAll: context
                            .read<SearchCubit>()
                            .clearRecentSearches,
                        onTap: (s) {
                          searchCtrl.text = s;
                          context.read<SearchCubit>().searchProperties(
                            kAllListings,
                            s,
                          );
                          context.read<SearchCubit>().saveSearch(s);
                        },
                      ),
                    )
                  else ...[
                    // Result count bar
                    SliverToBoxAdapter(
                      child: _ResultCountBar(
                        count: state.filteredProperties.length,
                        query: state.query,
                        activeFilters: state.activeFilterCount,
                        onClearFilters: context
                            .read<SearchCubit>()
                            .resetFilters,
                      ),
                    ),

                    // Results grid or empty state
                    if (state.filteredProperties.isEmpty)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: _EmptyResults(query: state.query),
                      )
                    else
                      _ResultsGrid(properties: state.filteredProperties),
                  ],

                  const SliverToBoxAdapter(child: SizedBox(height: 80)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// =============================================================================
//  Sticky search header delegate
// =============================================================================

class _SearchHeader extends SliverPersistentHeaderDelegate {
  _SearchHeader({
    required this.topPadding,
    required this.searchCtrl,
    required this.focusNode,
    required this.state,
    required this.onChanged,
    required this.onSubmitted,
    required this.onClear,
    required this.onToggleFilters,
  });

  final double topPadding;
  final TextEditingController searchCtrl;
  final FocusNode focusNode;
  final SearchState state;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClear;
  final VoidCallback onToggleFilters;

  // header = topPad + 12 (top pad) + 38 (field height) + 12 (bottom pad) = topPad + 62
  double get _h => topPadding + 62;

  @override
  double get maxExtent => _h;
  @override
  double get minExtent => _h;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      height: _h,
      child: Container(
        color: cs.surface,
        padding: EdgeInsets.fromLTRB(14, topPadding + 12, 14, 12),
        child: Row(
          children: [
            // Back
            GestureDetector(
              onTap: () => Navigator.maybePop(context),
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: cs.surfaceVariant,
                  borderRadius: BorderRadius.circular(VeriRentRadius.sm),
                  border: Border.all(color: cs.outlineVariant),
                ),
                child: Icon(
                  Icons.arrow_back_rounded,
                  size: 18,
                  color: cs.onSurface,
                ),
              ),
            ),

            const SizedBox(width: 8),

            // Search field
            Expanded(
              child: SizedBox(
                height: 38,
                child: TextField(
                  controller: searchCtrl,
                  focusNode: focusNode,
                  onChanged: onChanged,
                  onSubmitted: onSubmitted,
                  style: VeriRentText.bodyMedium.copyWith(color: cs.onSurface),
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'Location, type, area...',
                    hintStyle: VeriRentText.bodyMedium.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      size: 18,
                      color: cs.primary,
                    ),
                    suffixIcon: state.query.isNotEmpty
                        ? GestureDetector(
                            onTap: onClear,
                            child: Icon(
                              Icons.close_rounded,
                              size: 16,
                              color: cs.onSurfaceVariant,
                            ),
                          )
                        : null,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 0,
                    ),
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(VeriRentRadius.md),
                      borderSide: BorderSide(color: cs.outlineVariant),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(VeriRentRadius.md),
                      borderSide: BorderSide(color: cs.outlineVariant),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(VeriRentRadius.md),
                      borderSide: BorderSide(color: cs.primary, width: 1.5),
                    ),
                    filled: true,
                    fillColor: cs.surfaceVariant,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 8),

            // Filter toggle
            Stack(
              clipBehavior: Clip.none,
              children: [
                GestureDetector(
                  onTap: onToggleFilters,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: state.filtersExpanded
                          ? VeriRentColors.primaryDim
                          : cs.surfaceVariant,
                      borderRadius: BorderRadius.circular(VeriRentRadius.sm),
                      border: Border.all(
                        color: state.filtersExpanded
                            ? VeriRentColors.primary
                            : cs.outlineVariant,
                      ),
                    ),
                    child: Icon(
                      Icons.tune_rounded,
                      size: 18,
                      color: state.filtersExpanded
                          ? VeriRentColors.primary
                          : cs.onSurfaceVariant,
                    ),
                  ),
                ),
                if (state.activeFilterCount > 0)
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: VeriRentColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${state.activeFilterCount}',
                          style: VeriRentText.labelSmall.copyWith(
                            color: Colors.white,
                            fontSize: 9,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(_SearchHeader old) =>
      old.topPadding != topPadding || old.state != state;
}

// =============================================================================
//  Result count bar
// =============================================================================

class _ResultCountBar extends StatelessWidget {
  const _ResultCountBar({
    required this.count,
    required this.query,
    required this.activeFilters,
    required this.onClearFilters,
  });
  final int count;
  final String query;
  final int activeFilters;
  final VoidCallback onClearFilters;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      color: cs.surfaceVariant,
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 6),
      child: Row(
        children: [
          Expanded(
            child: RichText(
              text: TextSpan(
                style: VeriRentText.bodySmall.copyWith(
                  color: cs.onSurfaceVariant,
                ),
                children: [
                  TextSpan(
                    text: '$count',
                    style: VeriRentText.titleSmall.copyWith(
                      color: cs.onSurface,
                      fontSize: 12,
                    ),
                  ),
                  TextSpan(text: ' results for "$query"'),
                ],
              ),
            ),
          ),
          if (activeFilters > 0)
            GestureDetector(
              onTap: onClearFilters,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  borderRadius: BorderRadius.circular(VeriRentRadius.full),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$activeFilters filter${activeFilters > 1 ? 's' : ''}',
                      style: VeriRentText.labelSmall.copyWith(
                        color: cs.onPrimaryContainer,
                        fontSize: 9,
                      ),
                    ),
                    const SizedBox(width: 3),
                    Icon(
                      Icons.close_rounded,
                      size: 9,
                      color: cs.onPrimaryContainer,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// =============================================================================
//  Results grid — intrinsic cards, no fixed SizedBox
// =============================================================================

class _ResultsGrid extends StatelessWidget {
  const _ResultsGrid({required this.properties});
  final List<PropertyModel> properties;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.73,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => _CompactCard(property: properties[index]),
          childCount: properties.length,
        ),
      ),
    );
  }
}

// =============================================================================
//  Compact card (same as home.dart — extract to shared widget in production)
// =============================================================================

class _CompactCard extends StatelessWidget {
  const _CompactCard({required this.property});
  final PropertyModel property;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final p = property;

    return GestureDetector(
      onTap: () {
        // context.push('/listing_details', extra: p);
      },
      child: Container(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(VeriRentRadius.lg),
          border: Border.all(
            color: p.isVerified == true
                ? VeriRentColors.primary.withOpacity(0.3)
                : cs.outlineVariant,
            width: p.isVerified == true ? 1.25 : 0.75,
          ),
          boxShadow: [
            BoxShadow(
              color: cs.shadow.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 46,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(VeriRentRadius.lg),
                    ),
                    child: (p.imageUrls?.isNotEmpty == true)
                        ? Image.network(
                            p.imageUrls!.first,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _Placeholder(),
                          )
                        : _Placeholder(),
                  ),
                  if (p.isVerified == true)
                    Positioned(top: 6, left: 6, child: _VerifiedBadge()),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: _CatPill(category: p.category),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 54,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 7, 8, 7),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      p.title ?? '—',
                      style: VeriRentText.titleSmall.copyWith(
                        color: cs.onSurface,
                        fontSize: 11,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          size: 9,
                          color: cs.onSurfaceVariant,
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            p.location ?? p.area ?? '—',
                            style: VeriRentText.bodySmall.copyWith(
                              color: cs.onSurfaceVariant,
                              fontSize: 9,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if ((p.bedrooms ?? 0) > 0)
                      Row(
                        children: [
                          _MiniChip(
                            icon: Icons.bed_rounded,
                            label: '${p.bedrooms}',
                          ),
                          const SizedBox(width: 4),
                          _MiniChip(
                            icon: Icons.bathtub_outlined,
                            label: '${p.bathrooms}',
                          ),
                        ],
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '₦${p.price ?? '—'}',
                                style: VeriRentText.titleSmall.copyWith(
                                  color: cs.primary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (p.priceUnit != null)
                                Text(
                                  p.priceUnit!,
                                  style: VeriRentText.labelSmall.copyWith(
                                    color: cs.onSurfaceVariant,
                                    fontSize: 8,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        if (p.tierColor != null && p.tierLabel != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: p.tierColor!.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(
                                VeriRentRadius.full,
                              ),
                              border: Border.all(
                                color: p.tierColor!.withOpacity(0.4),
                                width: 0.5,
                              ),
                            ),
                            child: Text(
                              p.tierLabel!
                                  .replaceAll(' Agency', '')
                                  .replaceAll(' Individual', ''),
                              style: VeriRentText.labelSmall.copyWith(
                                color: p.tierColor,
                                fontSize: 7,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniChip extends StatelessWidget {
  const _MiniChip({required this.icon, required this.label});
  final IconData icon;
  final String label;
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 9, color: cs.onSurfaceVariant),
        const SizedBox(width: 2),
        Text(
          label,
          style: VeriRentText.labelSmall.copyWith(
            color: cs.onSurfaceVariant,
            fontSize: 9,
          ),
        ),
      ],
    );
  }
}

class _VerifiedBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
    decoration: BoxDecoration(
      color: VeriRentColors.success500,
      borderRadius: BorderRadius.circular(VeriRentRadius.full),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.verified_rounded, size: 7, color: Colors.white),
        const SizedBox(width: 2),
        Text(
          'Verified',
          style: VeriRentText.labelSmall.copyWith(
            color: Colors.white,
            fontSize: 7,
          ),
        ),
      ],
    ),
  );
}

class _CatPill extends StatelessWidget {
  const _CatPill({required this.category});
  final PropertyCategory? category;
  @override
  Widget build(BuildContext context) {
    final label = switch (category) {
      PropertyCategory.land => 'Land',
      PropertyCategory.commercial => 'Comm.',
      PropertyCategory.estate => 'Estate',
      PropertyCategory.shortlet => 'Shortlet',
      _ => 'Res.',
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.45),
        borderRadius: BorderRadius.circular(VeriRentRadius.full),
      ),
      child: Text(
        label,
        style: VeriRentText.labelSmall.copyWith(
          color: Colors.white,
          fontSize: 7,
        ),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      color: cs.surfaceVariant,
      child: Center(
        child: Icon(
          Icons.home_work_rounded,
          size: 28,
          color: cs.onSurfaceVariant.withOpacity(0.3),
        ),
      ),
    );
  }
}

class _EmptyResults extends StatelessWidget {
  const _EmptyResults({required this.query});
  final String query;
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 44,
            color: cs.onSurfaceVariant.withOpacity(0.35),
          ),
          const SizedBox(height: 12),
          Text(
            'No results for "$query"',
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(color: cs.onSurface),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Text(
            'Try adjusting filters or different keywords.',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// =============================================================================
//  Recent Searches (unchanged from previous version)
// =============================================================================

class _RecentSearches extends StatelessWidget {
  const _RecentSearches({
    required this.searches,
    required this.onTap,
    required this.onClearAll,
  });
  final List<String> searches;
  final ValueChanged<String> onTap;
  final VoidCallback onClearAll;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
          child: Row(
            children: [
              Text(
                'Recent Searches',
                style: VeriRentText.titleMedium.copyWith(color: cs.onSurface),
              ),
              const Spacer(),
              if (searches.isNotEmpty)
                TextButton(
                  onPressed: onClearAll,
                  child: Text(
                    'Clear all',
                    style: VeriRentText.labelMedium.copyWith(color: cs.primary),
                  ),
                ),
            ],
          ),
        ),
        if (searches.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'No recent searches',
              style: VeriRentText.bodySmall.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          )
        else
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
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: cs.surfaceVariant,
                          borderRadius: BorderRadius.circular(
                            VeriRentRadius.sm,
                          ),
                        ),
                        child: Icon(
                          Icons.history_rounded,
                          size: 15,
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
                        size: 13,
                        color: cs.onSurfaceVariant,
                      ),
                      dense: true,
                      visualDensity: VisualDensity.compact,
                    ),
                    if (!isLast)
                      Divider(height: 1, color: cs.outlineVariant, indent: 50),
                  ],
                );
              }),
            ),
          ),

        const SizedBox(height: 20),

        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Text(
            'Popular Areas',
            style: VeriRentText.titleMedium.copyWith(color: cs.onSurface),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 7,
            runSpacing: 7,
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
                            horizontal: 12,
                            vertical: 7,
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
                                size: 12,
                                color: cs.onSurfaceVariant,
                              ),
                              const SizedBox(width: 3),
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
