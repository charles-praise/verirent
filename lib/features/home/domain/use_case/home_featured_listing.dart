import 'package:flutter/material.dart';
import 'package:verirent/core/shared/network_image/ui/pages/network_image.dart';
import 'package:verirent/features/home/domain/entities/property_model.dart';

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
          mainAxisExtent: 260,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => FeaturedCardFactory.build(
            context,
            HomeLocalRepo().allListedProperties[index],
          ),
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
        separatorBuilder: (context, index) =>
            const SizedBox(width: VeriRentSpacing.sm),
        itemBuilder: (context, index) {
          return FeaturedCardFactory.build(
            context,
            HomeLocalRepo().featuredProperties[index],
          );
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
          mainAxisExtent: 260,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => FeaturedCardFactory.build(
            context,
            HomeLocalRepo().residentialProperties[index],
          ),
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
          mainAxisExtent: 260,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => FeaturedCardFactory.build(
            context,
            HomeLocalRepo().estateProperties[index],
          ),
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
          mainAxisExtent: 260,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => FeaturedCardFactory.build(
            context,
            HomeLocalRepo().landedProperties[index],
          ),
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
          mainAxisExtent: 260,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => FeaturedCardFactory.build(
            context,
            HomeLocalRepo().commercialProperties[index],
          ),
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
          mainAxisExtent: 260,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => FeaturedCardFactory.build(
            context,
            HomeLocalRepo().shortletProperties[index],
          ),
          childCount: HomeLocalRepo().shortletProperties.length,
        ),
      ),
    );
  }
}

// ── Property Option Listing  UseCase ─────────────────────────────────────────────────────────────────

class PropertyOption extends StatelessWidget {
  const PropertyOption({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(left: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Discount available in',
                style: VeriRentText.titleSmall.copyWith(color: cs.onSurface),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: Text(
                  'See all',
                  style: VeriRentText.labelMedium.copyWith(color: cs.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 120,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: HomeLocalRepo().featuredProperties.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, i) => _ListingThumb(
                index: i,
                property: HomeLocalRepo().featuredProperties[i],
                color:
                    HomeLocalRepo().featuredProperties[i].tierColor ??
                    VeriRentColors.tierBasic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ListingThumb extends StatelessWidget {
  const _ListingThumb({
    super.key,
    required this.index,
    required this.color,
    required this.property,
  });
  final int index;
  final Color color;
  final PropertyModel property;

  static const _titles = [
    '3 Bed Flat, GRA Phase 2',
    'Executive Duplex, Trans-Amadi',
    'Office Space, D-Line',
    'Studio Apt, Rumuola',
    'Land 648m², Rumuigbo',
  ];
  static const _prices = [
    '₦1.8M/yr',
    '₦4.5M/yr',
    '₦2.2M/yr',
    '₦550k/yr',
    '₦18.5M',
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      width: 168,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(VeriRentRadius.lg),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 56,
              decoration: BoxDecoration(
                color: color.withOpacity(0.08),
                borderRadius: BorderRadius.circular(VeriRentRadius.md),
                border: Border.all(color: color.withOpacity(0.2)),
              ),
              child: Center(
                child: CustomNetworkImage(imgUrl: property.imageUrls!.first),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _titles[index % _titles.length],
              style: VeriRentText.titleSmall.copyWith(color: cs.onSurface),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              _prices[index % _prices.length],
              style: VeriRentText.labelMedium.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
