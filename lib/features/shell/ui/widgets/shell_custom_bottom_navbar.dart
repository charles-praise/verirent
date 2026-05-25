import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/agents_theme.dart';
import '../../domain/entities/nav_item.dart';
import '../cubit/main_cubit.dart';

class ShellCustomBottomNavbar extends StatelessWidget {
  const ShellCustomBottomNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    //navigate
    void onTabTapped(int index) {
      HapticFeedback.mediumImpact();
      context.read<MainCubit>().navigate(index);
    }

    // list of navigation items
    final List<NavItem> _navItems = [
      NavItem(
        icon: Icons.grid_view_outlined,
        activeIcon: Icons.grid_view_rounded,
        label: "Discover",
      ),
      NavItem(
        icon: Icons.equalizer_outlined,
        activeIcon: Icons.equalizer_rounded,
        label: "Popular",
      ),
      NavItem(
        icon: Icons.bookmark_border_rounded,
        activeIcon: Icons.bookmark_rounded,
        label: 'Saved',
      ),
      NavItem(
        icon: Icons.person_outline_rounded,
        activeIcon: Icons.person_rounded,
        label: 'Profile',
      ),
    ];

    return BlocBuilder<MainCubit, MainState>(
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 15),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.brightness == Brightness.light
                ? VeriRentColors.primary500
                : VeriRentColors.primary600,
            borderRadius: BorderRadius.circular(VeriRentRadius.full),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(VeriRentRadius.full),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(4, (index) {
                  final item = _navItems[index];
                  final isSelected = state.navigationIndex == index;

                  return GestureDetector(
                    onTap: () => onTabTapped(index),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Positioned(
                                top: 0,
                                bottom: 0,
                                right: 0,
                                left: 0,
                                child: Container(
                                  height: double.maxFinite,
                                  width: double.maxFinite,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? VeriRentColors.primaryDim
                                        : VeriRentColors.transparent,
                                    borderRadius: BorderRadius.circular(
                                      VeriRentRadius.xs,
                                    ),
                                  ),
                                ),
                              ),
                              Icon(
                                isSelected ? item.activeIcon : item.icon,
                                size: 30,
                                color:
                                    Theme.of(context).colorScheme.brightness ==
                                        Brightness.light
                                    ? isSelected
                                          ? VeriRentColors.primary
                                          : VeriRentColors.white
                                    : isSelected
                                    ? VeriRentColors.primary
                                    : VeriRentColors.neutral200,
                              ),
                            ],
                          ),
                          Text(
                            item.label,
                            style: TextStyle(
                              fontSize: 12,
                              color: VeriRentColors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        );
      },
    );
  }
}

//     BackdropFilter(
//         filter: ImageFilter.blur(
//           sigmaX: VeriRentRadius.xl,
//           sigmaY: VeriRentRadius.xl,
//         ),
