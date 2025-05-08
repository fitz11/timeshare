import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class TestCalendar extends StatefulWidget {
  const TestCalendar({super.key});

  @override
  State<StatefulWidget> createState() => _TestCalendarState();
}

class _TestCalendarState extends State<TestCalendar> {
  DateTime today = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('calendar testing'), elevation: 5),
      body: TableCalendar(
        focusedDay: today,
        firstDay: DateTime(today.year, DateTime.january, 1),
        lastDay: DateTime(today.year, DateTime.december, 31),
        shouldFillViewport: false,
        weekNumbersVisible: true,
      ),
    );
  }
}
