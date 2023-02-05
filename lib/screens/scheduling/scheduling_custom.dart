import 'dart:async';
import 'package:ashpazi/common/app.dart';
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

class SchedulingCustom {
  static DateTime _dateTime = DateTime.now();

  static String message = "";

  static bool choseDateTimeState = false;

  static FoodTutorial? choseFood;

  static Map<String, String> alarm = {
    "alarmName": "هشدار",
    "alarmDescription": "هشدار برای پخت غذا",
  };

  static final TextEditingController _txtName = TextEditingController();
  static final TextEditingController _txtDesc = TextEditingController();

  static DateTime? _choseDateTime = _dateTime;
  static TimeOfDay? _timeOfDay;

  static Future<DateTime?> showDateTimePicker(
      context, Function changeState) async {
    final chose = await showDatePicker(
      context: context,
      initialDate: _dateTime,
      firstDate: _dateTime,
      lastDate: _dateTime.add(const Duration(days: 30)),
    );

    _timeOfDay = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dial,
    );

    _choseDateTime = chose;

    if (_choseDateTime != null && _timeOfDay != null) {
      _choseDateTime = DateTime(
        _choseDateTime!.year,
        _choseDateTime!.month,
        _choseDateTime!.day,
        _timeOfDay!.hour,
        _timeOfDay!.minute,
      );
    }

    choseDateTimeState = true;
    if (checkDateTime(changeState)) {
      int remainHour = 0;
      int remianMinute = 0;

      int remainYear = 0;
      int remainMonth = 0;
      int remainDay = 0;

      remainYear = _choseDateTime!.year - _dateTime.year;
      remainMonth = _choseDateTime!.month - _dateTime.month;
      remainDay = _choseDateTime!.day - _dateTime.day;

      if (_choseDateTime!.hour < _dateTime.hour) {
        remainHour = (24 - _dateTime.hour) + _choseDateTime!.hour;
        remainDay--;
      } else {
        remainHour = _choseDateTime!.hour - _dateTime.hour;
      }
      if (_choseDateTime!.minute < _dateTime.minute) {
        remianMinute = (60 - _dateTime.minute) + _choseDateTime!.minute;
        if (remainHour == 0) {
          remainDay--;
          remainHour = 23;
        } else {
          remainHour--;
        }
      } else {
        remianMinute = _choseDateTime!.minute - _dateTime.minute;
      }
      String text = remainYear > 0 ? "$remainYear سال و " : "";
      text += remainMonth > 0 ? "$remainMonth ماه و " : "";
      text += remainDay > 0 ? "$remainDay روز و " : "";
      text += "$remainHour ساعت و ";
      text += "$remianMinute دقیقه ";
      SnackBarWidget.snackBar("$text باقی مانده است", context);
    } else {
      SnackBarWidget.snackBar(
          "تاریخ و زمان مناسب انتخاب نشد".toString(), context);
    }
    changeState("customtime");
    return _choseDateTime;
  }

  static Stream<String> streamTime(Function changeState) {
    Stream<String> stream = Stream.periodic(const Duration(seconds: 1), (i) {
      if (choseDateTimeState) {
        checkDateTime(changeState);
      }
      return setTime();
    });

    return stream;
  }

  static setTime() {
    _dateTime = _dateTime.add(const Duration(seconds: 1));
    return "${_dateTime.hour.toString()}:${_dateTime.minute.toString()}:${_dateTime.second.toString()}";
  }

  static bool checkDateTime(Function changeState) {
    if (_choseDateTime == null || _timeOfDay == null) {
      message = "زمان انتخاب نشد";
      choseDateTimeState = false;
      _choseDateTime = null;
      changeState("customstime");
      return false;
    } else if (_choseDateTime!.millisecondsSinceEpoch <
        _dateTime.add(const Duration(minutes: 5)).millisecondsSinceEpoch) {
      _choseDateTime = null;
      message = "زمان انتخاب شده اشتباه است";
      choseDateTimeState = false;
      changeState("customstime");
      return false;
    } else {
      return true;
    }
  }

  static String date() {
    final date = DateTime.now();

    return "${date.year.toString()}/${date.month.toString()}/${(date.day).toString()}";
  }

  static Stream<String> streamDate() {
    DateTime time = DateTime.now();

    Stream<String> streamDate =
        Stream.periodic(const Duration(minutes: 1), (i) {
      time = time.add(const Duration(minutes: 1));
      return "${time.year.toString()}/${time.month.toString()}/${(time.day).toString()}";
    });

    return streamDate;
  }

  static Widget schedulingCustom(
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
                          showDateTimePicker(context, changeState);
                        },
                        child: Row(
                          children: [
                            BlocBuilder<SchedulingCubit, SchedulingState>(
                                builder: (context, state) {
                              if (state is SchedulingCustomTimeState) {
                                return StreamBuilder<String>(
                                    stream: streamTime(changeState),
                                    builder: (context, snapshot) {
                                      return TextWidget.text(
                                          fontSize: 20,
                                          _choseDateTime == null
                                              ? message
                                              : "${_choseDateTime!.hour}:${_choseDateTime!.minute}",
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
                      BlocBuilder<SchedulingCubit, SchedulingState>(
                          builder: (context, state) {
                        if (state is SchedulingCustomTimeState &&
                            _choseDateTime != null) {
                          return TextWidget.text(
                              "${_choseDateTime!.year}/${_choseDateTime!.month}/${_choseDateTime!.day}",
                              color: Colors.white);
                        } else {
                          return StreamBuilder(
                            stream: streamDate(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.active) {
                                return TextWidget.text(snapshot.data,
                                    color: Colors.white);
                              } else {
                                return TextWidget.text(date(),
                                    color: Colors.white);
                              }
                            },
                          );
                        }
                      }),
                    ],
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  ButtonWidget.elevatedButton(context, () {
                    showDateTimePicker(context, changeState);
                  }, "تاریخ و زمان", GetSizes.getWidth(40, context)),
                  const SizedBox(
                    height: 30.0,
                  ),
                  BlocBuilder<SchedulingCubit, SchedulingState>(
                      builder: (context, state) {
                    if ((state is SchedulingCustomState ||
                        state is SchedulingCustomTimeState)) {
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
                    if (_choseDateTime != null) {
                      try {
                        int alarmDateTime = DateTime(
                                _choseDateTime!.year,
                                _choseDateTime!.month,
                                _choseDateTime!.day,
                                _choseDateTime!.hour,
                                _choseDateTime!.minute)
                            .millisecondsSinceEpoch;

                        await db.setAlarm(
                            choseFood.id,
                            alarm["alarmName"] as String,
                            _dateTime.millisecondsSinceEpoch.toString(),
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
