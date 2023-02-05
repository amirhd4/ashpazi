import "package:flutter_bloc/flutter_bloc.dart";
part 'scheduling_state.dart';

class SchedulingCubit extends Cubit<SchedulingState> {
  SchedulingCubit() : super(SchedulingInitial());
  void showHome() {
    emit(SchedulingHomeState());
  }

  void showToday() {
    emit(SchedulingTodayState());
  }

  void showTomorrow() {
    emit(SchedulingTomorrowState());
  }

  void showTwodays() {
    emit(SchedulingTwodaysState());
  }

  void showCustom() {
    emit(SchedulingCustomState());
  }

  void showTodayTime() {
    emit(SchedulingTodayTimeState());
  }

  void showTomorrowTime() {
    emit(SchedulingTomorrowTimeState());
  }

  void showTwodaysTime() {
    emit(SchedulingTwodaysTimeState());
  }

  void showCustomTime() {
    emit(SchedulingCustomTimeState());
  }
}
