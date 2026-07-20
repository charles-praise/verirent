// shell.dart
//
// Location integration:
//
//   - The shell (Scaffold, IndexedStack, bottom nav) builds immediately,
//     unconditionally, every time. It is never swapped out for a gate
//     screen.
//   - LocationLoadingOverlay is stacked on top during initial GPS
//     resolution (LocationState.phase == loading).
//   - LocationModal is mounted ONCE here, stacked on top of the shell.
//     It is the SINGLE presentation surface for the location picker —
//     used both for the compulsory startup gate (requiresManualSelection)
//     and for casual manual editing later (isOpen, via LocationTrigger
//     wherever that's placed, e.g. Home's app bar). LocationModal owns
//     its own internal visibility via LocationState.showLocationModal,
//     so this file does not need to branch on requiresManualSelection
//     itself — it's always mounted, and shows/hides itself.
//   - GPS-layer failures (denied/permanentlyDenied/error) do NOT produce
//     a separate overlay here — LocationModal already covers them via
//     requiresManualSelection (see LocationState). LocationGpsBanner,
//     dropped into Home, remains for POST-gate background refresh
//     failures only (non-blocking).
//
// Remove the global scaffoldKey — it causes the duplicate GlobalKey error.
// The shell's Scaffold owns the key; Home reads it via the scaffold's context.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/shared/location/ui/cubit/location_cubit.dart';
import '../../../../core/shared/location/ui/cubit/location_state.dart';
import '../../../../core/shared/location/ui/page/location_modal.dart';
import '../../../../core/shared/location/ui/widget/locationLoadingOverlay.dart';
import '../../feature/notification/ui/pages/notification.dart';
import '../cubit/main_cubit.dart';
import '../cubit/main_state.dart';
import '../widgets/shell_custom_bottom_navbar.dart';

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return BlocBuilder<MainCubit, MainState>(
      builder: (context, state) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: cs.brightness == Brightness.light
              ? SystemUiOverlayStyle.dark
              : SystemUiOverlayStyle.light,
          child: SafeArea(
            top: false,
            child: Scaffold(
              key: state.scaffoldKey,
              drawer: const NotificationDrawer(),
              resizeToAvoidBottomInset: false,
              body: Stack(
                children: [
                  IndexedStack(
                    index: state.navigationIndex,
                    children: state.pages,
                  ),
                  const Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: ShellCustomBottomNavbar(),
                  ),

                  // ── Loading overlay — only during initial resolution.
                  BlocBuilder<LocationCubit, LocationState>(
                    bloc: Dependencies.locationCubit,
                    buildWhen: (prev, curr) => prev.phase != curr.phase,
                    builder: (context, locationState) {
                      if (locationState.phase == LocationPhase.loading) {
                        return const LocationLoadingOverlay();
                      }
                      return const SizedBox.shrink();
                    },
                  ),

                  const LocationModal(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
