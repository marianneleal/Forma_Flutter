import 'package:forma_flutter/model/task.dart';

class Habit {
  int? id;
  String name;
  int color;
  DateTime dueDate;
  List<Task> tasks;

  Habit({
    this.id,
    required this.name,
    required this.color,
    required this.dueDate,
    required this.tasks,
  });
}
