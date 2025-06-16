import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Event {
  final String title;
  final DateTime time;
  final String? owner;
  final bool repeatOnDay;
  final Color color;
  final BoxShape shape;

  Event(
    this.title,
    this.time, {
    this.owner,
    this.repeatOnDay = false,
    this.color = Colors.black,
    this.shape = BoxShape.circle,
  });
}

List<Event> testEvents = [
  Event(
    'Work',
    DateTime.utc(2025, 6, 15),
    owner: 'David',
    color: Colors.blue,
    shape: BoxShape.rectangle,
  ),
  Event(
    'Brunch',
    DateTime.utc(2025, 6, 16),
    owner: 'Maddie',
    color: Colors.green,
    shape: BoxShape.circle,
  ),
];

final userEventList = Map<DateTime, List<Event>>();

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

DateTime today = DateTime.now();
DateTime firstDay = DateTime(today.year, DateTime.january, 1);
DateTime lastDay = DateTime(today.year, DateTime.december, 31);
