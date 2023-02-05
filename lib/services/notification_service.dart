import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationApi {
  static FlutterLocalNotificationsPlugin? _flutterLocalNotificationsPlugin;
  static AndroidInitializationSettings? _initializationSettingsAndroid;
  static DarwinInitializationSettings? _initializationSettingsIOS;
  //static IOSInitializationSettings? _initializationSettingsIOS;
  static InitializationSettings? _initializationSettings;

  static int count = 0;

  static Future<void> notificationApi() async {
    _flutterLocalNotificationsPlugin ??= FlutterLocalNotificationsPlugin();

    _initializationSettingsAndroid ??=
        const AndroidInitializationSettings("@mipmap/launcher_icon");

    _initializationSettingsIOS ??= const DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true);

    _initializationSettings ??= InitializationSettings(
      android: _initializationSettingsAndroid,
      iOS: _initializationSettingsIOS,
    );
    await _flutterLocalNotificationsPlugin!.initialize(
      _initializationSettings!,
    );
  }

  static Future<void> sendNotification(
      String? title, String? body, BuildContext context) async {
    final Int64List vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;

    await _flutterLocalNotificationsPlugin!.show(
      count++,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails("Food", "Food Name",
            channelDescription: "Showing Food Alarm or Description about food",
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/launcher_icon',
            visibility: NotificationVisibility.public,
            largeIcon:
                const DrawableResourceAndroidBitmap('@mipmap/launcher_icon'),
            vibrationPattern: vibrationPattern,
            playSound: true,
            enableLights: true,
            color: const Color.fromARGB(255, 0, 140, 255),
            ledColor: const Color.fromARGB(255, 0, 140, 255),
            ledOnMs: 1000,
            ledOffMs: 500),
      ),
    );
  }
}
