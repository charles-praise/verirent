import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:verirent/core/theme/agents_theme.dart';
import 'package:verirent/features/home/domain/use_case/home_featured_listing.dart';
import 'package:verirent/features/home/domain/use_case/home_recent.dart';
import 'package:verirent/features/home/ui/cubit/home_cubit.dart';
import 'package:verirent/features/home/ui/widgets/home_section_header.dart';
import 'package:verirent/features/shell/ui/pages/shell.dart';

import '../widgets/home_custom_appbar.dart';
import '../widgets/home_filter.dart';

class Home extends StatefulWidget {
  const Home({super.key, required GlobalKey<ScaffoldState> scaffoldKey});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<bool> _isVisible = ValueNotifier<bool>(true);
  final FocusNode _searchFocus = FocusNode();

  final _filters = ['All', 'Apartment', 'Duplex', 'Furnished', 'Corporate'];
  final _filterIcons = [
    Icons.star_rounded,
    Icons.house_rounded,
    Icons.apartment_rounded,
    Icons.chair_rounded,
    Icons.business_center_rounded,
  ];

  void _listenToScroll() {
    final direction = _scrollController.position.userScrollDirection;

    if (direction == ScrollDirection.reverse) {
      if (_isVisible.value) {
        _isVisible.value = false;
      }
    } else if (direction == ScrollDirection.forward) {
      if (!_isVisible.value) {
        _isVisible.value = true;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_listenToScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final topPad = MediaQuery.paddingOf(context).top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: cs.brightness == Brightness.light
          ? SystemUiOverlayStyle.dark
          : SystemUiOverlayStyle.light,
      child: BlocProvider(
        create: (_) => GetIt.instance<HomeCubit>(),
        child: BlocConsumer<HomeCubit, HomeState>(
          listener: (_, _) {},
          builder: (context, state) {
            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                // ── Persistent App bar ─────────────────────────────
                SliverPersistentHeader(
                  pinned: true,
                  delegate: HomeAppBar(
                    context: context,
                    topPadding: topPad,
                    scaffoldKey: scaffoldKey,
                    focusNode: _searchFocus,
                    controller: _searchController,
                  ),
                ),

                // ── Search filter ────────────────────────
                SliverToBoxAdapter(
                  child: ValueListenableBuilder<bool>(
                    valueListenable: _isVisible,
                    builder:
                        (BuildContext context, bool visible, Widget? child) {
                          return AnimatedOpacity(
                            duration: const Duration(milliseconds: 250),
                            opacity: visible ? 1.0 : 0.0,
                            child: SearchFilter(
                              filters: _filters,
                              filterIcons: _filterIcons,
                              activeIndex: state.activeIndex,
                              onFilterTap: (i) {
                                HapticFeedback.lightImpact();
                                context.read<HomeCubit>().activeIndex(i);
                              },
                            ),
                          );
                        },
                  ),
                ),

                // ── Featured Listing ───────────────────────────────────
                const SliverToBoxAdapter(
                  child: FeaturedListingsHorizontalUseCase(),
                ),

                // ── Recently Added ─────────────────────────────────────
                SliverToBoxAdapter(
                  child: SectionHeader(
                    title: 'Recently Added',
                    onSeeAll: () {},
                  ),
                ),
                RecentListingUseCase(),

                // ── Agency Banner ───────────────────────────────────────
                SliverToBoxAdapter(child: _buildAgencyBanner()),

                // ── Available Listing ──────────────────────────────────
                SliverToBoxAdapter(
                  child: SectionHeader(
                    title: 'Available Listing',
                    onSeeAll: () {},
                  ),
                ),
                FeaturedListingsVerticalUseCase(),

                // ── Bottom spacing ─────────────────────────────────────
                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            );
          },
        ),
      ),
    );
  }

  // ── Agency Banner ─────────────────────────────────────────────────────────
  Widget _buildAgencyBanner() => Padding(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(
          color: Theme.of(context).colorScheme.brightness == Brightness.light
              ? VeriRentColors.primary.withOpacity(0.35)
              : Theme.of(context).colorScheme.outlineVariant,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: VeriRentColors.goldDim,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.verified_rounded,
              color: VeriRentColors.gold,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Are you an agency?', style: VeriRentText.labelMedium),
                Text(
                  'Get ESVARBON-certified & join the platform',
                  style: VeriRentText.labelMedium,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: VeriRentColors.gold,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                'Apply',
                style: VeriRentText.labelMedium.copyWith(
                  color:
                      Theme.of(context).colorScheme.brightness ==
                          Brightness.light
                      ? VeriRentColors.white
                      : VeriRentColors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
