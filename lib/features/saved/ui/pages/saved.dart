// =============================================================================
//  VeriRent NG — Saved Listings Page
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/shared/network_image/ui/pages/network_image.dart';
import '../../../../core/theme/agents_theme.dart';
import '../../../home/ui/widgets/home_tier_badge.dart';
import '../cubit/saved_cubit.dart';
import '../cubit/saved_state.dart';

class SavedPage extends StatelessWidget {
  const SavedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<SavedCubit>()..loadSaved(),
      child: const _SavedView(),
    );
  }
}

class _SavedView extends StatelessWidget {
  const _SavedView();

  static const _filters = ['All', 'Rent', 'Sale', 'Verified'];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.brightness == Brightness.light
          ? VeriRentColors.neutral50
          : VeriRentColors.neutral900,
      body: BlocBuilder<SavedCubit, SavedState>(
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              // ── App Bar ────────────────────────────────────────────────
              SliverAppBar(
                pinned: true,
                backgroundColor: cs.surface,
                elevation: 0,
                scrolledUnderElevation: 1,
                title: Text(
                  'Saved',
                  style: VeriRentText.headlineMedium.copyWith(
                    color: cs.onSurface,
                  ),
                ),
                actions: [
                  if (state.status == SavedStatus.loaded &&
                      state.items.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: cs.primaryContainer.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(
                            VeriRentRadius.full,
                          ),
                        ),
                        child: Text(
                          '${state.items.length} saved',
                          style: VeriRentText.labelSmall.copyWith(
                            color: cs.primary,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              // ── Filter chips ──────────────────────────────────────────
              if (state.status == SavedStatus.loaded ||
                  state.status == SavedStatus.loading)
                SliverToBoxAdapter(
                  child: _FilterRow(
                    filters: _filters,
                    activeIndex: state.activeFilterIndex,
                    onTap: (i) {
                      HapticFeedback.selectionClick();
                      context.read<SavedCubit>().setFilter(i);
                    },
                  ),
                ),

              // ── Body content ───────────────────────────────────────────
              switch (state.status) {
                SavedStatus.loading => const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                ),
                SavedStatus.error => SliverFillRemaining(
                  child: _ErrorView(message: state.errorMessage),
                ),
                SavedStatus.empty => const SliverFillRemaining(
                  child: _EmptyView(),
                ),
                _ =>
                  state.filteredItems.isEmpty
                      ? const SliverFillRemaining(child: _EmptyFilterView())
                      : SliverPadding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate((ctx, i) {
                              final item = state.filteredItems[i];
                              return _SavedListItem(
                                key: ValueKey(item.id),
                                item: item,
                                isRemoving: state.removingIds.contains(item.id),
                                onRemove: () {
                                  HapticFeedback.mediumImpact();
                                  context.read<SavedCubit>().removeSaved(
                                    item.id!,
                                  );
                                },
                                onTap: () => context.push(
                                  '/listing_details',
                                  extra: item,
                                ),
                              );
                            }, childCount: state.filteredItems.length),
                          ),
                        ),
              },
            ],
          );
        },
      ),
    );
  }
}

// ── Filter Row ─────────────────────────────────────────────────────────────────

