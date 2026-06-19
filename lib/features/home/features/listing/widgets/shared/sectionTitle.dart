import 'package:flutter/material.dart';

import '../../../../../../core/theme/agents_theme.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
    child: Text(
      text,
      style: VeriRentText.titleMedium.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
      ),
    ),
  );
}
