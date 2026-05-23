import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:verirent/core/theme/agents_theme.dart';
import 'package:verirent/features/home/ui/widgets/home_search_bar.dart';

import '../widgets/home_custom_appbar.dart';
import '../widgets/home_quick_action.dart';
import '../widgets/home_section_header.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final ext = Theme.of(context).extension<VeriRentExtension>()!;
    final text = Theme.of(context).textTheme;

    final topPad = MediaQuery.of(context).padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: cs.brightness == Brightness.light
          ? SystemUiOverlayStyle.dark
          : SystemUiOverlayStyle.light,
      child: CustomScrollView(
        slivers: [
          // ── App bar ───────────────────────────────────────────────────────
          SliverToBoxAdapter(child: HomeAppBar(topPadding: topPad)),
          // ── Search bar ────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                VeriRentSpacing.base,
                VeriRentSpacing.sm,
                VeriRentSpacing.base,
                VeriRentSpacing.base,
              ),
              child: HomeSearchBar(
                controller: _searchController,
                focusNode: _searchFocus,
              ),
            ),
          ),
          // ── Trust stats strip ─────────────────────────────────────────────
          // const SliverToBoxAdapter(child: TrustStatsStrip()),
          // ── Quick actions ─────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: SectionHeader(title: 'Quick Actions', onSeeAll: null),
          ),
          const SliverToBoxAdapter(child: QuickActionsGrid()),
        ],
      ),
    );
  }
}
