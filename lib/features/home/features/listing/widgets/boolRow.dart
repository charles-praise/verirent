import 'package:flutter/material.dart';

import '../../../../../core/theme/agents_theme.dart';

class BoolRowSimple extends StatelessWidget {
  const BoolRowSimple({
    required this.icon,
    required this.label,
    required this.value,
    this.isLast = false,
    this.trueColor,
  });
  final IconData icon;
  final String label;
  final bool value;
  final bool isLast;
  final Color? trueColor;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final okColor = trueColor ?? VeriRentColors.success500;
    final activeColor = value
        ? cs.brightness == Brightness.dark
              ? VeriRentColors.accent400
              : okColor
        : cs.onSurfaceVariant;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: activeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(VeriRentRadius.sm),
                ),
                child: Icon(icon, size: 15, color: activeColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: VeriRentText.bodyMedium.copyWith(color: cs.onSurface),
                ),
              ),
              Icon(
                value ? Icons.check_circle_rounded : Icons.cancel_rounded,
                size: 18,
                color: value ? okColor : cs.outlineVariant,
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            color: cs.outlineVariant,
            indent: 58,
            endIndent: 14,
          ),
      ],
    );
  }
}
