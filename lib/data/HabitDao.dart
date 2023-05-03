import 'package:forma_flutter/data/DatabaseHelper.dart';
import 'package:forma_flutter/models/habit.dart';
import 'package:sqflite/sqflite.dart';

class HabitDao {
  HabitDao._privateConstructor();
  static final HabitDao instance = HabitDao._privateConstructor();
  Future<List<Habit>> getHabits() async {
    Database db = await DatabaseHelper.instance.database;
    var habits = await db.query('habits');
    List<Habit> habitList =
        habits.map((habit) => Habit.fromMap(habit)).toList();
    return habitList;
  }

  Future<int> insertHabit(Habit habit) async {
    Database db = await DatabaseHelper.instance.database;
    return await db.insert('habits', habit.toMap());
  }

  Future<int> updateHabit(Habit habit) async {
    Database db = await DatabaseHelper.instance.database;
    return await db.update('habits', habit.toMap(),
        where: 'id = ?', whereArgs: [habit.id]);
  }

  Future<int> deleteHabit(int id) async {
    Database db = await DatabaseHelper.instance.database;
    return await db.delete('habits', where: 'id = ?', whereArgs: [id]);
  }
}
