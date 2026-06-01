import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verirent/features/message/ui/pages/messages.dart';
import 'package:verirent/features/saved/ui/pages/saved.dart';
import 'package:verirent/features/settings/ui/pages/settings.dart';
import 'package:verirent/features/shell/data/localRepo.dart';

import '../../../home/ui/pages/home.dart';
import '../../../shell/ui/cubit/main_cubit.dart';
import '../../../shell/ui/widgets/shell_custom_bottom_navbar.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

class Main extends StatelessWidget {
  Main({super.key});

  // primary widgets
  final List<Widget> _mainScreens = [
    Home(scaffoldKey: scaffoldKey),
    MessagesPage(),
    SavedPage(),
    SettingsPage(),
  ];
  // build
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    // main app
    return BlocConsumer<MainCubit, MainState>(
      builder: (BuildContext context, state) {
        // loading state.
        if (state.status == Status.loading) {
          return CircularProgressIndicator.adaptive();
        }
        // loaded state.
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: cs.brightness == Brightness.light
              ? SystemUiOverlayStyle.dark
              : SystemUiOverlayStyle.light,
          child: SafeArea(
            top: false,
            bottom: true,
            maintainBottomViewPadding: true,
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              key: scaffoldKey,
              drawer: NotificationDrawer(),
              body: Stack(
                children: [
                  //application stack
                  IndexedStack(
                    index: state.navigationIndex,
                    children: _mainScreens,
                  ),
                  //custom bottom navigation
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: const ShellCustomBottomNavbar(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      // listeners
      listener: (BuildContext context, state) {},
    );
  }
}
