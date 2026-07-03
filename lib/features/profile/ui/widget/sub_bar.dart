// =============================================================================
//  SHARED CHROME
// =============================================================================
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/agents_theme.dart';

class SubBar extends StatelessWidget implements PreferredSizeWidget {
  const SubBar({super.key, required this.title, this.actions});
  final String title;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return AppBar(
      backgroundColor: cs.surface,
      foregroundColor: cs.onSurface,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded, size: 20),
        onPressed: () => Navigator.maybePop(context),
      ),
      title: Text(
        title,
        style: VeriRentText.titleLarge.copyWith(color: cs.onSurface),
      ),
      actions: actions,
      systemOverlayStyle: cs.brightness == Brightness.light
          ? SystemUiOverlayStyle.dark
          : SystemUiOverlayStyle.light,
    );
  }
}

Widget sectionLabel(BuildContext context, String label) => Padding(
  padding: const EdgeInsets.fromLTRB(0, 20, 0, 8),
  child: Text(
    label.toUpperCase(),
    style: VeriRentText.labelSmall.copyWith(
      color: Theme.of(context).colorScheme.onSurfaceVariant,
      letterSpacing: 1.1,
      fontSize: 10,
    ),
  ),
);

Widget fieldLabel(BuildContext context, String label, {bool required = false}) {
  final cs = Theme.of(context).colorScheme;
  return Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(
      children: [
        Text(
          label,
          style: VeriRentText.labelMedium.copyWith(color: cs.onSurface),
        ),
        if (required)
          Text(
            ' *',
            style: VeriRentText.labelMedium.copyWith(color: VeriRentColors.red),
          ),
      ],
    ),
  );
}
