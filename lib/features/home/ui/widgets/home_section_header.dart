import 'package:flutter/material.dart';

import '../../../../core/theme/agents_theme.dart';

// ---------------------------------------------------------------------------
//  Section header
// ---------------------------------------------------------------------------

class SectionHeader extends StatelessWidget {
  const SectionHeader({required this.title, this.onSeeAll});

  final String title;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        VeriRentSpacing.base,
        VeriRentSpacing.base,
        VeriRentSpacing.sm,
        VeriRentSpacing.sm,
      ),
      child: Row(
        children: [
          Text(
            title,
            style: VeriRentText.headlineSmall.copyWith(color: cs.onSurface),
          ),
          const Spacer(),
          if (onSeeAll != null)
            TextButton(
              onPressed: onSeeAll,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: VeriRentSpacing.sm,
                ),
                minimumSize: const Size(0, 32),
              ),
              child: Text(
                'See all',
                style: VeriRentText.labelMedium.copyWith(color: cs.primary),
              ),
            ),
        ],
      ),
    );
  }
}
