import 'package:flutter/material.dart';

import '../../../../core/theme/agents_theme.dart';
import '../../data/local_repo.dart';
import '../../ui/widgets/home_recent_listing.dart';

// ── Recently Added Use Case ─────────────────────────────────────────────────────────────────
class RecentListingUseCase extends StatelessWidget {
  const RecentListingUseCase({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(
            VeriRentSpacing.base,
            0,
            VeriRentSpacing.base,
            VeriRentSpacing.sm,
          ),
          child: RecentCardFactory.build(context, recentProperties[index]),
        );
      }, childCount: 2),
    );
  }
}
