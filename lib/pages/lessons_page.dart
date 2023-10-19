import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:horse_factory/models/user.dart';
import 'package:horse_factory/utils/date_utils.dart';
import 'package:horse_factory/utils/enum_utils.dart';
import 'package:mongo_dart/mongo_dart.dart' hide State;

import 'package:horse_factory/models/lesson.dart';
import 'package:horse_factory/utils/mongo_database.dart';

class LessonsPage extends StatefulWidget {
  late User user;

  LessonsPage({Key? key, required this.user}) : super(key: key);

  @override
  State<LessonsPage> createState() => _LessonsPageState();
}

class _LessonsPageState extends State<LessonsPage> {
  final List<Lesson> _lessons = [];
  final lessonsCollection = MongoDatabase().getCollection("lessons");

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _getLessons();
  }

  Future<void> _getLessons() async {
    ObjectId userId = widget.user.id;

    SelectorBuilder query =
        where.eq('userId', userId).sortBy('date', descending: true);
    final List<Map<String, dynamic>> data =
        await lessonsCollection.find(query).toList();

    for (var lessonData in data) {
      try {
        setState(() {
          _lessons.add(Lesson.fromMap(lessonData, lessonData['_id']));
        });
      } catch (e) {
        print(
            "Impossible de convertir l'objet suivant en cours : $lessonData : $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lessons List'),
      ),
      body: ListView.builder(
        itemCount: _lessons.length,
        itemBuilder: (context, index) {
          final lesson = _lessons[index];

          late final Icon icon;
          switch (lesson.status.name) {
            case "approved":
              icon = const Icon(Icons.check);
              break;
            case "rejected":
              icon = const Icon(Icons.close);
              break;
            default:
              icon = const Icon(Icons.pending);
              break;
          }

          late final Color color;
          switch (lesson.status.name) {
            case "approved" || "completed":
              color = Colors.green;
              break;
            case "rejected":
              color = Colors.red;
              break;
            default:
              color = Colors.grey;
              break;
          }

          final date = getDateTimeString(lesson.date);

          // Affiche "x min" si minutes inférieur à 60, sinon affiche au format "HHhmm"
          late final String duration;
          if (lesson.duration < 60) {
            duration = "${lesson.duration}min";
          } else {
            String hours = (lesson.duration ~/ 60).toString();
            String minutes = (lesson.duration % 60).toString();
            if (minutes.length == 1) minutes = "0$minutes";

            duration = "${hours}h$minutes";
          }

          return Card(
            child: ListTile(
              leading: icon,
              title: Text(getEnumValueString(lesson.discipline)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(getEnumValueString(lesson.place)),
                  Row(
                    children: [
                      Text(date),
                      const SizedBox(width: 10.0),
                    ],
                  )
                ],
              ),
              trailing: Text(duration),
              tileColor: color,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddLessonDialog,
        tooltip: 'Add lesson',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddLessonDialog() {
    showDialog(
      context: context,
      builder: (context) {
        var discipline = 'Dressage';
        var place = "Indoor arena";
        var duration = "30 minutes";

        DateTime selectedDate = DateTime.now();
        TimeOfDay selectedTime = TimeOfDay.now();

        return AlertDialog(
          title: const Text('Plan new lesson'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Discipline
                DropdownButtonFormField(
                  value: discipline,
                  onChanged: (String? newValue) {
                    setState(() {
                      discipline = newValue!;
                    });
                  },
                  items: <String>['Dressage', 'Show Jumping', 'Endurance']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(fontSize: 20),
                      ),
                    );
                  }).toList(),
                ),
                // Lieu
                DropdownButtonFormField(
                  value: place,
                  onChanged: (String? newValue) {
                    setState(() {
                      place = newValue!;
                    });
                  },
                  items: <String>['Indoor arena', 'Outdoor arena']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(fontSize: 20),
                      ),
                    );
                  }).toList(),
                ),

                // Durée
                DropdownButtonFormField(
                  value: duration,
                  onChanged: (String? newValue) {
                    setState(() {
                      duration = newValue!;
                    });
                  },
                  items: <String>['30 minutes', '1 hour']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(fontSize: 20),
                      ),
                    );
                  }).toList(),
                ),

                // Date
                ElevatedButton(
                  onPressed: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null && pickedDate != selectedDate) {
                      setState(() {
                        selectedDate = pickedDate;
                      });
                    }
                  },
                  child: Text(
                      "Select date: ${selectedDate.toLocal().toString().split(' ')[0]}"),
                ),
                const SizedBox(height: 10.0),
                // Heure
                ElevatedButton(
                  onPressed: () async {
                    final TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: selectedTime,
                    );
                    if (pickedTime != null && pickedTime != selectedTime) {
                      setState(() {
                        selectedTime = pickedTime;
                      });
                    }
                  },
                  child: Text("Select time: ${selectedTime.format(context)}"),
                ),
                const SizedBox(height: 20.0),

                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          DateTime finalDateTime = DateTime(
                            selectedDate.year,
                            selectedDate.month,
                            selectedDate.day,
                            selectedTime.hour,
                            selectedTime.minute,
                          );

                          switch (discipline) {
                            case "Dressage":
                              discipline = "dressage";
                              break;
                            case "Show Jumping":
                              discipline = "showJumping";
                              break;
                            case "Endurance":
                              discipline = "endurance";
                              break;
                          }

                          place = place == 'Indoor arena'
                              ? 'indoorArena'
                              : 'outdoorArena';

                          final int durationMinutes =
                              duration == '30 minutes' ? 30 : 60;

                          try {
                            // Créer une instance Lesson
                            ObjectId userId = widget.user.id;
                            Lesson newLesson = Lesson(
                              discipline: discipline,
                              place: place,
                              date: finalDateTime,
                              duration: durationMinutes,
                              userId: userId,
                            );

                            final lessonObject = newLesson.toMap();

                            // Sauvegarde dans la base de données
                            final lessonsCollection =
                                MongoDatabase().getCollection("lessons");

                            setState(() {
                              _lessons.add(newLesson);
                            });
                            await lessonsCollection.insert(newLesson.toMap());
                            Navigator.of(context).pop();
                          } catch (e) {
                            print('Erreur lors de la création du cours : $e');
                          }
                        }
                      },
                      child: const Text("Add lesson"),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
