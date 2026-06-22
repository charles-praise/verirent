/// =============================================================================
///  VeriRent NG — Category Recent Listing Cards
///  Compact horizontal cards for the "Recently Added" section.
///
///  Factory usage:
///    RecentCardFactory.build(context, card)
///
///  | Property Type          | Card Variant      | Hero metric         |
///  | ---------------------- | ----------------- | ------------------- |
///  | Apartment/Duplex/House | ResidentialCard   | Beds + baths        |
///  | Penthouse              | ResidentialCard   | Gold premium accent |
///  | Land/Farm/Plot         | LandCard          | Plot size (m²)      |
///  | Office/Shop/Plaza/Mall | CommercialCard    | Sqm + floor         |
///  | Estate                 | EstateCard        | Unit count          |
///  | Shortlet               | ShortletCard      | Per night price     |
/// =============================================================================
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:verirent/core/shared/network_image/ui/pages/network_image.dart';
import 'package:verirent/core/shared/widgets/verifiedBadge.dart';

import '../../../../core/theme/agents_theme.dart';
import '../../domain/entities/property_model.dart';
import 'home_room_chip.dart';
import 'home_tier_badge.dart';

// =============================================================================
//  DISPATCHER
// =============================================================================

abstract final class RecentCardFactory {
  static Widget build(BuildContext context, PropertyModel card) {
    switch (card.category) {
      case PropertyCategory.land:
        return LandCard(card: card);
      case PropertyCategory.commercial:
        return CommercialCard(card: card);
      case PropertyCategory.estate:
        return EstateCard(card: card);
      case PropertyCategory.shortlet:
        return ShortletCard(card: card);
      case PropertyCategory.residential:
      default:
        return ResidentialCard(card: card);
    }
  }
}

// =============================================================================
//  SHARED HELPERS
// =============================================================================

/// Left-side thumbnail with optional category indicator strip.
class _Thumbnail extends StatelessWidget {
  const _Thumbnail({required this.imgUrl, this.stripColor, required this.item});
  final String imgUrl;
  final Color? stripColor;
  final PropertyModel item;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRect(
            child: CustomNetworkImage(
              imgUrl: imgUrl,
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(VeriRentRadius.lg),
              ),
            ),
          ),
          // Verified badge  top left-edge category
          if (item.verificationStatus == VerificationStatus.verified &&
              item.isVerified == true)
            Positioned(top: 6, right: 6, child: verifiedBadge()),
        ],
      ),
    );
  }
}

// =============================================================================
//  1. RESIDENTIAL CARD  (default)
// =============================================================================

