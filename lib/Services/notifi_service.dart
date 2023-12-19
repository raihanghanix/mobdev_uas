import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('flutter_logo');

    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {});

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {});
  }

  notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker'),
        iOS: DarwinNotificationDetails());
  }

  Future showNotification(
      {int id = 0, String? title, String? body, String? payLoad}) async {
    return notificationsPlugin.show(
        id, title, body, await notificationDetails());
  }

  Future showScheduledNotification(
      {int id = 2,
      String formattedString = "",
      String? title,
      String? body,
      String? payLoad}) async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation("Asia/Jakarta"));

    DateTime timestamp1 = DateTime.parse(formattedString).add(
      const Duration(minutes: 0),
    );
    DateTime timestamp2 = DateTime.now()
        .add(
          const Duration(hours: 7),
        )
        .toUtc();
    Duration difference = timestamp1.difference(timestamp2);
    int differenceInSeconds = difference.inSeconds.abs();
    print('$timestamp2 $timestamp1');
    print('The difference in seconds is: $differenceInSeconds seconds');

    return notificationsPlugin.zonedSchedule(
      3,
      title,
      body,
      tz.TZDateTime.now(tz.local).add(Duration(seconds: differenceInSeconds)),
      await notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
