/// ── Saved List Item ────────────────────────────────────────────────────────────
library;

import 'package:flutter/material.dart';
import 'package:verirent/core/models/property_model.dart';

import '../../../../core/shared/widgets/cylinder_listing_widget.dart';
import '../../../../core/theme/agents_theme.dart';

class SavedItems extends StatelessWidget {
  const SavedItems({
    super.key,
    required this.index,
    required this.item,
    required this.isRemoving,
    required this.onRemove,
    required this.onTap,
  });

  final List<PropertyModel> item;
  final int index;
  final bool isRemoving;
  final VoidCallback onRemove;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 280),
      opacity: isRemoving ? 0.0 : 1.0,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 280),
        offset: isRemoving ? const Offset(0.15, 0) : Offset.zero,
        child: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              SizedBox(
                height: 100,
                child: RecentCardFactory.build(context, item[index]),
              ),
              Positioned(
                top: -10,
                right: -5,
                child: GestureDetector(
                  onTap: onRemove,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: VeriRentColors.red.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      backgroundColor:
                          Theme.of(context).colorScheme.brightness ==
                              Brightness.dark
                          ? VeriRentColors.accent400
                          : VeriRentColors.primary50,
                      child: Icon(
                        Icons.close,
                        size: 16,
                        color: VeriRentColors.primary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
