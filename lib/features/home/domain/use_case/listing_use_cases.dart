import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:verirent/core/models/property_model.dart';
import 'package:verirent/core/repo/local_repo.dart';
import 'package:verirent/core/shared/network_image/ui/pages/network_image.dart';
import 'package:verirent/core/shared/widgets/header.dart';
import 'package:verirent/core/shared/widgets/verifiedBadge.dart';

import '../../../../core/shared/widgets/card_listing_widget.dart';
import '../../../../core/shared/widgets/cylinder_listing_widget.dart';
import '../../../../core/shared/widgets/saveButton.dart';
import '../../../../core/theme/agents_theme.dart';

class GetPropertiesUseCase {
  final LocalRepository repository;

  GetPropertiesUseCase(this.repository);

  Future<List<PropertyModel>> call(PropertyCategory category) {
    switch (category) {
      case PropertyCategory.all:
        return repository.all();

      case PropertyCategory.featured:
        return repository.featured();

      case PropertyCategory.residential:
        return repository.residential();

      case PropertyCategory.commercial:
        return repository.commercial();

      case PropertyCategory.estate:
        return repository.estate();

      case PropertyCategory.land:
        return repository.land();

      case PropertyCategory.recent:
        return repository.recent();

      case PropertyCategory.shortLet:
        return repository.shortLets();
      case PropertyCategory.option:
        return repository.option();
      case PropertyCategory.none:
        return repository.all();
    }
  }
}

class PropertyUseCase extends StatelessWidget {
  const PropertyUseCase({super.key, required this.properties});

  final List<PropertyModel> properties;

  @override
  Widget build(BuildContext context) {
    if (properties.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    switch (properties.first.category) {
      case PropertyCategory.featured:
        return SliverToBoxAdapter(
          child: SizedBox(
            height: 260,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: VeriRentSpacing.base,
              ),
              itemCount: properties.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: VeriRentSpacing.sm),
              itemBuilder: (_, index) => Column(
                children: [
                  Header(listing: properties),
                  FeaturedCardFactory.build(context, properties[index]),
                ],
              ),
            ),
          ),
        );

      case PropertyCategory.option:
        return SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(left: 14),
            child: SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: properties.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (_, index) => Column(
                  children: [
                    Header(listing: properties),
                    _ListingThumb(
                      index: index,
                      property: properties[index],
                      color:
                          properties[index].tierColor ??
                          VeriRentColors.tierBasic,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

      case PropertyCategory.recent:
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => Padding(
              padding: const EdgeInsets.fromLTRB(
                VeriRentSpacing.base,
                0,
                VeriRentSpacing.base,
                VeriRentSpacing.sm,
              ),
              child: Column(
                children: [
                  Header(listing: properties),
                  RecentCardFactory.build(context, properties[index]),
                ],
              ),
            ),
            childCount: properties.length,
          ),
        );

      default:
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
              (context, index) => Column(
                children: [
                  Header(listing: properties),
                  FeaturedCardFactory.build(context, properties[index]),
                ],
              ),
              childCount: properties.length,
            ),
          ),
        );
    }
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
