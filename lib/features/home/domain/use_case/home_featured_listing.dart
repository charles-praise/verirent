import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../../core/theme/agents_theme.dart';
import '../../data/local_repo.dart';
import '../../ui/widgets/home_featured_list.dart';

// ── All Listing  UseCase ─────────────────────────────────────────────────────────────────
class AllListingUseCase extends StatelessWidget {
  const AllListingUseCase({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: VeriRentSpacing.base),
      sliver: SliverMasonryGrid.count(
        crossAxisCount: 2,
        mainAxisSpacing: VeriRentSpacing.sm,
        crossAxisSpacing: VeriRentSpacing.sm,
        childCount: allListedProperties.length,
        itemBuilder: (context, index) {
          return FeaturedCardFactory.build(context, allListedProperties[index]);
        },
      ),
    );
  }
}

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

// ── Residential Listing UseCase ─────────────────────────────────────────────────────────────────

class ResidentialPropertiesListingUseCase extends StatelessWidget {
  const ResidentialPropertiesListingUseCase({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: VeriRentSpacing.base),
      sliver: SliverMasonryGrid.count(
        crossAxisCount: 2,
        mainAxisSpacing: VeriRentSpacing.sm,
        crossAxisSpacing: VeriRentSpacing.sm,
        childCount: residentialProperties.length,
        itemBuilder: (context, index) {
          return FeaturedCardFactory.build(
            context,
            residentialProperties[index],
          );
        },
      ),
    );
  }
}

// ── Estate Listing UseCase ─────────────────────────────────────────────────────────────────

class EstatePropertiesUseCase extends StatelessWidget {
  const EstatePropertiesUseCase({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: VeriRentSpacing.base),
      sliver: SliverMasonryGrid.count(
        crossAxisCount: 2,
        mainAxisSpacing: VeriRentSpacing.sm,
        crossAxisSpacing: VeriRentSpacing.sm,
        childCount: estateProperties.length,
        itemBuilder: (context, index) {
          return FeaturedCardFactory.build(context, estateProperties[index]);
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

class CommercialPropertiesUseCase extends StatelessWidget {
  const CommercialPropertiesUseCase({super.key});

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

// ── shortlet Listing UseCase ─────────────────────────────────────────────────────────────────

class ShortLetPropertiesUseCase extends StatelessWidget {
  const ShortLetPropertiesUseCase({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: VeriRentSpacing.base),
      sliver: SliverMasonryGrid.count(
        crossAxisCount: 2,
        mainAxisSpacing: VeriRentSpacing.sm,
        crossAxisSpacing: VeriRentSpacing.sm,
        childCount: shortletProperties.length,
        itemBuilder: (context, index) {
          return FeaturedCardFactory.build(context, shortletProperties[index]);
        },
      ),
    );
  }
}
