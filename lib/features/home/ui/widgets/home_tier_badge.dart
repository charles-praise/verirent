import 'package:flutter/material.dart';

import '../../../../core/theme/agents_theme.dart';

class TierBadge extends StatelessWidget {
  const TierBadge({super.key, required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(VeriRentRadius.full),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Text(
        label,
        style: VeriRentText.labelSmall.copyWith(color: color, fontSize: 9),
      ),
    );
  }
}
