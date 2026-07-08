import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:verirent/features/settings/ui/pages/settings.dart';
import 'package:verirent/features/shell/feature/notification/ui/cubit/notification_cubit.dart';

import '../widget/filter_chip.dart';
import '../widget/notification_tile.dart';

class NotificationDrawer extends StatelessWidget {
  const NotificationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: GetIt.I<NotificationCubit>(),
      child: Drawer(
        width: 380,
        child: SafeArea(
          child: BlocBuilder<NotificationCubit, NotificationState>(
            builder: (context, state) {
              if (state.phase == NotificationPhase.loading) {
                return CircularProgressIndicator.adaptive();
              }
              if (state.phase == NotificationPhase.error) {
                return Center(
                  child: Text('An Error occurred \n${state.errorMessage}'),
                );
              }
              final cubit = GetIt.I<NotificationCubit>();
              return Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(
                            context,
                          ).dividerColor.withValues(alpha: 0.1),
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
                              '${state.unreadCount()} unread',
                              style: TextStyle(
                                fontSize: 13,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            // "Mark all read" button
                            TextButton(
                              onPressed: () => cubit.markAllAsRead(),
                              child: const Text('Mark all read'),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.settings_outlined,
                                size: 20,
                              ),
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SettingsPage(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Filter chips row
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          CustomFilterChip(
                            label: 'All',
                            selected:
                                state.filter == NotificationFilterType.all,
                            count: state.countFor(NotificationFilterType.all),
                            onTap: () =>
                                cubit.changeFilter(NotificationFilterType.all),
                          ),
                          CustomFilterChip(
                            label: 'Unread',
                            selected:
                                state.filter == NotificationFilterType.unread,
                            count: state.countFor(
                              NotificationFilterType.unread,
                            ),
                            onTap: () => cubit.changeFilter(
                              NotificationFilterType.unread,
                            ),
                          ),
                          CustomFilterChip(
                            label: 'Mentions',
                            selected:
                                state.filter == NotificationFilterType.mentions,
                            count: state.countFor(
                              NotificationFilterType.mentions,
                            ),
                            onTap: () => cubit.changeFilter(
                              NotificationFilterType.mentions,
                            ),
                          ),
                          CustomFilterChip(
                            label: 'System',
                            selected:
                                state.filter == NotificationFilterType.system,
                            count: state.countFor(
                              NotificationFilterType.system,
                            ),
                            onTap: () => cubit.changeFilter(
                              NotificationFilterType.system,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Notification list
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: state.filteredNotifications.length,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 1, indent: 68),
                      itemBuilder: (context, index) {
                        final notificationModel =
                            state.filteredNotifications[index];
                        return NotificationTile(
                          notificationModel: notificationModel,
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
                          color: Theme.of(
                            context,
                          ).dividerColor.withOpacity(0.1),
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
              );
            },
          ),
        ),
      ),
    );
  }
}
