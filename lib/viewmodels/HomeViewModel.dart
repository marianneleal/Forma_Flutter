import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:forma_flutter/data/HabitDao.dart';

import '../models/habit.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel._privateConstructor();
  final _habitDao = HabitDao.instance;
  static final HomeViewModel instance = HomeViewModel._privateConstructor();

  // var habits = HabitDao.instance.getHabits();
  List<Habit>? habits;

  HomeViewModel() {
    getAllHabits();
  }

  Future<void> getAllHabits() async {
    habits = await _habitDao.getHabits();
    notifyListeners();
  }

  void removeHabit(Habit habit) async {
    await _habitDao.deleteHabit(habit.id!);
  }
}
