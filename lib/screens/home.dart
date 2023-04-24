import 'package:flutter/material.dart';
import 'package:forma_flutter/local_data/DatabaseHelper.dart';
import 'package:forma_flutter/model/habit.dart';
import 'package:forma_flutter/widgets/habit_row.dart';
import 'package:forma_flutter/screens/detail.dart';
import 'package:visibility_detector/visibility_detector.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var future = DatabaseHelper.instance.getHabits();

  // on appear callback
  @override
  void initState() {
    super.initState();
    future = DatabaseHelper.instance.getHabits();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('home'),
      onVisibilityChanged: (visibilityInfo) {
        if (visibilityInfo.visibleFraction == 1) {
          setState(() {
            future = DatabaseHelper.instance.getHabits();
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
                        ? Padding(
                            padding: const EdgeInsets.all(80.0),
                            child: const Center(
                                child: Text("No habits yet. Add one!",
                                    style: TextStyle(fontSize: 20))),
                          )
                        : ListView(
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
                                      DatabaseHelper.instance
                                          .deleteHabit(habit.id!);
                                      setState(() {
                                        future =
                                            DatabaseHelper.instance.getHabits();
                                        snapshot.data!.remove(habit);
                                      });
                                    },
                                    child: HabitRow(habit: habit)))
                                .toList(),
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
