import 'dart:ui';
import 'package:ashpazi/cubits/ashpazi_cubit.dart';
import 'package:ashpazi/common/app.dart';
import 'package:ashpazi/models/food_tutorial.dart';
import 'package:ashpazi/tools/database.dart';
import 'package:ashpazi/widgets/appbar.dart';
import 'package:ashpazi/widgets/button.dart';
import 'package:ashpazi/widgets/item_gridview.dart';
import 'package:ashpazi/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({Key? key}) : super(key: key);

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  late List<FoodTutorial> foods;
  List<FoodTutorialCategory> foodCategory = [];
  FoodTutorial? choseFood;
  int choseCategory = 0;
  int step = 0;
  ScrollController scrollController = ScrollController();
  bool showFloatButton = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future getData() async {
    DBProvider database = DBProvider.db;
    foods = await database.getAllFoods();
    analyticsData(foods);
  }

  analyticsData(List<FoodTutorial> foods) {
    for (String element in AppInfo.foodCategory) {
      foodCategory
          .add(FoodTutorialCategory(province: element, foodTutorial: []));
    }
    for (int i = 0; i < foods.length; i++) {
      for (int ii = 0; ii < foodCategory.length; ii++) {
        if (foods[i].foodCategory == foodCategory[ii].province) {
          foodCategory[ii].categoryCount++;
          foodCategory[ii].foodTutorial.add(foods[i]);
          if (AshpaziCubit.foodId != null &&
              AshpaziCubit.foodId == foods[i].id) {
            choseFood = foods[i];
            choseCategory = ii;
          }
        }
      }
    }
    fixText();
    if (choseFood != null) {
      AshpaziCubit.foodId = 0;
      context.read<AshpaziCubit>().showFood();
    } else {
      context.read<AshpaziCubit>().showCategory();
    }
  }

  String fixText() {
    for (int i = 0; i < foodCategory.length; i++) {
      for (int ii = 0; ii < foodCategory[i].foodTutorial.length; ii++) {
        for (int iii = 0;
            iii < foodCategory[i].foodTutorial[ii].foodDescription.length;
            iii++) {
          if (foodCategory[i]
                  .foodTutorial[ii]
                  .foodDescription[iii]
                  .contains("(") &&
              foodCategory[i]
                  .foodTutorial[ii]
                  .foodDescription[iii + 1]
                  .contains("م") &&
              foodCategory[i]
                  .foodTutorial[ii]
                  .foodDescription[iii + 2]
                  .contains(")")) {
            step++;
            foodCategory[i].foodTutorial[ii].foodDescription = foodCategory[i]
                .foodTutorial[ii]
                .foodDescription
                .replaceRange(
                    iii, iii + 3, "\n\n\n مرحله ${step.toString()} \n\n\n");
          }
          if (iii ==
              foodCategory[i].foodTutorial[ii].foodDescription.length - 1) {
            step = 0;
          }
        }
      }
    }
    return "";
  }

  String changeTitle(AshpaziState state) {
    if (state is AshpaziShowFood) {
      return choseFood!.foodName;
    } else if (state is AshpaziShowFoods) {
      if (foodCategory[choseCategory].province == "دسر") {
        return "دسر";
      } else {
        return "غذاهای ${foodCategory[choseCategory].province}";
      }
    } else {
      return "دسته بندی";
    }
  }

  @override
  Widget build(BuildContext context) {
    scrollController.addListener(() {
      if (scrollController.offset > 35) {
        showFloatButton = true;
      } else {
        showFloatButton = false;
      }
      context.read<AshpaziCubit>().showFood();
    });
    return Scaffold(
      appBar: AppBarWidget.appBar(
        null,
        titleWidget: BlocBuilder<AshpaziCubit, AshpaziState>(
            builder: (context, state) => Text(
                  changeTitle(state),
                  style: AppBarInfo.appBarTitleStyle,
                )),
        context,
        AppBarInfo.backColor,
        leading: BlocBuilder<AshpaziCubit, AshpaziState>(
          builder: (context, state) {
            return IconButton(
              onPressed: () {
                if (state is AshpaziShowCategory) {
                  Navigator.pop(context);
                } else if (state is AshpaziShowFoods) {
                  choseFood = null;

                  context.read<AshpaziCubit>().showCategory();
                } else if (state is AshpaziShowFood) {
                  context.read<AshpaziCubit>().showFoods();
                }
                changeTitle(state);
              },
              icon: const Icon(
                Icons.arrow_back,
              ),
            );
          },
        ),
      ),
      body: Container(
        width: GetSizes.getWidth(100, context),
        height: GetSizes.getHeight(100, context),
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/cooking_tutorial.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: BlocConsumer<AshpaziCubit, AshpaziState>(
          listener: (context, state) {},
          builder: (context, state) {
            // Show Categories
            if (state is AshpaziShowCategory) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    TextFieldWidget.search(
                      searchController,
                      (value) {
                        int find = -1;
                        if (value.isNotEmpty) {
                          find = foods.indexWhere(
                              (element) => element.foodName.contains(value));
                        }

                        if (find != -1) {
                          choseFood = foods[find];
                        } else {
                          choseFood = null;
                        }
                        context.read<AshpaziCubit>().showCategory();
                      },
                    ),
                    choseFood != null
                        ? Padding(
                            padding: const EdgeInsets.all(50.0),
                            child: ButtonWidget.elevatedButton(
                              context,
                              () {
                                choseCategory = foodCategory.indexWhere(
                                    (element) =>
                                        element.province ==
                                        choseFood!.foodCategory);
                                context.read<AshpaziCubit>().showFood();
                                changeTitle(state);
                              },
                              choseFood!.foodName,
                              GetSizes.getWidth(50.0, context),
                            ))
                        : Container(),
                    SizedBox(
                      height: GetSizes.getHeight(125, context),
                      width: GetSizes.getWidth(
                          TutorialScreenInfo.itemWidth, context),
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          childAspectRatio: 4,
                        ),
                        itemCount: foodCategory.length,
                        itemBuilder: (BuildContext context, int i) {
                          return GridViewItemWidget.item(
                            "${foodCategory[i].province}  ${foodCategory[i].categoryCount}",
                            () {
                              choseCategory = i;
                              choseFood = null;
                              context.read<AshpaziCubit>().showFoods();
                              changeTitle(state);
                            },
                            null,
                            fontSize: 20.0,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
              // Show Foods by Category
            } else if (state is AshpaziShowFoods) {
              List<FoodTutorial> food = [];

              for (int i = 0;
                  i < foodCategory[choseCategory].foodTutorial.length;
                  i++) {
                food.add(foodCategory[choseCategory].foodTutorial[i]);
              }

              return SizedBox(
                height: GetSizes.getHeight(85, context),
                width: GetSizes.getWidth(TutorialScreenInfo.itemWidth, context),
                child: ListView.builder(
                    itemCount: foodCategory[choseCategory].foodTutorial.length,
                    itemBuilder: (context, index) {
                      return ButtonWidget.elevatedButton(context, () {
                        choseFood =
                            foodCategory[choseCategory].foodTutorial[index];
                        context.read<AshpaziCubit>().showFood();
                        changeTitle(state);
                      },
                          foodCategory[choseCategory]
                              .foodTutorial[index]
                              .foodName,
                          TutorialScreenInfo.itemWidth,
                          picture: foodCategory[choseCategory]
                              .foodTutorial[index]
                              .foodImage);
                    }),
              );
              // Show Food Tutorial page
            } else if (state is AshpaziShowFood) {
              return SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            width: GetSizes.getWidth(100, context),
                            height: GetSizes.getHeight(40, context),
                            child: Image(
                                image: AssetImage(
                                    "assets/images/${choseFood!.foodImage}"))),
                        const SizedBox(height: 10.0),
                        Text(choseFood!.foodName,
                            style: const TextStyle(
                                fontFamily: "bMitra",
                                fontSize: 25,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10.0),
                        Text(choseFood!.foodDescription,
                            style: const TextStyle(
                              fontFamily: "bMitra",
                              fontSize: 22,
                            )),
                        const SizedBox(height: 10.0),
                        Text(choseFood!.foodCategory,
                            style: const TextStyle(
                                fontFamily: "bZiba",
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              );
              // Initializing
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
      floatingActionButton: BlocBuilder<AshpaziCubit, AshpaziState>(
        builder: (context, state) {
          if (state is AshpaziShowFood && showFloatButton) {
            return FloatingActionButton(
              child: const Text(
                "بالا",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                scrollController.animateTo(0,
                    duration: const Duration(seconds: 1),
                    curve: Curves.bounceIn);
                showFloatButton = false;
              },
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
