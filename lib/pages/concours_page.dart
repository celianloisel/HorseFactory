import 'package:flutter/material.dart';
import 'package:horse_factory/models/user.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class TestPage extends StatefulWidget {
  const TestPage({Key? key, required this.title, required User user}) : super(key: key);

  final String title;

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  File? _selectedImage;

  void _pickImage() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    setState(() {
      _selectedImage = File(pickedFile.path);
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: ElevatedButton(
          style: TextButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 31, 166, 238),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Nouvelle compétition"),
                  content: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Nom de la compétition'),
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Date de la compétition'),
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Adresse de la compétition'),
                        ),
                        ElevatedButton(
                          onPressed: _pickImage,
                          child: Text("Ajouter une photo"),
                        ),
                        if (_selectedImage != null)
                          Image.file(_selectedImage!),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text("Annuler"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text("Enregistrer"),
                      onPressed: () {
                      
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: Text("Ajoutez une compétition"),
        ),
      ),
    );
  }
}
