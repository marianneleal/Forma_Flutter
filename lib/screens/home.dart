import 'package:flutter/material.dart';
import 'package:forma_flutter/model/habit.dart';
import 'package:forma_flutter/widgets/habit_row.dart';

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
            FutureBuilder<List<Habit>>(
                future: DatabaseHelper.instance.getHabits(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Habit>> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return snapshot.data!.isEmpty
                      ? const Center(child: Text("No habits yet. Add one!"))
                      : ListView(
                          shrinkWrap: true,
                          children: snapshot.data!
                              .map((habit) => HabitRow(habit: habit))
                              .toList(),
                        );
                }),
          ],
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Detail()),
              );
            },
            child: const Icon(Icons.add),
            backgroundColor: Colors.purple));
  }
}
