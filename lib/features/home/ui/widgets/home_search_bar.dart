import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verirent/core/api/data/mock_data.dart';
import 'package:verirent/features/search/ui/cubit/search_cubit.dart';
import 'package:verirent/features/search/ui/cubit/search_state.dart';

import '../../../../core/theme/agents_theme.dart';
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
  final String hintText;
  final FocusNode focusNode;

  @override
  State<HomeSearchBar> createState() => _HomeSearchBarState();
}

class _HomeSearchBarState extends State<HomeSearchBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _showSearchFilter() {
    FocusScope.of(context).unfocus();
    final SearchCubit searchCubit = context.read<SearchCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      showDragHandle: false,
      builder: (sheetContext) {
        // The bottom-sheet has its own context that does not inherit the
        // SearchCubit from HomeSearchBar, so we provide it explicitly.
        return FractionallySizedBox(
          heightFactor: 0.50,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(sheetContext).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: SingleChildScrollView(
              child: BlocBuilder<SearchCubit, SearchState>(
                bloc: searchCubit,
                builder: (ctx, state) => FiltersPanel(
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
                  onReset: searchCubit.resetFilters,
                  // Dismiss the sheet and collapse the cubit flag on Apply.
                  onApply: () {
                    searchCubit.toggleFilters();
                    Navigator.of(sheetContext).pop();

                    searchCubit.filterResult(kAllListings);
                    searchCubit.resetFilters();
                    // TODO: trigger searchCubit.runSearch() here when
                    // real search results are wired up.
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
      // If the user dismisses the sheet by dragging it down (without
      // pressing Apply), make sure the cubit flag is reset so tapping
      // the filter button again will reopen the sheet.
      if (searchCubit.state.filtersExpanded) {
        searchCubit.toggleFilters();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return BlocConsumer<SearchCubit, SearchState>(
      listenWhen: (previous, current) =>
          previous.filtersExpanded != current.filtersExpanded,
      listener: (context, state) {
        if (state.filtersExpanded) {
          _showSearchFilter();
        }
      },
      builder: (context, state) {
        return Row(
          children: [
            // ── Search field (read-only; navigates to SearchPage on tap) ──
            Expanded(
              child: SizedBox(
                height: 42,
                child: Container(
                  height: 42,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(VeriRentRadius.md),
                    border: Border.all(width: 0),
                  ),
                  child: TextField(
                    controller: widget.controller,
                    focusNode: widget.focusNode,
                    readOnly: false,
                    onSubmitted: (query) {
                      if (query.trim().isNotEmpty) {
                        context.read<SearchCubit>().saveSearch(query);
                      }
                    },
                    onTapOutside: (_) {},
                    onTap: () {},
                    onChanged: (value) {
                      final homeCubit = context.read<HomeCubit>();

                      context.read<SearchCubit>().searchProperties(
                        homeCubit.state.allProperties,
                        value,
                      );
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: cs.surface,
                      hintText: widget.hintText,
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
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: cs.onSurfaceVariant,
                      ),
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
            ),

            const SizedBox(width: VeriRentSpacing.sm),

            // ── Filter toggle button with active-filter badge ────────────
            Stack(
              clipBehavior: Clip.none,
              children: [
                BlocBuilder<SearchCubit, SearchState>(
                  builder: (context, state) {
                    return GestureDetector(
                      onTap: context.read<SearchCubit>().toggleFilters,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: state.filtersExpanded
                              ? cs.primaryContainer
                              : cs.surface,
                          borderRadius: BorderRadius.circular(
                            VeriRentRadius.sm,
                          ),
                          border: Border.all(
                            color: state.filtersExpanded
                                ? VeriRentColors.primary
                                : cs.outlineVariant,
                          ),
                        ),
                        child: state.query.isNotEmpty
                            ? GestureDetector(
                                onTap: () {
                                  widget.controller.clear();
                                  context.read<SearchCubit>().clearQuery();
                                },
                                child: Icon(
                                  Icons.close_rounded,
                                  size: 18,
                                  color: state.filtersExpanded
                                      ? VeriRentColors.primary
                                      : cs.onSurfaceVariant,
                                ),
                              )
                            : Icon(
                                Icons.tune_rounded,
                                size: 18,
                                color: state.filtersExpanded
                                    ? VeriRentColors.primary
                                    : cs.onSurfaceVariant,
                              ),
                      ),
                    );
                  },
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
                          style: VeriRentText.labelMedium.copyWith(
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
