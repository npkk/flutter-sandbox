import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sandbox/state/flutter_local_notification_plugin.dart';
import 'package:timezone/timezone.dart' as tz;

class HomePage extends ConsumerWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flnp = ref.watch(flutterLocalNotificationPluginProvider.future);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder(
              future: flnp,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return CircularProgressIndicator();
                }
                return ElevatedButton(
                  onPressed: () async {
                    debugPrint('タップされた');

                    const notificationDetails = NotificationDetails(
                      android: AndroidNotificationDetails(
                        'channel_id_0',
                        'channel_name_0',
                        channelDescription: 'description',
                        importance: Importance.max,
                        priority: Priority.high,
                        ticker: 'ticker',
                        actions: <AndroidNotificationAction>[
                          AndroidNotificationAction(
                            'react',
                            'React',
                            cancelNotification: true,
                            showsUserInterface: true,
                          ),
                          AndroidNotificationAction(
                            'ignore',
                            'Ignore',
                            cancelNotification: true,
                            showsUserInterface: false,
                          ),
                        ],
                      ),
                    );
                    await snapshot.data!.zonedSchedule(
                      0,
                      'title',
                      'body',
                      tz.TZDateTime.now(tz.local)
                          .add(const Duration(minutes: 1)),
                      notificationDetails,
                      androidScheduleMode:
                          AndroidScheduleMode.exactAllowWhileIdle,
                      uiLocalNotificationDateInterpretation:
                          UILocalNotificationDateInterpretation.absoluteTime,
                    );
                    debugPrint('通知が登録された');
                  },
                  child: Text('1分後に通知'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
