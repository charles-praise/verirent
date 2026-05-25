import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:verirent/core/theme/agents_theme.dart';
import 'package:verirent/features/home/ui/cubit/home_cubit.dart';

import '../widgets/home_custom_appbar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  final _filters = ['All', 'Apartment', 'Duplex', 'Furnished', 'Corporate'];
  final _filterIcons = [
    Icons.star_rounded,
    Icons.house_rounded,
    Icons.apartment_rounded,
    Icons.chair_rounded,
    Icons.business_center_rounded,
  ];

  @override
  void dispose() {
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
                SliverToBoxAdapter(child: HomeAppBar(topPadding: topPad)),

                // ── Filters ─────────────────────────────────────────────
                SliverToBoxAdapter(
                  child: _buildFilters(context: context, state: state),
                ),
                // ── Quick actions ─────────────────────────────────────────────────
                // const SliverToBoxAdapter(child: QuickActionsGrid()),
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
