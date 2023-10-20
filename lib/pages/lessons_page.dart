import 'package:flutter/material.dart';
import 'package:horse_factory/models/lesson.dart';
import 'package:horse_factory/models/user.dart';
import 'package:horse_factory/utils/date_utils.dart';
import 'package:horse_factory/utils/enum_utils.dart';
import 'package:horse_factory/utils/mongo_database.dart';
import 'package:horse_factory/widgets/pop_up_lesson_content_widget.dart';
import 'package:horse_factory/widgets/pop_up_widget.dart';
import 'package:mongo_dart/mongo_dart.dart' hide State;

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

  bool viewingPendingLessons = false;

  MongoDatabase mongoDatabase = MongoDatabase();

  @override
  void initState() {
    loadLessons();
    print(widget.user.roles);
    super.initState();
  }

  Future<void> loadLessons() async {
    late SelectorBuilder query;
    if (viewingPendingLessons) {
      query = where
          // Récupère les cours en attente, triés par date après maintenant
          .ne('userId', widget.user.id) // tous les autres utilisateurs
          .eq('status', Status.pending.name)
          .sortBy('date', descending: false)
          .gt('date', DateTime.now());
    } else {
      // Récupère les cours de l'utilisateur, triés par date après maintenant
      query = where
          .eq('userId', widget.user.id)
          .sortBy('date', descending: false)
          .gt('date', DateTime.now());
    }
    final lessonsList = await mongoDatabase.getLessons(query);
    setState(() {
      lessons = lessonsList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cours'), actions: [
        // if admin show button to view pending lessons
        if (widget.user.roles.contains('ADMIN'))
          TextButton(
            child: Text(
              viewingPendingLessons
                  ? 'Voir mes cours'
                  : 'Voir les cours en attente',
              style: const TextStyle(color: Colors.white),
            ),
            onPressed: () {
              setState(() {
                viewingPendingLessons = !viewingPendingLessons;
              });
              loadLessons(); // Rechargez les cours
            },
          )
      ]),
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
                final disciplineString = getEnumValueString(lesson.discipline);
                final placeString = getEnumValueString(lesson.place);
                final dateString = getDateTimeString(lesson.date);

                late Icon statusIcon;
                switch (lesson.status) {
                  case Status.approved:
                    statusIcon = const Icon(Icons.check, color: Colors.green);
                    break;
                  case Status.rejected:
                    statusIcon = const Icon(Icons.close, color: Colors.red);
                    break;
                  default:
                    statusIcon = const Icon(Icons.pending);
                    break;
                }

                return Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.menu_book_outlined),
                        title: Text('$disciplineString - $placeString'),
                        subtitle: Text(
                            'Date: $dateString - ${lesson.duration} minutes'),
                        // Afficher l'icone de statut dans le trailing si viewingPendingLessons est faux
                        trailing: !viewingPendingLessons
                            ? statusIcon
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon:
                                        Icon(Icons.check, color: Colors.green),
                                    onPressed: () {
                                      mongoDatabase.updateLessonStatus(
                                          lesson.id!, Status.approved);
                                      loadLessons();
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.close, color: Colors.red),
                                    onPressed: () {
                                      mongoDatabase.updateLessonStatus(
                                          lesson.id!, Status.rejected);
                                      loadLessons();
                                    },
                                  ),
                                ],
                              ),
                      ),
                    ],
                  ),
                );
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
