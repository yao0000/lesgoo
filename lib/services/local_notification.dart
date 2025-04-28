import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

final FlutterLocalNotificationsPlugin plugin =
    FlutterLocalNotificationsPlugin();

void initNotificationService() async {
  await requestNotificationPermission();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('img');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await plugin.initialize(initializationSettings);
}

Future<void> requestNotificationPermission() async {
  // Android 13+ requires runtime permission
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }

  // iOS-specific permission
  await plugin
      .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin
      >()
      ?.requestPermissions(alert: true, badge: true, sound: true);
}

void showNotification(String message) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics = 
      AndroidNotificationDetails(
        'lesgoo_notification',
        'lesgoo_notification',
        importance: Importance.max,
        priority: Priority.high,
      );

  const NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );

  await plugin.show(
    0,
    'Booking Confirmed',
    message,
    platformChannelSpecifics,
    payload: 'booking_details',
  );
}
