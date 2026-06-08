/// ── Saved List Item ────────────────────────────────────────────────────────────
library;

import 'package:flutter/material.dart';
import 'package:verirent/features/home/domain/entities/property_model.dart';
import 'package:verirent/features/home/ui/widgets/home_recent_listing.dart';

import '../../../../core/theme/agents_theme.dart';

class SavedListItem extends StatelessWidget {
  const SavedListItem({
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
          padding: const EdgeInsets.only(top: VeriRentSpacing.md),
          child: Stack(
            children: [
              SizedBox(
                height: 100,
                child: RecentCardFactory.build(context, item[index]),
              ),
              Positioned(
                bottom: 6,
                left: 6,
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
                      child: const Icon(
                        Icons.favorite_rounded,
                        size: 14,
                        color: VeriRentColors.red,
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
