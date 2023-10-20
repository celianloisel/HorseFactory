import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'lesson.dart';

class CalendarState extends ChangeNotifier {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  Map<DateTime, List<Lesson>> _events = {};

  CalendarFormat get calendarFormat => _calendarFormat;
  DateTime get selectedDay => _selectedDay;
  Map<DateTime, List<Lesson>> get events => _events;

  void setCalendarFormat(CalendarFormat format) {
    _calendarFormat = format;
    notifyListeners();
  }

  void setSelectedDay(DateTime day) {
    _selectedDay = day;
    notifyListeners();
  }

  void setEvents(Map<DateTime, List<Lesson>> events) {
    _events = events;
    notifyListeners();
  }
}
