// home.dart
//
// Fixes vs home_fixed2.dart:
//
//   FIX 1 — Seed SearchCubit on init
//     SearchCubit._allProperties was [] until the user typed something,
//     so applyFilters() from the bottom sheet always got an empty source
//     list and produced zero results.
//     → initState now calls searchCubit.setAllProperties(kAllListings).
//
//   FIX 2 — isFiltering includes activeFilterCount
//     The filtered-grid branch was only entered when query or category
//     chip was active.  A filter-only apply (price, beds, verified) set
//     neither, so Home stayed on the full-feed view and showed no change.
//     → isFiltering now also checks searchState.activeFilterCount > 0.
//
//   FIX 3 — onSearchChanged passes kAllListings directly
//     HomeSearchBar.onChanged was reading HomeCubit.state.allProperties
//     which was never populated, passing [] to searchProperties every time.
//     → _onSearchChanged passes kAllListings directly (same source of truth).
//
//   FIX 4 — BlocBuilder buildWhen for SearchCubit
//     HomeCubit BlocBuilder had buildWhen that only rebuilt on activeIndex
//     changes, but the outer SearchCubit BlocBuilder rebuilt on every
//     SearchState change including filtersExpanded toggling, causing
//     unnecessary full-tree rebuilds while the sheet was animating.
//     → SearchCubit BlocBuilder now has its own targeted buildWhen.

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:verirent/features/home/data/local_repo.dart';
import 'package:verirent/features/home/domain/entities/property_model.dart';
import 'package:verirent/features/home/ui/widgets/home_featured_list.dart';

