import 'package:flutter/material.dart';

import '../../../../core/theme/agents_theme.dart';
import '../../domain/entities/home_listing_card.dart';
import 'home_room_chip.dart';
import 'home_tier_badge.dart';

class RecentListingCard extends StatelessWidget {
  const RecentListingCard({super.key, required this.card});

  final ListingCard card;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 100,
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
        child: Row(
          children: [
            // Thumbnail
            Container(
              width: 90,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [cs.primaryContainer, cs.secondaryContainer],
                ),
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(VeriRentRadius.lg),
                ),
              ),
              child: Center(
                child: Text(card.emoji, style: const TextStyle(fontSize: 32)),
              ),
            ),

            // Details
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
                            card.title,
                            style: VeriRentText.titleSmall.copyWith(
                              color: cs.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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
                    Row(
                      children: [
                        Text(
                          card.price,
                          style: VeriRentText.labelMedium.copyWith(
                            color: cs.primary,
                            fontWeight: FontWeight.w700,
                          ),
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
