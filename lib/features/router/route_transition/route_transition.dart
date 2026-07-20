import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Creates a fade transition for each route
CustomTransitionPage customTransitionPage({
  required BuildContext context,
  required Cubit cubit,
  required Widget child,
}) => CustomTransitionPage(
  child: BlocProvider.value(value: cubit, child: child),
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
