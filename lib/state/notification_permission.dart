import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sandbox/state/flutter_local_notification_plugin.dart';

class NotificationPermissionNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    final flutterLocalNotificationPlugin =
        await ref.watch(flutterLocalNotificationPluginProvider.future);
    return await flutterLocalNotificationPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.areNotificationsEnabled() ??
        false;
  }

  /// Request permission to use the notification service.
  ///
  /// If the permission is granted, the state will be updated to `true`.
  Future<void> requestPermission() async {
    final flutterLocalNotificationPlugin =
        await ref.watch(flutterLocalNotificationPluginProvider.future);
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () async =>
          await flutterLocalNotificationPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>()
              ?.requestNotificationsPermission() ??
          false,
    );
  }
}

final notificationPermissionNotifierProvider =
    AsyncNotifierProvider<NotificationPermissionNotifier, bool>(
  NotificationPermissionNotifier.new,
);
