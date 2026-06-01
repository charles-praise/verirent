// TODO: (implement the following) The UI should visually communicate the asset category before the user even reads the title.

// switch(property.category){
//   case PropertyCategory.land:
//     return LandFeaturedCard(property);
//
//   case PropertyCategory.residential:
//     return ResidentialFeaturedCard(property);
//
//   case PropertyCategory.commercial:
//     return CommercialFeaturedCard(property);
//
//   case PropertyCategory.estate:
//     return EstateFeaturedCard(property);
//
//   default:
//     return ResidentialFeaturedCard(property);
// }
//
// | Property Type   | Card Style               |
// | --------------- | ------------------------ |
// | Apartment       | Residential Card         |
// | Duplex          | Residential Card         |
// | House           | Residential Card         |
// | Penthouse       | Premium Residential Card |
// | Land            | Land Card                |
// | Farm Land       | Land Card                |
// | Commercial Plot | Land Card                |
// | Office          | Commercial Card          |
// | Shop            | Commercial Card          |
// | Plaza           | Commercial Card          |
// | Mall            | Commercial Card          |
// | Estate          | Estate Card              |
// | Shortlet        | Airbnb Card              |


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:verirent/core/shared/network_image/ui/pages/network_image.dart';

import '../../../../core/theme/agents_theme.dart';
import '../../../../core/util/rating_formatter.dart';
import '../../domain/entities/property_model.dart';
import 'home_tier_badge.dart';

class FeaturedCard extends StatefulWidget {
  const FeaturedCard({super.key, required this.card});
  final PropertyModel card;

  @override
  State<FeaturedCard> createState() => _FeaturedCardState();
}

class _FeaturedCardState extends State<FeaturedCard> {
  bool _isSaved = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final card = widget.card;

