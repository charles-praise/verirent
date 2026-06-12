import 'package:flutter/material.dart';

import '../../../../core/theme/agents_theme.dart';
import '../../data/local_repo.dart';
import '../../ui/widgets/home_featured_list.dart';

// ── All Listing  UseCase ─────────────────────────────────────────────────────────────────
class AllListingUseCase extends StatelessWidget {
  const AllListingUseCase({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.64,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => FeaturedCardFactory.build(
              context, HomeLocalRepo().allListedProperties[index]),
          childCount: HomeLocalRepo().allListedProperties.length,
        ),
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
      height: 260,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: VeriRentSpacing.base),
        itemCount: HomeLocalRepo().featuredProperties.length,
        separatorBuilder: (_, __) => const SizedBox(width: VeriRentSpacing.sm),
        itemBuilder: (context, index) {
          return FeaturedCardFactory.build(
              context, HomeLocalRepo().featuredProperties[index]);
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
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.64,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => FeaturedCardFactory.build(
              context, HomeLocalRepo().residentialProperties[index]),
          childCount: HomeLocalRepo().residentialProperties.length,
        ),
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
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.64,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => FeaturedCardFactory.build(
              context, HomeLocalRepo().estateProperties[index]),
          childCount: HomeLocalRepo().estateProperties.length,
        ),
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
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.64,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => FeaturedCardFactory.build(
              context, HomeLocalRepo().landedProperties[index]),
          childCount: HomeLocalRepo().landedProperties.length,
        ),
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
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.64,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => FeaturedCardFactory.build(
              context, HomeLocalRepo().commercialProperties[index]),
          childCount: HomeLocalRepo().commercialProperties.length,
        ),
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
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.64,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => FeaturedCardFactory.build(
              context, HomeLocalRepo().shortletProperties[index]),
          childCount: HomeLocalRepo().shortletProperties.length,
        ),
      ),
    );
  }
}
