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
    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 20),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
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
    );
  }
}
