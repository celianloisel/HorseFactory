import 'package:flutter/material.dart';
import 'package:horse_factory/models/lesson.dart';
import 'package:horse_factory/models/user.dart';
import 'package:horse_factory/utils/mongo_database.dart';
import 'package:horse_factory/widgets/pop_up_lesson_content_widget.dart';
import 'package:horse_factory/widgets/pop_up_widget.dart';

class LessonsPage extends StatefulWidget {
  const LessonsPage({super.key, required this.user});

  final User user;

  @override
  LessonsPageState createState() => LessonsPageState();
}

class LessonsPageState extends State<LessonsPage> {
  var discipline = 'Dressage';
  var place = "Indoor arena";
  var duration = "30 minutes";
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  List<Lesson> lessons = [];

  MongoDatabase mongoDatabase = MongoDatabase();

  @override
  void initState() {
    loadLessons();
    super.initState();
  }

  Future<void> loadLessons() async {
    final lessonsList = await mongoDatabase.getLessons();
    setState(() {
      lessons = lessonsList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cours'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          const Text(
            'Cours',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Bienvenue dans l\'espace des cours',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 48),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: lessons.length,
              itemBuilder: (BuildContext context, int index) {
                final lesson = lessons[index];
                if (lesson.date.isAfter(DateTime.now())) {
                  return Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.menu_book_outlined),
                          title: Text(
                              '${lesson.discipline == Discipline.dressage ? "Dressage" : lesson.discipline == Discipline.endurance ? "Endurance" : "Saut d’obstacle"} - ${lesson.place == Place.indoorArena ? 'Manège' : 'Carrière'}'
                          ),
                          subtitle: Text(
                              'Date: ${lesson.date.day}/${lesson.date.month}/${lesson.date.year} à ${lesson.date.hour}h${lesson.date.minute} - ${lesson.duration} minutes'
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return PopUpWidget(
                title: 'Popup Title',
                content: PopUpLessonContentWidget(
                  onUpdate: (
                    String updatedDiscipline,
                    String updatedPlace,
                    String updatedDuration,
                    DateTime updatedDate,
                    TimeOfDay updatedTime,
                  ) {
                    setState(() {
                      discipline = updatedDiscipline;
                      place = updatedPlace;
                      duration = updatedDuration;
                      selectedDate = updatedDate;
                      selectedTime = updatedTime;
                    });
                  },
                ),
                acceptButtonText: 'OK',
                acceptButtonFunction: () {
                  DateTime finalDateTime = DateTime(
                    selectedDate.year,
                    selectedDate.month,
                    selectedDate.day,
                    selectedTime.hour,
                    selectedTime.minute,
                  );

                  Lesson newLesson = Lesson(
                    place: place == 'Indoor arena'
                        ? Place.indoorArena
                        : Place.outdoorArena,
                    date: finalDateTime,
                    duration: duration == '30 minutes' ? 30 : 60,
                    discipline: discipline == 'Dressage'
                        ? Discipline.dressage
                        : discipline == 'Show Jumping'
                            ? Discipline.showJumping
                            : Discipline.endurance,
                    status: 'pending',
                    userId: widget.user.id,
                  );

                  mongoDatabase.createLesson(newLesson);

                  loadLessons();

                  Navigator.of(context).pop();
                },
                cancelButtonText: 'Cancel',
              );
            },
          );
        },
        tooltip: 'Ajouter un cours',
        child: const Icon(Icons.add),
      ),
    );
  }
}
