import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' hide State;

import 'package:horse_factory/models/lesson.dart';
import 'package:horse_factory/utils/mongo_database.dart';

class LessonsPage extends StatefulWidget {
  const LessonsPage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<LessonsPage> createState() => _LessonsPageState();
}

class _LessonsPageState extends State<LessonsPage> {
  List<Lesson> _lessons = [];
  final lessonsCollection = MongoDatabase().getCollection("lessons");

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _getLessons();
  }

  Future<void> _getLessons() async {
    final List<Map<String, dynamic>> data =
        await lessonsCollection.find().toList();
    setState(() {
      _lessons = data
          .map((lessonData) =>
              Lesson.fromMap(lessonData, lessonData['_id'].$oid.toString()))
          .toList();
    });
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

          late final icon;
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

          late final color;
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

          // Retire la timezone de la date
          final date = lesson.date
              .toString()
              .substring(0, lesson.date.toString().length - 6);

          // Affiche "x min" si minutes inférieur à 60, sinon affiche au format "HHhmm"
          late final duration;
          if (lesson.duration < 60) {
            duration = "${lesson.duration} min";
          } else {
            duration = "${lesson.duration ~/ 60}h${lesson.duration % 60} min";
          }

          return Card(
            child: ListTile(
              leading: icon,
              title: Text(lesson.discipline.name),
              subtitle: Row(
                children: [
                  Text(date),
                  const SizedBox(width: 10),
                  Text(duration),
                ],
              ),
              trailing: Text(lesson.status.name),
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

        DateTime _selectedDate = DateTime.now();
        TimeOfDay _selectedTime = TimeOfDay.now();

        return AlertDialog(
          title: Text('Plan new lesson'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /*
                Formulaire avec :
                  - Dropdown pour la discipline : Dressage, Show Jumping et Endurance
                  - Dropdown pour le lieu : Indoor arena, Outdoor arena
                  - Selecteur pour la date et l'heure
                  - Dropdown pour la durée : 30 minutes, 1 hour
                 */
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

                // Date et heure
                // Sélecteur de date
                ElevatedButton(
                  onPressed: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null && pickedDate != _selectedDate)
                      setState(() {
                        _selectedDate = pickedDate;
                      });
                  },
                  child: Text(
                      "Select date: ${_selectedDate.toLocal().toString().split(' ')[0]}"),
                ),
                SizedBox(height: 10.0),

                // Sélecteur d'heure
                ElevatedButton(
                  onPressed: () async {
                    final TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: _selectedTime,
                    );
                    if (pickedTime != null && pickedTime != _selectedTime)
                      setState(() {
                        _selectedTime = pickedTime;
                      });
                  },
                  child: Text("Select time: ${_selectedTime.format(context)}"),
                ),
                const SizedBox(height: 20.0),

                /*
                TextButton pour :
                - Annuler l'ajout de cours d'équitation
                - Fermer la boîte de dialogue
                 */

                /*
                TextButton pour :
                - Créer une instance Lesson
                - L'enregistrer dans la base de données en la convertissant en Map
                - Fermer la boîte de dialogue
                 */
                TextButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      DateTime finalDateTime = DateTime(
                        _selectedDate.year,
                        _selectedDate.month,
                        _selectedDate.day,
                        _selectedTime.hour,
                        _selectedTime.minute,
                      );

                      switch (discipline) {
                        case "Dressage":
                          discipline = "dressage";
                          break;
                        case "Show Jumping":
                          discipline = "show_jumping";
                          break;
                        case "Endurance":
                          discipline = "endurance";
                          break;
                      }

                      final String id = ObjectId()
                          .$oid
                          .toString(); // Pour générer un nouvel ID unique
                      place = place == 'Indoor arena'
                          ? 'indoor_arena'
                          : 'outdoor_arena'; // Convertit String en enum Place
                      final int durationMinutes =
                          duration == '30 minutes' ? 30 : 60;

                      print("id: $id");
                      print("place: $place");
                      print("date: $finalDateTime");
                      print("duration: $durationMinutes");
                      print("discipline: $discipline");
                      print("status: pending");
                      final String userId = ObjectId()
                          .$oid
                          .toString(); // Remplacez par l'ID d'utilisateur approprié
                      // print("userId: $userId");

                      // Créer une instance Lesson
                      Lesson newLesson = Lesson(
                        id: id, // Pour générer un nouvel ID unique
                        place: place == 'Indoor arena'
                            ? 'indoor_arena'
                            : 'outdoor_arena', // Convertit String en enum Place
                        date: finalDateTime,
                        duration: duration == '30 minutes' ? 30 : 60,
                        discipline: discipline,
                        status:
                            'pending', // Statut par défaut lors de la création
                        userId: ObjectId()
                            .$oid
                            .toString(), // Remplacez par l'ID d'utilisateur approprié
                      );

                      final lessonObject = newLesson.toMap();

                      // Sauvegarde dans la base de données
                      final lessonsCollection =
                          MongoDatabase().getCollection("lessons");

                      try {
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
            ),
          ),
        );
      },
    );
  }
}
