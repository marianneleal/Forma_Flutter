import 'package:flutter/material.dart';
import 'package:forma_flutter/widgets/habit_row.dart';

import '../model/task.dart';
import '../widgets/task_row.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'My Habits',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  HabitRow(),
                  TaskRow(
                      task:
                          Task(id: 1, name: 'Drink water', isCompleted: false))
                ],
              ),
            )
          ],
        ));
  }
}
