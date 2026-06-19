import 'package:flutter/material.dart';

import '../../../../../../core/theme/agents_theme.dart';
import '../../domain/entities/statItems.dart';

class HeroStatsBar extends StatelessWidget {
  const HeroStatsBar({super.key, required this.stats, this.accentColor});
  final List<StatItem> stats;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final color = accentColor ?? cs.primary;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(VeriRentRadius.lg),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        children: List.generate(stats.length, (i) {
          final isLast = i == stats.length - 1;
          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Column(
                      children: [
                        Icon(
                          stats[i].icon,
                          size: 20,
                          color: cs.brightness == Brightness.dark
                              ? VeriRentColors.accent400
                              : VeriRentColors.primary,
                        ),
                        const SizedBox(height: 4),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            stats[i].value,
                            style: VeriRentText.titleSmall.copyWith(
                              color: cs.onSurface,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            stats[i].label,
                            style: VeriRentText.bodySmall.copyWith(
                              color: cs.onSurfaceVariant,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (!isLast)
                  Container(width: 1, height: 48, color: cs.outlineVariant),
              ],
            ),
          );
        }),
      ),
    );
  }
}
