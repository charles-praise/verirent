import 'package:go_router/go_router.dart';
import 'package:verirent/core/di/injection.dart';
import 'package:verirent/features/router/route_transition/route_transition.dart';
import 'package:verirent/features/search/ui/pages/search.dart';

import '../route_path/route_paths.dart';

GoRoute searchRoute() => GoRoute(
  name: "Search",
  path: RoutePaths.search,
  pageBuilder: (context, state) => customTransitionPage(
    context: context,
    cubit: Dependencies.searchCubit,
    child: SearchPage(),
  ),
);
