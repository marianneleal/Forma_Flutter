import 'package:forma_flutter/data/DatabaseHelper.dart';
import 'package:forma_flutter/models/habit.dart';
import 'package:forma_flutter/models/task.dart';
import 'package:sqflite/sqflite.dart';

class TaskDao {
  TaskDao._privateConstructor();

  static final TaskDao instance = TaskDao._privateConstructor();

  Future<List<Task>> getTasksByHabitId(int habitId) async {
    Database db = await DatabaseHelper.instance.database;
    var tasks =
        await db.query('tasks', where: 'habitId = ?', whereArgs: [habitId]);
    List<Task> taskList = tasks.map((task) => Task.fromMap(task)).toList();
    return taskList;
  }

  Future insertTasks(List<Task> tasks) async {
    Database db = await DatabaseHelper.instance.database;
    Batch batch = db.batch();
    for (Task task in tasks) {
      batch.insert('tasks', task.toMap());
    }
    return await batch.commit(noResult: true);
  }

  Future updateTasks(List<Task> tasks) async {
    Database db = await DatabaseHelper.instance.database;
    Batch batch = db.batch();
    for (Task task in tasks) {
      batch
          .update('tasks', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
    }
    return await batch.commit(noResult: true);
  }

  Future<int> deleteTask(int id) async {
    Database db = await DatabaseHelper.instance.database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}
