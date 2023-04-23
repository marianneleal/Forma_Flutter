import '../model/habit.dart';
import '../model/task.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';

@Database(version: 1, entities: [Task, Habit])
abstract class MyDatabase extends FloorDatabase {
  // DAOs
  TaskDao get taskDao;
  HabitDao get habitDao;

  static Future<MyDatabase> getInstance() async {
    return await $FloorMyDatabase.databaseBuilder('my_database.db').build();
  }
}
