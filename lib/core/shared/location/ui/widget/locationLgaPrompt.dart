// =============================================================================
//  VeriRent NG — LocationLgaPrompt
//
//  Non-blocking nudge for LocationState.needsLgaConfirmation (state known,
//  LGA missing). Two-stage:
//    1. A SnackBar fires once, the instant this condition becomes true.
//    2. If the user dismisses or ignores the snackbar, a persistent card
//       remains visible (place it on Home, same spot as LocationGpsBanner)
//       until the user picks an LGA or explicitly dismisses the card.
//
//  Deliberately does NOT block anything — selectedState alone is enough
//  for the app to function; this only asks for LGA to sharpen content
//  relevance. Tapping "Select LGA" opens the LocationDropdown's panel
//  directly via the cubit (toggleDropdown), no overlay/blur involved.
//
//  Usage: mount LocationLgaPromptListener ONCE near the root of the
//  screen that should show the snackbar (Home is the natural place,
//  since it needs a Scaffold/ScaffoldMessenger ancestor). Mount
//  LocationLgaCard wherever the persistent card should render — same
//  screen, typically right below LocationGpsBanner.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../theme/agents_theme.dart';
import '../cubit/location_cubit.dart';
import '../cubit/location_state.dart';

/// Fires the one-time SnackBar. Mount this near the top of a screen that
/// has a Scaffold ancestor (e.g. wrap Home's body, or place inside Home's
/// build method) so ScaffoldMessenger.of(context) resolves correctly.
class LocationLgaPromptListener extends StatelessWidget {
  const LocationLgaPromptListener({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<LocationCubit, LocationState>(
      bloc: GetIt.I<LocationCubit>(),
      // Fires only on the transition INTO needsLgaConfirmation — never
      // re-fires on unrelated rebuilds, and re-arms naturally if the
      // condition clears and re-occurs later (e.g. state changes again).
      listenWhen: (prev, curr) =>
          !prev.needsLgaConfirmation && curr.needsLgaConfirmation,
      listener: (context, state) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: VeriRentColors.warning500,
            duration: const Duration(seconds: 5),
            content: Text(
              'We found ${state.selectedState} — select your LGA for better content.',
              style: VeriRentText.bodySmall.copyWith(color: Colors.white),
            ),
            action: SnackBarAction(
              label: 'Select',
              textColor: Colors.white,
              onPressed: () => GetIt.I<LocationCubit>().toggleDropdown(),
            ),
          ),
        );
      },
      child: child,
    );
  }
}

/// The persistent dismissible card — stays visible until the user picks
/// an LGA or taps dismiss. Re-appears if needsLgaConfirmation becomes
/// true again later (e.g. state changed, LGA cleared).
class LocationLgaCard extends StatefulWidget {
  const LocationLgaCard({super.key});

  @override
  State<LocationLgaCard> createState() => _LocationLgaCardState();
}

class _LocationLgaCardState extends State<LocationLgaCard> {
  bool _dismissed = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationCubit, LocationState>(
      bloc: GetIt.I<LocationCubit>(),
      buildWhen: (prev, curr) =>
          prev.needsLgaConfirmation != curr.needsLgaConfirmation ||
          prev.selectedState != curr.selectedState,
      builder: (context, state) {
        if (!state.needsLgaConfirmation) {
          if (_dismissed) _dismissed = false; // re-arm for next occurrence
          return const SizedBox.shrink();
        }
        if (_dismissed) return const SizedBox.shrink();

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: VeriRentColors.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(VeriRentRadius.md),
            border: Border.all(color: VeriRentColors.primary.withOpacity(0.25)),
          ),
          child: Row(
            children: [
              Icon(
                Icons.pin_drop_outlined,
                size: 16,
                color: VeriRentColors.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Select your LGA in ${state.selectedState} for better content.',
                  style: VeriRentText.bodySmall.copyWith(
                    color: VeriRentColors.primary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () => GetIt.I<LocationCubit>().toggleDropdown(),
                child: Text(
                  'Select',
                  style: VeriRentText.labelSmall.copyWith(
                    color: VeriRentColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => setState(() => _dismissed = true),
                child: Icon(
                  Icons.close_rounded,
                  size: 14,
                  color: VeriRentColors.primary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
