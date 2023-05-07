import 'package:flutter/material.dart';
import '../data/HabitDao.dart';
import '../data/TaskDao.dart';
import '../models/habit.dart';
import '../models/task.dart';

class DetailViewModel extends ChangeNotifier {
  Habit? habit;

  late TextEditingController nameController;
  late bool hasDueDate;
  DateTime? dueDate;
  late Color color;
  List<Task> tasks = [];
  bool colorPickerOpen = false;

  String get dueDateText => hasDueDate ? 'Due Date' : 'No due date';

  DetailViewModel(this.habit) {
    if (habit != null) {
      nameController = TextEditingController(text: habit!.name);
      color = Color(habit!.color);
      hasDueDate = habit!.dueDate != null;
      if (!hasDueDate) {
        dueDate = DateTime.now();
      } else {
        dueDate = habit!.dueDate;
      }
      fetchTasks();
    } else {
      color = Colors.grey;
      nameController = TextEditingController();
      hasDueDate = false;
      dueDate = null;
    }
  }

  void save() async {
    if (habit?.id == null) {
      final habitId = await HabitDao.instance.insertHabit(Habit(
        name: nameController.text,
        color: color.value,
        dueDate: dueDate,
      ));
      for (Task task in tasks) {
        task.habitId = habitId;
      }
    } else {
      habit!.name = nameController.text;
      habit!.color = color.value;
      habit!.dueDate = dueDate;
      await HabitDao.instance.updateHabit(habit!);
      for (Task task in tasks) {
        task.habitId = habit!.id!;
      }
    }

    final newTasks = tasks.where((task) => task.id == null).toList();
    final existingTasks = tasks.where((task) => task.id != null).toList();

    // await two futures
    await Future.wait([
      TaskDao.instance.insertTasks(newTasks),
      TaskDao.instance.updateTasks(existingTasks),
    ]);
  }

  Future<void> fetchTasks() async {
    if (habit != null) {
      tasks = await TaskDao.instance.getTasksByHabitId(habit!.id!);
      notifyListeners();
    }
  }

  void toggleColorPicker() {
    colorPickerOpen = !colorPickerOpen;
    notifyListeners();
  }

  void setColor(Color newColor) {
    color = newColor;
    notifyListeners();
  }

  void toggleDueDate() {
    hasDueDate = !hasDueDate;
    notifyListeners();
  }
}
