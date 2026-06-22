// =============================================================================
//  VeriRent NG — Messages Page
//  Chat thread list + individual chat screen, driven by MessagesCubit.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:verirent/core/shared/network_image/ui/pages/network_image.dart';
import 'package:verirent/core/shared/widgets/custom_search_bar.dart';
import 'package:verirent/core/shared/widgets/verifiedBadge.dart';

import '../../../../core/theme/agents_theme.dart';
import '../cubit/message_cubit.dart';
import '../cubit/message_state.dart';

Color messagesColor({required BuildContext context, required bool container}) {
  final ColorScheme cs = Theme.of(context).colorScheme;
  if (container == true) {
    return cs.brightness == Brightness.dark ? cs.secondary : cs.primary;
  }

  return cs.brightness == Brightness.dark ? cs.onSecondary : cs.onPrimary;
}

// =============================================================================
//  Entry Point
// =============================================================================

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ThreadListView();
  }
}

// =============================================================================
//  Thread List View
// =============================================================================

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
                  child: Center(child: CircularProgressIndicator()),
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
                              return _SectionLabel(label: 'Recent');
                            }
                            final thread = state.threads[i - 1];
                            final cubit = context.read<MessagesCubit>();
                            return _ThreadTile(
                              state: state,
                              thread: thread,
                              onLongPress: () {
                                cubit.toggleChatSelection(thread.id);
                              },
                              onTap: () {
                                HapticFeedback.selectionClick();
                                cubit.openChat(thread.id);
                                if (state.isSelected) {
                                  cubit.toggleChatSelection(thread.id);
                                } else {
                                  context.push(
                                    '/message/chat',
                                    extra: context.read<MessagesCubit>(),
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

// ── Thread Tile ────────────────────────────────────────────────────────────────

class _ThreadTile extends StatelessWidget {
  const _ThreadTile({
    required this.thread,
    required this.onTap,
    required this.onLongPress,
    required this.state,
  });
  final ChatThread thread;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final MessagesState state;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final hasUnread = thread.unreadCount > 0;

    return InkWell(
      onLongPress: onLongPress,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: state.selectedChatId.contains(thread.id)
              ? cs.brightness == Brightness.light
                    ? Theme.of(context).colorScheme.primaryContainer
                    : VeriRentColors.accent400.withValues(alpha: 0.3)
              : hasUnread
              ? cs.primaryContainer.withValues(alpha: 0.08)
              : Colors.transparent,
          border: Border(
            bottom: BorderSide(color: cs.outlineVariant, width: 0.5),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            // ── Avatar ──────────────────────────────────────────────
            state.selectedChatId.contains(thread.id)
                ? Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: thread.isVerifiedAgency
                          ? cs.primaryContainer
                          : cs.surfaceVariant,
                      shape: BoxShape.circle,
                      border: thread.isVerifiedAgency
                          ? Border.all(
                              color: cs.primary.withOpacity(0.4),
                              width: 1.5,
                            )
                          : null,
                    ),
                    child: Center(child: Icon(Icons.check)),
                  )
                : Stack(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: thread.isVerifiedAgency
                              ? cs.primaryContainer
                              : cs.surfaceVariant,
                          shape: BoxShape.circle,
                          border: thread.isVerifiedAgency
                              ? Border.all(
                                  color: cs.primary.withOpacity(0.4),
                                  width: 1.5,
                                )
                              : null,
                        ),
                        child: thread.avatarUrl != null
                            ? ClipOval(
                                child: CustomNetworkImage(
                                  imgUrl: thread.avatarUrl!,
                                ),
                              )
                            : Center(
                                child: Text(
                                  thread.initials,
                                  style: VeriRentText.titleSmall.copyWith(
                                    color: thread.isVerifiedAgency
                                        ? cs.primary
                                        : cs.onSurfaceVariant,
                                  ),
                                ),
                              ),
                      ),
                      // Online indicator
                      if (thread.isOnline)
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: VeriRentColors.green,
                              shape: BoxShape.circle,
                              border: Border.all(color: cs.surface, width: 2),
                            ),
                          ),
                        ),
                    ],
                  ),
            const SizedBox(width: 12),

            // ── Content ─────────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (thread.isVerifiedAgency) ...[
                        verifiedBadge(fontSize: 12),
                        const SizedBox(width: 4),
                      ],
                      Expanded(
                        child: Text(
                          thread.participantName,
                          style: VeriRentText.titleSmall.copyWith(
                            color: cs.onSurface,
                            fontWeight: hasUnread
                                ? FontWeight.w700
                                : FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        _formatTime(thread.lastMessageTime),
                        style: VeriRentText.bodySmall.copyWith(
                          color: hasUnread ? cs.primary : cs.onSurfaceVariant,
                          fontSize: 10,
                          fontWeight: hasUnread
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  if (thread.propertyTitle != null) ...[
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(
                          Icons.home_rounded,
                          size: 10,
                          color: cs.onSurfaceVariant,
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            thread.propertyTitle!,
                            style: VeriRentText.labelSmall.copyWith(
                              color: cs.primary.withOpacity(0.8),
                              fontSize: 10,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          thread.lastMessage,
                          style: VeriRentText.bodySmall.copyWith(
                            color: hasUnread
                                ? cs.onSurface
                                : cs.onSurfaceVariant,
                            fontWeight: hasUnread
                                ? FontWeight.w500
                                : FontWeight.w400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (hasUnread) ...[
                        const SizedBox(width: 8),
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: cs.brightness == Brightness.dark
                                ? cs.secondary
                                : cs.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${thread.unreadCount}',
                              style: VeriRentText.labelSmall.copyWith(
                                color: cs.brightness == Brightness.dark
                                    ? cs.onSecondary
                                    : cs.onPrimary,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays == 1) return 'Yesterday';
    return DateFormat('d MMM').format(dt);
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
      child: Text(
        label.toUpperCase(),
        style: VeriRentText.labelSmall.copyWith(
          color: cs.onSurfaceVariant,
          letterSpacing: 0.8,
        ),
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
