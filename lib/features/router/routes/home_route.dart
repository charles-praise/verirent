import 'package:go_router/go_router.dart';
import 'package:verirent/features/home/ui/pages/home.dart';

import '../../../core/di/injection.dart';
import '../route_path/route_paths.dart';
import '../route_transition/route_transition.dart';

/// Navigate to the [HomeRoute]
GoRoute homeRoute() => GoRoute(
  name: "home",
  path: RoutePaths.home,
  pageBuilder: (context, state) => customTransitionPage(
    context: context,
    cubit: Dependencies.homeCubit,
    child: Home(scaffoldKey: null),
  ),
);
