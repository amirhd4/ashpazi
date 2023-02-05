import 'package:flutter_bloc/flutter_bloc.dart';
part 'foodlist_state.dart';

class FoodListCubit extends Cubit<FoodListState> {
  FoodListCubit() : super(FoodListInitialState());

  void initial() {
    emit(FoodListInitialState());
  }

  void gotData() {
    emit(FoodListGotDataState());
  }

  void nothingToShow() {
    emit(FoodListNothingToShowState());
  }

  void itemExpanded() {
    emit(FoodListExpanded());
  }
}
