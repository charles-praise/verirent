// =============================================================================
//  VeriRent NG — Messages Page
//  Chat thread list + individual chat screen, driven by MessagesCubit.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/agents_theme.dart';
import '../cubit/message_cubit.dart';
import '../cubit/message_state.dart';

// =============================================================================
//  Entry Point
// =============================================================================

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<MessagesCubit>()..loadThreads(),
      child: const _MessagesShell(),
    );
  }
}

/// Switches between ThreadListView ↔ ChatView without a route change.
class _MessagesShell extends StatelessWidget {
  const _MessagesShell();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessagesCubit, MessagesState>(
      buildWhen: (prev, curr) => prev.activeChatId != curr.activeChatId,
      builder: (context, state) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (child, anim) => SlideTransition(
            position:
                Tween<Offset>(
                  begin: state.activeChatId != null
                      ? const Offset(1, 0)
                      : const Offset(-1, 0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(parent: anim, curve: Curves.easeInOutCubic),
                ),
            child: child,
          ),
          child: state.activeChatId == null
              ? const ThreadListView(key: ValueKey('list'))
              : const ChatView(key: ValueKey('chat')),
        );
      },
    );
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
          return CustomScrollView(
            slivers: [
              // ── AppBar ────────────────────────────────────────────
              SliverAppBar(
                pinned: true,
                backgroundColor: cs.surface,
                elevation: 0,
                scrolledUnderElevation: 1,
                title: Row(
                  children: [
                    Text(
                      'Messages',
                      style: VeriRentText.headlineMedium.copyWith(
                        color: cs.onSurface,
                      ),
                    ),
                    if (state.totalUnread > 0) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: cs.primary,
                          borderRadius: BorderRadius.circular(
                            VeriRentRadius.full,
                          ),
                        ),
                        child: Text(
                          '${state.totalUnread}',
                          style: VeriRentText.labelSmall.copyWith(
                            color: cs.onPrimary,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      Icons.edit_note_sharp,
                      color: cs.primary,
                      size: 22,
                    ),
                    onPressed: () {},
                    tooltip: 'New message',
                  ),
                ],
              ),

              // ── Search bar ────────────────────────────────────────
              SliverToBoxAdapter(
                child: Container(
                  color: cs.surface,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: SearchBar(
                    hintText: 'Search messages...',
                    leading: Icon(
                      Icons.search_rounded,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ),
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
                            return _ThreadTile(
                              thread: thread,
                              onTap: () {
                                HapticFeedback.selectionClick();
                                context.read<MessagesCubit>().openChat(
                                  thread.id,
                                );
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
  const _ThreadTile({required this.thread, required this.onTap});
  final ChatThread thread;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final hasUnread = thread.unreadCount > 0;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: hasUnread
              ? cs.primaryContainer.withOpacity(0.08)
              : Colors.transparent,
          border: Border(
            bottom: BorderSide(color: cs.outlineVariant, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            // ── Avatar ──────────────────────────────────────────────
            Stack(
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
                          child: Image.network(
                            thread.avatarUrl!,
                            fit: BoxFit.cover,
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
                        Icon(
                          Icons.verified_rounded,
                          size: 12,
                          color: cs.primary,
                        ),
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
                            color: cs.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${thread.unreadCount}',
                              style: VeriRentText.labelSmall.copyWith(
                                color: cs.onPrimary,
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

// =============================================================================
//  Chat View (single thread)
// =============================================================================

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return BlocConsumer<MessagesCubit, MessagesState>(
      listenWhen: (prev, curr) =>
          prev.activeThread?.messages.length !=
          curr.activeThread?.messages.length,
      listener: (_, __) => _scrollToBottom(),
      builder: (context, state) {
        final thread = state.activeThread;
        if (thread == null) return const SizedBox.shrink();

        return Scaffold(
          backgroundColor: cs.brightness == Brightness.light
              ? VeriRentColors.neutral50
              : VeriRentColors.neutral900,
          appBar: _ChatAppBar(thread: thread),
          body: Column(
            children: [
              // ── Property context banner ──────────────────────────
              if (thread.propertyTitle != null)
                _PropertyContextBanner(title: thread.propertyTitle!),

              // ── Messages list ────────────────────────────────────
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  itemCount: thread.messages.length,
                  itemBuilder: (_, i) {
                    final msg = thread.messages[i];
                    final prevMsg = i > 0 ? thread.messages[i - 1] : null;
                    final showDateSeparator =
                        prevMsg == null ||
                        !_isSameDay(prevMsg.timestamp, msg.timestamp);

                    return Column(
                      children: [
                        if (showDateSeparator)
                          _DateSeparator(date: msg.timestamp),
                        _MessageBubble(
                          message: msg,
                          isLastInGroup:
                              i == thread.messages.length - 1 ||
                              thread.messages[i + 1].senderId != msg.senderId,
                        ),
                      ],
                    );
                  },
                ),
              ),

              // ── Composer ─────────────────────────────────────────
              _MessageComposer(
                controller: _controller,
                focusNode: _focusNode,
                isSending: state.isSending,
                onChanged: (v) =>
                    context.read<MessagesCubit>().updateComposingText(v),
                onSend: () {
                  HapticFeedback.lightImpact();
                  context.read<MessagesCubit>().sendMessage();
                  _controller.clear();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

// ── Chat App Bar ───────────────────────────────────────────────────────────────

class _ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _ChatAppBar({required this.thread});
  final ChatThread thread;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AppBar(
      backgroundColor: cs.surface,
      elevation: 0,
      scrolledUnderElevation: 1,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_rounded, color: cs.onSurface, size: 20),
        onPressed: () => context.read<MessagesCubit>().closeChat(),
      ),
      title: Row(
        children: [
          // Avatar
          Stack(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: thread.isVerifiedAgency
                      ? cs.primaryContainer
                      : cs.surfaceVariant,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    thread.initials,
                    style: VeriRentText.labelMedium.copyWith(
                      color: thread.isVerifiedAgency
                          ? cs.primary
                          : cs.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
              if (thread.isOnline)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: VeriRentColors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: cs.surface, width: 1.5),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (thread.isVerifiedAgency)
                      Padding(
                        padding: const EdgeInsets.only(right: 3),
                        child: Icon(
                          Icons.verified_rounded,
                          size: 12,
                          color: cs.primary,
                        ),
                      ),
                    Flexible(
                      child: Text(
                        thread.participantName,
                        style: VeriRentText.titleSmall.copyWith(
                          color: cs.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Text(
                  thread.isOnline ? 'Online' : thread.participantRole,
                  style: VeriRentText.bodySmall.copyWith(
                    color: thread.isOnline
                        ? VeriRentColors.green
                        : cs.onSurfaceVariant,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.call_rounded, color: cs.primary, size: 22),
          onPressed: () {},
          tooltip: 'Call',
        ),
        IconButton(
          icon: Icon(
            Icons.more_vert_rounded,
            color: cs.onSurfaceVariant,
            size: 22,
          ),
          onPressed: () {},
          tooltip: 'More options',
        ),
      ],
    );
  }
}

// ── Property Context Banner ────────────────────────────────────────────────────

class _PropertyContextBanner extends StatelessWidget {
  const _PropertyContextBanner({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: cs.primaryContainer.withOpacity(0.3),
      child: Row(
        children: [
          Icon(Icons.home_rounded, size: 14, color: cs.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: VeriRentText.labelSmall.copyWith(color: cs.primary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Icon(
            Icons.open_in_new_rounded,
            size: 12,
            color: cs.primary.withOpacity(0.7),
          ),
        ],
      ),
    );
  }
}

// ── Message Bubble ─────────────────────────────────────────────────────────────

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message, required this.isLastInGroup});

  final ChatMessage message;
  final bool isLastInGroup;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    if (message.isSystem) return _SystemMessage(text: message.text);

    final isMe = message.isMe;

    return Padding(
      padding: EdgeInsets.only(top: 2, bottom: isLastInGroup ? 8 : 2),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Incoming: avatar placeholder (only on last in group)
          if (!isMe) ...[
            if (isLastInGroup)
              Container(
                width: 24,
                height: 24,
                margin: const EdgeInsets.only(right: 6, bottom: 2),
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.business_rounded,
                    size: 12,
                    color: cs.primary,
                  ),
                ),
              )
            else
              const SizedBox(width: 30),
          ],

          // Bubble
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.72,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isMe ? cs.primary : cs.surface,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(VeriRentRadius.lg),
                  topRight: const Radius.circular(VeriRentRadius.lg),
                  bottomLeft: Radius.circular(
                    isMe
                        ? VeriRentRadius.lg
                        : (isLastInGroup ? 4 : VeriRentRadius.lg),
                  ),
                  bottomRight: Radius.circular(
                    isMe
                        ? (isLastInGroup ? 4 : VeriRentRadius.lg)
                        : VeriRentRadius.lg,
                  ),
                ),
                border: isMe
                    ? null
                    : Border.all(color: cs.outlineVariant, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: cs.shadow.withOpacity(0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: isMe
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: VeriRentText.bodyMedium.copyWith(
                      color: isMe ? cs.onPrimary : cs.onSurface,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        DateFormat('h:mm a').format(message.timestamp),
                        style: VeriRentText.bodySmall.copyWith(
                          color: isMe
                              ? cs.onPrimary.withOpacity(0.7)
                              : cs.onSurfaceVariant,
                          fontSize: 10,
                        ),
                      ),
                      if (isMe) ...[
                        const SizedBox(width: 4),
                        _StatusIcon(status: message.status),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusIcon extends StatelessWidget {
  const _StatusIcon({required this.status});
  final MessageStatus status;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return switch (status) {
      MessageStatus.sent => Icon(
        Icons.check_rounded,
        size: 12,
        color: cs.onPrimary.withOpacity(0.6),
      ),
      MessageStatus.delivered => Icon(
        Icons.done_all_rounded,
        size: 12,
        color: cs.onPrimary.withOpacity(0.6),
      ),
      MessageStatus.read => Icon(
        Icons.done_all_rounded,
        size: 12,
        color: VeriRentColors.gold,
      ),
    };
  }
}

class _SystemMessage extends StatelessWidget {
  const _SystemMessage({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: cs.surfaceVariant,
            borderRadius: BorderRadius.circular(VeriRentRadius.full),
          ),
          child: Text(
            text,
            style: VeriRentText.bodySmall.copyWith(
              color: cs.onSurfaceVariant,
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

// ── Date Separator ─────────────────────────────────────────────────────────────

class _DateSeparator extends StatelessWidget {
  const _DateSeparator({required this.date});
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final now = DateTime.now();
    final diff = now.difference(date).inDays;
    final label = diff == 0
        ? 'Today'
        : diff == 1
        ? 'Yesterday'
        : DateFormat('MMMM d, yyyy').format(date);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(child: Divider(color: cs.outlineVariant, thickness: 0.5)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              label,
              style: VeriRentText.labelSmall.copyWith(
                color: cs.onSurfaceVariant,
                fontSize: 10,
              ),
            ),
          ),
          Expanded(child: Divider(color: cs.outlineVariant, thickness: 0.5)),
        ],
      ),
    );
  }
}

// ── Message Composer ──────────────────────────────────────────────────────────

class _MessageComposer extends StatelessWidget {
  const _MessageComposer({
    required this.controller,
    required this.focusNode,
    required this.isSending,
    required this.onChanged,
    required this.onSend,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isSending;
  final void Function(String) onChanged;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.fromLTRB(
        12,
        10,
        12,
        10 + MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(top: BorderSide(color: cs.outlineVariant, width: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Attachment button
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: cs.surfaceVariant,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.attach_file_rounded,
              color: cs.onSurfaceVariant,
              size: 18,
            ),
          ),
          const SizedBox(width: 8),

          // Text field
          Expanded(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 120),
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                onChanged: onChanged,
                style: VeriRentText.bodyMedium.copyWith(color: cs.onSurface),
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: VeriRentText.bodyMedium.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                  filled: true,
                  fillColor: cs.surfaceVariant,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(VeriRentRadius.xl),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(VeriRentRadius.xl),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(VeriRentRadius.xl),
                    borderSide: BorderSide(color: cs.primary, width: 1.5),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Send button
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isSending ? cs.primary.withOpacity(0.5) : cs.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: cs.primary.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: GestureDetector(
              onTap: isSending ? null : onSend,
              child: isSending
                  ? Padding(
                      padding: const EdgeInsets.all(10),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: cs.onPrimary,
                      ),
                    )
                  : Icon(Icons.send_rounded, color: cs.onPrimary, size: 18),
            ),
          ),
        ],
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
