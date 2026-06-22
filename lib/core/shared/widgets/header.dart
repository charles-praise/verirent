import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:verirent/core/shared/location/ui/cubit/location_cubit.dart';
import 'package:verirent/features/home/domain/entities/property_model.dart';

import '../../theme/agents_theme.dart';
import '../location/ui/cubit/location_state.dart';

// ---------------------------------------------------------------------------
//  Section header
// ---------------------------------------------------------------------------

class Header extends StatelessWidget {
  final EdgeInsets? padding;
  final bool? showSeeAll;

  const Header({
    super.key,
    required this.title,
    this.padding,
    this.showSeeAll,
    required this.listing,
  });

  final String title;
  final List<PropertyModel> listing;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: GetIt.I<LocationCubit>(),
      child: BlocBuilder<LocationCubit, LocationState>(
        builder: (context, locationState) {
          final cs = Theme.of(context).colorScheme;
          String text = '$title in ${locationState.selectedLga ?? "--"}';
          return Padding(
            padding:
                padding ??
                EdgeInsets.fromLTRB(
                  VeriRentSpacing.base,
                  VeriRentSpacing.base,
                  VeriRentSpacing.sm,
                  VeriRentSpacing.sm,
                ),
            child: Row(
              children: [
                Text(
                  text,
                  style: VeriRentText.headlineSmall.copyWith(
                    color: cs.onSurface,
                    fontSize: 13,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Spacer(),
                if (showSeeAll != null)
                  TextButton(
                    onPressed: () =>
                        context.push("/see_all", extra: [listing, text]),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: VeriRentSpacing.sm,
                      ),
                      minimumSize: const Size(0, 32),
                    ),
                    child: Text(
                      'View all',
                      style: VeriRentText.labelMedium.copyWith(
                        color: cs.primary,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
