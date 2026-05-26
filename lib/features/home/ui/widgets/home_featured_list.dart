import 'package:flutter/material.dart';

import '../../../../core/theme/agents_theme.dart';
import '../../domain/entities/home_listing_card.dart';
import 'home_room_chip.dart';
import 'home_tier_badge.dart';

class FeaturedCard extends StatelessWidget {
  const FeaturedCard({super.key, required this.card});

  final ListingCard card;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {},
      child: SizedBox(
        height: 240,
        child: Container(
          width: 220,
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(VeriRentRadius.lg),
            border: Border.all(color: cs.outlineVariant, width: 1),
            boxShadow: [
              BoxShadow(
                color: cs.shadow.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image area (emoji placeholder)
              Container(
                height: 110,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [cs.primaryContainer, cs.secondaryContainer],
                  ),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(VeriRentRadius.lg),
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        card.emoji,
                        style: const TextStyle(fontSize: 40),
                      ),
                    ),
                    if (card.isVerified)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
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
                                size: 10,
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
                  ],
                ),
              ),

              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(VeriRentSpacing.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        card.title,
                        style: VeriRentText.titleSmall.copyWith(
                          color: cs.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
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
                      const Spacer(),
                      Row(
                        children: [
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
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            card.price,
                            style: VeriRentText.titleSmall.copyWith(
                              color: cs.primary,
                              fontWeight: FontWeight.w700,
                            ),
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

class MonsoryFeaturedCard extends StatelessWidget {
  const MonsoryFeaturedCard({super.key, required this.card});

  final ListingCard card;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(VeriRentRadius.lg),
        border: Border.all(color: cs.outlineVariant, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: card.isVerified ? 140 : 110,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [cs.primaryContainer, cs.secondaryContainer],
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(VeriRentRadius.lg),
              ),
            ),
            child: Center(
              child: Text(card.emoji, style: const TextStyle(fontSize: 40)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(VeriRentSpacing.sm),
            child: Text(
              card.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
