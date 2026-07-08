import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:verirent/features/shell/feature/notification/domain/notification_model.dart';

import '../../../../../../core/repo/local_repo.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationState()) {
    init();
  }
  final _localRepository = GetIt.I<LocalRepository>();

  Future<void> init() async {
    await loadNotifications();
  }

  Future<void> loadNotifications() async {
    emit(state.copyWith(phase: NotificationPhase.loading));
    try {
      final notifications = await _localRepository.notifications();
      await Future.delayed(const Duration(seconds: 1));
      emit(
        state.copyWith(
          phase: NotificationPhase.loaded,
          notifications: notifications,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          phase: NotificationPhase.error,
          errorMessage: "the following error occurred $e",
        ),
      );
      debugPrint("$e");
    }
  }

  /// Marks every notification as read, both in state and (if you persist
  /// notifications locally) in storage.
  void markAllAsRead() {
    if (state.notifications.isEmpty) return;

    final updated = state.notifications
        .map((n) => n.read ? n : n.copyWith(read: true))
        .toList();

    emit(state.copyWith(notifications: updated));

    // Persist if your LocalRepository supports it, e.g.:
    // _localRepository.saveNotifications(updated);
  }

  /// Marks a single notification as read (handy for tapping a tile).
  void markAsRead(int id) {
    final updated = state.notifications
        .map((n) => n.id == id ? n.copyWith(read: true) : n)
        .toList();
    emit(state.copyWith(notifications: updated));
  }

  void changeFilter(NotificationFilterType filter) {
    emit(state.copyWith(filter: filter));
  }
}
