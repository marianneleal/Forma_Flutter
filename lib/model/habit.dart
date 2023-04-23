import 'package:forma_flutter/model/task.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class Habit {
  int? id;
  String name;
  int color;
  DateTime? dueDate;
  List<Task>? tasks;

  Habit({
    this.id,
    required this.name,
    required this.color,
    this.dueDate,
    this.tasks,
  });

  factory Habit.fromMap(Map<String, dynamic> json) => Habit(
        id: json['id'],
        name: json['name'],
        color: json['color'],
        dueDate: json['dueDate'] != null
            ? DateTime.parse(json['dueDate'] as String)
            : null,
        tasks: json['tasks'] != null
            ? List<Task>.from(json['tasks'].map((x) => Task.fromMap(x)))
            : null,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'color': color,
        'dueDate': dueDate?.toIso8601String(),
        'tasks': tasks != null
            ? List<dynamic>.from(tasks!.map((x) => x.toMap()))
            : null,
      };
}

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
}
