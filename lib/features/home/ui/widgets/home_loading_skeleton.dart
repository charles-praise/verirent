// =============================================================================
//  VeriRent NG — Home Body Loading Skeleton
//
//  File: lib/features/home/ui/widgets/home_loading_skeleton.dart
//
//  The AppBar (SliverPersistentHeader) and filter chips are REAL widgets that
//  stay mounted during loading. Only the feed body swaps to skeleton bones.
//
//  Usage — in home.dart replace the body slivers spread with:
//
//    ..._bodySlivers(context, homeState, searchState, isFiltering),
//
//  Where _bodySlivers returns skeleton slivers when phase is loading/initial,
//  and the real feed slivers otherwise. See the integration snippet at the
//  bottom of this file.
//
//  pubspec.yaml dependency:
//    shimmer: ^3.0.0
// =============================================================================

// =============================================================================
//  PUBLIC API
//  Drop-in replacement for the body slivers spread in home.dart.
//  Returns a List<Widget> (all Slivers) so it can be spread into CustomScrollView.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/agents_theme.dart';

/// Returns skeleton body slivers. The AppBar + filter row are NOT included —
/// they remain as real widgets in the parent CustomScrollView.
List<Widget> homeBodySkeletonSlivers(BuildContext context) {
  final cs = Theme.of(context).colorScheme;
  final bool isDark = cs.brightness == Brightness.dark;

  final Color base = isDark
      ? VeriRentColors.neutral800
      : VeriRentColors.neutral100;
  final Color highlight = isDark
      ? VeriRentColors.neutral700
      : VeriRentColors.neutral50;

  // Wrap all bones in a single Shimmer so the gradient sweeps across the
  // whole feed in one coordinated wave.
  return [
    SliverToBoxAdapter(
      child: Shimmer.fromColors(
        baseColor: base,
        highlightColor: highlight,
        period: const Duration(milliseconds: 1100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Featured horizontal strip ──────────────────────────────
            _FeaturedStripSkeleton(cs: cs),

            // ── Option thumbs row ──────────────────────────────────────
            _OptionThumbsSkeleton(cs: cs),

            // ── Section label + 3 recent cards ────────────────────────
            _SectionLabelSkeleton(cs: cs),
            ..._recentCards(cs),

            // ── Section label + 2×2 grid ───────────────────────────────
            _SectionLabelSkeleton(cs: cs),
            _GridSkeleton(cs: cs),

            const SizedBox(height: 100),
          ],
        ),
      ),
    ),
  ];
}

// =============================================================================
//  INTEGRATION SNIPPET  (paste into home.dart)
// =============================================================================
//
//  import '../widgets/home_loading_skeleton.dart';
//
//  // Inside build(), replace the body slivers spread:
//  CustomScrollView(
//    controller: _scrollController,
//    slivers: [
//      SliverPersistentHeader(pinned: true, delegate: HomeAppBar(...)),
//
//      // Filter chips always visible
//      SliverToBoxAdapter(
//        child: SearchFilter(
//          filters: homeState.filters,
//          filterIcons: homeState.filterIcons,
//          activeIndex: homeState.activeIndex,
//          onFilterTap: _onFilterTap,
//        ),
//      ),
//
//      // Body — skeleton while loading, real feed once loaded
//      if (homeState.phase == HomePhase.loading ||
//          homeState.phase == HomePhase.initial)
//        ...homeBodySkeletonSlivers(context)
//      else if (homeState.phase == HomePhase.error)
//        SliverFillRemaining(
//          hasScrollBody: false,
//          child: _ErrorRetry(onRetry: () => GetIt.I<HomeCubit>().loadListing()),
//        )
//      else
//        ...(isFiltering
//            ? _filteredViewList(...)
//            : _defaultViewList(...)),
//    ],
//  )
//
// =============================================================================

// =============================================================================
//  PRIVATE SKELETON PARTS
// =============================================================================

List<Widget> _recentCards(ColorScheme cs) => List.generate(
  3,
  (_) => Padding(
    padding: const EdgeInsets.fromLTRB(
      VeriRentSpacing.base,
      0,
      VeriRentSpacing.base,
      VeriRentSpacing.sm,
    ),
    child: _RecentCardSkeleton(cs: cs),
  ),
);

// ── Featured strip ────────────────────────────────────────────────────────────

class _FeaturedStripSkeleton extends StatelessWidget {
  const _FeaturedStripSkeleton({required this.cs});
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 276,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          VeriRentSpacing.base,
          8,
          VeriRentSpacing.base,
          8,
        ),
        itemCount: 3,
        separatorBuilder: (_, __) => const SizedBox(width: VeriRentSpacing.sm),
        itemBuilder: (_, __) =>
            _Bone(width: 170, height: 260, radius: VeriRentRadius.lg, cs: cs),
      ),
    );
  }
}

