import 'dart:convert';
import 'dart:io';
import 'package:ashpazi/models/alarm.dart';
import 'package:ashpazi/models/food_tutorial.dart';
import 'package:ashpazi/tools/check_alarm.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();
  static BuildContext? context;

  static late Database _database;

  static Future<List<dynamic>> jsonDecoder(BuildContext context) async {
    String data = await DefaultAssetBundle.of(context)
        .loadString("assets/json/foodtutorial.json");

    return jsonDecode(data);
  }

  Future<Database> get database async {
    // Initializing database
    _database = await initDB();

    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "ashpazi.db");
    return await openDatabase(path, version: 5, onOpen: (db) {},
        onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < 5) {
        await db.delete("FoodsTutorial");
        setFoodsData(db);
        db.batch().commit();
      }
    }, onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE FoodsTutorial ("
          "food_id INTEGER PRIMARY KEY,"
          "food_name TEXT,"
          "food_description TEXT,"
          "food_category TEXT,"
          "food_image TEXT"
          ")");

      await db.execute("CREATE TABLE Alarms ("
          "alarm_id INTEGER PRIMARY KEY,"
          "food_id INTEGER,"
          "alarm_name TEXT,"
          "alarm_start TEXT,"
          "alarm_end TEXT,"
          "alarm_description TEXT,"
          "alarm_done INTEGER DEFAULT 0"
          ")");
      await setFoodsData(db);
    });
  }

  Future<void> setFoodsData(Database db) async {
    final data = await jsonDecoder(context!);
    for (var element in data) {
      await db.insert("FoodsTutorial", {
        "food_id": element["food_id"],
        "food_name": element["food_name"],
        "food_description": element["food_description"],
        "food_category": element["food_category"],
        "food_image": element["food_image"]
      });
    }
    db.batch().commit();
  }

  Future<List<FoodTutorial>> getAllFoods() async {
    final db = await database;

    List<FoodTutorial> food = [];
    List<Map<String, dynamic>> res = await db.query("FoodsTutorial");
    for (Map<String, dynamic> element in res) {
      food.add(
        FoodTutorial(
          id: element["food_id"],
          foodName: element["food_name"],
          foodDescription: element["food_description"],
          foodCategory: element["food_category"],
          foodImage: element["food_image"],
        ),
      );
    }
    return food;
  }

  Future setAlarm(int foodId, String alarmName, String startTime,
      String endTime, String alarmDescription) async {
    await _database.insert(
      "Alarms",
      {
        "alarm_id": null,
        "food_id": foodId,
        "alarm_name": alarmName,
        "alarm_start": startTime,
        "alarm_end": endTime,
        "alarm_description": alarmDescription,
      },
    );
  }

  Future getAllAlarms({bool last = false}) async {
    final db = await database;
    List<Map<String, dynamic>> res = await db.query("Alarms");
    if (last) {
      final lastObject = res.last;
      CheckAlarm.alarms.add(
        Alarm(
            id: lastObject["alarm_id"],
            foodId: lastObject["food_id"],
            alarmName: lastObject["alarm_name"],
            alarmStart: double.parse(lastObject["alarm_start"].toString()),
            alarmEnd: double.parse(lastObject["alarm_end"].toString()),
            alarmDescription: lastObject["alarm_description"],
            alarmDone: lastObject["alarm_done"]),
      );
    } else {
      for (Map<String, dynamic> element in res) {
        if (element["alarm_done"] != 1) {
          CheckAlarm.alarms.add(
            Alarm(
                id: element["alarm_id"],
                foodId: element["food_id"],
                alarmName: element["alarm_name"],
                alarmStart: double.parse(element["alarm_start"].toString()),
                alarmEnd: double.parse(element["alarm_end"].toString()),
                alarmDescription: element["alarm_description"],
                alarmDone: element["alarm_done"]),
          );
        }
      }
    }
  }

  Future<List<Alarm>> getAlarmsList({bool last = false}) async {
    final db = await database;
    List<Map<String, dynamic>> res =
        await db.query("Alarms", orderBy: "alarm_id desc");
    List<Alarm> alarms = [];
    for (var element in res) {
      alarms.add(
        Alarm(
          id: element["alarm_id"],
          foodId: element["food_id"],
          alarmName: element["alarm_name"],
          alarmStart: double.parse(element["alarm_start"].toString()),
          alarmEnd: double.parse(element["alarm_end"].toString()),
          alarmDescription: element["alarm_description"],
          alarmDone: element["alarm_done"],
          foodName: element["food_id"] == -1
              ? "غذای دلخواه"
              : (await db.query("FoodsTutorial",
                  where: "food_id == ?",
                  whereArgs: [element["food_id"]]))[0]["food_name"] as String,
        ),
      );
    }
    return alarms;
  }

  Future updateAlarms(int id) async {
    final db = await database;
    await db.update("Alarms", {"alarm_done": 1}, where: "alarm_id = $id");
  }
}
