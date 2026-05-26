import 'package:flutter/material.dart';

class NotificationDrawer extends StatelessWidget {
  const NotificationDrawer({super.key});

  // Dummy professional notifications data
  final List<Map<String, dynamic>> notifications = const [
    {
      "id": 1,
      "title": "Project Deadline Approaching",
      "message":
          "Q2 Marketing Campaign deliverables are due in 2 days. Please review the final assets.",
      "time": "2 min ago",
      "type": "urgent",
      "read": false,
      "sender": "Project Manager",
      "avatar": "PM",
      "color": 0xFFFF6B6B,
    },
    {
      "id": 2,
      "title": "Meeting Invitation",
      "message":
          "You have been invited to the Engineering Sync at 3:00 PM in Conference Room B.",
      "time": "15 min ago",
      "type": "meeting",
      "read": false,
      "sender": "Sarah Chen",
      "avatar": "SC",
      "color": 0xFF4ECDC4,
    },
    {
      "id": 3,
      "title": "Code Review Request",
      "message":
          "Alex requested your review on PR #2847: 'Implement OAuth2 authentication flow'.",
      "time": "1 hour ago",
      "type": "review",
      "read": false,
      "sender": "Alex Rivera",
      "avatar": "AR",
      "color": 0xFF45B7D1,
    },
    {
      "id": 4,
      "title": "Deployment Successful",
      "message":
          "Production deployment v2.4.1 completed successfully. All health checks passed.",
      "time": "3 hours ago",
      "type": "success",
      "read": true,
      "sender": "DevOps Bot",
      "avatar": "DB",
      "color": 0xFF96CEB4,
    },
    {
      "id": 5,
      "title": "New Team Member",
      "message":
          "Emily Watson has joined the Design team. Welcome them to the workspace!",
      "time": "5 hours ago",
      "type": "info",
      "read": true,
      "sender": "HR Portal",
      "avatar": "HR",
      "color": 0xFFFFEAA7,
    },
    {
      "id": 6,
      "title": "Budget Approval Required",
      "message":
          "Q3 infrastructure budget needs your approval. Total: \$12,500 for cloud services.",
      "time": "Yesterday",
      "type": "action",
      "read": false,
      "sender": "Finance Team",
      "avatar": "FT",
      "color": 0xFFDDA0DD,
    },
    {
      "id": 7,
      "title": "Security Alert",
      "message":
          "Unusual login detected from IP 203.145.67.89 in Singapore. Verify this was you.",
      "time": "Yesterday",
      "type": "security",
      "read": false,
      "sender": "Security Center",
      "avatar": "SC",
      "color": 0xFFFF7675,
    },
    {
      "id": 8,
      "title": "Weekly Report Generated",
      "message":
          "Your weekly performance summary is ready. Click to view detailed analytics.",
      "time": "2 days ago",
      "type": "report",
      "read": true,
      "sender": "Analytics Bot",
      "avatar": "AB",
      "color": 0xFF74B9FF,
    },
    {
      "id": 9,
      "title": "Sprint Planning Reminder",
      "message":
          "Sprint 24 planning session starts tomorrow at 10:00 AM. Please update your backlog items.",
      "time": "2 days ago",
      "type": "reminder",
      "read": true,
      "sender": "Scrum Master",
      "avatar": "SM",
      "color": 0xFFA29BFE,
    },
    {
      "id": 10,
      "title": "Client Feedback Received",
      "message":
          "Acme Corp provided feedback on the latest prototype. 4 items need addressing.",
      "time": "3 days ago",
      "type": "feedback",
      "read": true,
      "sender": "Client Portal",
      "avatar": "CP",
      "color": 0xFFFD79A8,
    },
  ];

  IconData _getIcon(String type) {
    switch (type) {
      case 'urgent':
        return Icons.warning_amber_rounded;
      case 'meeting':
        return Icons.calendar_today_rounded;
      case 'review':
        return Icons.code_rounded;
      case 'success':
        return Icons.check_circle_rounded;
      case 'info':
        return Icons.person_add_alt_1_rounded;
      case 'action':
        return Icons.attach_money_rounded;
      case 'security':
        return Icons.security_rounded;
      case 'report':
        return Icons.assessment_rounded;
      case 'reminder':
        return Icons.event_note_rounded;
      case 'feedback':
        return Icons.feedback_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = notifications.where((n) => !n['read']).length;

    return Drawer(
      width: 380,
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).dividerColor.withOpacity(0.1),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Notifications',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$unreadCount unread',
                        style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          // Mark all as read
                        },
                        child: const Text('Mark all read'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.settings_outlined, size: 20),
                        onPressed: () {
                          // Settings
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Filter chips
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _FilterChip(
                      label: 'All',
                      selected: true,
                      count: notifications.length,
                    ),
                    _FilterChip(
                      label: 'Unread',
                      selected: false,
                      count: unreadCount,
                    ),
                    _FilterChip(label: 'Mentions', selected: false, count: 2),
                    _FilterChip(label: 'System', selected: false, count: 4),
                  ],
                ),
              ),
            ),

            // Notification list
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: notifications.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, indent: 68),
                itemBuilder: (context, index) {
                  final n = notifications[index];
                  return _NotificationTile(
                    title: n['title'],
                    message: n['message'],
                    time: n['time'],
                    sender: n['sender'],
                    avatar: n['avatar'],
                    color: Color(n['color']),
                    icon: _getIcon(n['type']),
                    isRead: n['read'],
                  );
                },
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Theme.of(context).dividerColor.withOpacity(0.1),
                  ),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.history),
                  label: const Text('View Notification History'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Supporting Widgets ──

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final int count;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text('$label ($count)'),
        backgroundColor: selected
            ? Theme.of(context).colorScheme.primaryContainer
            : Theme.of(context).colorScheme.surfaceContainerHighest,
        side: selected ? null : BorderSide.none,
        labelStyle: TextStyle(
          fontSize: 12,
          fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          color: selected
              ? Theme.of(context).colorScheme.onPrimaryContainer
              : Theme.of(context).hintColor,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final String title;
  final String message;
  final String time;
  final String sender;
  final String avatar;
  final Color color;
  final IconData icon;
  final bool isRead;

  const _NotificationTile({
    required this.title,
    required this.message,
    required this.time,
    required this.sender,
    required this.avatar,
    required this.color,
    required this.icon,
    required this.isRead,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Handle notification tap
        Navigator.pop(context); // Close drawer
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: isRead
              ? null
              : Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar with icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(child: Icon(icon, color: color, size: 22)),
            ),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (!isRead)
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontWeight: isRead
                                ? FontWeight.w500
                                : FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).hintColor,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        sender,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: color,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 3,
                        height: 3,
                        decoration: BoxDecoration(
                          color: Theme.of(context).hintColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: 11,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
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
}
