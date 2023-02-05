part of 'scheduling_cubit.dart';

abstract class SchedulingState {}

class SchedulingInitial extends SchedulingState {}

class SchedulingHomeState extends SchedulingState {}

class SchedulingTodayState extends SchedulingState {}

class SchedulingTomorrowState extends SchedulingState {}

class SchedulingTwodaysState extends SchedulingState {}

class SchedulingCustomState extends SchedulingState {}

class SchedulingTodayTimeState extends SchedulingState {}

class SchedulingTomorrowTimeState extends SchedulingState {}

class SchedulingTwodaysTimeState extends SchedulingState {}

class SchedulingCustomTimeState extends SchedulingState {}
