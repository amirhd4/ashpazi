import 'dart:async';
import 'package:ashpazi/models/food_tutorial.dart';
import 'dart:ui';
import 'package:ashpazi/cubits/scheduling_cubit.dart';
import 'package:ashpazi/services/notification_service.dart';
import 'package:ashpazi/tools/database.dart';
import 'package:ashpazi/tools/image_clip.dart';
import 'package:ashpazi/widgets/button.dart';
import 'package:ashpazi/widgets/snackbar.dart';
import 'package:ashpazi/widgets/text.dart';
import 'package:ashpazi/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SchedulingTomorrow {
  static TimeOfDay? timeOfDay;

  static DateTime currentTime = DateTime.now();

  static String message = "";

  static bool choseTimeState = false;

  static FoodTutorial? choseFood;

  static Map<String, String> alarm = {
    "alarmName": "هشدار",
    "alarmDescription": "هشدار برای پخت غذا",
  };

  static final TextEditingController _txtName = TextEditingController();
  static final TextEditingController _txtDesc = TextEditingController();

  static Future<TimeOfDay?> showPicker(context, Function changeState) async {
    TimeOfDay? choseTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dial,
    );

    choseTimeState = true;
    timeOfDay = choseTime;
    checkTime(changeState);
    changeState("tomorrowtime");

    if (timeOfDay != null) {
      String remTxt = "";
      //int day;
      if ((timeOfDay!.hour > currentTime.hour) ||
          (timeOfDay!.hour == currentTime.hour &&
              timeOfDay!.minute >= currentTime.minute)) {
//        day = 1;
        remTxt = "1 روز و ";
      } else {
        //      day = 0;
      }
      int hour = 0;
      if (timeOfDay!.hour != currentTime.hour) {
        if (timeOfDay!.hour > currentTime.hour) {
          hour = timeOfDay!.hour - currentTime.hour;
        } else {
          hour = 24 - (currentTime.hour - timeOfDay!.hour);
        }
      }
      int minute = 0;
      if (timeOfDay!.minute != currentTime.minute) {
        if (timeOfDay!.minute > currentTime.minute) {
          minute = timeOfDay!.minute - currentTime.minute;
        } else {
          if (hour == 0) {
            hour = 23;
          } else {
            hour--;
          }
          minute = 60 - (currentTime.minute - timeOfDay!.minute);
        }
      }

      remTxt += "$hour:$minute دیگر باقی مانده است";

      SnackBarWidget.snackBar(remTxt, context);
    } else {
      SnackBarWidget.snackBar("زمان انتخاب نشد".toString(), context);
    }
    return choseTime;
  }

  static Stream<String> streamTime(Function changeState) {
    Stream<String> stream = Stream.periodic(const Duration(seconds: 1), (i) {
      if (choseTimeState) {
        checkTime(changeState);
      }
      return setTime();
    });

    return stream;
  }

  static setTime() {
    currentTime = currentTime.add(const Duration(seconds: 1));
    return "${currentTime.hour.toString()}:${currentTime.minute.toString()}:${currentTime.second.toString()}";
  }

  static checkTime(Function changeState) {
    if (timeOfDay == null) {
      message = "زمان انتخاب نشد";
      choseTimeState = false;
      changeState("tomorrowtime");
    }
  }

  static String date() {
    final date = DateTime.now();

    return "${date.year.toString()}/${date.month.toString()}/${(date.day + 1).toString()}";
  }

  static Stream<String> streamDate() {
    DateTime time = DateTime.now();

    Duration? second = const Duration(seconds: 1);

    Future.delayed(const Duration(seconds: 1), () {
      second = null;
    });

    Stream<String> streamDate =
        Stream.periodic(second ?? const Duration(minutes: 1), (i) {
      time.add(const Duration(minutes: 1));
      return "${time.year.toString()}/${time.month.toString()}/${(time.day + 1).toString()}";
    });

    return streamDate;
  }

  static Widget schedulingTomorrow(
      context, Function changeState, DBProvider db, FoodTutorial choseFood) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.blue.shade900.withOpacity(0.75),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget.text("زمان", color: Colors.white),
                      GestureDetector(
                        onTap: () {
                          showPicker(context, changeState);
                        },
                        child: Row(
                          children: [
                            const Icon(
                              Icons.timer,
                              color: Colors.amber,
                            ),
                            TextWidget.textBold("انتخاب",
                                color: Colors.amber.shade200, fontSize: 15),
                            BlocBuilder<SchedulingCubit, SchedulingState>(
                                builder: (context, state) {
                              if (state is SchedulingTomorrowTimeState) {
                                return StreamBuilder<String>(
                                    stream: streamTime(changeState),
                                    builder: (context, snapshot) {
                                      return TextWidget.text(
                                          fontSize: 20,
                                          timeOfDay == null
                                              ? message
                                              : "${timeOfDay!.hour}:${timeOfDay!.minute}",
                                          color: Colors.white);
                                    });
                              } else {
                                return StreamBuilder<String>(
                                    stream: streamTime(changeState),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.active) {
                                        return TextWidget.text(snapshot.data!,
                                            color: Colors.white);
                                      } else {
                                        return const CircularProgressIndicator();
                                      }
                                    });
                              }
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget.text("تاریخ", color: Colors.white),
                      StreamBuilder(
                        stream: streamDate(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.active) {
                            return TextWidget.text(snapshot.data,
                                color: Colors.white);
                          } else {
                            return TextWidget.text(date(), color: Colors.white);
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  BlocBuilder<SchedulingCubit, SchedulingState>(
                      builder: (context, state) {
                    if (state is SchedulingTomorrowState ||
                        state is SchedulingTomorrowTimeState) {
                      return Column(
                        children: [
                          TextWidget.textBold(choseFood.foodName,
                              fontSize: 25, color: Colors.white),
                          const SizedBox(
                            height: 10,
                          ),
                          ClipPath(
                            clipper: ImageClipper(context),
                            child: Image(
                              image: AssetImage(
                                  "assets/images/${choseFood.foodImage}"),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  }),
                  const SizedBox(
                    height: 30.0,
                  ),
                  TextFieldWidget.textField(_txtName, (value) {
                    alarm["alarmName"] = value;
                  }, "نام زمانبندی...", Icons.schedule),
                  const SizedBox(height: 10),
                  TextFieldWidget.textField(_txtDesc, (value) {
                    alarm["alarmDescription"] = value;
                  }, "توضیحات زمانبندی...", Icons.description),
                  const SizedBox(
                    height: 30.0,
                  ),
                  ButtonWidget.elevatedButton(context, () async {
                    if (timeOfDay != null) {
                      try {
                        int alarmDateTime = DateTime(
                                currentTime.year,
                                currentTime.month,
                                currentTime.day + 1,
                                timeOfDay!.hour,
                                timeOfDay!.minute)
                            .millisecondsSinceEpoch;

                        await db.setAlarm(
                            choseFood.id,
                            alarm["alarmName"] as String,
                            currentTime.millisecondsSinceEpoch.toString(),
                            alarmDateTime.toString(),
                            alarm["alarmDescription"] as String);
                        NotificationApi.sendNotification(
                          "زمانبندی",
                          "زمانبندی برای ${choseFood.foodName} با موفقیت انجام شد",
                          context,
                        );
                        await db.getAllAlarms(last: true);
                      } on Exception catch (e) {
                        SnackBarWidget.snackBar("مشکلی بوجود آمد", context);
                        SnackBarWidget.snackBar(e.toString(), context);
                      }
                    } else {
                      SnackBarWidget.snackBar(
                          "زمان مناسب را انتاخب کنید", context);
                    }
                  }, "ثبت", 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
