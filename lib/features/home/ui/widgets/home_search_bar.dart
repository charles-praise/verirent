// home_search_bar.dart
//
// Fix summary:
//   • Sheet open/close is owned by local _sheetOpen bool — never by cubit.
//   • onApply calls searchCubit.applyFilters(kAllListings) — the new clean
//     method that re-runs the pipeline without touching query or resetting
//     anything.
//   • Removed the old filterResult() + resetFilters() calls from onApply
//     which were wiping the filter values immediately after applying them.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/api/data/mock_data.dart';
import '../../../../core/theme/agents_theme.dart';
import '../../../search/ui/cubit/search_cubit.dart';
import '../../../search/ui/cubit/search_state.dart';
import '../../../search/ui/widget/filter_panel.dart';
import '../../../search/utils/formatPrice.dart';
import '../cubit/home_cubit.dart';

class HomeSearchBar extends StatefulWidget {
  const HomeSearchBar({
    super.key,
    required this.controller,
    required this.focusNode,
    this.hintText = 'Search by location, type…',
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;

  @override
  State<HomeSearchBar> createState() => _HomeSearchBarState();
}

class _HomeSearchBarState extends State<HomeSearchBar> {
  bool _sheetOpen = false;

  void _openSheet() {
    if (_sheetOpen) return;
    setState(() => _sheetOpen = true);
    FocusScope.of(context).unfocus();

    final searchCubit = context.read<SearchCubit>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      showDragHandle: false,
      builder: (sheetCtx) {
        return FractionallySizedBox(
          heightFactor: 0.52,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(sheetCtx).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: SingleChildScrollView(
              child: BlocBuilder<SearchCubit, SearchState>(
                bloc: searchCubit,
                builder: (_, state) => FiltersPanel(
                  priceRange: state.priceRange,
                  selectedType: state.selectedType,
                  minBeds: state.minBeds,
                  minBaths: state.minBaths,
                  verifiedOnly: state.verifiedOnly,
                  propertyTypes: state.propertyTypes,
                  onPriceChanged: searchCubit.updatePrice,
                  onTypeChanged: searchCubit.updateType,
                  onBedsChanged: searchCubit.updateBeds,
                  onBathsChanged: searchCubit.updateBaths,
                  onVerifiedChanged: searchCubit.updateVerified,
                  onReset: () {
                    searchCubit.resetFilters();
                    // After reset, re-run against full list so Home
                    // immediately reflects the cleared state.
                    searchCubit.applyFilters(kAllListings);
                  },
                  onApply: () {
                    // ✓ Apply current filter values against the full list.
                    // Does NOT reset anything. Does NOT touch the query.
                    searchCubit.applyFilters(kAllListings);
                    Navigator.of(sheetCtx).pop();
                  },
                  formatPrice: formatPrice,
                  showFilterOnHomePage: true,
                ),
              ),
            ),
          ),
        );
      },
    ).whenComplete(() {
      if (mounted) setState(() => _sheetOpen = false);
    });
  }

  void _toggleSheet() {
    if (_sheetOpen) {
      Navigator.of(context).pop();
    } else {
      _openSheet();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        return Row(
          children: [
            // ── Search field ─────────────────────────────────────────────
            Expanded(
              child: SizedBox(
                height: 42,
                child: TextField(
                  controller: widget.controller,
                  focusNode: widget.focusNode,
                  onChanged: (value) {
                    context.read<SearchCubit>().searchProperties(
                      context.read<HomeCubit>().state.allProperties,
                      value,
                    );
                  },
                  onSubmitted: (query) {
                    if (query.trim().isNotEmpty) {
                      context.read<SearchCubit>().saveSearch(query);
                    }
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: cs.surface,
                    hintText: widget.hintText,
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: cs.onSurfaceVariant,
                      size: 20,
                    ),
                    suffixIcon: state.query.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              widget.controller.clear();
                              context.read<SearchCubit>().clearQuery();
                            },
                            child: Icon(
                              Icons.close_rounded,
                              size: 18,
                              color: cs.onSurfaceVariant,
                            ),
                          )
                        : null,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(VeriRentRadius.md),
                      borderSide: BorderSide(color: cs.outlineVariant),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(VeriRentRadius.md),
                      borderSide: BorderSide(color: cs.outlineVariant),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(VeriRentRadius.md),
                      borderSide: BorderSide(color: cs.primary, width: 1.5),
                    ),
                  ),
                  style: VeriRentText.bodyMedium.copyWith(color: cs.onSurface),
                ),
              ),
            ),

            const SizedBox(width: VeriRentSpacing.sm),

            // ── Filter button ────────────────────────────────────────────
            Stack(
              clipBehavior: Clip.none,
              children: [
                GestureDetector(
                  onTap: _toggleSheet,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: _sheetOpen ? cs.primaryContainer : cs.surface,
                      borderRadius: BorderRadius.circular(VeriRentRadius.sm),
                      border: Border.all(
                        color: _sheetOpen ? cs.primary : cs.outlineVariant,
                      ),
                    ),
                    child: Icon(
                      Icons.tune_rounded,
                      size: 18,
                      color: _sheetOpen ? cs.primary : cs.onSurfaceVariant,
                    ),
                  ),
                ),
                if (state.activeFilterCount > 0)
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: VeriRentColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${state.activeFilterCount}',
                          style: VeriRentText.labelSmall.copyWith(
                            color: Colors.white,
                            fontSize: 9,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}
