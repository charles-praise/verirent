// Shell Route
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:verirent/features/shell/ui/pages/shell.dart';

import '../../../core/di/injection.dart';
import '../route_path/route_paths.dart';
import '../route_transition/route_transition.dart';

/// Navigate to the [ShellRoute]
GoRoute shell() => GoRoute(
  name: "Shell or Landing page",
  path: RoutePaths.main,
  pageBuilder: (context, state) => customTransitionPage(
    context: context,
    cubit: Dependencies.main,
    child: MultiBlocProvider(
      providers: [
        BlocProvider.value(value: Dependencies.locationCubit),
        BlocProvider.value(value: Dependencies.authCubit),
        BlocProvider.value(value: Dependencies.main),
      ],
      child: Main(),
    ),
  ),
);
