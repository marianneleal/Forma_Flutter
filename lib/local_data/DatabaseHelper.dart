import 'package:forma_flutter/model/habit.dart';
import 'package:forma_flutter/model/task.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'habits.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE habits(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        color INTEGER NOT NULL,
        dueDate TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE tasks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        isCompleted INTEGER NOT NULL,
        habitId INTEGER NOT NULL,
        FOREIGN KEY (habitId) REFERENCES habits(id)
      )
    ''');
  }

  Future<List<Habit>> getHabits() async {
    Database db = await instance.database;
    var habits = await db.query('habits');
    List<Habit> habitList =
        habits.map((habit) => Habit.fromMap(habit)).toList();
    return habitList;
  }

  Future<int> insertHabit(Habit habit) async {
    Database db = await instance.database;
    return await db.insert('habits', habit.toMap());
  }

  Future<int> updateHabit(Habit habit) async {
    Database db = await instance.database;
    return await db.update('habits', habit.toMap(),
        where: 'id = ?', whereArgs: [habit.id]);
  }

  Future<int> deleteHabit(int id) async {
    Database db = await instance.database;
    return await db.delete('habits', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Task>> getTasksByHabitId(int habitId) async {
    Database db = await instance.database;
    var tasks =
        await db.query('tasks', where: 'habitId = ?', whereArgs: [habitId]);
    List<Task> taskList = tasks.map((task) => Task.fromMap(task)).toList();
    return taskList;
  }

  Future<int> insertTask(Task task) async {
    Database db = await instance.database;
    return await db.insert('tasks', task.toMap());
  }

  Future<int> updateTask(Task task) async {
    Database db = await instance.database;
    return await db
        .update('tasks', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }

  Future<int> deleteTask(int id) async {
    Database db = await instance.database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}
