import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../appBar/home_appBar.dart';
import '../models/user.dart';
import '../models/lesson.dart';
import '../utils/mongo_database.dart';

// Pas le temps de finir mais le problème est le faite que la date est l'heure soit stocké en même temps
// Cela auurait été mieux de les séparer mais bon, semaine cool
// Merci à vous tous !!!!!!

class HomePage extends StatefulWidget {
  late User user;

  HomePage({required this.user});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  Map<DateTime, List<Lesson>> _events = {};
  final mongoDatabase = MongoDatabase();

  Future<void> fetchEventsFromDatabase() async {
    final lessons = await mongoDatabase.getLessons();
    print(lessons);

    if (!mounted) {
      return;
    }

    final updatedEvents = <DateTime, List>{};

    for (final lesson in lessons) {
      final lessonDate = lesson.date;

      if (updatedEvents.containsKey(lessonDate)) {
        updatedEvents[lessonDate]!.add(lesson);
      } else {
        updatedEvents[lessonDate] = [lesson];
      }
    }

    if (mounted) {
      setState(() {
        _events = updatedEvents.map((key, value) => MapEntry(key, value.cast<Lesson>()));
      });
    }

  }


  @override
  void initState() {
    super.initState();
    fetchEventsFromDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(title: 'Home Page', user: widget.user),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Container(
              height: 300,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/box_chevaux.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Hey, you',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: TableCalendar(
              calendarFormat: _calendarFormat,
              focusedDay: _focusedDay,
              firstDay: DateTime.utc(2023, 1, 1),
              lastDay: DateTime.utc(2023, 12, 31),
              eventLoader: (day) {
                return _events[day] ?? [];
              },
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  final hasLessons = _events[date] != null && _events[date]!.isNotEmpty;
                  if (hasLessons) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      width: 5.0,
                      height: 5.0,
                    );
                  } else {
                  return Container();
                  }
                },
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
              ),
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              onPageChanged: (day) {
                if (mounted) {
                  setState(() {
                    _focusedDay = day;
                  });
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