import '../../../../core/api/data/mock_data.dart';
import '../../../../core/shared/ads/ui/pages/recentAds.dart';
import '../../../../core/theme/agents_theme.dart';
import '../../../search/ui/cubit/search_cubit.dart';
import '../../../search/ui/cubit/search_state.dart';
import '../../domain/use_case/home_featured_listing.dart';
import '../../domain/use_case/home_recent_useCase.dart';
import '../cubit/home_cubit.dart';
import '../widgets/home_custom_appbar.dart';
import '../widgets/home_filter.dart';
import '../widgets/home_section_header.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.scaffoldKey});
  final GlobalKey<ScaffoldState>? scaffoldKey;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<bool> _isVisible = ValueNotifier(true);
  final FocusNode _searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_listenToScroll);
    _searchController.addListener(_onSearchChanged);

    // FIX 1: Seed SearchCubit immediately so applyFilters() from the
    // bottom sheet has a source list before the user types anything.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      GetIt.I<SearchCubit>().setAllProperties(kAllListings);
    });
  }

  // FIX 3: Pass kAllListings directly — never depend on HomeCubit.allProperties
  // which is never populated and would always pass [] to the cubit.
  void _onSearchChanged() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      GetIt.I<SearchCubit>().searchProperties(
        kAllListings,
        _searchController.text,
      );
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_listenToScroll);
    _scrollController.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchFocus.dispose();
    _isVisible.dispose();
    super.dispose();
  }

  void _listenToScroll() {
    final direction = _scrollController.position.userScrollDirection;
    if (direction == ScrollDirection.reverse && _isVisible.value) {
      _isVisible.value = false;
    } else if (direction == ScrollDirection.forward && !_isVisible.value) {
      _isVisible.value = true;
    }
  }

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 800));
    // TODO: context.read<HomeCubit>().loadListings();
  }

  void _onFilterTap(int i) {
    HapticFeedback.lightImpact();
    context.read<HomeCubit>().activeIndex(i);
    GetIt.I<SearchCubit>().setHomeCategory(i);
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.paddingOf(context).top;

    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (prev, curr) => prev.activeIndex != curr.activeIndex,
      builder: (context, homeState) {
        return BlocProvider.value(
          value: GetIt.I<SearchCubit>(),
          child: BlocBuilder<SearchCubit, SearchState>(
            // FIX 4: Only rebuild when the fields that drive layout actually change.
            // filtersExpanded toggling (sheet open/close) should NOT trigger a
            // full Home rebuild.
            buildWhen: (prev, curr) =>
                prev.searchStage != curr.searchStage ||
                prev.filteredProperties != curr.filteredProperties ||
                prev.query != curr.query ||
                prev.selectedCategory != curr.selectedCategory ||
                prev.activeFilterCount != curr.activeFilterCount,
            builder: (context, searchState) {
              // FIX 2: activeFilterCount > 0 is the missing condition.
              // Without it, a filter-only apply from the sheet (no query, no
              // category chip) never switches Home to the filtered-grid view.
              final isFiltering =
                  searchState.query.isNotEmpty ||
                  searchState.selectedCategory != PropertyCategory.initial ||
                  searchState.activeFilterCount > 0;

              return CustomScrollView(
                controller: _scrollController,
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                slivers: [
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: HomeAppBar(
                      topPadding: topPad,
                      scaffoldKey: widget.scaffoldKey!,
                      focusNode: _searchFocus,
                      controller: _searchController,
                    ),
                  ),
                  ...(isFiltering
                      ? _filteredViewList(
                          context: context,
                          searchState: searchState,
                          filters: homeState.filters,
                          onFilterTap: _onFilterTap,
                          onClearAll: () {
                            GetIt.I<SearchCubit>().resetFilters();
                            context.read<HomeCubit>().activeIndex(0);
                            _searchController.clear();
                          },
                          filterIcons: homeState.filterIcons,
                          homeState: homeState,
                        )
                      : _defaultViewList(
                          context: context,
                          isVisible: _isVisible,
                          homeState: homeState,
                          onFilterTap: _onFilterTap,
                        )),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.query, required this.hasFilters});
  final String query;
  final bool hasFilters;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final String title;
    final String subtitle;

    if (query.isNotEmpty && hasFilters) {
      title = 'No results for "$query"';
      subtitle = 'Try clearing some filters or using different keywords.';
    } else if (query.isNotEmpty) {
      title = 'No results for "$query"';
      subtitle = 'Try a different location, property type, or area.';
    } else {
      title = 'No properties match your filters';
      subtitle = 'Try adjusting price range, bedrooms, or other criteria.';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 48,
            color: cs.onSurfaceVariant.withValues(alpha: 0.35),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(color: cs.onSurface),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
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

List<Widget> _defaultViewList({
  required BuildContext context,
  required ValueNotifier<bool> isVisible,
  required HomeState homeState,
  required ValueChanged<int> onFilterTap,
}) {
  return [
    SliverToBoxAdapter(
      child: ValueListenableBuilder<bool>(
        valueListenable: isVisible,
        builder: (_, visible, __) => AnimatedOpacity(
          duration: const Duration(milliseconds: 220),
          opacity: visible ? 1 : 1,
          child: SearchFilter(
            filters: homeState.filters,
            filterIcons: homeState.filterIcons,
            activeIndex: homeState.activeIndex,
            onFilterTap: onFilterTap,
          ),
        ),
      ),
    ),
    // Featured
    const SliverToBoxAdapter(child: FeaturedListingsHorizontalUseCase()),
    // Property Options
    SliverToBoxAdapter(
      child: SectionHeader(
        title: 'Discount & Promotions',
        listing: HomeLocalRepo().featuredProperties,
        showSeeAll: true,
      ),
    ),
    const SliverToBoxAdapter(child: PropertyOption()),
    // Recent
    SliverToBoxAdapter(
      child: SectionHeader(
        title: 'Recently Added',
        showSeeAll: true,
        listing: HomeLocalRepo().recentProperties,
      ),
    ),
    const RecentListingUseCase(),
    // Ads (become an agent)
    SliverToBoxAdapter(child: buildAgencyBanner(context: context)),
    // Residential
    SliverToBoxAdapter(
      child: SectionHeader(
        title: 'Residential',
        showSeeAll: true,
        listing: HomeLocalRepo().residentialProperties,
      ),
    ),
    const ResidentialPropertiesListingUseCase(),
    // Land
    SliverToBoxAdapter(
      child: SectionHeader(
        title: 'Land & Plots',
        showSeeAll: true,
        listing: HomeLocalRepo().landedProperties,
      ),
    ),
    const LandedPropertiesUseCase(),
    // Commercial
    SliverToBoxAdapter(
      child: SectionHeader(
        title: 'Commercial',
        showSeeAll: true,
        listing: HomeLocalRepo().commercialProperties,
      ),
    ),
    const CommercialPropertiesUseCase(),
    // Estate's
    SliverToBoxAdapter(
      child: SectionHeader(
        title: 'Estates & Housing',
        showSeeAll: true,
        listing: HomeLocalRepo().estateProperties,
      ),
    ),
    const EstatePropertiesUseCase(),
    //  Short Let's
    SliverToBoxAdapter(
      child: SectionHeader(
        title: 'Short Lets',
        showSeeAll: true,
        listing: HomeLocalRepo().shortletProperties,
      ),
    ),
    const ShortLetPropertiesUseCase(),
    const SliverToBoxAdapter(child: SizedBox(height: 80)),
  ];
}

List<Widget> _filteredViewList({
  required BuildContext context,
  required SearchState searchState,
  required List<String> filters,
  required ValueChanged<int> onFilterTap,
  required VoidCallback onClearAll,
  required List<IconData> filterIcons,
  required HomeState homeState,
}) {
  final cs = Theme.of(context).colorScheme;
  final results = searchState.filteredProperties;
  final isLoading = searchState.searchStage == SearchStage.loading;
  return [
    // Category chips stay visible
    SliverToBoxAdapter(
      child: SearchFilter(
        filters: filters,
        filterIcons: filterIcons,
        activeIndex: homeState.activeIndex,
        onFilterTap: onFilterTap,
      ),
    ),

    // Status bar: count + active filter badge + clear
    SliverToBoxAdapter(
      child: Container(
        color: cs.surfaceContainerHighest,
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 6),
        child: Row(
          children: [
            // Result count / status label
            if (isLoading)
              Row(
                children: [
                  SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                      color: cs.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Searching…',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                  ),
                ],
              )
            else
              Expanded(
                child: Text(
                  results.isEmpty
                      ? 'No properties found'
                      : '${results.length} property${results.length == 1 ? 'y' : 'ies'} found',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: cs.onSurface,
                    fontSize: 12,
                  ),
                ),
              ),

            // Active filter badge with one-tap clear
            if (searchState.activeFilterCount > 0) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onClearAll,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: cs.primaryContainer,
                    borderRadius: BorderRadius.circular(VeriRentRadius.full),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${searchState.activeFilterCount} filter${searchState.activeFilterCount > 1 ? 's' : ''}',
                        style: VeriRentText.labelSmall.copyWith(
                          color: cs.onPrimaryContainer,
                          fontSize: 9,
                        ),
                      ),
                      const SizedBox(width: 4),
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

            // Clear search query button (separate from filter badge)
            if (searchState.query.isNotEmpty) ...[
              const SizedBox(width: 6),
              GestureDetector(
                onTap: onClearAll,
                child: Icon(
                  Icons.close_rounded,
                  size: 16,
                  color: cs.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    ),

    // Results or empty state
    if (results.isEmpty && !isLoading)
      SliverFillRemaining(
        hasScrollBody: false,
        child: _EmptyState(
          query: searchState.query,
          hasFilters: searchState.activeFilterCount > 0,
        ),
      )
    else
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            mainAxisExtent: 260,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) =>
                FeaturedCardFactory.build(context, results[index]),
            childCount: results.length,
          ),
        ),
      ),

    const SliverToBoxAdapter(child: SizedBox(height: 80)),
  ];
}
