import 'package:ashpazi/common/app.dart';
import 'package:ashpazi/common/routes.dart';
import 'package:ashpazi/services/notification_service.dart';
import 'package:ashpazi/tools/check_alarm.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NotificationApi.notificationApi();
    CheckAlarm.checkAlarm(context);
    return MaterialApp(
      onGenerateRoute: Routes.routes,
      initialRoute: "/splash",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: "bZiba"),
      title: AppInfo.title,
    );
  }
}
