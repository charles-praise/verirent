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
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../features/home/ui/cubit/home_cubit.dart';
import '../../../features/search/ui/cubit/search_cubit.dart';
import '../../../features/search/ui/cubit/search_state.dart';
import '../../../features/search/ui/widget/filter_panel.dart';
import '../../../features/search/utils/kFormatPrice.dart';
import '../../api/data/mock_data.dart';
import '../../theme/agents_theme.dart';
import '../../util/filterOrUploadProperty.dart';

class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({
    super.key,
    required this.controller,
    required this.focusNode,
    this.hintText = 'Search by location, type…',
    this.showFilter = true,
    this.cubit,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final bool showFilter;
  final Cubit? cubit;

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
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
                  formatPrice: kFormatPrice,
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

    return BlocProvider.value(
      value: GetIt.I<SearchCubit>(),
      child: BlocBuilder<SearchCubit, SearchState>(
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
                      GetIt.I<SearchCubit>().searchProperties(
                        context.read<HomeCubit>().state.allProperties,
                        value,
                      );
                    },
                    onSubmitted: (query) {
                      if (query.trim().isNotEmpty) {
                        GetIt.I<SearchCubit>().saveSearch(query);
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
                                GetIt.I<SearchCubit>().clearQuery();
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
                    style: VeriRentText.bodyMedium.copyWith(
                      color: cs.onSurface,
                    ),
                  ),
                ),
              ),
              if (widget.showFilter) const SizedBox(width: VeriRentSpacing.sm),

              // ── Filter button ────────────────────────────────────────────
              if (widget.showFilter)
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showCreateListingBottomSheet(
                          context,
                          onOpenFilter: () {
                            _toggleSheet();
                          },
                          onUploadProperty: () {
                            context.push("auth/upload_property");
                          },
                        );
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: _sheetOpen ? cs.primaryContainer : cs.surface,
                          borderRadius: BorderRadius.circular(
                            VeriRentRadius.sm,
                          ),
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
      ),
    );
  }
}
