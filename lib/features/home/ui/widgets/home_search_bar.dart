import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:verirent/features/search/ui/search.dart';

import '../../../../core/theme/agents_theme.dart';

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
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // void _showSearchFilter() {
  //   widget.focusNode.unfocus();
  //
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     showDragHandle: false,
  //     builder: (context) {
  //       return FractionallySizedBox(
  //         heightFactor: 0.50,
  //         child: Container(
  //           decoration: BoxDecoration(
  //             color: Theme.of(context).colorScheme.surface,
  //             borderRadius: const BorderRadius.vertical(
  //               top: Radius.circular(20),
  //             ),
  //           ),
  //           child: Column(
  //             children: [
  //               const SizedBox(height: 8),
  //               Padding(
  //                 padding: const EdgeInsets.symmetric(horizontal: 16),
  //                 child: Row(
  //                   children: [
  //                     Expanded(
  //                       child: Text(
  //                         'Filters',
  //                         style: VeriRentText.titleMedium.copyWith(
  //                           color: Theme.of(context).colorScheme.onSurface,
  //                         ),
  //                       ),
  //                     ),
  //                     IconButton(
  //                       onPressed: () => Navigator.pop(context),
  //                       icon: const Icon(Icons.close_rounded),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               const Divider(height: 1),
  //               Expanded(
  //                 child: DraggableScrollableSheet(
  //                   initialChildSize: 1.0,
  //                   minChildSize: 1.0,
  //                   maxChildSize: 1.0,
  //                   expand: true,
  //                   builder: (context, scrollController) {
  //                     return ListView.builder(
  //                       controller: scrollController,
  //                       itemCount: 5,
  //                       itemBuilder: (context, index) {
  //                         return const ListTile(
  //                           title: Text("Charles the Greatest !!!"),
  //                         );
  //                       },
  //                     );
  //                   },
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: TextField(
            readOnly: true,
            showCursor: false,
            canRequestFocus: false,
            style: VeriRentText.bodyMedium.copyWith(color: cs.onSurface),
            onTapOutside: (_) => widget.focusNode.unfocus(),
            onTap: () {
              context.push("/search");
            },
            decoration: InputDecoration(
              hintText: 'Search by location, type…',
              prefixIcon: Icon(
                Icons.search_rounded,
                color: cs.onSurfaceVariant,
                size: 20,
              ),
              suffixIcon: ValueListenableBuilder<TextEditingValue>(
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
        GestureDetector(
          onTap: () {
            widget.focusNode.unfocus();
            SearchPage(
              showSearchFilter: () {
                context.push("/search");
                setState(() => filtersExpanded = !filtersExpanded);
              },
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
}
