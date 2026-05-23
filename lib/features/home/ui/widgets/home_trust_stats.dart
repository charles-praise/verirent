import 'package:flutter/material.dart';

import '../../../../core/theme/agents_theme.dart';
// ---------------------------------------------------------------------------
//  Trust stats strip
// ---------------------------------------------------------------------------

class TrustStatsStrip extends StatelessWidget {
  const TrustStatsStrip({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.fromLTRB(
        VeriRentSpacing.base,
        0,
        VeriRentSpacing.base,
        VeriRentSpacing.base,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: VeriRentSpacing.base,
        vertical: VeriRentSpacing.md,
      ),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(VeriRentRadius.lg),
        border: Border.all(color: cs.outlineVariant, width: 1),
      ),
      child: Row(
        children: [
          _StatItem(label: 'Agencies', value: '800+'),
          _StatDivider(),
          _StatItem(label: 'Verified Listings', value: '2,400'),
          _StatDivider(),
          _StatItem(label: 'Tenants Protected', value: '12K+'),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: VeriRentText.headlineSmall.copyWith(
              color: cs.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            label,
            style: VeriRentText.bodySmall.copyWith(color: cs.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: 1,
      height: 36,
      color: cs.outlineVariant,
      margin: const EdgeInsets.symmetric(horizontal: VeriRentSpacing.xs),
    );
  }
}
