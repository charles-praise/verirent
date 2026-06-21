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
import 'package:get_it/get_it.dart';
import 'package:verirent/features/home/ui/cubit/home_cubit.dart';
import 'package:verirent/features/message/ui/cubit/message_cubit.dart';
import 'package:verirent/features/saved/ui/cubit/saved_cubit.dart';
import 'package:verirent/features/settings/ui/cubit/settings_cubit.dart';

import '../../../../core/shared/location/ui/cubit/location_cubit.dart';
import '../../../../core/shared/location/ui/cubit/location_state.dart';
import '../../../../core/shared/location/ui/page/location_modal.dart';
import '../../../../core/shared/location/ui/widget/locationLoadingOverlay.dart';
import '../../../home/ui/pages/home.dart';
import '../../../message/ui/pages/messages.dart';
import '../../../saved/ui/pages/saved.dart';
import '../../../settings/ui/pages/settings.dart';
import '../../data/localRepo.dart';
import '../cubit/main_cubit.dart';
import '../cubit/main_state.dart';
import '../widgets/shell_custom_bottom_navbar.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class Main extends StatelessWidget {
  Main({super.key});

  final List<Widget> _mainScreens = [
    BlocProvider.value(
      value: GetIt.I<HomeCubit>(),
      child: Home(scaffoldKey: _scaffoldKey),
    ),
    BlocProvider.value(value: GetIt.I<MessagesCubit>(), child: MessagesPage()),
    BlocProvider.value(value: GetIt.I<SavedCubit>(), child: SavedPage()),
    BlocProvider.value(value: GetIt.I<SettingsCubit>(), child: SettingsPage()),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return BlocProvider(
      create: (create) => GetIt.I<MainCubit>(),
      child: BlocBuilder<MainCubit, MainState>(
        builder: (context, state) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: cs.brightness == Brightness.light
                ? SystemUiOverlayStyle.dark
                : SystemUiOverlayStyle.light,
            child: SafeArea(
              top: false,
              child: Scaffold(
                key: _scaffoldKey,
                drawer: const NotificationDrawer(),
                resizeToAvoidBottomInset: false,
                body: Stack(
                  children: [
                    // ── The real shell — always built, never swapped out ──
                    IndexedStack(
                      index: state.navigationIndex,
                      children: _mainScreens,
                    ),
                    const Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: ShellCustomBottomNavbar(),
                    ),

                    // ── Loading overlay — only during initial resolution.
                    BlocBuilder<LocationCubit, LocationState>(
                      bloc: GetIt.I<LocationCubit>(),
                      buildWhen: (prev, curr) => prev.phase != curr.phase,
                      builder: (context, locationState) {
                        if (locationState.phase == LocationPhase.loading) {
                          return const LocationLoadingOverlay();
                        }
                        return const SizedBox.shrink();
                      },
                    ),

                    // ── THE single location picker surface — handles both
                    //    the compulsory gate and manual edits. Mounted
                    //    once, owns its own visibility internally.
                    const LocationModal(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
