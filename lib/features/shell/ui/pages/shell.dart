import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../home/ui/pages/home.dart';
import '../../../home/ui/pages/home_screen.dart';
import '../../../home/ui/pages/verirent_home.dart';
import '../../../shell/ui/cubit/main_cubit.dart';
import '../../../shell/ui/widgets/shell_custom_bottom_navbar.dart';

class Main extends StatelessWidget {
  Main({super.key});

  // primary widgets
  final List<Widget> _mainScreens = [
    VeriRentApp(),
    HomeScreen(),
    Home(),
    Home(),
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
          child: Scaffold(
            resizeToAvoidBottomInset: false,
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
        );
      },
      // listeners
      listener: (BuildContext context, state) {},
    );
  }
}
