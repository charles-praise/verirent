import 'package:flutter/material.dart';

import '../../../../core/shared/widgets/cylinder_listing_widget.dart';
import '../../../../core/theme/agents_theme.dart';
import '../../data/local_repo.dart';

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
          child: RecentCardFactory.build(
            context,
            HomeLocalRepo().recentProperties[index],
          ),
        );
      }, childCount: 4),
    );
  }
}
