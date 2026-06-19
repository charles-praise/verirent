import 'package:flutter/material.dart';

import '../../../../../../core/theme/agents_theme.dart';
import '../../../../domain/entities/property_model.dart';

class TitleBlock extends StatelessWidget {
  const TitleBlock({super.key, required this.listing});
  final PropertyModel listing;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      color: cs.surface,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            listing.title ?? "",
            overflow: TextOverflow.ellipsis,
            style: VeriRentText.headlineSmall.copyWith(
              color: cs.brightness == Brightness.dark
                  ? cs.onSurfaceVariant
                  : cs.primary,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.location_on_rounded,
                size: 14,
                color: cs.brightness == Brightness.dark
                    ? VeriRentColors.accent400
                    : VeriRentColors.primary,
              ),
              const SizedBox(width: 3),
              Expanded(
                child: Text(
                  '${listing.address}, ${listing.area}, ${listing.lga}',
                  style: VeriRentText.bodySmall.copyWith(
                    color: cs.brightness == Brightness.dark
                        ? cs.onSurfaceVariant
                        : cs.primary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
