import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:verirent/features/router/routes/auth_route.dart';
import 'package:verirent/features/router/routes/detailsRoute.dart';
import 'package:verirent/features/router/routes/messageRoute.dart';
import 'package:verirent/features/router/routes/profile_route.dart';
import 'package:verirent/features/router/routes/savedRoute.dart';
import 'package:verirent/features/router/routes/searchRoute.dart';
import 'package:verirent/features/router/routes/seeAll_route.dart';
import 'package:verirent/features/router/routes/settings_route.dart';

import '../../core/di/injection.dart';
import '../../core/shared/location/ui/cubit/location_cubit.dart';
import 'route_path/route_paths.dart';
import 'routes/home_route.dart';
import 'routes/shell_route.dart';

abstract final class _Routes {
  static final _locationNotifier = _CubitListenable(Dependencies.locationCubit);
  static final GoRouter router = GoRouter(
    overridePlatformDefaultLocation: true,
    initialLocation: RoutePaths.main,
    refreshListenable: _locationNotifier,
    redirect: (context, state) {
      final locationState = Dependencies.locationCubit.state;
      final isMain = state.matchedLocation == RoutePaths.main;
      final isAuth = state.matchedLocation.startsWith(RoutePaths.auth);
      if (isMain || isAuth) return null;
      if (!locationState.isComplete) {
        return RoutePaths.main;
      }

      return null;
    },
    routes: [
      shell(),
      homeRoute(),
      seeAllRoute(),
      authRoute(),
      searchRoute(),
      profileRoute(),
      settingsRoute(),
      detailsRoute(),
      savedRoute(),
      messageRoute(),
    ],
  );
}

GoRouter get agentNgRoute => _Routes.router;

class _CubitListenable extends ChangeNotifier {
  _CubitListenable(LocationCubit cubit) {
    cubit.stream.listen((_) => notifyListeners());
  }
}