    return GestureDetector(
      onTap: () {
        context.push("/listing_details", extra: card);
      },
      child: SizedBox(
        height: 280,
        child: Container(
          width: 200,
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(VeriRentRadius.lg),
            border: Border.all(
              color: card.isVerified
                  ? VeriRentColors.primary.withOpacity(0.35)
                  : cs.outlineVariant,
              width: card.isVerified ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: cs.shadow.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Image area ──────────────────────────────────────
              Stack(
                children: [
                  // Background gradient
                  SizedBox(
                    height: 130,
                    width: double.infinity,
                    child: CustomNetworkImage(
                      imgUrl: card.imageUrls.first,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(VeriRentRadius.lg),
                        topRight: Radius.circular(VeriRentRadius.lg),
                      ),
                    ),
                  ),

                  // Property type badge (top-left)
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: VeriRentColors.bg.withOpacity(0.72),
                        borderRadius: BorderRadius.circular(
                          VeriRentRadius.full,
                        ),
                        border: Border.all(color: VeriRentColors.border),
                      ),
                      child: Text(
                        card.propertyType,
                        style: VeriRentText.labelSmall.copyWith(
                          color: VeriRentColors.text,
                          fontSize: 9,
                        ),
                      ),
                    ),
                  ),

                  // Verified badge (top-right)
                  if (card.isVerified)
                    Positioned(
                      top: 8,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: VeriRentColors.success500,
                          borderRadius: BorderRadius.circular(
                            VeriRentRadius.full,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.verified_rounded,
                              size: 9,
                              color: VeriRentColors.white,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              'Verified',
                              style: VeriRentText.labelSmall.copyWith(
                                color: VeriRentColors.white,
                                fontSize: 9,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Save / heart button (top-right)
                  Positioned(
                    bottom: 6,
                    right: 6,
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        setState(() => _isSaved = !_isSaved);
                      },
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: _isSaved
                              ? VeriRentColors.red.withOpacity(0.65)
                              : VeriRentColors.transparent,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _isSaved
                                ? VeriRentColors.red.withOpacity(0.4)
                                : VeriRentColors.border,
                          ),
                        ),
                        child: Icon(
                          _isSaved
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          size: 14,
                          color: _isSaved
                              ? VeriRentColors.red
                              : VeriRentColors.textMuted,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // ── Content ─────────────────────────────────────────
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(VeriRentSpacing.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        card.title,
                        style: VeriRentText.titleSmall.copyWith(
                          color: cs.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),

                      // Location
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
                              card.location,
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

                      // Beds · Baths · Area
                      Row(
                        children: [
                          _InfoChip(
                            icon: Icons.bed_rounded,
                            label: '${card.bedrooms}bd',
                          ),
                          const SizedBox(width: 4),
                          _InfoChip(
                            icon: Icons.bathtub_outlined,
                            label: '${card.bathrooms}bth',
                          ),
                          const SizedBox(width: 4),
                          _InfoChip(
                            icon: Icons.square_foot_rounded,
                            label: '${card.areaSqm}m²',
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Rating + Agency
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 12,
                            color: VeriRentColors.gold,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            ratingNumberFormater(card.rating),
                            style: VeriRentText.labelSmall.copyWith(
                              color: cs.onSurface,
                              fontSize: 10,
                            ),
                          ),
                          Text(
                            ' (${card.reviewCount})',
                            style: VeriRentText.bodySmall.copyWith(
                              color: cs.onSurfaceVariant,
                              fontSize: 10,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: VeriRentColors.primaryDim,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.business_rounded,
                              size: 9,
                              color: VeriRentColors.primary,
                            ),
                          ),
                          const SizedBox(width: 3),
                          Flexible(
                            child: Text(
                              card.agencyName,
                              style: VeriRentText.labelSmall.copyWith(
                                color: VeriRentColors.primary,
                                fontSize: 9,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),

                      // Price + Tier badge
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "₦ ${card.price}",
                                style: VeriRentText.titleSmall.copyWith(
                                  color: cs.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                'per year',
                                style: VeriRentText.bodySmall.copyWith(
                                  color: cs.onSurfaceVariant,
                                  fontSize: 9,
                                ),
                              ),
                            ],
                          ),
                          TierBadge(
                            label: card.tierLabel
                                .replaceAll(' Agency', '')
                                .replaceAll(' Individual', ''),
                            color: card.tierColor,
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
      ),
    );
  }
}

// ── Info Chip ─────────────────────────────────────────────────────────────────
class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: cs.surfaceVariant,
        borderRadius: BorderRadius.circular(VeriRentRadius.xs),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 9, color: cs.onSurfaceVariant),
          const SizedBox(width: 3),
          Text(
            label,
            style: VeriRentText.labelSmall.copyWith(
              color: cs.onSurfaceVariant,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Monsory FeaturedCard ─────────────────────────────────────────────────────────────────
class MonsoryFeaturedCard extends StatefulWidget {
  const MonsoryFeaturedCard({super.key, required this.card});

  final PropertyModel card;

  @override
  State<MonsoryFeaturedCard> createState() => _MonsoryFeaturedCardState();
}

class _MonsoryFeaturedCardState extends State<MonsoryFeaturedCard> {
  bool isSaved = false;
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        context.push("/listing_details", extra: widget.card);
      },
      child: Container(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(VeriRentRadius.lg),
          border: Border.all(color: cs.outlineVariant, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Agent image
            Stack(
              children: [
                SizedBox(
                  height: widget.card.isVerified ? 140 : 110,
                  width: double.infinity,
                  child: CustomNetworkImage(
                    imgUrl: widget.card.imageUrls.first,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(VeriRentRadius.lg),
                    ),
                  ),
                ),

                // rating bottom left
                Positioned(
                  left: 6,
                  bottom: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: cs.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, size: 12, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          ratingNumberFormater(widget.card.rating),
                          style: VeriRentText.labelSmall.copyWith(
                            color: cs.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Save / heart button (bottom-right)
                Positioned(
                  bottom: 6,
                  right: 6,
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      setState(() => isSaved = !isSaved);
                    },
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: isSaved
                            ? VeriRentColors.red.withOpacity(0.65)
                            : VeriRentColors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSaved
                              ? VeriRentColors.red.withOpacity(0.4)
                              : VeriRentColors.border,
                        ),
                      ),
                      child: Icon(
                        isSaved
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        size: 14,
                        color: isSaved
                            ? VeriRentColors.red
                            : VeriRentColors.textMuted,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            //Property details
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.card.title,
                          style: VeriRentText.titleSmall.copyWith(
                            color: cs.onSurface,
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
                      Icon(
                        Icons.location_on_outlined,
                        size: 12,
                        color: cs.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          widget.card.location,
                          style: VeriRentText.bodySmall.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundImage: widget.card.agentAvatarUrl != null
                            ? NetworkImage(widget.card.agentAvatarUrl!)
                            : null,
                        backgroundColor: cs.surfaceVariant,
                        child: widget.card.agentAvatarUrl == null
                            ? Text(widget.card.agentInitials!)
                            : null,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Agent',
                          style: VeriRentText.bodySmall.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ),
                      Text(
                        widget.card.price,
                        style: VeriRentText.titleSmall.copyWith(
                          color: cs.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Wrap(
                  //   spacing: 8,
                  //   children: card.amenities
                  //       .take(4)
                  //       .map(
                  //         (a) => Chip(
                  //           label: Text(a, style: VeriRentText.labelSmall),
                  //         ),
                  //       )
                  //       .toList(),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
