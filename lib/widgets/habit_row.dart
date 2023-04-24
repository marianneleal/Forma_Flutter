import 'package:flutter/material.dart';
import 'package:forma_flutter/model/habit.dart';

import '../screens/detail.dart';

class HabitRow extends StatelessWidget {
  const HabitRow({Key? key, required this.habit}) : super(key: key);
  final Habit habit;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Detail(habit: habit)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        child: Material(
          borderRadius: BorderRadius.circular(10.0),
          elevation: 3.0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  constraints: BoxConstraints(minWidth: 50),
                  width: 35.0,
                  height: 35.0,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  decoration: BoxDecoration(
                    color: Color(habit.color),
                    shape: BoxShape.circle,
                  ),
                ),
                Text(habit.name,
                    style: const TextStyle(
                      fontSize: 20,
                    )),
                const Spacer(),
                // Container(
                //   margin: const EdgeInsets.only(right: 20),
                //   child: const Icon(Icons.arrow_forward_ios,
                //       size: 30, color: Colors.grey),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
