import 'package:go_router/go_router.dart';
import 'package:verirent/core/di/injection.dart';
import 'package:verirent/features/home/features/listing/ui/pages/listing_deatils.dart';
import 'package:verirent/features/router/route_transition/route_transition.dart';

import '../../../core/models/property/property_model.dart';
import '../route_path/route_paths.dart';

GoRoute detailsRoute() => GoRoute(
  name: "Details Page",
  path: RoutePaths.listingDetails,
  pageBuilder: (context, state) {
    final extra = state.extra as PropertyModel;
    return customTransitionPage(
      context: context,
      cubit: Dependencies.listingDetailsCubit,
      child: ListingDetailsFactory.build(context, extra),
    );
  },
);
