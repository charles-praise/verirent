// home.dart
// developer: charles praise diepriye
//
// Architecture notes
// ──────────────────
// • HomeCubit  → owns category chips, loading phase, paginated listings.
// • SearchCubit → owns query, filter panel values, filteredProperties.
// • "isFiltering" = any signal that the user wants a narrowed view
//   (non-empty query | non-none category | activeFilterCount > 0).
// • Three mutually-exclusive body modes:
//     LOADING   – skeleton slivers
//     ERROR     – error sliver
//     LOADED    – category view  (searchStage == initial && !isFiltering)
//              – filter view    (isFiltering, results available)
//              – empty view     (isFiltering, results == [])
// • BlocBuilders carry tight buildWhen predicates so the tree only
//   rebuilds when the slice of state it actually cares about changes.
// • BlocProvider.value is hoisted above both BlocBuilders to avoid
//   re-wrapping on every rebuild.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide RefreshCallback;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:verirent/core/repo/local_repo.dart';
import 'package:verirent/features/home/domain/use_case/listing_use_cases.dart';
import 'package:verirent/features/home/ui/widgets/home_loading_skeleton.dart';

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
  final ValueNotifier<bool> _fabVisible = ValueNotifier(true);
  final FocusNode _searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _searchController.addListener(_onSearchChanged);

    // Seed SearchCubit with the full local catalogue so applyFilters()
    // always has a non-empty source list, even before the user types.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      GetIt.I<SearchCubit>().setAllProperties(
        await GetIt.I<LocalRepository>().all(),
      );
    });
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    _searchFocus.dispose();
    _fabVisible.dispose();
    super.dispose();
  }

  // ── Scroll-direction tracker ───────────────────────────────────────────
  void _onScroll() {
    final dir = _scrollController.position.userScrollDirection;
    if (dir == ScrollDirection.reverse && _fabVisible.value) {
      _fabVisible.value = false;
    } else if (dir == ScrollDirection.forward && !_fabVisible.value) {
      _fabVisible.value = true;
    }
  }

  // ── Search bar → SearchCubit ───────────────────────────────────────────
  // Reads fresh data from LocalRepository every keystroke so the source
  // list is always current (handles background refreshes / new listings).
  void _onSearchChanged() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      GetIt.I<SearchCubit>().searchProperties(
        await GetIt.I<LocalRepository>().all(),
        _searchController.text,
      );
    });
  }

  // ── Pull-to-refresh ────────────────────────────────────────────────────
  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 800));
    GetIt.I<HomeCubit>().loadListing();
  }

  // ── Category chip tap ──────────────────────────────────────────────────
  void _onFilterTap(int i) {
    HapticFeedback.lightImpact();
    GetIt.I<HomeCubit>().activeIndex(i);
  }

  // ── Reset all search/filter state ──────────────────────────────────────
  void _onClearAll() {
    GetIt.I<SearchCubit>().resetFilters();
    GetIt.I<HomeCubit>().activeIndex(0);
    _searchController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.paddingOf(context).top;

    // Hoist the BlocProvider above both BlocBuilders so it is never
    // recreated on a rebuild of either inner builder.
    return BlocProvider.value(
      value: GetIt.I<SearchCubit>(),
      child: BlocBuilder<HomeCubit, HomeState>(
        // Only rebuild when loading phase or active category chip changes.
        buildWhen: (p, c) =>
            p.phase != c.phase || p.activeIndex != c.activeIndex,
        builder: (context, homeState) {
          return BlocBuilder<SearchCubit, SearchState>(
            // Rebuild only when any visible search/filter output changes.
            // filtersExpanded is intentionally excluded — it drives the
            // bottom-sheet only and should not re-render the feed.
            buildWhen: (p, c) =>
                p.searchStage != c.searchStage ||
                p.filteredProperties != c.filteredProperties ||
                p.query != c.query ||
                p.selectedCategory != c.selectedCategory ||
                p.activeFilterCount != c.activeFilterCount,
            builder: (context, searchState) {
              return CustomScrollView(
                controller: _scrollController,
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                slivers: _buildSlivers(
                  context: context,
                  homeState: homeState,
                  searchState: searchState,
                  topPad: topPad,
                ),
              );
            },
          );
        },
      ),
    );
  }

  List<Widget> _buildSlivers({
    required BuildContext context,
    required HomeState homeState,
    required SearchState searchState,
    required double topPad,
  }) {
    return [
      // ── Pinned app-bar / search bar ──────────────────────────────────
      SliverPersistentHeader(
        pinned: true,
        delegate: HomeAppBar(
          topPadding: topPad,
          scaffoldKey: widget.scaffoldKey!,
          focusNode: _searchFocus,
          controller: _searchController,
        ),
      ),

      // ── Phase: loading / initial ─────────────────────────────────────
      if (homeState.phase == HomePhase.loading ||
          homeState.phase == HomePhase.initial)
        ...homeBodySkeletonSlivers(context)
      // ── Phase: error ─────────────────────────────────────────────────
      else if (homeState.phase == HomePhase.error)
        const SliverFillRemaining(hasScrollBody: false, child: _ErrorState())
      // ── Phase: loaded ─────────────────────────────────────────────────
      else ...[
        // Category chips are always visible in the loaded state.
        SliverToBoxAdapter(
          child: SearchFilter(
            filters: homeState.filters,
            filterIcons: homeState.filterIcons,
            activeIndex: homeState.activeIndex,
            onFilterTap: _onFilterTap,
          ),
        ),

        CupertinoSliverRefreshControl(onRefresh: _onRefresh),

        // ── Body: determines which of the three modes to render ────────
        ..._buildBody(
          context: context,
          homeState: homeState,
          searchState: searchState,
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 80)),
      ],
    ];
  }

  /// Returns the appropriate body slivers for the loaded phase.
  ///
  /// Three mutually-exclusive modes:
  ///   1. Category view  — no active search/filters
  ///   2. Filter view    — filtering active, results found
  ///   3. Empty view     — filtering active, no results
  List<Widget> _buildBody({
    required BuildContext context,
    required HomeState homeState,
    required SearchState searchState,
  }) {
    final isFiltering = _isFiltering(searchState);
    final isSearching = searchState.searchStage == SearchStage.loading;

    // ── Mode 1: default category view ───────────────────────────────────
    if (!isFiltering) {
      return _categorySlivers(homeState);
    }

    // ── Modes 2 & 3: search/filter is active ────────────────────────────
    final results = searchState.filteredProperties;
    final hasResults = results.isNotEmpty;

    return [
      // Status bar: count + filter badge + clear button
      SliverToBoxAdapter(
        child: _StatusBar(
          searchState: searchState,
          isSearching: isSearching,
          resultCount: results.length,
          onClearAll: _onClearAll,
        ),
      ),

      // ── Mode 3: empty ───────────────────────────────────────────────
      if (!hasResults && !isSearching)
        SliverFillRemaining(
          hasScrollBody: false,
          child: _EmptyState(
            query: searchState.query,
            hasFilters: searchState.activeFilterCount > 0,
          ),
        )
      // ── Mode 2: results grid / list ─────────────────────────────────
      else
        PropertyUseCase(category: PropertyCategory.all, properties: results),
    ];
  }

  // ── Category-view slivers (one per category section) ──────────────────
  List<Widget> _categorySlivers(HomeState homeState) {
    final listings = homeState.listings;

    List<Widget> section(PropertyCategory cat) => [
      PropertyUseCase(category: cat, properties: listings[cat] ?? []),
    ];

    switch (homeState.activeIndex) {
      case 1: // Apartment → residential
        return section(PropertyCategory.residential);
      case 2: // Duplex → estate
        return section(PropertyCategory.estate);
      case 3: // Furnished → shortLet
        return section(PropertyCategory.shortLet);
      case 4: // Corporate → commercial
        return section(PropertyCategory.commercial);
      default: // All
        return [
              PropertyCategory.featured,
              PropertyCategory.option,
              PropertyCategory.recent,
              PropertyCategory.residential,
              PropertyCategory.land,
              PropertyCategory.commercial,
              PropertyCategory.estate,
              PropertyCategory.shortLet,
            ]
            .map(
              (cat) => PropertyUseCase(
                category: cat,
                properties: listings[cat] ?? [],
              ),
            )
            .toList();
    }
  }
}

