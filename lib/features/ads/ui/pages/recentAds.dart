// ── Agency Banner ─────────────────────────────────────────────────────────
import 'package:flutter/material.dart';

import '../../../../core/theme/agents_theme.dart';

Widget buildAgencyBanner({required BuildContext context}) => Padding(
  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
  child: Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      border: Border.all(
        color: Theme.of(context).colorScheme.brightness == Brightness.light
            ? VeriRentColors.primary.withOpacity(0.35)
            : Theme.of(context).colorScheme.outlineVariant,
      ),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Theme.of(context).colorScheme.shadow.withOpacity(0.06),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: VeriRentColors.goldDim,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.verified_rounded,
            color: VeriRentColors.gold,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Are you an agency?', style: VeriRentText.labelMedium),
              Text(
                'Get ESVARBON-certified & join the platform',
                style: VeriRentText.labelMedium,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: VeriRentColors.gold,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              'Apply',
              style: VeriRentText.labelMedium.copyWith(
                color:
                    Theme.of(context).colorScheme.brightness == Brightness.light
                    ? VeriRentColors.white
                    : VeriRentColors.black,
              ),
            ),
          ),
        ),
      ],
    ),
  ),
);
