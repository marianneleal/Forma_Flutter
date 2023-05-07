import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:forma_flutter/data/TaskDao.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../models/habit.dart';
import '../models/task.dart';
import 'package:intl/intl.dart';
import '../viewmodels/DetailViewModel.dart';
import '../widgets/task_row.dart';

class Detail extends StatefulWidget {
  final Habit? habit;
  const Detail({Key? key, this.habit}) : super(key: key);

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DetailViewModel(widget.habit),
      child: Consumer<DetailViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text(viewModel.habit == null
                  ? 'Add Habit'
                  : viewModel.habit!.name),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8.0),
                    const Text("HABIT INFO"),
                    TextFormField(
                      controller: viewModel.nameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Habit Name',
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    InkWell(
                      onTap: () {
                        viewModel.toggleColorPicker();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          elevation: 2.0,
                          borderRadius: BorderRadius.circular(4.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                const Text(
                                  'Color',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                                Container(
                                  width: 35.0,
                                  height: 35.0,
                                  decoration: BoxDecoration(
                                    color: viewModel.color,
                                    shape: BoxShape.circle,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    if (viewModel.colorPickerOpen)
                      ColorPicker(
                        pickerColor: viewModel.color,
                        onColorChanged: (color) {
                          viewModel.setColor(color);
                          print(color);
                        },
                      ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Material(
                        elevation: 3.0,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    viewModel.dueDateText,
                                    style: const TextStyle(fontSize: 20.0),
                                  ),
                                  ToggleSwitch(
                                    iconSize: 10,
                                    cornerRadius: 20.0,
                                    activeBgColors: [
                                      const [Colors.grey],
                                      [Colors.green[800]!]
                                    ],
                                    radiusStyle: true,
                                    activeFgColor: Colors.white,
                                    inactiveBgColor: Colors.grey[300],
                                    inactiveFgColor: Colors.white,
                                    initialLabelIndex:
                                        viewModel.hasDueDate ? 1 : 0,
                                    labels: const ['off', 'on'],
                                    totalSwitches: 2,
                                    onToggle: (index) {
                                      viewModel.toggleDueDate();
                                      _addDueDate(viewModel);
                                      print('switched to: $index');
                                    },
                                  )
                                ],
                              ),
                            ),
                            if (viewModel.hasDueDate &&
                                viewModel.dueDate != null)
                              SizedBox(
                                height: 36.0,
                                child: Text(
                                    DateFormat('d MMM')
                                        .format(viewModel.dueDate!)
                                        .toString(),
                                    style: const TextStyle(
                                      fontSize: 20.0,
                                    )),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const Text("TASKS"),
                    Card(
                      child: Column(
                        children: [
                          Column(
                            // shrinkWrap: true,
                            // physics: const NeverScrollableScrollPhysics(),
                            children: [
                              for (final task in viewModel.tasks)
                                Dismissible(
                                  key: Key(task.hashCode.toString()),
                                  background: Container(
                                      color: Colors.red,
                                      child: const Icon(Icons.delete)),
                                  direction: DismissDirection.endToStart,
                                  onDismissed: (direction) {
                                    viewModel.deleteTask(task);
                                  },
                                  child: TaskRow(
                                    task: task,
                                  ),
                                )
                            ],
                          ),
                          Material(
                            borderRadius: BorderRadius.circular(4.0),
                            elevation: 3.0,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      String taskName = '';
                                      return AlertDialog(
                                        title: const Text('Add task'),
                                        content: TextField(
                                          autofocus: true,
                                          decoration: const InputDecoration(
                                            labelText: 'Task name',
                                          ),
                                          onChanged: (value) {
                                            taskName = value;
                                          },
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              viewModel.tasks.add(Task(
                                                  name: taskName,
                                                  isCompleted: false));
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              'Add',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Row(
                                  children: const [
                                    Icon(Icons.add_circle),
                                    SizedBox(width: 5),
                                    Text('Add task'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
                child: const Icon(Icons.save),
                onPressed: () async {
                  viewModel.save();
                  Navigator.pop(context);
                }),
          );
        },
      ),
    );
  }

  Future<DateTime?> _selectDueDate(DetailViewModel viewModel) async {
    if (!viewModel.hasDueDate) {
      final date = null;
    } else {
      final date = await showDatePicker(
        context: context,
        initialDate:
            viewModel.dueDate != null ? viewModel.dueDate! : DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      return date;
    }
  }

  Future<void> _addDueDate(DetailViewModel viewModel) async {
    final date = await _selectDueDate(viewModel);
    if (date != null) {
      viewModel.hasDueDate = true;
      viewModel.dueDate = date;
    } else {
      viewModel.hasDueDate = false;
      viewModel.dueDate = null;
    }
  }
}
