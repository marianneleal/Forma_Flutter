import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'HabitDao.dart';
import 'TaskDao.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  final _taskDao = TaskDao.instance;
  final _habitDao = HabitDao.instance;
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
      CREATE TABLE habits (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        color INTEGER NOT NULL,
        dueDate TEXT,
        UNIQUE(id) ON CONFLICT REPLACE
);
    ''');
    await db.execute('''
      CREATE TABLE tasks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        isCompleted INTEGER NOT NULL,
        habitId INTEGER NOT NULL,
        FOREIGN KEY (habitId) REFERENCES habits(id),
      )
    ''');
  }
}
