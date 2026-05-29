// =============================================================================
//  VeriRent NG — HomeAppBar (Professional Upgrade)
// =============================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:verirent/features/home/ui/widgets/home_search_bar.dart';

import '../../../../core/theme/agents_theme.dart';

class HomeAppBar extends SliverPersistentHeaderDelegate {
  HomeAppBar({
    required this.context,
    required this.scaffoldKey,
    required this.focusNode,
    required this.topPadding,
    required this.controller,
  });
  final BuildContext context;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final double topPadding;
  final FocusNode focusNode;
  final TextEditingController controller;

  // Content height calculation:
  // topPadding: 44px (approx, varies by device)
  // VeriRentSpacing.md: 12px (top padding)
  // Greeting text: 20px
  // Spacing: 8px
  // Row (location/notification/avatar): 38px
  // Spacing: 8px
  // HomeSearchBar: 50px (typical)
  // Bottom padding: 8px
  // Total: ~154px (plus topPadding)

  static const double CONTENT_HEIGHT = 130.0;

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
    return Container(
      padding: EdgeInsets.fromLTRB(
        VeriRentSpacing.base,
        topPadding + VeriRentSpacing.md,
        VeriRentSpacing.base,
        VeriRentSpacing.sm,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [VeriRentColors.primary600, VeriRentColors.primary500],
        ),
        boxShadow: [
          BoxShadow(
            color: VeriRentColors.primary600.withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Greeting + Headline ────────────────────────────────────────
          Flexible(
            child: Text(
              '${_greeting()}, Charles 👋',
              style: VeriRentText.bodySmall.copyWith(
                color: VeriRentColors.white.withOpacity(0.70),
              ),
            ),
          ),
          // ── Top Row: Location · Notification · Avatar ─────────────────
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: VeriRentColors.white.withOpacity(0),
                      borderRadius: BorderRadius.circular(VeriRentRadius.full),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: VeriRentColors.secondary500.withOpacity(
                              0.25,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.location_on_rounded,
                            size: 11,
                            color: VeriRentColors.secondary300,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            'Port Harcourt, Rivers State',
                            style: VeriRentText.labelMedium.copyWith(
                              color: VeriRentColors.white.withOpacity(0.90),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Icon(
                          Icons.expand_more_rounded,
                          size: 16,
                          color: VeriRentColors.white.withOpacity(0.55),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: VeriRentSpacing.sm),
              _AppBarIconButton(
                icon: Icons.notifications_none_rounded,
                badgeCount: 3,
                onTap: () {
                  scaffoldKey.currentState!.isEndDrawerOpen
                      ? scaffoldKey.currentState!.closeDrawer()
                      : scaffoldKey.currentState!.openDrawer();
                },
              ),
              const SizedBox(width: VeriRentSpacing.sm),
              // Avatar with online dot
              GestureDetector(
                onTap: () {
                  context.push("/profile");
                },
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
                        gradient: const LinearGradient(
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
          const SizedBox(height: VeriRentSpacing.xs),
          // ── Search App Bar  ─────────────────
          HomeSearchBar(controller: controller, focusNode: focusNode),
          // const SizedBox(height: 3),
          // Text(
          //   'Find Your Perfect\nVerified Home',
          //   style: VeriRentText.headlineMedium.copyWith(
          //     color: VeriRentColors.white,
          //     fontWeight: FontWeight.w800,
          //     height: 1.25,
          //   ),
          // ),
          //
          // const SizedBox(height: VeriRentSpacing.md),
          //
          // // ── Trust Stats ────────────────────────────────────────────────
          // Row(
          //   children: [
          //     _StatPill(
          //       icon: Icons.verified_rounded,
          //       label: '127 Verified',
          //       iconColor: VeriRentColors.secondary300,
          //     ),
          //     const SizedBox(width: 8),
          //     _StatPill(
          //       icon: Icons.fiber_new_rounded,
          //       label: '3 New Today',
          //       iconColor: VeriRentColors.green,
          //     ),
          //     const SizedBox(width: 8),
          //     _StatPill(
          //       icon: Icons.business_rounded,
          //       label: '18 Agencies',
          //       iconColor: VeriRentColors.primary200,
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  @override
  double get maxExtent {
    final height = topPadding + CONTENT_HEIGHT;
    return height.clamp(140.0, 250.0);
  }

  @override
  double get minExtent {
    final height = topPadding + CONTENT_HEIGHT;
    return height.clamp(140.0, 250.0);
  }

  bool shouldRebuild(HomeAppBar oldDelegate) {
    return false;
  }
}

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
              decoration: const BoxDecoration(
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
