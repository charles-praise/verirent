import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:verirent/core/models/property_model.dart';
import 'package:verirent/core/shared/location/ui/cubit/location_cubit.dart';

import '../../theme/agents_theme.dart';
import '../location/ui/cubit/location_state.dart';

class Header extends StatelessWidget {
  final EdgeInsets? padding;
  final bool? showSeeAll;

  const Header({
    super.key,
    this.padding,
    this.showSeeAll,
    required this.category,
  });

  final PropertyCategory category;

  String _titleFromCategory(PropertyCategory category) {
    switch (category) {
      case PropertyCategory.featured:
        return 'Featured Listings';

      case PropertyCategory.residential:
        return 'Residential';

      case PropertyCategory.land:
        return 'Land & Plots';

      case PropertyCategory.commercial:
        return 'Commercial';

      case PropertyCategory.estate:
        return 'Estates & Housing';

      case PropertyCategory.shortLet:
        return 'Short Lets';

      case PropertyCategory.recent:
        return 'Recently Added';

      case PropertyCategory.option:
        return 'Discount & Promotions';

      case PropertyCategory.all:
        return 'All Listings';

      case PropertyCategory.none:
        return 'Properties';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (category == PropertyCategory.none) {
      return const SizedBox.shrink();
    }

    return BlocProvider.value(
      value: GetIt.I<LocationCubit>(),
      child: BlocBuilder<LocationCubit, LocationState>(
        builder: (context, locationState) {
          final cs = Theme.of(context).colorScheme;

          final title = _titleFromCategory(category);

          final text =
              '$title in ${locationState.selectedLga ?? "invalid location"}';

          return Padding(
            padding:
                padding ??
                const EdgeInsets.fromLTRB(
                  VeriRentSpacing.base,
                  VeriRentSpacing.base,
                  VeriRentSpacing.sm,
                  VeriRentSpacing.sm,
                ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    text,
                    style: VeriRentText.headlineSmall.copyWith(
                      color: cs.onSurface,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                if (showSeeAll == true)
                  TextButton(
                    onPressed: () =>
                        context.push("/see_all", extra: [category, text]),
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
