import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:verirent/features/auth/ui/cubit/auth_cubit.dart';
import 'package:verirent/features/auth/ui/pages/login.dart';
import 'package:verirent/features/profile/ui/cubit/profile_cubit.dart';
import 'package:verirent/features/profile/ui/pages/profile.dart';
import 'package:verirent/features/search/ui/cubit/search_cubit.dart';
import 'package:verirent/features/search/ui/search.dart';
import 'package:verirent/features/settings/ui/cubit/settings_cubit.dart';
import 'package:verirent/features/settings/ui/pages/settings.dart';

import '../../features/auth/ui/pages/signup.dart';
import '../../features/home/ui/cubit/home_cubit.dart';
import '../../features/home/ui/pages/home.dart';
import '../../features/shell/ui/cubit/main_cubit.dart';
import '../../features/shell/ui/pages/shell.dart';

class _Route {
  static final String main = '/';
  static final String home = '/home';
  static final String auth = '/auth';
  static final String login = '/login';
  static final String search = "/search";
  static final String signup = "/signup";
  static final String profile = "/profile";
  static final String settings = "/settings";
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
            child: Home(scaffoldKey: scaffoldKey),
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

      // Auth Route
      GoRoute(
        name: "Auth",
        path: _Route.auth,
        builder: (context, state) {
          return SizedBox();
        },
        routes: [
          // Login
          GoRoute(
            path: _Route.login,
            name: "Login",
            pageBuilder: (context, state) => CustomTransitionPage(
              child: BlocProvider(
                create: (context) => GetIt.instance<AuthCubit>(),
                child: LoginPage(),
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

          // SignUp
          GoRoute(
            path: _Route.signup,
            name: "SignUp",
            pageBuilder: (context, state) => CustomTransitionPage(
              child: BlocProvider(
                create: (context) => GetIt.instance<AuthCubit>(),
                child: SignupPage(),
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
      ),

      //Search Route
      GoRoute(
        name: "Search",
        path: _Route.search,
        pageBuilder: (context, state) => CustomTransitionPage(
          child: BlocProvider(
            create: (context) => GetIt.instance<SearchCubit>(),
            child: SearchPage(),
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

      // Profile Route
      GoRoute(
        name: "Profile Page",
        path: _Route.profile,
        pageBuilder: (context, state) => CustomTransitionPage(
          child: BlocProvider(
            create: (context) => GetIt.instance<ProfileCubit>(),
            child: ProfilePage(),
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

      //Settings Page
      GoRoute(
        name: "Settings Page",
        path: _Route.settings,
        pageBuilder: (context, state) => CustomTransitionPage(
          child: BlocProvider(
            create: (context) => GetIt.instance<SettingsCubit>(),
            child: SettingsPage(),
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
