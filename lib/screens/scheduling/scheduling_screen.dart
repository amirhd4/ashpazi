import 'package:ashpazi/common/app.dart';
import 'package:ashpazi/cubits/scheduling_cubit.dart';
import 'package:ashpazi/models/food_tutorial.dart';
import 'package:ashpazi/screens/scheduling/scheduling_custom.dart';
import 'package:ashpazi/screens/scheduling/scheduling_home.dart';
import 'package:ashpazi/screens/scheduling/scheduling_today.dart';
import 'package:ashpazi/screens/scheduling/scheduling_tomorrow.dart';
import 'package:ashpazi/screens/scheduling/scheduling_twodays.dart';
import 'package:ashpazi/tools/database.dart';
import 'package:ashpazi/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SchedulingScreen extends StatefulWidget {
  const SchedulingScreen({Key? key}) : super(key: key);
  static FoodTutorial? choseFood;

  @override
  State<SchedulingScreen> createState() => _SchedulingScreenState();
}

class _SchedulingScreenState extends State<SchedulingScreen> {
  DBProvider db = DBProvider.db;
  List<FoodTutorial> foods = [];

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future getData() async {
    DBProvider database = DBProvider.db;
    foods = await database.getAllFoods();
    final food = foods[0];
    foods[0] = FoodTutorial(
      id: -1,
      foodName: "غذای دلخواه",
      foodDescription: "یک غذای دلخواه به انتخاب خودتان",
      foodCategory: "دلخواه",
      foodImage: "cooking.gif",
    );
    foods.add(food);

    changeState("home");
  }

  changeState(String show) {
    if (show == "home") {
      Future.delayed(const Duration(seconds: 1), () {
        context.read<SchedulingCubit>().showHome();
      });
    } else {
      switch (show.toString()) {
        case "today":
          context.read<SchedulingCubit>().showToday();
          break;
        case "tomorrow":
          context.read<SchedulingCubit>().showTomorrow();
          break;
        case "twodays":
          context.read<SchedulingCubit>().showTwodays();
          break;
        case "custom":
          context.read<SchedulingCubit>().showCustom();
          break;
        case "todaytime":
          context.read<SchedulingCubit>().showTodayTime();
          break;
        case "tomorrowtime":
          context.read<SchedulingCubit>().showTomorrowTime();
          break;
        case "twodaystime":
          context.read<SchedulingCubit>().showTwodaysTime();
          break;
        case "customtime":
          context.read<SchedulingCubit>().showCustomTime();
          break;
        default:
      }
    }
  }

  changeThings(SchedulingState state, {bool leading = false}) {
    if (state is SchedulingInitial || state is SchedulingHomeState) {
      if (leading) {
        Navigator.pop(context);
      } else {
        return Text("زمانبندی", style: AppBarInfo.appBarTitleStyle);
      }
    } else if (state is SchedulingTodayState) {
      if (leading) {
        changeState("home");
      } else {
        return Text("زمانبندی برای امروز", style: AppBarInfo.appBarTitleStyle);
      }
    } else if (state is SchedulingTomorrowState) {
      if (leading) {
        changeState("home");
      } else {
        return Text("زمانبندی برای فردا", style: AppBarInfo.appBarTitleStyle);
      }
    } else if (state is SchedulingTwodaysState) {
      if (leading) {
        changeState("home");
      } else {
        return Text("زمانبندی برای پسفردا", style: AppBarInfo.appBarTitleStyle);
      }
    } else {
      if (leading) {
        changeState("home");
      } else {
        return Text("زمانبندی سفارشی", style: AppBarInfo.appBarTitleStyle);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget.appBar(
        null,
        titleWidget: BlocBuilder<SchedulingCubit, SchedulingState>(
          builder: (context, state) {
            return changeThings(state);
          },
        ),
        leading: BlocBuilder<SchedulingCubit, SchedulingState>(
            builder: (context, state) {
          return IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              changeThings(state, leading: true);
            },
          );
        }),
        context,
        AppBarInfo.backColor,
      ),
      body: Container(
        alignment: Alignment.center,
        width: GetSizes.getWidth(100, context),
        height: GetSizes.getHeight(100, context),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/cooking_time.png"),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BlocBuilder<SchedulingCubit, SchedulingState>(
                  builder: (context, state) {
                if (state is SchedulingHomeState) {
                  return SchedulingHome.schedulingHome(
                      changeState, context, foods);
                } else if (state is SchedulingTodayState ||
                    state is SchedulingTodayTimeState) {
                  return SchedulingToday.schedulingToday(
                      context, changeState, db, SchedulingScreen.choseFood!);
                } else if (state is SchedulingTomorrowState ||
                    state is SchedulingTomorrowTimeState) {
                  return SchedulingTomorrow.schedulingTomorrow(
                      context, changeState, db, SchedulingScreen.choseFood!);
                } else if (state is SchedulingTwodaysState ||
                    state is SchedulingTwodaysTimeState) {
                  return SchedulingTwodays.schedulingTwodays(
                      context, changeState, db, SchedulingScreen.choseFood!);
                } else if (state is SchedulingCustomState ||
                    state is SchedulingCustomTimeState) {
                  return SchedulingCustom.schedulingCustom(
                      context, changeState, db, SchedulingScreen.choseFood!);
                } else {
                  return SizedBox(
                    width: GetSizes.getWidth(20, context),
                    height: GetSizes.getWidth(20, context),
                    child: const CircularProgressIndicator(),
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
