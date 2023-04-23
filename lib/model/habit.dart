import 'package:forma_flutter/model/task.dart';

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
