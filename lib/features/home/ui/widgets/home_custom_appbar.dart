import 'package:flutter/material.dart';

import '../../../../core/theme/agents_theme.dart';
import 'home_search_bar.dart';

class HomeAppBar extends StatefulWidget {
  const HomeAppBar({super.key, required this.topPadding});

  final double topPadding;

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
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

    return Container(
      padding: EdgeInsets.fromLTRB(
        VeriRentSpacing.base,
        widget.topPadding + VeriRentSpacing.md,
        VeriRentSpacing.base,
        VeriRentSpacing.md,
      ),
      decoration: BoxDecoration(
        color: cs.primary,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [VeriRentColors.primary600, VeriRentColors.primary500],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Location pill
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      size: VeriRentRadius.lg,
                      color: VeriRentColors.secondary300,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Port Harcourt, Rivers State',
                      style: VeriRentText.labelMedium.copyWith(
                        color: VeriRentColors.white.withOpacity(0.85),
                      ),
                    ),
                    const SizedBox(width: 2),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: VeriRentRadius.lg,
                      color: VeriRentColors.white.withOpacity(0.6),
                    ),
                  ],
                ),
              ),

              // Notification icon
              _AppBarIconButton(
                icon: Icons.notifications_none_rounded,
                badgeCount: 3,
                onTap: () {},
              ),

              const SizedBox(width: VeriRentSpacing.sm),

              // Avatar
              GestureDetector(
                onTap: () {},
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: VeriRentColors.secondary500,
                  child: Text(
                    'CP',
                    style: VeriRentText.labelSmall.copyWith(
                      color: VeriRentColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: VeriRentSpacing.md),

          // Text(
          //   'Good morning, Charles 👋',
          //   style: VeriRentText.bodySmall.copyWith(
          //     color: VeriRentColors.white.withOpacity(0.7),
          //   ),
          // ),
          // const SizedBox(height: 2),
          HomeSearchBar(controller: _searchController, focusNode: _searchFocus),
        ],
      ),
    );
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: VeriRentColors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(VeriRentRadius.sm),
            ),
            child: Icon(icon, size: 20, color: VeriRentColors.white),
          ),
          if (badgeCount > 0)
            Positioned(
              top: -4,
              right: -4,
              child: Container(
                width: 16,
                height: 16,
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
}
