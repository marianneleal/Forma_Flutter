import 'package:flutter/material.dart';

class HabitRow extends StatelessWidget {
  const HabitRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 20),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            child: const Icon(
              Icons.check_box_outline_blank,
              size: 30,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Habit Name',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Habit Description',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            margin: const EdgeInsets.only(right: 20),
            child: const Icon(
              Icons.arrow_forward_ios,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}
