import 'package:flutter/material.dart';

import '../../theme/agents_theme.dart';

Center profileAvatar({
  required BuildContext context,
  bool showCameraIcon = true,
}) {
  final cs = Theme.of(context).colorScheme;
  return Center(
    child: Stack(
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [VeriRentColors.primary400, VeriRentColors.primary700],
            ),
            border: Border.all(
              color: VeriRentColors.gold,
              width: showCameraIcon ? 2.5 : 1.2,
            ),
          ),
          child: Center(
            child: Text(
              'CP',
              style: showCameraIcon
                  ? VeriRentText.headlineMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    )
                  : VeriRentText.titleMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                    ),
            ),
          ),
        ),
        if (showCameraIcon)
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: cs.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: cs.surface, width: 2),
                ),
                child: const Icon(
                  Icons.camera_alt_rounded,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    ),
  );
}
