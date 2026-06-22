import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:verirent/core/shared/location/ui/cubit/location_cubit.dart';
import 'package:verirent/core/shared/location/ui/cubit/location_state.dart';
import 'package:verirent/core/shared/network_image/ui/pages/network_image.dart';
import 'package:verirent/core/shared/widgets/verifiedBadge.dart';
import 'package:verirent/features/home/domain/entities/property_model.dart';

import '../../../../core/shared/widgets/card_listing_widget.dart';
import '../../../../core/shared/widgets/saveButton.dart';
import '../../../../core/theme/agents_theme.dart';
import '../../data/local_repo.dart';

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
    return BlocProvider.value(
      value: GetIt.I<LocationCubit>(),
      child: BlocBuilder<LocationCubit, LocationState>(
        builder: (context, locationState) {
          return Padding(
            padding: const EdgeInsets.only(left: 14),
            child: SizedBox(
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
          );
        },
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

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => context.push('/listing_details', extra: property),
      child: Container(
        width: 168,
        padding: const EdgeInsets.all(3),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(VeriRentRadius.lg),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                clipBehavior: Clip.hardEdge,
                children: [
                  Positioned.fill(
                    child: CustomNetworkImage(
                      imgUrl: property.imageUrls!.first,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(VeriRentRadius.lg),
                        topRight: Radius.circular(VeriRentRadius.lg),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 2,
                    left: 2,
                    child: SaveButton(item: property),
                  ),
                  if (property.isVerified!)
                    Positioned(top: 8, right: 8, child: verifiedBadge()),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.only(left: 3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.title ?? 'No title',
                    style: VeriRentText.titleSmall.copyWith(
                      color: cs.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    property.price ?? '0',
                    style: VeriRentText.labelMedium.copyWith(
                      color: color,
                      fontWeight: FontWeight.w700,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
