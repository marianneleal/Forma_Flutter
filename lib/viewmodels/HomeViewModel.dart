import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:forma_flutter/data/HabitDao.dart';

class HomeViewModel {
  HomeViewModel._privateConstructor();
  final _habitDao = HabitDao.instance;
  static final HomeViewModel instance = HomeViewModel._privateConstructor();
  static Database? _database;

  getAllHabits() async {
    return await _habitDao.getHabits();
  }
}
