import 'package:flutter/material.dart';

import '../../../../../../core/models/property_model.dart';
import '../../../../../../core/theme/agents_theme.dart';

class PricingBlock extends StatelessWidget {
  const PricingBlock({super.key, required this.listing, required this.accent});
  final PropertyModel listing;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(VeriRentRadius.lg),
        border: Border.all(color: accent.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pricing & Terms',
            style: VeriRentText.titleSmall.copyWith(
              color: cs.brightness == Brightness.dark
                  ? cs.onSurfaceVariant
                  : cs.primary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '₦${listing.price}',
                  style: VeriRentText.headlineMedium.copyWith(
                    color: cs.brightness == Brightness.dark
                        ? cs.onSurfaceVariant
                        : cs.primary,
                  ),
                ),
              ),
              Flexible(
                child: Text(
                  listing.priceUnit!,
                  style: VeriRentText.labelMedium.copyWith(
                    color: cs.brightness == Brightness.dark
                        ? cs.onSurfaceVariant
                        : cs.primary,
                  ),
                ),
              ),
            ],
          ),
          if (listing.paymentTerms!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: cs.brightness == Brightness.dark
                    ? VeriRentColors.accent400
                    : VeriRentColors.goldDim,
                borderRadius: BorderRadius.circular(VeriRentRadius.sm),
              ),
              child: Text(
                listing.paymentTerms!,
                style: VeriRentText.bodySmall.copyWith(
                  color: VeriRentColors.primary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
