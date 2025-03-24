/*import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:travel/ui/widgets/dialog_msg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseMessage {
  static final _messaging = FirebaseMessaging.instance;
  static String? _token;

  static Future<void> requestPermission(BuildContext context) async {
    final setting = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    showMessageDialog(
      context: context,
      title: "Notification Permission",
      message:
          setting.authorizationStatus == AuthorizationStatus.authorized
              ? "Notifications Allowed"
              : "Notifications Denied",
    );
  }

  static Future<void> getToken() async {
    _token = await _messaging.getToken();

    if (kDebugMode) {
      print("Registration Token=$_token");
    }
  }

  static void initLocalNotifications() {
  }
}*/
