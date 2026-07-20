// ── Thread Tile ────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:verirent/core/shared/custom_network_media/ui/pages/network_media.dart';

import '../../../../core/shared/widgets/verifiedBadge.dart';
import '../../../../core/theme/agents_theme.dart';
import '../cubit/message_state.dart';

class ThreadTile extends StatelessWidget {
  const ThreadTile({
    super.key,
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
                                child: CustomNetworkMedia(
                                  url: thread.avatarUrl!,
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
                        verifiedBadge(
                          fontSize: 12,
                          tierColor: thread.tierColor,
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

class SectionLabel extends StatelessWidget {
  const SectionLabel({super.key, required this.label});
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
