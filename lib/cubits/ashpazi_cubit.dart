import "package:flutter_bloc/flutter_bloc.dart";
part 'ashpazi_state.dart';

class AshpaziCubit extends Cubit<AshpaziState> {
  AshpaziCubit() : super(AshpaziInitial());
  void showCategory() {
    emit(AshpaziShowCategory());
  }

  void showFoods() {
    emit(AshpaziShowFoods());
  }

  void showFood() {
    emit(AshpaziShowFood());
  }

  static int? foodId;
}
