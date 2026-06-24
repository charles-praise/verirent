import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:verirent/core/shared/widgets/card_listing_widget.dart';
import 'package:verirent/features/home/features/view/ui/cubit/see_all_cubit.dart';

import '../../../../../../core/models/property_model.dart';
import '../../../../../../core/theme/agents_theme.dart';
import '../../../../../../core/util/sentenceCase.dart';
import '../../../../../search/ui/cubit/search_cubit.dart';

class SeeAllPage extends StatefulWidget {
  final List<PropertyModel> properties;
  final String title;
  const SeeAllPage({super.key, required this.properties, required this.title});

  @override
  State<SeeAllPage> createState() => _SeeAllPageState();
}

class _SeeAllPageState extends State<SeeAllPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_search);
  }

  void _search() {
    GetIt.I<SearchCubit>().searchProperties(
      widget.properties,
      _searchController.text,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _categoryFinder(String category) {
    debugPrint(category);
    return category.toSentenceCase();
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    return Scaffold(
      key: ValueKey("See All"),
      body: BlocBuilder<SeeAllCubit, SeeAllState>(
        builder: (context, seeAllState) {
          return CustomScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            slivers: [
              // sticky search header
              SliverPersistentHeader(
                pinned: true,
                delegate: _SearchHeader(
                  topPadding: topPad,
                  searchCtrl: _searchController,
                  focusNode: _focusNode,
                  state: seeAllState,
                  onChanged: (value) => GetIt.I<SearchCubit>().searchProperties(
                    widget.properties,
                    value,
                  ),
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      GetIt.I<SearchCubit>().saveSearch(value);
                    }
                  },
                  onClear: () {
                    _searchController.clear();
                    context.read<SeeAllCubit>().clearQuery();
                  },
                  onToggleFilters: () {},
                ),
              ),
              SliverAppBar(
                pinned: true,
                automaticallyImplyLeading: false,
                automaticallyImplyActions: false,
                title: _SearchFilter(
                  filters: seeAllState.filters,
                  filterIcons: seeAllState.filterIcons,
                  activeIndex: seeAllState.activeIndex,
                  onFilterTap: (index) {
                    context.read<SeeAllCubit>().activeIndex(index);
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    VeriRentSpacing.base,
                    VeriRentSpacing.sm,
                    VeriRentSpacing.sm,
                    VeriRentSpacing.sm,
                  ),
                  child: Text(
                    widget.title.toSentenceCase(),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ),
              // initial state
              if (seeAllState.seeAllStage == SeeAllStage.initial)
                _PropertyGrid(properties: widget.properties),
              // loading state
              if (seeAllState.seeAllStage == SeeAllStage.loading)
                SliverToBoxAdapter(child: CircularProgressIndicator.adaptive()),
              if (seeAllState.seeAllStage == SeeAllStage.loaded)
                if (seeAllState.filteredProperties.isEmpty) _EmptyView(),
              _PropertyGrid(properties: seeAllState.filteredProperties),
            ],
          );
        },
      ),
    );
  }
}

class _SearchFilter extends StatelessWidget {
  const _SearchFilter({
    super.key,
    required this.filters,
    required this.filterIcons,
    required this.activeIndex,
    required this.onFilterTap,
  });

  final List<String> filters;
  final List<IconData> filterIcons;
  final int activeIndex;
  final ValueChanged<int> onFilterTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      children: [
        // ── Filter chips ─────────────────────────────────────────
        Container(
          padding: EdgeInsets.fromLTRB(0, VeriRentSpacing.sm, 0, 0),
          color: cs.brightness == Brightness.light
              ? VeriRentColors.neutral50
              : VeriRentColors.neutral900,
          child: SizedBox(
            height: 46,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(
                VeriRentSpacing.base,
                4,
                VeriRentSpacing.base,
                8,
              ),
              itemCount: filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (ctx, i) {
                final active = i == activeIndex;
                return GestureDetector(
                  onTap: () => onFilterTap(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: active
                          ? VeriRentColors.accent400
                          : cs.brightness == Brightness.light
                          ? VeriRentColors.white
                          : VeriRentColors.surface2,
                      border: Border.all(color: VeriRentColors.transparent),
                      borderRadius: BorderRadius.circular(VeriRentRadius.full),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          filterIcons[i],
                          size: VeriRentSpacing.md,
                          color: active
                              ? VeriRentColors.primary
                              : VeriRentColors.textMuted,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          filters[i],
                          style: TextStyle(
                            fontSize: VeriRentSpacing.md,
                            fontWeight: active
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: active
                                ? VeriRentColors.primary
                                : VeriRentColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _SearchHeader extends SliverPersistentHeaderDelegate {
  _SearchHeader({
    required this.topPadding,
    required this.searchCtrl,
    required this.focusNode,
    required this.state,
    required this.onChanged,
    required this.onSubmitted,
    required this.onClear,
    required this.onToggleFilters,
    this.hintText,
  });

  final String? hintText;
  final double topPadding;
  final TextEditingController searchCtrl;
  final FocusNode focusNode;
  final SeeAllState state;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClear;
  final VoidCallback onToggleFilters;

  // header = topPad + 12 (top pad) + 38 (field height) + 12 (bottom pad) = topPad + 62
  double get _h => topPadding + 62;

  @override
  double get maxExtent => _h;
  @override
  double get minExtent => _h;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      height: _h,
      child: Container(
        color: VeriRentColors.primary,
        padding: EdgeInsets.fromLTRB(14, topPadding + 12, 14, 12),
        child: Row(
          children: [
            // Back
            GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: cs.surfaceVariant,
                  borderRadius: BorderRadius.circular(VeriRentRadius.sm),
                  border: Border.all(color: cs.outlineVariant),
                ),
                child: Icon(
                  Icons.arrow_back_rounded,
                  size: 18,
                  color: cs.onSurface,
                ),
              ),
            ),

            const SizedBox(width: 8),

            // Search field
            Expanded(
              child: SizedBox(
                height: 38,
                child: TextField(
                  key: ValueKey("see all searchbar"),
                  controller: searchCtrl,
                  focusNode: focusNode,
                  onChanged: onChanged,
                  onSubmitted: onSubmitted,
                  style: VeriRentText.bodyMedium.copyWith(color: cs.onSurface),
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: hintText ?? 'Location, type, area...',
                    hintStyle: VeriRentText.bodyMedium.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      size: 18,
                      color: cs.primary,
                    ),
                    suffixIcon: state.query.isNotEmpty
                        ? GestureDetector(
                            onTap: onClear,
                            child: Icon(
                              Icons.close_rounded,
                              size: 16,
                              color: cs.onSurfaceVariant,
                            ),
                          )
                        : null,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 0,
                    ),
                    isDense: true,
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
                    filled: true,
                    fillColor: cs.surfaceVariant,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(_SearchHeader old) =>
      old.topPadding != topPadding || old.state != state;
}

class _PropertyGrid extends StatelessWidget {
  const _PropertyGrid({required this.properties});

  final List<PropertyModel> properties;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          mainAxisExtent: 260,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) =>
              FeaturedCardFactory.build(context, properties[index]),
          childCount: properties.length,
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          const Text(
            "No properties found",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            "Try adjusting your search filters",
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}
