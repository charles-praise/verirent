import 'package:go_router/go_router.dart';
import 'package:verirent/core/di/injection.dart';
import 'package:verirent/features/router/route_transition/route_transition.dart';
import 'package:verirent/features/saved/ui/pages/saved.dart';

import '../route_path/route_paths.dart';

GoRoute savedRoute() => GoRoute(
  name: "Saved Page",
  path: RoutePaths.saved,
  pageBuilder: (context, state) {
    return customTransitionPage(
      context: context,
      cubit: Dependencies.savedCubit,
      child: SavedPage(),
    );
  },
);
