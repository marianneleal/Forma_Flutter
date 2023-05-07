import 'package:flutter/material.dart';
import 'package:forma_flutter/widgets/habit_row.dart';
import 'package:forma_flutter/screens/detail.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../viewmodels/HomeViewModel.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeViewModel(),
      child: Consumer<HomeViewModel>(
        builder: (context, viewModel, child) {
          return VisibilityDetector(
            key: const Key('home'),
            onVisibilityChanged: (visibilityInfo) {
              if (visibilityInfo.visibleFraction == 1) {
                viewModel.getAllHabits();
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
                    _buildHabitList(viewModel),
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
                    backgroundColor: Colors.purple)),
          );
        },
      ),
    );
  }

  Widget _buildHabitList(HomeViewModel viewModel) {
    if (viewModel.habits == null) {
      return const Center(child: CircularProgressIndicator());
    } else {
      if (viewModel.habits!.isEmpty) {
        return const Center(
          child: Text(
            "No habits yet. Add one!",
            style: TextStyle(fontSize: 20),
          ),
        );
      } else {
        return Expanded(
          child: ListView(
            shrinkWrap: true,
            children: viewModel.habits!
                .map((habit) => Dismissible(
                    key: UniqueKey(),
                    background: Container(
                      color: Colors.red,
                      child: const Icon(Icons.delete),
                    ),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      viewModel.removeHabit(habit);
                      viewModel.getAllHabits();
                    },
                    child: HabitRow(habit: habit)))
                .toList(),
          ),
        );
      }
    }
  }
}
