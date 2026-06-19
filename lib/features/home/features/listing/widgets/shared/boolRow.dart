import 'package:flutter/material.dart';

import '../../../../../../core/theme/agents_theme.dart';
import 'infoRow.dart';

class BoolRow extends StatelessWidget {
  const BoolRow({
    super.key,
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
    return InfoRow(
              icon: icon,
              label: label,
              value: '',
              isLast: isLast,
              accentColor: value ? okColor : cs.onSurfaceVariant,
            ).build ==
            null // force override trailing
        ? const SizedBox()
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: (value ? okColor : cs.onSurfaceVariant)
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(VeriRentRadius.sm),
                      ),
                      child: Icon(
                        icon,
                        size: 15,
                        color: value ? okColor : cs.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        label,
                        style: VeriRentText.bodyMedium.copyWith(
                          color: cs.onSurface,
                        ),
                      ),
                    ),
                    Icon(
                      value ? Icons.check_circle_rounded : Icons.cancel_rounded,
                      size: 18,
                      color: value ? okColor : cs.onSurfaceVariant,
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
