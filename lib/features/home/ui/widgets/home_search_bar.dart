import 'package:flutter/material.dart';

import '../../../../core/theme/agents_theme.dart';

// ---------------------------------------------------------------------------
//  Search bar
// ---------------------------------------------------------------------------

class HomeSearchBar extends StatefulWidget {
  const HomeSearchBar({
    super.key,
    required this.controller,
    required this.focusNode,
  });

  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  State<HomeSearchBar> createState() => _HomeSearchBarState();
}

class _HomeSearchBarState extends State<HomeSearchBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            style: VeriRentText.bodyMedium.copyWith(color: cs.onSurface),
            onTapOutside: (value) {
              widget.focusNode.unfocus();
            },
            decoration: InputDecoration(
              hintText: 'Search by location, type…',
              prefixIcon: Icon(
                Icons.search_rounded,
                color: cs.onSurfaceVariant,
                size: 20,
              ),
              suffixIcon: ValueListenableBuilder(
                valueListenable: widget.controller,
                builder: (context, value, _) => value.text.isNotEmpty
                    ? GestureDetector(
                        onTap: widget.controller.clear,
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
        GestureDetector(
          onTap: () {
            Scaffold.of(context).showBottomSheet(
              (context) => _buildSearchFilter(context),
              sheetAnimationStyle: AnimationStyle(
                duration: Duration(milliseconds: 400),
                reverseDuration: const Duration(milliseconds: 300),
              ),
            );
          },
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: cs.primaryContainer,
              borderRadius: BorderRadius.circular(VeriRentRadius.md),
            ),
            child: Icon(Icons.tune_rounded, color: cs.primary, size: 20),
          ),
        ),
      ],
    );
  }

  dynamic _buildSearchFilter(BuildContext context) {
    DraggableScrollableSheet(
      builder: (BuildContext context, ScrollController scrollController) {
        return AnimatedBuilder(
          animation: scrollController,
          builder: (BuildContext context, Widget? child) {
            return Container(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return ListTile(
                    title: const Text("Charles the Greatest !!!"),
                  );
                },
                itemCount: 25,
              ),
            );
          },
        );
      },
    );
    // _controller.forward();
  }
}
