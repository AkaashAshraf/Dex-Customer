import 'package:flutter/material.dart' show Color;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> showNotification(title, body) async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'your channel id',
    'your channel name',
    'your channel description',
    ledColor: const Color.fromARGB(255, 0, 255, 0),
    ledOnMs: 1000,
    ledOffMs: 500,
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
  );
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);
  var flutterLocalNotificationsPlugin;
  await flutterLocalNotificationsPlugin
      .show(0, '$title', '$body', platformChannelSpecifics, payload: 'item x');
}
