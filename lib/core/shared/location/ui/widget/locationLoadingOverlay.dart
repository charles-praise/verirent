// =============================================================================
//  VeriRent NG — LocationLoadingOverlay
//
//  Shown by Main while LocationCubit.state.phase == LocationPhase.loading
//  (initial GPS/permission/geocode resolution in progress, or an explicit
//  refresh()). Uses the existing AnimatedLoadingLogo. No blur — this is not
//  blocking anything the user could interact with yet, it's just the first
//  thing they see.
// =============================================================================

import 'package:flutter/material.dart';

import '../../../../theme/agents_theme.dart';
import '../../../loading/ui/pages/custom_logo.dart';

class LocationLoadingOverlay extends StatelessWidget {
  const LocationLoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: VeriRentColors.black,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AnimatedLoadingLogo(size: 72),
            const SizedBox(height: 20),
            Text(
              'Determining your location…',
              style: VeriRentText.bodyMedium.copyWith(
                color: VeriRentColors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
