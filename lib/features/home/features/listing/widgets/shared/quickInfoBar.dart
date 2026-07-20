import 'package:flutter/material.dart';

import '../../../../../../core/models/property/property_model.dart';
import '../../../../../../core/theme/agents_theme.dart';

class QuickInfoBar extends StatelessWidget {
  const QuickInfoBar({
    super.key,
    required this.listing,
    required this.accentColor,
  });
  final PropertyModel listing;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      color: cs.surface,
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '₦ ${listing.price}',
                  style: VeriRentText.headlineMedium.copyWith(
                    color: cs.brightness == Brightness.dark
                        ? cs.onSurfaceVariant
                        : cs.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  listing.priceUnit!,
                  style: VeriRentText.bodySmall.copyWith(
                    color: cs.brightness == Brightness.dark
                        ? cs.onSurfaceVariant
                        : cs.primary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color:
                  (listing.isVerified!
                          ? VeriRentColors.success500
                          : VeriRentColors.warning500)
                      .withOpacity(0.12),
              borderRadius: BorderRadius.circular(VeriRentRadius.md),
              border: Border.all(
                color:
                    (listing.isVerified!
                            ? VeriRentColors.success500
                            : VeriRentColors.warning500)
                        .withOpacity(0.4),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  listing.isVerified!
                      ? Icons.verified_rounded
                      : Icons.warning_amber_rounded,
                  size: 14,
                  color: listing.isVerified!
                      ? VeriRentColors.success500
                      : VeriRentColors.warning500,
                ),
                const SizedBox(width: 4),
                Text(
                  listing.isVerified! ? 'Verified' : 'Pending',
                  style: VeriRentText.labelSmall.copyWith(
                    color: listing.isVerified!
                        ? VeriRentColors.success500
                        : VeriRentColors.warning500,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
