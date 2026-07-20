import 'package:go_router/go_router.dart';
import 'package:verirent/features/home/features/view/ui/pages/see_all.dart';
import 'package:verirent/features/router/route_args/view_all_chat_args.dart';
import 'package:verirent/features/router/route_transition/route_transition.dart';

import '../../../core/di/injection.dart';
import '../route_path/route_paths.dart';

GoRoute seeAllRoute() => GoRoute(
  path: RoutePaths.seeAll,
  name: "View All",
  pageBuilder: (context, state) {
    final extras = state.extra as ViewAllChatArgs;

    return customTransitionPage(
      context: context,
      cubit: Dependencies.seeAllCubit,
      child: SeeAllPage(
        properties: extras.properties,
        title: extras.text,
        category: extras.category,
      ),
    );
  },
);
