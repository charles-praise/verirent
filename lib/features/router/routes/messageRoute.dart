import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:verirent/features/message/ui/pages/messages.dart';
import 'package:verirent/features/router/route_args/chat_args.dart';
import 'package:verirent/features/router/route_transition/route_transition.dart';

import '../../../core/di/injection.dart';
import '../../message/features/chat/ui/pages/chat.dart';
import '../route_path/route_paths.dart';

GoRoute messageRoute() {
  return GoRoute(
    name: "Message Page",
    path: RoutePaths.message,
    pageBuilder: (context, state) {
      return customTransitionPage(
        context: context,
        cubit: Dependencies.messageCubit,
        child: MessagesPage(),
      );
    },
    routes: [
      // chat route
      GoRoute(
        name: "Chat Page",
        path: RoutePaths.chat,
        pageBuilder: (context, state) {
          final extras = state.extra as ChatRouteArgs;
          return CustomTransitionPage(
            child: ChatView(
              key: const ValueKey('chat'),
              messagesCubit: extras.cubit,
              property: extras.property,
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
          );
        },
      ),
    ],
  );
}