// ── Helpers ──────────────────────────────────────────────────────────────

/// True when ANY search/filter signal is active.
bool _isFiltering(SearchState s) =>
    s.query.isNotEmpty ||
    s.selectedCategory != PropertyCategory.none ||
    s.activeFilterCount > 0;

// ── Sub-widgets ───────────────────────────────────────────────────────────

/// Status bar shown above search results.
class _StatusBar extends StatelessWidget {
  const _StatusBar({
    required this.searchState,
    required this.isSearching,
    required this.resultCount,
    required this.onClearAll,
  });

  final SearchState searchState;
  final bool isSearching;
  final int resultCount;
  final VoidCallback onClearAll;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      color: cs.surfaceContainerHighest,
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 6),
      child: Row(
        children: [
          // Left: spinner while searching, count when done
          if (isSearching)
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
                resultCount == 0
                    ? 'No properties found'
                    : '$resultCount propert${resultCount == 1 ? 'y' : 'ies'} found',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: cs.onSurface,
                  fontSize: 12,
                ),
              ),
            ),

          // Active filter badge
          if (searchState.activeFilterCount > 0) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onClearAll,
              child: _FilterBadge(cs: cs, count: searchState.activeFilterCount),
            ),
          ],

          // Clear query button
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
    );
  }
}

/// Pill badge showing active filter count with a close icon.
class _FilterBadge extends StatelessWidget {
  const _FilterBadge({required this.cs, required this.count});

  final ColorScheme cs;
  final int count;

  @override
  Widget build(BuildContext context) {
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
            '$count filter${count > 1 ? 's' : ''}',
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
}

/// Shown when the active search/filter pipeline returns zero results.
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

/// Shown when HomeCubit emits HomePhase.error.
class _ErrorState extends StatelessWidget {
  const _ErrorState();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.wifi_off_rounded,
            size: 48,
            color: cs.onSurfaceVariant.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 14),
          Text(
            'Could not load listings',
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(color: cs.onSurface),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            'Pull down to try again.',
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
