import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:verirent/core/models/property_model.dart';
import 'package:verirent/core/repo/local_repo.dart';
import 'package:verirent/core/shared/widgets/verifiedBadge.dart';

import '../../../../../../core/theme/agents_theme.dart';
import '../../../../ui/cubit/message_cubit.dart';
import '../../../../ui/cubit/message_state.dart';

// =============================================================================
//  Chat View (single thread)
// =============================================================================

class ChatView extends StatefulWidget {
  final MessagesCubit messagesCubit;
  const ChatView({super.key, required this.messagesCubit});

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

    return BlocProvider.value(
      value: widget.messagesCubit,
      child: BlocConsumer<MessagesCubit, MessagesState>(
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
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

Future<PropertyModel?> _navigateToListingPage(String? propertyTitle) async {
  if (propertyTitle == null) return null;

  final properties = await GetIt.I<LocalRepository>().all();

  try {
    return properties.firstWhere(
      (p) => p.title?.trim() == propertyTitle.trim(),
    );
  } catch (_) {
    return null;
  }
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
    final property = _navigateToListingPage(thread.propertyTitle);

    return AppBar(
      backgroundColor: cs.surface,
      elevation: 0,
      scrolledUnderElevation: 1,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_rounded, color: cs.onSurface, size: 20),
        onPressed: () {
          context.pop();
          context.read<MessagesCubit>().closeChat();
        },
      ),
      title: GestureDetector(
        onTap: () {
          context.push('/listing_details', extra: property);
        },
        child: Row(
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
                          child: verifiedBadge(fontSize: 12),
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
