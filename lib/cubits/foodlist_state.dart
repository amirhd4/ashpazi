part of 'foodlist_cubit.dart';

abstract class FoodListState {}

class FoodListInitialState extends FoodListState {}

class FoodListGotDataState extends FoodListState {}

class FoodListNothingToShowState extends FoodListState {}

class FoodListExpanded extends FoodListState {}