class ResidentialCard extends StatelessWidget {
  const ResidentialCard({super.key, required this.card});
  final PropertyModel card;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => context.push('/listing_details', extra: card),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(VeriRentRadius.lg),
          border: Border.all(
            color: card.isVerified!
                ? VeriRentColors.primary.withValues(alpha: 0.3)
                : cs.outlineVariant,
            width: card.isVerified! ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: cs.shadow.withValues(alpha: 0.4),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            _Thumbnail(
              imgUrl: card.imageUrls!.first,
              stripColor: VeriRentColors.primary,
              item: card,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: VeriRentSpacing.sm,
                  vertical: VeriRentSpacing.sm,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            card.title!,
                            style: VeriRentText.titleSmall.copyWith(
                              color: cs.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        TierBadge(
                          label: card.tierLabel!
                              .replaceAll(' Agency', '')
                              .replaceAll(' Individual', ''),
                          color: card.tierColor!,
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          size: 11,
                          color: cs.onSurfaceVariant,
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            card.location!,
                            style: VeriRentText.bodySmall.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          '₦ ${card.price}',
                          style: VeriRentText.labelMedium.copyWith(
                            color: cs.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        RoomChip(
                          icon: Icons.bed_rounded,
                          label: '${card.bedrooms}bd',
                        ),
                        const SizedBox(width: 4),
                        RoomChip(
                          icon: Icons.bathtub_outlined,
                          label: '${card.bathrooms}bth',
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

// =============================================================================
//  2. LAND CARD  (green strip, plot-size hero, document type)
// =============================================================================

class LandCard extends StatelessWidget {
  const LandCard({super.key, required this.card});
  final PropertyModel card;

  static const _green = Color(0xFF4CAF50);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => context.push('/listing_details', extra: card),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(VeriRentRadius.lg),
          border: Border.all(
            color: card.isVerified!
                ? _green.withValues(alpha: 0.4)
                : cs.outlineVariant,
            width: card.isVerified! ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: cs.shadow.withValues(alpha: 0.4),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            _Thumbnail(
              imgUrl: card.imageUrls!.first,
              stripColor: _green,
              item: card,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: VeriRentSpacing.sm,
                  vertical: VeriRentSpacing.sm,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            card.title!,
                            style: VeriRentText.titleSmall.copyWith(
                              color: cs.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _green.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(
                              VeriRentRadius.full,
                            ),
                            border: Border.all(
                              color: _green.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.landscape_rounded,
                                size: 9,
                                color: _green,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                'Land',
                                style: VeriRentText.labelSmall.copyWith(
                                  color: _green,
                                  fontSize: 9,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          size: 11,
                          color: cs.onSurfaceVariant,
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            card.location!,
                            style: VeriRentText.bodySmall.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          '₦ ${card.price}',
                          style: VeriRentText.labelMedium.copyWith(
                            color: _green,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        // Plot size is the hero metric for land
                        RoomChip(
                          icon: Icons.square_foot_rounded,
                          label: '${card.areaSqm}m²',
                          accentColor: _green,
                        ),
                        const SizedBox(width: 4),
                        RoomChip(
                          icon: Icons.description_rounded,
                          label: card.documentType ?? 'C of O',
                          accentColor: _green,
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

// =============================================================================
//  3. COMMERCIAL CARD  (blue strip, sqm + floor hero)
// =============================================================================

class CommercialCard extends StatelessWidget {
  const CommercialCard({super.key, required this.card});
  final PropertyModel card;

  static const _blue = VeriRentColors.info500;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => context.push('/listing_details', extra: card),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(VeriRentRadius.lg),
          border: Border.all(
            color: card.isVerified!
                ? _blue.withValues(alpha: 0.35)
                : cs.outlineVariant,
            width: card.isVerified! ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: cs.shadow.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            _Thumbnail(
              imgUrl: card.imageUrls!.first,
              stripColor: _blue,
              item: card,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: VeriRentSpacing.sm,
                  vertical: VeriRentSpacing.sm,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            card.title!,
                            style: VeriRentText.titleSmall.copyWith(
                              color: cs.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _blue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(
                              VeriRentRadius.full,
                            ),
                            border: Border.all(
                              color: _blue.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.business_center_rounded,
                                size: 9,
                                color: _blue,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                card.propertyType!,
                                style: VeriRentText.labelSmall.copyWith(
                                  color: _blue,
                                  fontSize: 9,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          size: 11,
                          color: cs.onSurfaceVariant,
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            card.location!,
                            style: VeriRentText.bodySmall.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          '₦ ${card.price}',
                          style: VeriRentText.labelMedium.copyWith(
                            color: _blue,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        RoomChip(
                          icon: Icons.square_foot_rounded,
                          label: '${card.areaSqm}m²',
                          accentColor: _blue,
                        ),
                        const SizedBox(width: 4),
                        RoomChip(
                          icon: Icons.layers_rounded,
                          label: card.floorLevel != null
                              ? '${card.floorLevel}F'
                              : 'GF',
                          accentColor: _blue,
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

// =============================================================================
//  4. ESTATE CARD  (gold strip, unit count hero)
// =============================================================================

class EstateCard extends StatelessWidget {
  const EstateCard({super.key, required this.card});
  final PropertyModel card;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => context.push('/listing_details', extra: card),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(VeriRentRadius.lg),
          border: Border.all(
            color: VeriRentColors.gold.withValues(alpha: 0.5),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: VeriRentColors.gold.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            _Thumbnail(
              imgUrl: card.imageUrls!.first,
              stripColor: VeriRentColors.gold,
              item: card,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: VeriRentSpacing.sm,
                  vertical: VeriRentSpacing.sm,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            card.title!,
                            style: VeriRentText.titleSmall.copyWith(
                              color: cs.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: VeriRentColors.goldDim,
                            borderRadius: BorderRadius.circular(
                              VeriRentRadius.full,
                            ),
                            border: Border.all(
                              color: VeriRentColors.gold.withValues(alpha: 0.4),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.workspace_premium_rounded,
                                size: 9,
                                color: VeriRentColors.gold,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                'Estate',
                                style: VeriRentText.labelSmall.copyWith(
                                  color: VeriRentColors.gold,
                                  fontSize: 9,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          size: 11,
                          color: cs.onSurfaceVariant,
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            card.location!,
                            style: VeriRentText.bodySmall.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          '₦ ${card.price}',
                          style: VeriRentText.labelMedium.copyWith(
                            color: VeriRentColors.gold,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        RoomChip(
                          icon: Icons.domain_rounded,
                          label: '${card.unitCount ?? '—'} Units',
                          accentColor: VeriRentColors.gold,
                        ),
                        const SizedBox(width: 4),
                        RoomChip(
                          icon: Icons.security_rounded,
                          label: 'Gated',
                          accentColor: VeriRentColors.gold,
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

// =============================================================================
//  5. SHORTLET CARD  (purple/teal, per-night price, WiFi/AC chips)
// =============================================================================

class ShortletCard extends StatelessWidget {
  const ShortletCard({super.key, required this.card});
  final PropertyModel card;

  static const _purple = Color(0xFF7C3AED);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => context.push('/listing_details', extra: card),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(VeriRentRadius.lg),
          border: Border.all(
            color: card.isVerified!
                ? _purple.withValues(alpha: 0.35)
                : cs.outlineVariant,
            width: card.isVerified! ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: cs.shadow.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Stack(
              children: [
                _Thumbnail(
                  imgUrl: card.imageUrls!.first,
                  stripColor: _purple,
                  item: card,
                ),
                // "Per night" overlay badge
                Positioned(
                  bottom: 6,
                  left: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: _purple,
                      borderRadius: BorderRadius.circular(VeriRentRadius.full),
                    ),
                    child: Text(
                      '/night',
                      style: VeriRentText.labelSmall.copyWith(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: VeriRentSpacing.sm,
                  vertical: VeriRentSpacing.sm,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            card.title!,
                            style: VeriRentText.titleSmall.copyWith(
                              color: cs.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _purple.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(
                              VeriRentRadius.full,
                            ),
                            border: Border.all(
                              color: _purple.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.weekend_rounded,
                                size: 9,
                                color: _purple,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                'Short-let',
                                style: VeriRentText.labelSmall.copyWith(
                                  color: _purple,
                                  fontSize: 9,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          size: 11,
                          color: cs.onSurfaceVariant,
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            card.location!,
                            style: VeriRentText.bodySmall.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        // Per-night price is the hero for shortlets
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '₦ ${card.price}',
                              style: VeriRentText.labelMedium.copyWith(
                                color: _purple,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'per night',
                              style: VeriRentText.bodySmall.copyWith(
                                color: cs.onSurfaceVariant,
                                fontSize: 8,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        RoomChip(
                          icon: Icons.wifi_rounded,
                          label: 'WiFi',
                          accentColor: _purple,
                        ),
                        const SizedBox(width: 4),
                        RoomChip(
                          icon: Icons.ac_unit_rounded,
                          label: 'AC',
                          accentColor: _purple,
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
