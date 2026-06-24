import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../features/saved/ui/cubit/saved_cubit.dart';
import '../../../features/saved/ui/cubit/saved_state.dart';
import '../../models/property_model.dart';
import '../../theme/agents_theme.dart';

class SaveButton extends StatelessWidget {
  const SaveButton({super.key, required this.item, this.size = 28});

  final PropertyModel item;
  final double size;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: GetIt.I<SavedCubit>(),
      child: BlocBuilder<SavedCubit, SavedState>(
        builder: (context, state) {
          final isSaved = state.items.any((p) => p.id == item.id);

          return GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();

              if (isSaved) {
                context.read<SavedCubit>().removeSaved(item.id!);
              } else {
                context.read<SavedCubit>().addSaved(item);
              }
            },
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: VeriRentColors.black.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isSaved
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                size: size * .5,
                color: isSaved ? VeriRentColors.red : VeriRentColors.textMuted,
              ),
            ),
          );
        },
      ),
    );
  }
}
