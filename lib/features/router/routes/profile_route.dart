import 'package:go_router/go_router.dart';
import 'package:verirent/core/di/injection.dart';
import 'package:verirent/features/profile/ui/pages/profile.dart';
import 'package:verirent/features/router/route_transition/route_transition.dart';

import '../route_path/route_paths.dart';

GoRoute profileRoute() => GoRoute(
  name: "Profile Page",
  path: RoutePaths.profile,
  pageBuilder: (context, state) => customTransitionPage(
    context: context,
    cubit: Dependencies.profileCubit,
    child: ProfilePage(),
  ),
);
