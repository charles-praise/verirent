import 'package:flutter/material.dart';

import '../../../../../../core/theme/agents_theme.dart';

class InfoRow extends StatelessWidget {
  const InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isLast = false,
    this.accentColor,
  });
  final IconData icon;
  final String label;
  final String value;
  final bool isLast;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final color = accentColor ?? cs.primary;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(VeriRentRadius.sm),
                ),
                child: Icon(
                  icon,
                  size: 15,
                  color: cs.brightness == Brightness.dark
                      ? VeriRentColors.accent400
                      : color,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 3,
                child: Text(
                  label,
                  style: VeriRentText.bodyMedium.copyWith(color: cs.onSurface),
                ),
              ),
              Flexible(
                flex: 2,
                child: Text(
                  value,
                  style: VeriRentText.labelMedium.copyWith(
                    color: cs.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
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
