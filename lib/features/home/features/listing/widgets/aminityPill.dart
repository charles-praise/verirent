import 'package:flutter/material.dart';

import '../../../../../core/theme/agents_theme.dart';

class AmenityPill extends StatelessWidget {
  const AmenityPill({super.key, required this.label, this.accentColor});
  final String label;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: cs.surfaceVariant,
        borderRadius: BorderRadius.circular(VeriRentRadius.full),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle_rounded,
            size: 12,
            color: accentColor ?? VeriRentColors.success500,
          ),
          const SizedBox(width: 4),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 100),
            child: Text(
              label,
              maxLines: 2,
              style: VeriRentText.bodySmall.copyWith(color: cs.onSurface),
            ),
          ),
        ],
      ),
    );
  }
}
