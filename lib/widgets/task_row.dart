import 'package:flutter/material.dart';

import '../model/task.dart';

class TaskRow extends StatefulWidget {
  final Task task;

  const TaskRow({Key? key, required this.task}) : super(key: key);

  @override
  _TaskRowState createState() => _TaskRowState();
}

class _TaskRowState extends State<TaskRow> {
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.task.isCompleted;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(10.0),
        elevation: 3.0,
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 10),
              child: Checkbox(
                value: _isChecked,
                onChanged: (value) {
                  setState(() {
                    _isChecked = value!;
                    widget.task.isCompleted = value;
                  });
                },
              ),
            ),
            Text(
              widget.task.name,
              style: TextStyle(
                fontSize: 16,
                color: widget.task.isCompleted ? Colors.grey : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
