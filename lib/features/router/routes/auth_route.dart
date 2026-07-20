import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:verirent/features/auth/ui/pages/login.dart';
import 'package:verirent/features/auth/ui/pages/signup.dart';
import 'package:verirent/features/home/features/listing/ui/pages/create_listing.dart';
import 'package:verirent/features/router/route_transition/route_transition.dart';

import '../../../core/di/injection.dart';
import '../route_path/route_paths.dart';

GoRoute authRoute() {
  return GoRoute(
    name: "Auth",
    path: RoutePaths.auth,
    builder: (context, state) {
      return SizedBox();
    },
    routes: [
      // Login
      GoRoute(
        path: RoutePaths.login,
        name: "Login",
        pageBuilder: (context, state) => customTransitionPage(
          context: context,
          cubit: Dependencies.authCubit,
          child: LoginPage(),
        ),
      ),

      // SignUp
      GoRoute(
        path: RoutePaths.signup,
        name: "SignUp",
        pageBuilder: (context, state) => customTransitionPage(
          context: context,
          cubit: Dependencies.authCubit,
          child: SignupPage(),
        ),
      ),

      // Create Listing
      GoRoute(
        path: RoutePaths.uploadProperty,
        name: "Upload Property",
        pageBuilder: (context, state) => customTransitionPage(
          context: context,
          cubit: Dependencies.authCubit,
          child: CreateListingPage(),
        ),
      ),
    ],
  );
}
