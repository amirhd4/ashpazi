class Alarm {
  int id;
  int foodId;
  String alarmName;
  double alarmStart;
  double alarmEnd;
  String alarmDescription;
  int alarmDone;
  String? foodName;
  Alarm({
    required this.id,
    required this.foodId,
    required this.alarmName,
    required this.alarmStart,
    required this.alarmEnd,
    required this.alarmDescription,
    required this.alarmDone,
    this.foodName,
  });
}
