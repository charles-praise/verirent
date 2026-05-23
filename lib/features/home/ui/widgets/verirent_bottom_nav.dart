// =============================================================================
//  VeriRent NG — Stack-Anchored Bottom Navigation
//  Nixel Technology Global | May 2026
//
//  KEY PATTERN — How to anchor a custom nav so keyboard NEVER pushes it up:
//
//  1. Set Scaffold(resizeToAvoidBottomInset: false)
//     → This stops the scaffold from shrinking its body when the keyboard opens.
//
//  2. Wrap the body in a Stack.
//
//  3. Put the nav in Positioned(bottom: 0, left: 0, right: 0, ...)
//     → It is pinned to the bottom of the Stack, which is the full screen height
//       (since the scaffold no longer resizes). The keyboard opens ON TOP of it.
//
//  4. Add bottom padding to your scrollable content equal to nav height +
//     MediaQuery.of(context).padding.bottom (safe area).
//     → This ensures the last list item isn't hidden behind the nav bar.
//
//  Usage in a Scaffold:
//
//    Scaffold(
//      resizeToAvoidBottomInset: false,          // ← STEP 1
//      body: Stack(                               // ← STEP 2
//        children: [
//          Positioned.fill(
//            bottom: VeriRentBottomNav.height,    // leave room for nav
//            child: YourPageContent(),
//          ),
//          const Positioned(                      // ← STEP 3
//            bottom: 0, left: 0, right: 0,
//            child: VeriRentBottomNav(
//              currentIndex: 0,
//              onTap: _onNavTap,
//            ),
//          ),
//        ],
//      ),
//    )
// =============================================================================

import 'package:flutter/material.dart';

import '../../../../core/theme/agents_theme.dart';

// ---------------------------------------------------------------------------
//  Nav item model
// ---------------------------------------------------------------------------

class _NavItem {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
}

const List<_NavItem> _kNavItems = [
  _NavItem(
    icon: Icons.home_outlined,
    activeIcon: Icons.home_rounded,
    label: 'Home',
  ),
  _NavItem(
    icon: Icons.search_outlined,
    activeIcon: Icons.search_rounded,
    label: 'Search',
  ),
  _NavItem(
    icon: Icons.bookmark_border_rounded,
    activeIcon: Icons.bookmark_rounded,
    label: 'Saved',
  ),
  _NavItem(
    icon: Icons.person_outline_rounded,
    activeIcon: Icons.person_rounded,
    label: 'Profile',
  ),
];

// ---------------------------------------------------------------------------
//  VeriRentBottomNav — drop-in reusable widget
// ---------------------------------------------------------------------------

class VeriRentBottomNav extends StatelessWidget {
  const VeriRentBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  /// Total height including iOS safe-area bottom inset.
  /// Use this as the `bottom` value for Positioned.fill on your content.
  static const double barHeight = 64.0;

  static double totalHeight(BuildContext context) =>
      barHeight + MediaQuery.of(context).padding.bottom;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      height: barHeight + bottomPadding,
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(top: BorderSide(color: cs.outlineVariant, width: 1)),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: Row(
          children: List.generate(_kNavItems.length, (i) {
            return _NavTile(
              item: _kNavItems[i],
              isActive: currentIndex == i,
              onTap: () => onTap(i),
            );
          }),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
//  Individual nav tile with animated indicator
// ---------------------------------------------------------------------------

class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  final _NavItem item;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final activeColor = cs.primary;
    final inactiveColor = cs.onSurfaceVariant;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          height: VeriRentBottomNav.barHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated pill indicator
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic,
                height: 32,
                width: isActive ? 56 : 32,
                decoration: BoxDecoration(
                  color: isActive
                      ? cs.primaryContainer
                      : VeriRentColors.transparent,
                  borderRadius: BorderRadius.circular(VeriRentRadius.full),
                ),
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 150),
                    child: Icon(
                      isActive ? item.activeIcon : item.icon,
                      key: ValueKey(isActive),
                      size: 22,
                      color: isActive ? activeColor : inactiveColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 2),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 150),
                style: VeriRentText.labelSmall.copyWith(
                  color: isActive ? activeColor : inactiveColor,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  letterSpacing: 0.3,
                ),
                child: Text(item.label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
