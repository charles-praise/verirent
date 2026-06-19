import 'package:flutter/material.dart';

import '../../../../../../core/theme/agents_theme.dart';
import '../../../../domain/entities/property_model.dart';

class DescriptionBlock extends StatelessWidget {
  const DescriptionBlock({super.key, required this.listing});
  final PropertyModel listing;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(VeriRentRadius.lg),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About This Property',
            style: VeriRentText.titleMedium.copyWith(color: cs.onSurface),
          ),
          const SizedBox(height: 10),
          Text(
            listing.description!,
            style: VeriRentText.bodyMedium.copyWith(
              color: cs.onSurfaceVariant,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
