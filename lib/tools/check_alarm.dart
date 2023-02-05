import 'dart:async';
import 'package:ashpazi/models/alarm.dart';
import 'package:ashpazi/services/notification_service.dart';
import 'package:ashpazi/tools/database.dart';
import 'package:flutter/cupertino.dart';

class CheckAlarm {
  static DBProvider database = DBProvider.db;
  static List<Alarm> alarms = [];

  static Future checkAlarm(BuildContext context) async {
    DBProvider.context = context;

    await database.getAllAlarms();

    Stream stream;

    StreamController streamController = StreamController();

    stream = streamController.stream;

    streamController.addStream(Stream.periodic(const Duration(seconds: 30)));

    stream.listen((event) {
      for (var alarm in alarms) {
        if (alarm.alarmEnd < DateTime.now().millisecondsSinceEpoch) {
          Future.delayed(const Duration(seconds: 10), () {
            NotificationApi.sendNotification("وقت ${alarm.alarmName} رسیده!",
                alarm.alarmDescription, context);
          }).then((value) => Future.delayed(const Duration(seconds: 10), () {
                NotificationApi.sendNotification(
                    "وقت ${alarm.alarmName} رسیده!",
                    alarm.alarmDescription,
                    context);
              }));
          database.updateAlarms(alarm.id);
          _removeItem(alarm.id);
        }
      }
    });
  }

  static _removeItem(int index) {
    alarms.removeWhere((element) => element.id == index);
  }
}
