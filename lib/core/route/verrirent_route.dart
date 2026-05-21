import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:verirent/features/home/ui/cubit/home_cubit.dart';
import 'package:verirent/features/home/ui/pages/home.dart';

class _Route {
  static final String home = '/';
  static final String discover = '/discover';
  static final String profile = '/profile';
  static final String nowPlaying = '/nowPLaying';
}

abstract final class VeriRentRoute {
  static final GoRouter router = GoRouter(
    overridePlatformDefaultLocation: true,
    initialLocation: _Route.home,

    // Home Route
    routes: [
      GoRoute(
        name: "Home",
        path: _Route.home,
        pageBuilder: (context, state) => CustomTransitionPage(
          child: BlocProvider(
            create: (context) => GetIt.instance<HomeCubit>(),
            child: const Home(),
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
    ],
  );
}
