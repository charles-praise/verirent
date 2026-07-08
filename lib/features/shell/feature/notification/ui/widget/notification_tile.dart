import 'package:flutter/material.dart';
import 'package:verirent/features/shell/feature/notification/domain/notification_model.dart';

class NotificationTile extends StatelessWidget {
  final NotificationModel notificationModel;

  const NotificationTile({super.key, required this.notificationModel});

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
    return InkWell(
      onTap: () {
        // Handle notification tap
        Navigator.pop(context); // Close drawer
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: notificationModel.read
              ? null
              : Theme.of(
                  context,
                ).colorScheme.primaryContainer.withValues(alpha: 0.3),
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
                color: notificationModel.color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(
                  _getIcon(notificationModel.type),
                  color: notificationModel.color,
                  size: 22,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (!notificationModel.read)
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
                          notificationModel.title,
                          style: TextStyle(
                            fontWeight: notificationModel.read
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
                    notificationModel.message,
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
                        notificationModel.sender,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: notificationModel.color,
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
                        notificationModel.time,
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
