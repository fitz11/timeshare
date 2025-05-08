import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Event {
  final String title;
  final String? owner;
  final bool repeatOnDay;
  final Color color;
  final BoxShape shape;

  Event(
    this.title, {
    this.owner,
    this.repeatOnDay = false,
    this.color = Colors.black,
    this.shape = BoxShape.circle,
  });
}

List<Event> testEvents = [
  Event('Work', owner: 'David', color: Colors.blue, shape: BoxShape.rectangle),
  Event('Brunch', owner: 'Maddie', color: Colors.green, shape: BoxShape.circle),
];

final userEventList = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
);

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

DateTime today = DateTime.now();
DateTime firstDay = DateTime(today.year, DateTime.january, 1);
DateTime lastDay = DateTime(today.year, DateTime.december, 31);
