import 'package:flutter/material.dart';

import '../../../../../core/models/property_model.dart';
import '../../../../../core/theme/agents_theme.dart';
import 'shared/listingThumb.dart';

// =============================================================================
//  ⑥ ACTIVE LISTINGS STRIP  (placeholder — connect to real BLoC in prod)
// =============================================================================

class ActiveListingsStrip extends StatelessWidget {
  const ActiveListingsStrip({
    super.key,
    required this.tierColor,
    required this.listing,
  });
  final Color tierColor;
  final PropertyModel listing;
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
                'Active Listings from ${listing.agency!.name ?? "Ag"}',
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
            height: 122,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, i) =>
                  ListingThumb(index: i, color: tierColor),
            ),
          ),
        ],
      ),
    );
  }
}
