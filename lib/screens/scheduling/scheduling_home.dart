import 'dart:ui';
import 'package:ashpazi/common/app.dart';
import 'package:ashpazi/models/food_tutorial.dart';
import 'package:ashpazi/screens/scheduling/scheduling_screen.dart';
import 'package:ashpazi/widgets/button.dart';
import 'package:ashpazi/widgets/item_gridview.dart';
import 'package:ashpazi/widgets/snackbar.dart';
import 'package:ashpazi/widgets/text.dart';
import 'package:ashpazi/widgets/textfield.dart';
import 'package:flutter/material.dart';

class SchedulingHome {
  static showError(context) {
    SnackBarWidget.snackBar("لطفا یک غذا انتخاب کنید", context);
  }

  static TextEditingController textController = TextEditingController();
  static List<FoodTutorial> _foods = [];
  static FoodTutorial? choseFood;

  static Widget schedulingHome(
      Function changeState, BuildContext context, List<FoodTutorial> foods) {
    choseFood ??= foods[0];
    SchedulingScreen.choseFood ??= choseFood;

    _foods = foods;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          height: GetSizes.getHeight(60, context),
          child: GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            children: [
              GridViewItemWidget.item("زمانبندی برای امروز", () {
                if (choseFood != null) {
                  changeState("today");
                } else {
                  showError(context);
                }
              }, Icons.date_range),
              GridViewItemWidget.item("زمانبندی برای فردا", () {
                if (choseFood != null) {
                  changeState("tomorrow");
                } else {
                  showError(context);
                }
              }, Icons.date_range_outlined),
              GridViewItemWidget.item("زمانبندی برای پس فردا", () {
                if (choseFood != null) {
                  changeState("twodays");
                } else {
                  showError(context);
                }
              }, Icons.date_range_rounded),
              GridViewItemWidget.item("زمانبندی سفارشی", () {
                if (choseFood != null) {
                  changeState("custom");
                } else {
                  showError(context);
                }
              }, Icons.date_range_sharp),
            ],
          ),
        ),
        SizedBox(
          height: GetSizes.getHeight(2, context),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10.0),
                    gradient: AppBarInfo.linearGradient),
                child: TextWidget.textBold("انتخاب غذا",
                    fontSize: 30.0, color: Colors.white)),
          ),
        ),
        SizedBox(
          height: GetSizes.getHeight(2, context),
        ),
        // Search: Search foods

        TextFieldWidget.search(
          textController,
          (value) {
            int find =
                foods.indexWhere((element) => element.foodName.contains(value));
            if (find != -1) {
              final FoodTutorial item = foods[1];

              foods[1] = foods[find];
              foods.removeAt(find);

              foods.add(item);
            } else {
              foods = _foods;
            }
            changeState("home");
          },
        ),

        SizedBox(
          height: GetSizes.getHeight(2, context),
        ),
        // Food List: create a list food
        SizedBox(
          width: GetSizes.getWidth(100, context),
          height: GetSizes.getHeight(45, context),
          child: ListView.builder(
            itemCount: foods.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Radio(
                      value: foods[index].id,
                      groupValue: choseFood!.id,
                      onChanged: (value) {
                        SchedulingScreen.choseFood = choseFood;

                        choseFood = foods[index];
                        SchedulingScreen.choseFood = choseFood;
                        changeState("home");
                      },
                    ),
                    ButtonWidget.elevatedButton(
                      context,
                      () {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: TextWidget.textBold(
                            " ${foods[index].foodName} ",
                            fontSize: 20,
                          ),
                          elevation: 0.0,
                          backgroundColor:
                              Colors.blue.shade900.withOpacity(0.8),
                        ));
                      },
                      foods[index].foodName,
                      60,
                      picture: foods[index].foodImage,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
