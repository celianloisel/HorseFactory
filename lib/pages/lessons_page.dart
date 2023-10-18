import 'package:flutter/material.dart';
import 'package:horse_factory/models/lesson.dart';
import 'package:horse_factory/pages/add_lesson_page.dart';
import 'package:horse_factory/utils/mongo_database.dart';

class LessonsPage extends StatefulWidget {
  const LessonsPage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<LessonsPage> createState() => _LessonsPageState();
}

class _LessonsPageState extends State<LessonsPage> {
  List<Lesson> _lessons = [];

  @override
  void initState() {
    super.initState();
    _getFilms();
  }

  Future<void> _getFilms() async {
    final lessonsCollection = MongoDatabase().getCollection("lessons");

    final List<Map<String, dynamic>> data =
        await lessonsCollection.find().toList();
    setState(() {
      _lessons = data
          .map((lessonData) =>
              Lesson.fromMap(lessonData, lessonData['_id'].toString()))
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
          return ListTile(
            title: Text(lesson.discipline.toString().split('.').last),
            subtitle: Text(lesson.date.toString()),
            trailing: Text(lesson.duration.toString()),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newContact = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddLessonPage()),
          ) as Lesson?;
          /*if (newContact != null) {
            setState(() {
              contacts.add(newContact);
            });
          }*/
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addLesson() {
    print("Cours ajouté !");
  }
}
