import 'package:flutter/material.dart';
import 'package:forma_flutter/local_data/DatabaseHelper.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../model/habit.dart';
import '../model/task.dart';
import 'package:intl/intl.dart';

import '../widgets/task_row.dart';

class Detail extends StatefulWidget {
  final Habit? habit;
  Detail({Key? key, this.habit}) : super(key: key);

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  late TextEditingController _nameController;
  late bool _hasDueDate;
  late DateTime? _dueDate;
  late Color _color;
  List<Task> _tasks = [];
  bool _colorPickerOpen = false;

  @override
  void initState() {
    super.initState();
    if (widget.habit != null) {
      _nameController = TextEditingController(text: widget.habit!.name);
      _hasDueDate = widget.habit!.dueDate != null;
      _dueDate = widget.habit!.dueDate!;
      _color = Color(widget.habit!.color);
    } else {
      _nameController = TextEditingController();
      _hasDueDate = false;
      _dueDate = DateTime.now();
      _color = Colors.grey;
    }
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    if (widget.habit != null) {
      _tasks =
          await DatabaseHelper.instance.getTasksByHabitId(widget.habit!.id!);
    }
  }

  void _save() async {
    final habit = widget.habit ?? Habit(name: "", color: Colors.grey.value);
    habit.name = _nameController.text;
    habit.dueDate = _dueDate;
    habit.color = _color.value;
    if (widget.habit == null) {
      await DatabaseHelper.instance.insertHabit(habit);
    } else {
      await DatabaseHelper.instance.updateHabit(habit);
    }
    for (final task in _tasks) {
      await DatabaseHelper.instance.updateHabit(habit);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.habit == null ? 'Add Habit' : widget.habit!.name),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8.0),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Habit Name',
                ),
              ),
              const SizedBox(height: 16.0),
              InkWell(
                onTap: () {
                  setState(() {
                    _colorPickerOpen = !_colorPickerOpen;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    elevation: 2.0,
                    borderRadius: BorderRadius.circular(8.0),
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
                              color: _color,
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
              if (_colorPickerOpen)
                ColorPicker(
                  pickerColor: _color,
                  onColorChanged: (color) {
                    setState(() {
                      _color = color;
                      print(color);
                    });
                  },
                ),
              SizedBox(
                height: 36.0,
                child: Row(
                  children: [
                    const Text('Add due date'),
                    Checkbox(
                      value: _hasDueDate,
                      onChanged: (value) {
                        setState(() {
                          _hasDueDate = value!;
                          _addDueDate();
                        });
                      },
                    ),
                  ],
                ),
              ),
              if (_hasDueDate && _dueDate != null)
                SizedBox(
                  height: 36.0,
                  child: Text("Due Date: " +
                      DateFormat('d MMM').format(_dueDate!).toString()),
                ),
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  for (final task in _tasks)
                    Dismissible(
                      key: Key(task.id.toString()),
                      background: Container(
                          color: Colors.red, child: const Icon(Icons.delete)),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        if (task.id != null) {
                          DatabaseHelper.instance.deleteTask(task.id!);
                        }
                        setState(() {
                          _tasks.remove(task);
                        });
                      },
                      child: TaskRow(
                        task: task,
                      ),
                    )
                ],
              ),
              ElevatedButton(
                onPressed: () {
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
                              setState(() {
                                _tasks.add(
                                    Task(name: taskName, isCompleted: false));
                              });
                              Navigator.pop(context);
                            },
                            child: const Text('Add'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Row(
                  children: const [
                    Icon(Icons.add),
                    SizedBox(width: 5),
                    Text('Add task'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () async {
        final habitId = await DatabaseHelper.instance.insertHabit(
          Habit(
            name: _nameController.text,
            color: _color.value,
            dueDate: _dueDate,
          ),
        );
        for (Task task in _tasks) {
          task.habitId = habitId;
        }
        await DatabaseHelper.instance.insertTasks(_tasks);
        Navigator.pop(context);
      }),
    );
  }

  Future<DateTime?> _selectDueDate() async {
    if (!_hasDueDate) {
      final date = null;
    } else {
      final date = await showDatePicker(
        context: context,
        initialDate: _dueDate != null ? _dueDate! : DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      return date;
    }
  }

  Future<void> _addDueDate() async {
    final date = await _selectDueDate();
    if (date != null) {
      setState(() {
        _hasDueDate = true;
        _dueDate = date;
      });
    } else {
      setState(() {
        _hasDueDate = false;
        _dueDate = null;
      });
    }
  }
}
