part of 'notification_cubit.dart';

enum NotificationPhase { initial, loading, loaded, error, empty }

enum NotificationFilterType { all, unread, mentions, system }

class NotificationState extends Equatable {
  final NotificationPhase phase;
  final String errorMessage;
  final List<NotificationModel> notifications;
  final NotificationFilterType filter;

  const NotificationState({
    this.phase = NotificationPhase.initial,
    this.notifications = const [],
    this.errorMessage = "",
    this.filter = NotificationFilterType.all,
  });

  NotificationState copyWith({
    NotificationPhase? phase,
    List<NotificationModel>? notifications,
    String? errorMessage,
    NotificationFilterType? filter,
  }) {
    return NotificationState(
      phase: phase ?? this.phase,
      notifications: notifications ?? this.notifications,
      errorMessage: errorMessage ?? this.errorMessage,
      filter: filter ?? this.filter,
    );
  }

  int unreadCount() => notifications.where((n) => !n.read).length;

  int countFor(NotificationFilterType f) {
    switch (f) {
      case NotificationFilterType.all:
        return notifications.length;
      case NotificationFilterType.unread:
        return unreadCount();
      case NotificationFilterType.mentions:
        return notifications.where((n) => n.type == 'info').length;
      case NotificationFilterType.system:
        return notifications
            .where((n) => ['security', 'report', 'reminder'].contains(n.type))
            .length;
    }
  }

  /// The list the UI should actually render, based on the active filter.
  List<NotificationModel> get filteredNotifications {
    switch (filter) {
      case NotificationFilterType.all:
        return notifications;
      case NotificationFilterType.unread:
        return notifications.where((n) => !n.read).toList();
      case NotificationFilterType.mentions:
        return notifications.where((n) => n.type == 'info').toList();
      case NotificationFilterType.system:
        return notifications
            .where((n) => ['security', 'report', 'reminder'].contains(n.type))
            .toList();
    }
  }

  @override
  List<Object?> get props => [phase, notifications, errorMessage, filter];
}
