import 'package:flutter/material.dart';

import '../../theme/agents_theme.dart';

Container verifiedBadge() => Container(
  padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
  decoration: BoxDecoration(
    color: VeriRentColors.white,
    borderRadius: BorderRadius.circular(VeriRentRadius.full),
  ),
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      const Icon(
        Icons.verified_rounded,
        size: 16,
        color: VeriRentColors.tierVerified,
      ),
      // const SizedBox(width: 3),
      // Text(
      //   'Verified',
      //   style: VeriRentText.labelSmall.copyWith(
      //     color: Colors.white,
      //     fontSize: 9,
      //   ),
      // ),
    ],
  ),
);