// ── Option thumbs ─────────────────────────────────────────────────────────────

class _OptionThumbsSkeleton extends StatelessWidget {
  const _OptionThumbsSkeleton({required this.cs});
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 4, 0, 12),
      child: SizedBox(
        height: 120,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 4,
          separatorBuilder: (_, __) => const SizedBox(width: 10),
          itemBuilder: (_, __) =>
              _Bone(width: 168, height: 120, radius: VeriRentRadius.lg, cs: cs),
        ),
      ),
    );
  }
}

// ── Section label ─────────────────────────────────────────────────────────────

class _SectionLabelSkeleton extends StatelessWidget {
  const _SectionLabelSkeleton({required this.cs});
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        VeriRentSpacing.base,
        16,
        VeriRentSpacing.base,
        10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _Bone(width: 120, height: 14, radius: 6, cs: cs),
          _Bone(width: 48, height: 12, radius: 6, cs: cs),
        ],
      ),
    );
  }
}

// ── Recent card ───────────────────────────────────────────────────────────────

class _RecentCardSkeleton extends StatelessWidget {
  const _RecentCardSkeleton({required this.cs});
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(VeriRentRadius.lg),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        children: [
          _Bone(
            width: 90,
            height: 100,
            radius: 0,
            cs: cs,
            topLeft: VeriRentRadius.lg,
            bottomLeft: VeriRentRadius.lg,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _Bone(width: double.infinity, height: 12, radius: 5, cs: cs),
                  _Bone(width: 130, height: 10, radius: 5, cs: cs),
                  Row(
                    children: [
                      _Bone(width: 80, height: 12, radius: 5, cs: cs),
                      const Spacer(),
                      _Bone(
                        width: 44,
                        height: 22,
                        radius: VeriRentRadius.xs,
                        cs: cs,
                      ),
                      const SizedBox(width: 6),
                      _Bone(
                        width: 44,
                        height: 22,
                        radius: VeriRentRadius.xs,
                        cs: cs,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}

// ── 2-col grid ────────────────────────────────────────────────────────────────

class _GridSkeleton extends StatelessWidget {
  const _GridSkeleton({required this.cs});
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 170 / 260,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(4, (_) => _GridCardSkeleton(cs: cs)),
      ),
    );
  }
}

class _GridCardSkeleton extends StatelessWidget {
  const _GridCardSkeleton({required this.cs});
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(VeriRentRadius.lg),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Bone(
            width: double.infinity,
            height: 130,
            radius: 0,
            cs: cs,
            topLeft: VeriRentRadius.lg,
            topRight: VeriRentRadius.lg,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(VeriRentSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Bone(width: double.infinity, height: 12, radius: 5, cs: cs),
                  const SizedBox(height: 6),
                  _Bone(width: 100, height: 10, radius: 5, cs: cs),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _Bone(
                        width: 38,
                        height: 18,
                        radius: VeriRentRadius.xs,
                        cs: cs,
                      ),
                      const SizedBox(width: 4),
                      _Bone(
                        width: 38,
                        height: 18,
                        radius: VeriRentRadius.xs,
                        cs: cs,
                      ),
                      const SizedBox(width: 4),
                      _Bone(
                        width: 38,
                        height: 18,
                        radius: VeriRentRadius.xs,
                        cs: cs,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      _Bone(width: 80, height: 12, radius: 5, cs: cs),
                      const Spacer(),
                      _Bone(width: 12, height: 12, radius: 6, cs: cs),
                      const SizedBox(width: 4),
                      _Bone(width: 48, height: 10, radius: 5, cs: cs),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _Bone(width: 88, height: 14, radius: 5, cs: cs),
                      _Bone(
                        width: 40,
                        height: 20,
                        radius: VeriRentRadius.full,
                        cs: cs,
                      ),
                    ],
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
//  ATOMIC BONE
// =============================================================================

class _Bone extends StatelessWidget {
  const _Bone({
    required this.width,
    required this.height,
    required this.radius,
    required this.cs,
    this.topLeft,
    this.topRight,
    this.bottomLeft,
    this.bottomRight,
  });

  final double width;
  final double height;
  final double radius;
  final ColorScheme cs;
  final double? topLeft;
  final double? topRight;
  final double? bottomLeft;
  final double? bottomRight;

  @override
  Widget build(BuildContext context) {
    final br =
        (topLeft != null ||
            topRight != null ||
            bottomLeft != null ||
            bottomRight != null)
        ? BorderRadius.only(
            topLeft: Radius.circular(topLeft ?? radius),
            topRight: Radius.circular(topRight ?? radius),
            bottomLeft: Radius.circular(bottomLeft ?? radius),
            bottomRight: Radius.circular(bottomRight ?? radius),
          )
        : BorderRadius.circular(radius);

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: br,
      ),
    );
  }
}