class _FilterRow extends StatelessWidget {
  const _FilterRow({
    required this.filters,
    required this.activeIndex,
    required this.onTap,
  });
  final List<String> filters;
  final int activeIndex;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      color: cs.surface,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(filters.length, (i) {
            final active = i == activeIndex;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => onTap(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: active ? cs.primary : cs.surfaceVariant,
                    borderRadius: BorderRadius.circular(VeriRentRadius.full),
                    border: Border.all(
                      color: active ? cs.primary : cs.outlineVariant,
                    ),
                  ),
                  child: Text(
                    filters[i],
                    style: VeriRentText.labelMedium.copyWith(
                      color: active ? cs.onPrimary : cs.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

// ── Saved List Item ────────────────────────────────────────────────────────────

class _SavedListItem extends StatelessWidget {
  const _SavedListItem({
    super.key,
    required this.item,
    required this.isRemoving,
    required this.onRemove,
    required this.onTap,
  });

  final dynamic item; // PropertyModel
  final bool isRemoving;
  final VoidCallback onRemove;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 280),
      opacity: isRemoving ? 0.0 : 1.0,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 280),
        offset: isRemoving ? const Offset(0.15, 0) : Offset.zero,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(VeriRentRadius.lg),
                border: Border.all(
                  color: item.isVerified
                      ? VeriRentColors.primary.withOpacity(0.3)
                      : cs.outlineVariant,
                  width: item.isVerified ? 1.5 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: cs.shadow.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Image ─────────────────────────────────────────
                  ClipRRect(
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(VeriRentRadius.lg),
                    ),
                    child: Stack(
                      children: [
                        SizedBox(
                          width: 110,
                          height: 120,
                          child: CustomNetworkImage(
                            imgUrl: item.imageUrls.first,
                          ),
                        ),
                        if (item.isVerified)
                          Positioned(
                            top: 7,
                            left: 7,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: VeriRentColors.success500,
                                borderRadius: BorderRadius.circular(
                                  VeriRentRadius.full,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.verified_rounded,
                                    size: 8,
                                    color: VeriRentColors.white,
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    'Verified',
                                    style: VeriRentText.labelSmall.copyWith(
                                      color: VeriRentColors.white,
                                      fontSize: 8,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // ── Details ───────────────────────────────────────
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title + remove button
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  item.title,
                                  style: VeriRentText.titleSmall.copyWith(
                                    color: cs.onSurface,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: onRemove,
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: VeriRentColors.red.withOpacity(0.08),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.favorite_rounded,
                                    size: 14,
                                    color: VeriRentColors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),

                          // Location
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_rounded,
                                size: 11,
                                color: cs.onSurfaceVariant,
                              ),
                              const SizedBox(width: 3),
                              Expanded(
                                child: Text(
                                  item.location,
                                  style: VeriRentText.bodySmall.copyWith(
                                    color: cs.onSurfaceVariant,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Stats row
                          if (item.bedrooms > 0)
                            Row(
                              children: [
                                _MiniStat(
                                  icon: Icons.bed_rounded,
                                  label: '${item.bedrooms}bd',
                                ),
                                const SizedBox(width: 6),
                                _MiniStat(
                                  icon: Icons.bathtub_outlined,
                                  label: '${item.bathrooms}bth',
                                ),
                                const SizedBox(width: 6),
                                _MiniStat(
                                  icon: Icons.square_foot_rounded,
                                  label: '${item.areaSqm}m²',
                                ),
                              ],
                            ),
                          if (item.bedrooms > 0) const SizedBox(height: 8),

                          // Price + tier
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '₦ ${item.price}',
                                    style: VeriRentText.titleSmall.copyWith(
                                      color: cs.primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    item.listingType == 'rent'
                                        ? 'per year'
                                        : 'asking price',
                                    style: VeriRentText.bodySmall.copyWith(
                                      color: cs.onSurfaceVariant,
                                      fontSize: 9,
                                    ),
                                  ),
                                ],
                              ),
                              TierBadge(
                                label: item.tierLabel
                                    .replaceAll(' Agency', '')
                                    .replaceAll(' Individual', ''),
                                color: item.tierColor,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 10, color: cs.onSurfaceVariant),
        const SizedBox(width: 3),
        Text(
          label,
          style: VeriRentText.labelSmall.copyWith(
            color: cs.onSurfaceVariant,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

// ── Empty / Error states ──────────────────────────────────────────────────────

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: cs.primaryContainer.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.favorite_border_rounded,
                size: 36,
                color: cs.primary.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No saved listings yet',
              style: VeriRentText.headlineSmall.copyWith(color: cs.onSurface),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the heart icon on any listing to save it here for easy access.',
              style: VeriRentText.bodyMedium.copyWith(
                color: cs.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyFilterView extends StatelessWidget {
  const _EmptyFilterView();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.filter_list_off_rounded,
              size: 48,
              color: cs.onSurfaceVariant.withOpacity(0.4),
            ),
            const SizedBox(height: 16),
            Text(
              'No listings match this filter',
              style: VeriRentText.bodyLarge.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({this.message});
  final String? message;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded, size: 48, color: cs.error),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: VeriRentText.headlineSmall.copyWith(color: cs.onSurface),
            ),
            if (message != null) ...[
              const SizedBox(height: 8),
              Text(
                message!,
                style: VeriRentText.bodySmall.copyWith(
                  color: cs.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => context.read<SavedCubit>().loadSaved(),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
