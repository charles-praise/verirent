import 'package:flutter/material.dart';

import '../../../../../../core/theme/agents_theme.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({super.key, required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(VeriRentRadius.lg),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(children: children),
    );
  }
}
