import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verirent/core/theme/agents_theme.dart';

import '../../domain/entities/nav_item.dart';
import '../cubit/main_cubit.dart';
import '../cubit/main_state.dart';

class ShellCustomBottomNavbar extends StatelessWidget {
  const ShellCustomBottomNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    final isLight =
        Theme.of(context).colorScheme.brightness == Brightness.light;

    void onTabTapped(int index) {
      final currentIndex = context.read<MainCubit>().state.navigationIndex;
      if (index != currentIndex) {
        HapticFeedback.mediumImpact();
        context.read<MainCubit>().navigate(index);
      }
    }

    final List<NavItem> navItems = [
      NavItem(
        icon: Icons.explore_outlined,
        activeIcon: Icons.explore_rounded,
        label: 'Discover',
      ),
      NavItem(
        icon: Icons.messenger_outline_outlined,
        activeIcon: Icons.messenger,
        label: 'Message',
      ),
      NavItem(
        icon: Icons.bookmark_border_rounded,
        activeIcon: Icons.bookmark_rounded,
        label: 'Saved',
      ),
      NavItem(
        icon: Icons.settings_outlined,
        activeIcon: Icons.settings,
        label: 'Settings',
      ),
    ];

    return BlocBuilder<MainCubit, MainState>(
      builder: (context, state) {
        final activeColor = Theme.of(context).brightness == Brightness.light
            ? VeriRentColors.primary
            : VeriRentColors.accent400;
        final inactiveColor = isLight
            ? const Color(0xFF8E8E93)
            : const Color(0xFF8E8E93);

        return SafeArea(
          top: false,
          minimum: const EdgeInsets.only(bottom: 12),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: isLight
                    ? Colors.white
                    : const Color(0xFF1C1C1E).withOpacity(0.94),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: isLight
                        ? const Color(0xFF000000).withOpacity(0.08)
                        : const Color(0xFF000000).withOpacity(0.25),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(navItems.length, (index) {
                      final item = navItems[index];
                      final isSelected = state.navigationIndex == index;

                      return Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => onTabTapped(index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeOutCubic,
                            margin: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 0,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? activeColor.withOpacity(0.12)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  isSelected ? item.activeIcon : item.icon,
                                  size: 22,
                                  color: isSelected
                                      ? activeColor
                                      : inactiveColor,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  item.label,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                    color: isSelected
                                        ? activeColor
                                        : inactiveColor,
                                    letterSpacing: 0.2,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
