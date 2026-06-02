import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../../core/theme/agents_theme.dart';
import '../../data/local_repo.dart';
import '../../ui/widgets/home_featured_list.dart';

// ── Featured Listing  UseCase ─────────────────────────────────────────────────────────────────

class FeaturedListingsHorizontalUseCase extends StatelessWidget {
  const FeaturedListingsHorizontalUseCase({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 270,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: VeriRentSpacing.base),
        itemCount: featuredProperties.length,
        separatorBuilder: (_, _) => const SizedBox(width: VeriRentSpacing.sm),
        itemBuilder: (context, index) {
          return FeaturedCardFactory.build(context, featuredProperties[index]);
        },
      ),
    );
  }
}

// ── Available/Recent Listing UseCase ─────────────────────────────────────────────────────────────────

class AvailableListingsVerticalUseCase extends StatelessWidget {
  const AvailableListingsVerticalUseCase({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: VeriRentSpacing.base),
      sliver: SliverMasonryGrid.count(
        crossAxisCount: 2,
        mainAxisSpacing: VeriRentSpacing.sm,
        crossAxisSpacing: VeriRentSpacing.sm,
        childCount: recentProperties.length,
        itemBuilder: (context, index) {
          return FeaturedCardFactory.build(context, recentProperties[index]);
        },
      ),
    );
  }
}

// ── Landed Listing UseCase ─────────────────────────────────────────────────────────────────

class LandedPropertiesUseCase extends StatelessWidget {
  const LandedPropertiesUseCase({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: VeriRentSpacing.base),
      sliver: SliverMasonryGrid.count(
        crossAxisCount: 2,
        mainAxisSpacing: VeriRentSpacing.sm,
        crossAxisSpacing: VeriRentSpacing.sm,
        childCount: landedProperties.length,
        itemBuilder: (context, index) {
          return FeaturedCardFactory.build(context, landedProperties[index]);
        },
      ),
    );
  }
}

// ── commercial Listing UseCase ─────────────────────────────────────────────────────────────────

class CommercialPropertiesListingUseCase extends StatelessWidget {
  const CommercialPropertiesListingUseCase({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: VeriRentSpacing.base),
      sliver: SliverMasonryGrid.count(
        crossAxisCount: 2,
        mainAxisSpacing: VeriRentSpacing.sm,
        crossAxisSpacing: VeriRentSpacing.sm,
        childCount: commercialProperties.length,
        itemBuilder: (context, index) {
          return FeaturedCardFactory.build(
            context,
            commercialProperties[index],
          );
        },
      ),
    );
  }
}
