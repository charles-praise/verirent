import 'package:flutter/material.dart';

import '../../../../core/theme/agents_theme.dart';

// =============================================================================
//  Sticky Search + Filter Delegate
// =============================================================================
class SearchFilter extends StatelessWidget {
  const SearchFilter({
    super.key,

    required this.filters,
    required this.filterIcons,
    required this.activeIndex,
    required this.onFilterTap,
  });

  final List<String> filters;
  final List<IconData> filterIcons;
  final int activeIndex;
  final ValueChanged<int> onFilterTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      children: [
        // ── Filter chips ─────────────────────────────────────────
        Container(
          padding: EdgeInsets.fromLTRB(
            0,
            VeriRentSpacing.sm,
            0,
            VeriRentSpacing.sm,
          ),
          color: cs.brightness == Brightness.light
              ? VeriRentColors.neutral50
              : VeriRentColors.neutral900,
          child: SizedBox(
            height: 46,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(
                VeriRentSpacing.base,
                4,
                VeriRentSpacing.base,
                8,
              ),
              itemCount: filters.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (ctx, i) {
                final active = i == activeIndex;
                return GestureDetector(
                  onTap: () => onFilterTap(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: active
                          ? VeriRentColors.primaryDim
                          : cs.brightness == Brightness.light
                          ? VeriRentColors.white
                          : VeriRentColors.surface2,
                      border: Border.all(
                        color: active
                            ? VeriRentColors.primary
                            : VeriRentColors.border,
                      ),
                      borderRadius: BorderRadius.circular(VeriRentRadius.full),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          filterIcons[i],
                          size: VeriRentSpacing.md,
                          color: active
                              ? VeriRentColors.primary
                              : VeriRentColors.textMuted,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          filters[i],
                          style: TextStyle(
                            fontSize: VeriRentSpacing.md,
                            fontWeight: active
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: active
                                ? VeriRentColors.primary
                                : VeriRentColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
