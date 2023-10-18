import 'package:flutter/material.dart';
import 'package:horse_factory/models/lesson.dart';

const List<String> list = <String>['One', 'Two', 'Three', 'Four'];

class AddLessonPage extends StatefulWidget {
  @override
  _AddLessonPageState createState() => _AddLessonPageState();
}

class _AddLessonPageState extends State<AddLessonPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var dropdownValue = 'Dog';
    return Scaffold(
      appBar: AppBar(title: const Text('Plan new lesson')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField(
              value: dropdownValue,
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                });
              },
              items: <String>['Dog', 'Cat', 'Tiger', 'Lion']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(fontSize: 20),
                  ),
                );
              }).toList(),
            ),
            TextField(
              controller: phoneController,
              decoration:
                  const InputDecoration(labelText: 'Numéro de téléphone'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            ElevatedButton(
              onPressed: () {
                /*final newContact = Contact(
                  name: nameController.text,
                  phoneNumber: phoneController.text,
                  email: emailController.text,
                );*/
                print(emailController.text);
                Navigator.pop(context);
              },
              child: const Text('Ajouter'),
            ),
          ],
        ),
      ),
    );
  }
}

class DropdownMenuExample extends StatefulWidget {
  const DropdownMenuExample({super.key});

  @override
  State<DropdownMenuExample> createState() => _DropdownMenuExampleState();
}

class _DropdownMenuExampleState extends State<DropdownMenuExample> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      initialSelection: list.first,
      onSelected: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
      },
      dropdownMenuEntries: list.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(value: value, label: value);
      }).toList(),
    );
  }
}
