import 'package:go_router/go_router.dart';
import 'package:verirent/core/di/injection.dart';
import 'package:verirent/features/router/route_transition/route_transition.dart';
import 'package:verirent/features/settings/ui/pages/settings.dart';

import '../route_path/route_paths.dart';

GoRoute settingsRoute() => GoRoute(
  name: "Settings Page",
  path: RoutePaths.settings,
  pageBuilder: (context, state) => customTransitionPage(
    context: context,
    cubit: Dependencies.settingsCubit,
    child: SettingsPage(),
  ),
);
