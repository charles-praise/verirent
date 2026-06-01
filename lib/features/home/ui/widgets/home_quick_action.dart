import 'package:flutter/material.dart';

import '../../../../core/theme/agents_theme.dart';
import '../../data/local_repo.dart';
import '../../domain/entities/home_quick_action.dart';

// ---------------------------------------------------------------------------
//  Quick actions grid
// ---------------------------------------------------------------------------

class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        VeriRentSpacing.base,
        0,
        VeriRentSpacing.base,
        VeriRentSpacing.sm,
      ),
      child: GridView.count(
        crossAxisCount: 4,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: VeriRentSpacing.sm,
        mainAxisSpacing: VeriRentSpacing.sm,
        childAspectRatio: 0.85,
        children: kActions.map((a) => _QuickActionTile(action: a)).toList(),
      ),
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({required this.action});

  final QuickAction action;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: action.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(VeriRentRadius.md),
              border: Border.all(
                color: action.color.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Icon(action.icon.icon, size: 22, color: action.color),
          ),
          const SizedBox(height: 6),
          Text(
            action.label,
            style: VeriRentText.labelSmall.copyWith(
              color: cs.onSurfaceVariant,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}
