// shell.dart

// Remove the global scaffoldKey — it causes the duplicate GlobalKey error.
// The shell's Scaffold owns the key; Home reads it via the scaffold's context.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:verirent/features/message/ui/cubit/message_cubit.dart';

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
    // Pass the key down once, from here.
    Home(scaffoldKey: _scaffoldKey),
    BlocProvider(
      create: (context) => GetIt.I<MessagesCubit>(),
      child: MessagesPage(),
    ),
    SavedPage(),
    SettingsPage(),
  ];

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
              // Shell owns the key — not Home.
              key: _scaffoldKey,
              drawer: const NotificationDrawer(),
              resizeToAvoidBottomInset: false,
              body: Stack(
                children: [
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
