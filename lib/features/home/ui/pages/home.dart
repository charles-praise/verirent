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
import 'package:verirent/core/repo/local_repo.dart';
import 'package:verirent/features/home/domain/use_case/listing_use_cases.dart';

import '../../../../core/models/property_model.dart';
import '../../../../core/theme/agents_theme.dart';
import '../../../search/ui/cubit/search_cubit.dart';
import '../../../search/ui/cubit/search_state.dart';
import '../cubit/home_cubit.dart';
import '../widgets/home_custom_appbar.dart';
import '../widgets/home_filter.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      GetIt.I<SearchCubit>().setAllProperties(
        await GetIt.I<LocalRepository>().all(),
      );
    });
  }

  void _onSearchChanged() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      GetIt.I<SearchCubit>().searchProperties(
        await GetIt.I<LocalRepository>().all(),
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
    GetIt.I<HomeCubit>().loadListing();
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
            buildWhen: (prev, curr) =>
                prev.searchStage != curr.searchStage ||
                prev.filteredProperties != curr.filteredProperties ||
                prev.query != curr.query ||
                prev.selectedCategory != curr.selectedCategory ||
                prev.activeFilterCount != curr.activeFilterCount,
            builder: (context, searchState) {
              final isFiltering =
                  searchState.query.isNotEmpty ||
                  searchState.selectedCategory != PropertyCategory.none ||
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
        builder: (context, visible, widget) => AnimatedOpacity(
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
    PropertyUseCase(
      properties: homeState.listings[PropertyCategory.featured] ?? [],
    ),
    PropertyUseCase(
      properties: homeState.listings[PropertyCategory.option] ?? [],
    ),
    PropertyUseCase(
      properties: homeState.listings[PropertyCategory.recent] ?? [],
    ),
    PropertyUseCase(
      properties: homeState.listings[PropertyCategory.residential] ?? [],
    ),
    PropertyUseCase(
      properties: homeState.listings[PropertyCategory.land] ?? [],
    ),
    PropertyUseCase(
      properties: homeState.listings[PropertyCategory.commercial] ?? [],
    ),
    PropertyUseCase(
      properties: homeState.listings[PropertyCategory.estate] ?? [],
    ),
    PropertyUseCase(
      properties: homeState.listings[PropertyCategory.shortLet] ?? [],
    ),
    PropertyUseCase(properties: homeState.listings[PropertyCategory.all] ?? []),
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
                child: filterBadgeWithOneTapClear(cs, searchState),
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
      PropertyUseCase(properties: results),
    const SliverToBoxAdapter(child: SizedBox(height: 80)),
  ];
}

Container filterBadgeWithOneTapClear(ColorScheme cs, SearchState searchState) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
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
        Icon(Icons.close_rounded, size: 9, color: cs.onPrimaryContainer),
      ],
    ),
  );
}
