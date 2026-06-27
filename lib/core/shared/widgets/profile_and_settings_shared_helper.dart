// =============================================================================
//  SHARED HELPERS
// =============================================================================

import 'package:flutter/material.dart';

import '../../theme/agents_theme.dart';

/// Standard app-bar for settings sub-pages.
class SubPageAppBar extends StatelessWidget {
  const SubPageAppBar({super.key, required this.title, this.actions});
  final String title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final topPad = MediaQuery.of(context).padding.top;
    return Container(
      color: cs.surface,
      padding: EdgeInsets.fromLTRB(4, topPad + 4, 8, 4),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded, size: 20),
            onPressed: () => Navigator.maybePop(context),
          ),
          Expanded(
            child: Text(
              title,
              style: VeriRentText.titleLarge.copyWith(color: cs.onSurface),
            ),
          ),
          if (actions != null) ...actions!,
        ],
      ),
    );
  }
}

/// Grouped card container consistent with SettingsPage.
class Group extends StatelessWidget {
  const Group({super.key, required this.children, this.margin});
  final List<Widget> children;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: margin ?? const EdgeInsets.fromLTRB(16, 0, 16, 0),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(VeriRentRadius.lg),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        children: List.generate(children.length, (i) {
          final isLast = i == children.length - 1;
          return Column(
            children: [
              children[i],
              if (!isLast)
                Divider(height: 1, color: cs.outlineVariant, indent: 54),
            ],
          );
        }),
      ),
    );
  }
}

/// Section label, same as SettingsPage's _SectionHeader.
class SectionLabel extends StatelessWidget {
  const SectionLabel(this.label, {super.key});
  final String label;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 20, 16, 6),
    child: Text(
      label.toUpperCase(),
      style: VeriRentText.labelSmall.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        letterSpacing: 1.0,
        fontSize: 11,
      ),
    ),
  );
}

/// Coloured icon container.
Widget profileIconBox(IconData icon, Color color) => Container(
  width: 34,
  height: 34,
  decoration: BoxDecoration(
    color: color.withOpacity(0.10),
    borderRadius: BorderRadius.circular(VeriRentRadius.sm),
  ),
  child: Icon(icon, size: 17, color: color),
);
