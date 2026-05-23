import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/ui/cubit/home_cubit.dart';
import '../../features/home/ui/pages/home.dart';
import '../../features/shell/ui/cubit/main_cubit.dart';
import '../../features/shell/ui/pages/shell.dart';

class _Route {
  static final String main = '/';
  static final String home = '/home';
  static final String profile = '/profile';
  static final String nowPlaying = '/nowPLaying';
}

abstract final class VeriRentRoute {
  static final GoRouter router = GoRouter(
    overridePlatformDefaultLocation: true,
    initialLocation: _Route.main,

    routes: [
      // Main Route
      GoRoute(
        name: "Main or Landing page",
        path: _Route.main,
        pageBuilder: (context, state) => CustomTransitionPage(
          child: BlocProvider(
            create: (context) => GetIt.instance<MainCubit>(),
            child: Main(),
          ),
          transitionsBuilder:
              (
                BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child,
              ) {
                return FadeTransition(opacity: animation, child: child);
              },
        ),
      ),

      //Home Route
      GoRoute(
        name: "home",
        path: _Route.home,
        pageBuilder: (context, state) => CustomTransitionPage(
          child: BlocProvider(
            create: (context) => GetIt.instance<HomeCubit>(),
            child: Home(),
          ),
          transitionsBuilder:
              (
                BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child,
              ) {
                return FadeTransition(opacity: animation, child: child);
              },
        ),
      ),
    ],
  );
}
