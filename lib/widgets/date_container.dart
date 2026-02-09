import 'package:flutter/material.dart';

class DateContainer extends StatelessWidget {
  final Color background;
  final TextStyle dayColor;
  final TextStyle weekDayColor;
  final String weekDay;
  final String day;

  DateContainer({
    super.key,
    required this.background,
    required this.dayColor,
    required this.weekDayColor,
    required this.weekDay,
    required this.day,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 66,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: background,
        border: Border.all(color: Colors.black), // Adjust as needed
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(weekDay, style: weekDayColor),
          ),
          Text(day, style: dayColor),
        ],
      ),
    );
  }
}
