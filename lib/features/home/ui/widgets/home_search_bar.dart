import 'package:flutter/material.dart';

import '../../../../core/theme/agents_theme.dart';

// ---------------------------------------------------------------------------
//  Search bar
// ---------------------------------------------------------------------------

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({
    super.key,
    required this.controller,
    required this.focusNode,
  });

  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            style: VeriRentText.bodyMedium.copyWith(color: cs.onSurface),
            onTapOutside: (value) {
              focusNode.unfocus();
            },
            decoration: InputDecoration(
              hintText: 'Search by location, type…',
              prefixIcon: Icon(
                Icons.search_rounded,
                color: cs.onSurfaceVariant,
                size: 20,
              ),
              suffixIcon: ValueListenableBuilder(
                valueListenable: controller,
                builder: (context, value, _) => value.text.isNotEmpty
                    ? GestureDetector(
                        onTap: controller.clear,
                        child: Icon(
                          Icons.close_rounded,
                          size: 18,
                          color: cs.onSurfaceVariant,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              filled: true,
              fillColor: cs.surface,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 14,
                horizontal: VeriRentSpacing.base,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(VeriRentRadius.md),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(VeriRentRadius.md),
                borderSide: BorderSide(color: cs.outlineVariant, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(VeriRentRadius.md),
                borderSide: BorderSide(color: cs.primary, width: 1.5),
              ),
            ),
          ),
        ),
        const SizedBox(width: VeriRentSpacing.sm),

        // Filter button
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: cs.primaryContainer,
            borderRadius: BorderRadius.circular(VeriRentRadius.md),
          ),
          child: Icon(Icons.tune_rounded, color: cs.primary, size: 20),
        ),
      ],
    );
  }
}
