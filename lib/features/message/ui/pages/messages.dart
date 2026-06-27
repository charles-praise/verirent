// =============================================================================
//  VeriRent NG — Messages Page
//  Chat thread list + individual chat screen, driven by MessagesCubit.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:verirent/core/shared/widgets/custom_search_bar.dart';
import 'package:verirent/features/message/ui/widget/message_tile_shimmer.dart';

import '../../../../core/theme/agents_theme.dart';
import '../cubit/message_cubit.dart';
import '../cubit/message_state.dart';
import '../widget/message_threadTile.dart';

Color messagesColor({required BuildContext context, required bool container}) {
  final ColorScheme cs = Theme.of(context).colorScheme;
  if (container == true) {
    return cs.brightness == Brightness.dark ? cs.secondary : cs.primary;
  }

  return cs.brightness == Brightness.dark ? cs.onSecondary : cs.onPrimary;
}

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ThreadListView();
  }
}

class ThreadListView extends StatelessWidget {
  const ThreadListView({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.brightness == Brightness.light
          ? VeriRentColors.neutral50
          : VeriRentColors.neutral900,
      body: BlocBuilder<MessagesCubit, MessagesState>(
        builder: (context, state) {
          final TextEditingController textEditingController =
              TextEditingController();
          final FocusNode focusNode = FocusNode();
          return CustomScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            slivers: [
              // ── AppBar ────────────────────────────────────────────
              SliverAppBar(
                pinned: true,
                backgroundColor: cs.surface,
                elevation: 0,
                scrolledUnderElevation: 1,
                leading: state.isSelected
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          context.read<MessagesCubit>().clearSelection();
                        },
                      )
                    : null,

                title: state.isSelected
                    ? Text('${state.selectedChatId.length} selected')
                    : Text(
                        'Messages',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                bottom: PreferredSize(
                  preferredSize: Size(double.infinity, 50),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
                    child: CustomSearchBar(
                      controller: textEditingController,
                      focusNode: focusNode,
                      showFilter: false,
                    ),
                  ),
                ),

                actions: [
                  if (state.isSelected) ...[
                    IconButton(
                      icon: const Icon(Icons.mark_chat_read),
                      onPressed: () {
                        context.read<MessagesCubit>().markSelectedAsRead();
                      },
                    ),

                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () {
                        context.read<MessagesCubit>().deleteSelectedChats();
                      },
                    ),
                  ],
                ],
              ),

              // ── Content ───────────────────────────────────────────
              switch (state.status) {
                MessagesStatus.loading => const SliverFillRemaining(
                  child: ThreadTileShimmer(),
                ),
                MessagesStatus.error => SliverFillRemaining(
                  child: _MessagesError(message: state.errorMessage),
                ),
                _ =>
                  state.threads.isEmpty
                      ? const SliverFillRemaining(child: _EmptyMessages())
                      : SliverList(
                          delegate: SliverChildBuilderDelegate((ctx, i) {
                            if (i == 0) {
                              return SectionLabel(label: 'Recent');
                            }
                            final thread = state.threads[i - 1];
                            final cubit = context.read<MessagesCubit>();
                            return ThreadTile(
                              state: state,
                              thread: thread,
                              onLongPress: () {
                                cubit.toggleChatSelection(thread.id);
                              },
                              onTap: () async {
                                if (!context.mounted) return;
                                HapticFeedback.selectionClick();
                                final property = cubit.getPropertyForThread(
                                  thread,
                                );
                                cubit.openChat(thread.id);
                                if (state.isSelected) {
                                  cubit.toggleChatSelection(thread.id);
                                } else {
                                  final listing = await property;
                                  if (!context.mounted) return;
                                  context.push(
                                    '/message/chat',
                                    extra: [cubit, listing!],
                                  );
                                }
                              },
                            );
                          }, childCount: state.threads.length + 1),
                        ),
              },

              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          );
        },
      ),
    );
  }
}

// ── Empty / Error states ──────────────────────────────────────────────────────

class _EmptyMessages extends StatelessWidget {
  const _EmptyMessages();

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
                Icons.chat_bubble_outline_rounded,
                size: 36,
                color: cs.primary.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No messages yet',
              style: VeriRentText.headlineSmall.copyWith(color: cs.onSurface),
            ),
            const SizedBox(height: 8),
            Text(
              'When you contact an agency about a property, the conversation will appear here.',
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

class _MessagesError extends StatelessWidget {
  const _MessagesError({this.message});
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
              'Could not load messages',
              style: VeriRentText.headlineSmall.copyWith(color: cs.onSurface),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => context.read<MessagesCubit>().loadThreads(),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
