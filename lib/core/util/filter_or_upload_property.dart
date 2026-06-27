import 'package:flutter/material.dart';

import '../shared/widgets/action_tile.dart';

Future<void> showCreateListingBottomSheet(
  BuildContext context, {
  required VoidCallback onOpenFilter,
  required VoidCallback onUploadProperty,
}) {
  final cs = Theme.of(context).colorScheme;

  return showModalBottomSheet(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: cs.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Choose Action',
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: 8),

            Text(
              'Filter listings or upload a new property.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            const SizedBox(height: 24),

            ActionTile(
              icon: Icons.tune_rounded,
              title: 'Open Filters',
              subtitle: 'Refine listings by price, location and features',
              onTap: () {
                Navigator.pop(context);
                onOpenFilter();
              },
            ),

            const SizedBox(height: 12),

            ActionTile(
              icon: Icons.add_home_work_rounded,
              title: 'Upload Property',
              subtitle: 'Create a new property listing',
              onTap: () {
                Navigator.pop(context);
                onUploadProperty();
              },
            ),
          ],
        ),
      );
    },
  );
}
