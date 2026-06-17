// developer: charles praise diepriye

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/agents_theme.dart';
import '../cubit/saved_cubit.dart';
import '../cubit/saved_state.dart';
import '../widget/saved_listing_item.dart';

class SavedPage extends StatelessWidget {
  const SavedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _SavedView();
  }
}

class _SavedView extends StatelessWidget {
  const _SavedView();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.brightness == Brightness.light
          ? VeriRentColors.neutral50
          : VeriRentColors.neutral900,
      body: BlocProvider(
        create: (context) => GetIt.I<SavedCubit>(),
        child: BlocBuilder<SavedCubit, SavedState>(
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
                    if (state.items.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.delete_sweep_rounded),
                        onPressed: () async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Clear Saved Listings'),
                              content: const Text('Remove all saved listings?'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text('Cancel'),
                                ),
                                FilledButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Clear'),
                                ),
                              ],
                            ),
                          );

                          if (confirmed == true && context.mounted) {
                            context.read<SavedCubit>().removeAllSaved();
                          }
                        },
                      ),
                  ],
                ),

                // ── Filter chips ──────────────────────────────────────────
                if (state.status == SavedStatus.loaded ||
                    state.status == SavedStatus.loading)
                  SliverToBoxAdapter(
                    child: _FilterRow(
                      filters: state.filters,
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
                                return SavedListItem(
                                  index: i,
                                  key: ValueKey(state.filteredItems[i]),
                                  item: state.filteredItems,
                                  isRemoving: state.removingIds.contains(
                                    state.filteredItems[i].id,
                                  ),
                                  onRemove: () {
                                    HapticFeedback.mediumImpact();
                                    context.read<SavedCubit>().removeSaved(
                                      state.filteredItems[i].id!,
                                    );
                                  },
                                  onTap: () => context.push(
                                    '/listing_details',
                                    extra: state.filteredItems[i],
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
                    color: active
                        ? cs.brightness == Brightness.light
                              ? cs.primary
                              : cs.secondary
                        : cs.surfaceVariant,
                    borderRadius: BorderRadius.circular(VeriRentRadius.full),
                    border: Border.all(
                      color: active
                          ? cs.brightness == Brightness.light
                                ? cs.primary
                                : cs.secondary
                          : cs.outlineVariant,
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
