import 'package:flutter/material.dart';
import 'package:forma_flutter/data/DatabaseHelper.dart';
import 'package:forma_flutter/data/HabitDao.dart';
import 'package:forma_flutter/models/habit.dart';
import 'package:forma_flutter/widgets/habit_row.dart';
import 'package:forma_flutter/screens/detail.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../viewmodels/HomeViewModel.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var viewModel = HomeViewModel.instance;
  var future = HabitDao.instance.getHabits();
  // on appear callback
  @override
  void initState() {
    super.initState();
    future = HabitDao.instance.getHabits();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('home'),
      onVisibilityChanged: (visibilityInfo) {
        if (visibilityInfo.visibleFraction == 1) {
          setState(() {
            future = HabitDao.instance.getHabits();
          });
        }
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'My Habits',
              style: TextStyle(fontSize: 26),
            ),
          ),
          body: Column(
            children: [
              FutureBuilder<List<Habit>>(
                  future: future,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Habit>> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return snapshot.data!.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.all(80.0),
                            child: Center(
                                child: Text("No habits yet. Add one!",
                                    style: TextStyle(fontSize: 20))),
                          )
                        : Expanded(
                            child: ListView(
                              shrinkWrap: true,
                              children: snapshot.data!
                                  .map((habit) => Dismissible(
                                      key: Key(habit.id.toString()),
                                      background: Container(
                                        color: Colors.red,
                                        child: const Icon(Icons.delete),
                                      ),
                                      direction: DismissDirection.endToStart,
                                      onDismissed: (direction) {
                                        HabitDao.instance
                                            .deleteHabit(habit.id!);
                                        setState(() {
                                          future =
                                              HabitDao.instance.getHabits();
                                          snapshot.data!.remove(habit);
                                        });
                                      },
                                      child: HabitRow(habit: habit)))
                                  .toList(),
                            ),
                          );
                  }),
            ],
          ),
          floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Detail()),
                );
              },
              child: const Icon(Icons.add),
              backgroundColor: Colors.purple)),
    );
  }
}
