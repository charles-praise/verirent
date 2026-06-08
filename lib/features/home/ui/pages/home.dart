// home.dart
//
// Changes:
//   • Filter chips call SearchCubit.setHomeCategory(i) AND HomeCubit.activeIndex(i)
//     so the chip highlight updates AND the data actually filters.
//   • When searchState.selectedCategory != initial (chip active) OR
//     searchState.query is non-empty, show the filtered grid instead of
//     the full sectioned feed.
//   • Refresh indicator wired correctly with NestedScrollView pattern.

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verirent/features/home/domain/entities/property_model.dart';

import '../../../../core/api/data/mock_data.dart';
import '../../../../core/theme/agents_theme.dart';
import '../../../ads/ui/pages/recentAds.dart';
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
  }

  void _onSearchChanged() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<SearchCubit>().searchProperties(
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

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.paddingOf(context).top;

    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (prev, curr) => prev.activeIndex != curr.activeIndex,
      builder: (context, homeState) {
        return BlocBuilder<SearchCubit, SearchState>(
          builder: (context, searchState) {
            // Show filtered grid when query OR category chip is active
            final isFiltering =
                searchState.query.isNotEmpty ||
                searchState.selectedCategory != PropertyCategory.initial;

            if (isFiltering) {
              return CustomScrollView(
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

                  // Filter chips stay visible in filtered view
                  SliverToBoxAdapter(
                    child: SearchFilter(
                      filters: homeState.filters,
                      filterIcons: homeState.filterIcons,
                      activeIndex: homeState.activeIndex,
                      onFilterTap: _onFilterTap,
                    ),
                  ),

                  // Result count header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 10, 14, 4),
                      child: Row(
                        children: [
                          Text(
                            '${searchState.filteredProperties.length} properties',
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                          ),
                          if (searchState.activeFilterCount > 0) ...[
                            const SizedBox(width: 6),
                            _FilterBadge(
                              count: searchState.activeFilterCount,
                              onClear: () {
                                context.read<SearchCubit>().resetFilters();
                                context.read<HomeCubit>().activeIndex(0);
                              },
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  if (searchState.filteredProperties.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: _EmptyState(query: searchState.query),
                    )
                  else
                    _CompactPropertyGrid(
                      properties: searchState.filteredProperties,
                    ),

                  const SliverToBoxAdapter(child: SizedBox(height: 80)),
                ],
              );
            }

            // ── Normal full-feed home ──────────────────────────────────
            return RefreshIndicator(
              onRefresh: _onRefresh,
              displacement: 60,
              strokeWidth: 2,
              child: CustomScrollView(
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

                  SliverToBoxAdapter(
                    child: ValueListenableBuilder<bool>(
                      valueListenable: _isVisible,
                      builder: (_, visible, _) => AnimatedOpacity(
                        duration: const Duration(milliseconds: 220),
                        opacity: visible ? 1 : 0,
                        child: SearchFilter(
                          filters: homeState.filters,
                          filterIcons: homeState.filterIcons,
                          activeIndex: homeState.activeIndex,
                          onFilterTap: _onFilterTap,
                        ),
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(
                    child: FeaturedListingsHorizontalUseCase(),
                  ),

                  SliverToBoxAdapter(
                    child: SectionHeader(
                      title: 'Recently Added',
                      onSeeAll: () {},
                    ),
                  ),
                  const RecentListingUseCase(),

                  SliverToBoxAdapter(
                    child: buildAgencyBanner(context: context),
                  ),

                  SliverToBoxAdapter(
                    child: SectionHeader(title: 'Residential', onSeeAll: () {}),
                  ),
                  const ResidentialPropertiesListingUseCase(),

                  SliverToBoxAdapter(
                    child: SectionHeader(
                      title: 'Land & Plots',
                      onSeeAll: () {},
                    ),
                  ),
                  const LandedPropertiesUseCase(),

                  SliverToBoxAdapter(
                    child: SectionHeader(title: 'Commercial', onSeeAll: () {}),
                  ),
                  const CommercialPropertiesUseCase(),

                  SliverToBoxAdapter(
                    child: SectionHeader(
                      title: 'Estates & Housing',
                      onSeeAll: () {},
                    ),
                  ),
                  const EstatePropertiesUseCase(),

                  SliverToBoxAdapter(
                    child: SectionHeader(title: 'Short Lets', onSeeAll: () {}),
                  ),
                  const ShortLetPropertiesUseCase(),

                  const SliverToBoxAdapter(child: SizedBox(height: 80)),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Wire chip tap to both cubits
  void _onFilterTap(int i) {
    HapticFeedback.lightImpact();
    context.read<HomeCubit>().activeIndex(i);
    // Ensure full list is loaded before filtering
    context.read<SearchCubit>().searchProperties(
      kAllListings,
      _searchController.text,
    );
    context.read<SearchCubit>().setHomeCategory(i);
  }
}

// =============================================================================
//  Compact 2-column property grid  (no fixed-size wrappers → no overflow)
// =============================================================================

class _CompactPropertyGrid extends StatelessWidget {
  const _CompactPropertyGrid({required this.properties});
  final List<PropertyModel> properties;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          // Aspect ratio chosen so the card content fits without overflow.
          // The compact card has: image(110) + body(~130) = 240px total.
          // At half-screen width ≈ 175px → ratio = 175/240 ≈ 0.73
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
//  Compact card — no fixed SizedBox wrappers, fully intrinsic
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
            // ── Image ──────────────────────────────────────────────────
            Expanded(
              flex: 46, // ~46% of card height for image
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
                            errorBuilder: (_, __, ___) =>
                                _ImagePlaceholder(category: p.category),
                          )
                        : _ImagePlaceholder(category: p.category),
                  ),
                  if (p.isVerified == true)
                    Positioned(top: 6, left: 6, child: _MiniVerifiedBadge()),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: _CategoryPill(category: p.category),
                  ),
                ],
              ),
            ),

            // ── Body ───────────────────────────────────────────────────
            Expanded(
              flex: 54, // ~54% for text content
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 7, 8, 7),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Title
                    Text(
                      p.title ?? '—',
                      style: VeriRentText.titleSmall.copyWith(
                        color: cs.onSurface,
                        fontSize: 11,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // Location
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

                    // Bed / bath chips (only for residential)
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

                    // Price + tier
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

class _MiniVerifiedBadge extends StatelessWidget {
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

class _CategoryPill extends StatelessWidget {
  const _CategoryPill({required this.category});
  final PropertyCategory? category;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (category) {
      PropertyCategory.land => ('Land', const Color(0xFF4CAF50)),
      PropertyCategory.commercial => ('Comm.', VeriRentColors.info500),
      PropertyCategory.estate => ('Estate', VeriRentColors.gold),
      PropertyCategory.shortlet => ('Shortlet', VeriRentColors.accent400),
      _ => ('Residential', VeriRentColors.primary),
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

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder({this.category});
  final PropertyCategory? category;

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

// =============================================================================
//  Filter badge (shows active count + clear button)
// =============================================================================

class _FilterBadge extends StatelessWidget {
  const _FilterBadge({required this.count, required this.onClear});
  final int count;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onClear,
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
              '$count active',
              style: VeriRentText.labelSmall.copyWith(
                color: cs.onPrimaryContainer,
                fontSize: 9,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.close_rounded, size: 9, color: cs.onPrimaryContainer),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
//  Empty state
// =============================================================================

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.query});
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
            query.isNotEmpty
                ? 'No results for "$query"'
                : 'No properties found',
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(color: cs.onSurface),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Text(
            'Try adjusting your filters or search terms.',
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
