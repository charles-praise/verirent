// home_custom_appbar.dart
//
// Fix: SliverGeometry assertion "layoutExtent exceeds paintExtent".
//
// The previous code used a static CONTENT_HEIGHT = 130.0 constant but the
// Column with mainAxisSize: min rendered at ~103px, so:
//   maxExtent = topPadding(23.5) + 130 = 153.5  ← claimed
//   child size                          = 146.5  ← actual paint
//   → assertion fires because layoutExtent > paintExtent.
//
// Fix strategy: compute extent from the sum of known, fixed pixel values
// rather than a single magic constant. Every item in the Column has a
// deterministic height; we add them up explicitly.
//
// Content breakdown (all in logical pixels, independent of text scaling):
//   greeting text (bodySmall, lineHeight 1.5 × fontSize 11)  ≈ 17px
//   top-row (icons/avatar, height 38px)                      = 38px
//   SizedBox gap                                             =  6px  (VeriRentSpacing.sm)
//   HomeSearchBar (fixed height 42px)                        = 42px
//   ─────────────────────────────────────────────────────────────────
//   content subtotal                                         = 103px
//   padding top extra: topPadding + md(10)                   = varies
//   padding bottom: sm(6)                                    =  6px
//   ─────────────────────────────────────────────────────────────────
//   total = topPadding + 10 + 103 + 6 = topPadding + 119
//
// We expose _contentH = 119.0 so maxExtent = topPadding + _contentH.
// If your search bar height or greeting text changes, update _contentH.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:verirent/core/shared/location/ui/page/location_trigger.dart';

import '../../../../core/theme/agents_theme.dart';
import 'home_search_bar.dart';

class HomeAppBar extends SliverPersistentHeaderDelegate {
  HomeAppBar({
    required this.scaffoldKey,
    required this.focusNode,
    required this.topPadding,
    required this.controller,
  });

  final GlobalKey<ScaffoldState> scaffoldKey;
  final double topPadding;
  final FocusNode focusNode;
  final TextEditingController controller;

  // ── Extent arithmetic ──────────────────────────────────────────────────
  // Sum of every fixed-height item inside the Column + vertical padding.
  // Keep this in sync if you add/remove children.
  //
  //  greeting line  : 17
  //  location row   : 38
  //  gap (sm = 6)   :  6
  //  search bar     : 42
  //  padding top-extra (md = 10) + padding bottom (sm = 6) : 16
  //  ─────────────────
  //  total content  : 119
  static const double _contentH = 119.0;

  // The key rule for a non-collapsing pinned header:
  //   maxExtent == minExtent  AND  child must render at exactly that height.
  // We achieve the latter by giving the Container a fixed height equal to
  // our computed extent.
  double _extent(double topPad) => topPad + _contentH;

  @override
  double get maxExtent => _extent(topPadding);

  @override
  double get minExtent => _extent(topPadding);

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final extent = _extent(topPadding);

    return SizedBox(
      height: extent, // ← forces child to exactly fill the declared extent
      child: Container(
        padding: EdgeInsets.fromLTRB(
          VeriRentSpacing.base,
          topPadding + VeriRentSpacing.md, // md = 10
          VeriRentSpacing.base,
          VeriRentSpacing.sm, // sm = 6
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [VeriRentColors.primary600, VeriRentColors.primary500],
          ),
          boxShadow: [
            BoxShadow(
              color: VeriRentColors.primary600.withOpacity(0.30),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max, // fills the SizedBox exactly
          children: [
            // ── Greeting ────────────────────────────────────────────────
            Text(
              '${_greeting()}, Charles 👋',
              style: VeriRentText.bodySmall.copyWith(
                color: VeriRentColors.white.withOpacity(0.70),
              ),
            ),
            // ── Top Row: Location · Notification · Avatar ───────────────
            Row(
              children: [
                Expanded(child: LocationTrigger()),
                const SizedBox(width: VeriRentSpacing.sm),
                _AppBarIconButton(
                  icon: Icons.notifications_none_rounded,
                  badgeCount: 3,
                  onTap: () {
                    final scaffold = scaffoldKey.currentState;
                    if (scaffold == null) return;
                    if (scaffold.isDrawerOpen) {
                      scaffold.closeDrawer();
                    } else {
                      scaffold.openDrawer();
                    }
                  },
                ),
                const SizedBox(width: VeriRentSpacing.sm),
                GestureDetector(
                  onTap: () => context.push('/profile'),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: VeriRentColors.secondary400,
                            width: 2,
                          ),
                          gradient: LinearGradient(
                            colors: [
                              VeriRentColors.secondary400,
                              VeriRentColors.secondary600,
                            ],
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'CP',
                            style: VeriRentText.labelSmall.copyWith(
                              color: VeriRentColors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: VeriRentColors.green,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: VeriRentColors.primary600,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: VeriRentSpacing.sm),
            // ── Search Bar ───────────────────────────────────────────────
            HomeSearchBar(controller: controller, focusNode: focusNode),
          ],
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant HomeAppBar oldDelegate) =>
      topPadding != oldDelegate.topPadding;
}

// =============================================================================
//  Icon button with optional badge
// =============================================================================

class _AppBarIconButton extends StatelessWidget {
  const _AppBarIconButton({
    required this.icon,
    required this.onTap,
    this.badgeCount = 0,
  });
  final IconData icon;
  final VoidCallback onTap;
  final int badgeCount;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: VeriRentColors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(VeriRentRadius.sm),
            border: Border.all(color: VeriRentColors.white.withOpacity(0.15)),
          ),
          child: Icon(icon, size: 20, color: VeriRentColors.white),
        ),
        if (badgeCount > 0)
          Positioned(
            top: -3,
            right: -3,
            child: Container(
              width: 17,
              height: 17,
              decoration: BoxDecoration(
                color: VeriRentColors.secondary500,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$badgeCount',
                  style: VeriRentText.labelSmall.copyWith(
                    color: VeriRentColors.white,
                    fontSize: 9,
                  ),
                ),
              ),
            ),
          ),
      ],
    ),
  );
}
