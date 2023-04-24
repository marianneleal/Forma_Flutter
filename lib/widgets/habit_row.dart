import 'package:flutter/material.dart';
import 'package:forma_flutter/model/habit.dart';

import '../screens/detail.dart';

class HabitRow extends StatelessWidget {
  const HabitRow({Key? key, required this.habit}) : super(key: key);
  final Habit habit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Detail(habit: habit)),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(top: 10, bottom: 10),
          child: Material(
            borderRadius: BorderRadius.circular(4.0),
            elevation: 3.0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    constraints: BoxConstraints(minWidth: 50),
                    width: 35.0,
                    height: 35.0,
                    margin: const EdgeInsets.only(left: 4, right: 10),
                    decoration: BoxDecoration(
                      color: Color(habit.color),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Wrap(spacing: 8.0, children: [
                      Text(habit.name,
                          style: const TextStyle(
                            fontSize: 20,
                          )),
                    ]),
                  ),
                  Icon(Icons.navigate_next, color: Colors.grey[600], size: 30)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
