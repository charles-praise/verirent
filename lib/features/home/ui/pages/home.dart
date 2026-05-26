import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:verirent/core/theme/agents_theme.dart';
import 'package:verirent/features/home/domain/use_case/home_featured_listing.dart';
import 'package:verirent/features/home/domain/use_case/home_recent.dart';
import 'package:verirent/features/home/ui/cubit/home_cubit.dart';
import 'package:verirent/features/home/ui/widgets/home_section_header.dart';

import '../widgets/home_custom_appbar.dart';

class Home extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const Home({super.key, required this.scaffoldKey});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  bool _showCompactSearch = false;

  final _filters = ['All', 'Apartment', 'Duplex', 'Furnished', 'Corporate'];
  final _filterIcons = [
    Icons.star_rounded,
    Icons.house_rounded,
    Icons.apartment_rounded,
    Icons.chair_rounded,
    Icons.business_center_rounded,
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      // Show compact search when first header (160px) has scrolled out
      if (_scrollController.position.pixels >= 160 && !_showCompactSearch) {
        setState(() => _showCompactSearch = true);
      } else if (_scrollController.position.pixels < 160 &&
          _showCompactSearch) {
        setState(() => _showCompactSearch = false);
      }
    });
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

    final topPad = MediaQuery.of(context).padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: cs.brightness == Brightness.light
          ? SystemUiOverlayStyle.dark
          : SystemUiOverlayStyle.light,
      child: BlocProvider(
        create: (context) => GetIt.instance<HomeCubit>(),
        child: BlocConsumer<HomeCubit, HomeState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                // ── App bar ───────────────────────────────────────────────────────
                SliverToBoxAdapter(
                  child: HomeAppBar(
                    state: state,
                    topPadding: topPad,
                    scaffoldKey: widget.scaffoldKey,
                  ),
                ),
                // ── Filters ─────────────────────────────────────────────
                SliverToBoxAdapter(
                  child: _buildFilters(context: context, state: state),
                ),
                // ── Featured Listing ─────────────────────────────────────────────────
                SliverToBoxAdapter(child: FeaturedListingsHorizontalUseCase()),
                // ── Recent Listing ─────────────────────────────────────────────────
                SliverToBoxAdapter(
                  child: SectionHeader(
                    title: 'Recently Added',
                    onSeeAll: () {},
                  ),
                ),
                RecentListingUseCase(),
                // ── Available Listing ─────────────────────────────────────────────────
                SliverToBoxAdapter(
                  child: SectionHeader(
                    title: 'Available Listing',
                    onSeeAll: () {},
                  ),
                ),
                FeaturedListingsVerticalUseCase(),
                // ── Extra Spacing  ─────────────────────────────────────────────────
                SliverToBoxAdapter(child: const SizedBox(height: 80)),
              ],
            );
          },
        ),
      ),
    );
  }

  // ── Filters ───────────────────────────────────────────────────────────────
  Widget _buildFilters({
    required BuildContext context,
    required dynamic state,
  }) => Padding(
    padding: const EdgeInsets.all(8.0),
    child: SizedBox(
      height: 46,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
        itemCount: _filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (ctx, i) {
          final active = i == state.activeIndex;
          return GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              context.read<HomeCubit>().activeIndex(i);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: active
                    ? VeriRentColors.primaryDim
                    : Theme.of(context).colorScheme.brightness ==
                          Brightness.light
                    ? VeriRentColors.white
                    : VeriRentColors.surface2,
                border: Border.all(
                  color: active
                      ? VeriRentColors.primary
                      : VeriRentColors.border,
                ),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _filterIcons[i],
                    size: VeriRentSpacing.md,
                    color: active
                        ? VeriRentColors.primary
                        : VeriRentColors.textMuted,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _filters[i],
                    style: TextStyle(
                      fontSize: VeriRentSpacing.md,
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
  );
}
