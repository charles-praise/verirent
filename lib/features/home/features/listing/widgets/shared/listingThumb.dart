import 'package:flutter/material.dart';

import '../../../../../../core/theme/agents_theme.dart';

class ListingThumb extends StatelessWidget {
  const ListingThumb({super.key, required this.index, required this.color});
  final int index;
  final Color color;

  static const _titles = [
    '3 Bed Flat, GRA Phase 2',
    'Executive Duplex, Trans-Amadi',
    'Office Space, D-Line',
    'Studio Apt, Rumuola',
    'Land 648m², Rumuigbo',
  ];
  static const _prices = [
    '₦1.8M/yr',
    '₦4.5M/yr',
    '₦2.2M/yr',
    '₦550k/yr',
    '₦18.5M',
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      width: 168,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(VeriRentRadius.lg),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 56,
              decoration: BoxDecoration(
                color: color.withOpacity(0.08),
                borderRadius: BorderRadius.circular(VeriRentRadius.md),
                border: Border.all(color: color.withOpacity(0.2)),
              ),
              child: Center(
                child: Icon(Icons.home_rounded, color: color, size: 22),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _titles[index % _titles.length],
              style: VeriRentText.titleSmall.copyWith(color: cs.onSurface),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              _prices[index % _prices.length],
              style: VeriRentText.labelMedium.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
