import 'package:ashpazi/common/app.dart';
import 'package:ashpazi/cubits/ashpazi_cubit.dart';
import 'package:ashpazi/cubits/foodlist_cubit.dart';
import 'package:ashpazi/models/alarm.dart';
import 'package:ashpazi/models/food_tutorial.dart';
import 'package:ashpazi/tools/check_alarm.dart';
import 'package:ashpazi/tools/database.dart';
import 'package:ashpazi/widgets/appbar.dart';
import 'package:ashpazi/widgets/snackbar.dart';
import 'package:ashpazi/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FoodListScreen extends StatefulWidget {
  const FoodListScreen({Key? key}) : super(key: key);

  @override
  State<FoodListScreen> createState() => _FoodListScreenState();
}

class _FoodListScreenState extends State<FoodListScreen> {
  late final DBProvider db;
  List<FoodTutorial> foods = [];
  List<Alarm>? alarms = [];
  List<bool> expanded = [];
  String message = "";

  @override
  void initState() {
    getDatabase();
    getAlarms();
    super.initState();
  }

  void getDatabase() {
    db = DBProvider.db;
  }

  void getAlarms() async {
    alarms = await db.getAlarmsList();

    if (alarms!.isEmpty) {
      message = "چیزی برای نمایش وجود ندارد";
      changeState("nothing");
    } else {
      expanded = List.generate(alarms!.length, (index) => false);
      changeState("gotdata");
    }
  }

  void _removeAlarm(int id) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            child: Container(
              height: GetSizes.getHeight(40, context),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Icon(
                        Icons.warning,
                        color: Colors.red,
                        size: 37.0,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      TextWidget.textBold("برای حذف این هشدار\n مطمعن هستید؟"),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.cancel,
                          color: Colors.red.shade700,
                        ),
                        iconSize: 35.0,
                      ),
                      IconButton(
                        onPressed: () async {
                          try {
                            db.updateAlarms(alarms![id].id);

                            CheckAlarm.alarms.remove(alarms![id]);
                            initialState();
                            Navigator.of(context).pop();
                          } on Exception catch (e) {
                            SnackBarWidget.snackBar("مشکلی پیش آمد", context);
                            SnackBarWidget.snackBar(e.toString(), context);
                          }
                        },
                        icon: Icon(
                          Icons.verified,
                          color: Colors.green.shade700,
                        ),
                        iconSize: 35.0,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  void changeState(String state) {
    switch (state) {
      case "gotdata":
        context.read<FoodListCubit>().gotData();
        break;
      case "nothing":
        context.read<FoodListCubit>().nothingToShow();
        break;
      case "expanded":
        context.read<FoodListCubit>().itemExpanded();
        break;
      default:
    }
  }

  void initialState() async {
    context.read<FoodListCubit>().initial();
    await Future.delayed(const Duration(seconds: 1));

    getAlarms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget.appBar(
        "فهرست زمانبندی",
        context,
        Colors.white,
        actions: [
          BlocBuilder<FoodListCubit, FoodListState>(
            builder: (context, state) {
              if (state is FoodListGotDataState) {
                return IconButton(
                  onPressed: () {
                    context.read<FoodListCubit>().initial();
                    Future.delayed(const Duration(seconds: 1)).then(
                      (value) => getAlarms(),
                    );
                  },
                  icon: const Icon(Icons.replay_circle_filled_sharp),
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
      body: Center(
        child: BlocBuilder<FoodListCubit, FoodListState>(
          builder: (context, state) {
            if (state is FoodListGotDataState || state is FoodListExpanded) {
              return ListView.builder(
                itemCount: alarms!.length,
                itemBuilder: (BuildContext context, int i) {
                  String? differenceText;

                  DateTime start = DateTime.fromMillisecondsSinceEpoch(
                      alarms![i].alarmStart.toInt());
                  DateTime end = DateTime.fromMillisecondsSinceEpoch(
                      alarms![i].alarmEnd.toInt());
                  String startText =
                      "${start.year}/${start.month}/${start.day} ${start.hour}:${start.minute}";
                  String endText =
                      "${end.year}/${end.month}/${end.day} ${end.hour}:${end.minute}";
                  if (alarms![i].alarmDone == 0) {
                    Duration differecne = end.difference(start);

                    if (differecne.inMinutes < 60) {
                      differenceText = "${differecne.inMinutes} دقیقه ";
                    } else if (differecne.inHours < 24) {
                      differenceText = "${differecne.inHours} ساعت";
                    } else {
                      differenceText = "${differecne.inDays} روز";
                    }
                  }
                  return Card(
                    shadowColor: Colors.grey,
                    //color: Colors.amber,
                    elevation: 10.0,
                    margin: const EdgeInsets.all(10.0),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: BlocBuilder<FoodListCubit, FoodListState>(
                        builder: (context, state) {
                          if ((state is FoodListExpanded ||
                                  state is FoodListGotDataState) &&
                              expanded[i]) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(alarms![i].alarmDone == 0
                                        ? Icons.alarm
                                        : Icons.alarm_off),
                                    TextWidget.textItem(
                                      differenceText ?? "پایان",
                                      color: Colors.amber.shade800,
                                    ),
                                  ],
                                ),
                                Center(
                                  child: TextWidget.textBold(
                                    alarms![i].alarmName,
                                    color: Colors.blue.shade700,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (alarms![i].foodId != -1) {
                                      AshpaziCubit.foodId = alarms![i].foodId;
                                      Navigator.pushNamed(context, "/tutorial");
                                    } else {
                                      SnackBarWidget.snackBar(
                                          "شما یک غذای دلخواه خود را انتاخب کرده اید!",
                                          context);
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                        color: Colors.blue.shade800,
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                    child: TextWidget.textBold(
                                        alarms![i].foodName!,
                                        color: Colors.white),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                TextWidget.textItem(
                                  alarms![i].alarmDescription,
                                ),
                                const SizedBox(
                                  height: 25.0,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextWidget.textItem("ایجاد شده در",
                                        color: Colors.blueAccent),
                                    TextWidget.textItem(startText),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextWidget.textItem("تاریخ و زمان",
                                        color: Colors.blueAccent),
                                    TextWidget.textItem(endText),
                                  ],
                                ),
                                alarms![i].alarmDone == 0
                                    ? Center(
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.remove_circle,
                                            color: Colors.red,
                                          ),
                                          onPressed: () {
                                            _removeAlarm(i);
                                          },
                                        ),
                                      )
                                    : Container(),
                              ],
                            );
                          } else {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                TextWidget.textBold(alarms![i].alarmName),
                                IconButton(
                                  onPressed: () {
                                    expanded[i] = true;
                                    changeState("expanded");
                                  },
                                  icon: const Icon(
                                    Icons.arrow_downward,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    ),
                  );
                },
              );
              // End Items
            } else if (state is FoodListNothingToShowState) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextWidget.textBold(message, color: Colors.amber.shade900),
                  const SizedBox(height: 15.0),
                  IconButton(
                    onPressed: () {
                      context.read<FoodListCubit>().initial();
                      Future.delayed(const Duration(seconds: 2))
                          .then((value) => getAlarms());
                    },
                    icon: const Icon(Icons.refresh),
                  ),
                ],
              );
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextWidget.textBold("لطفا کمی صبر کنید...",
                      color: Colors.amber.shade900),
                  const SizedBox(height: 5.0),
                  const CircularProgressIndicator(),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
