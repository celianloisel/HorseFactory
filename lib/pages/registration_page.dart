import 'package:mongo_dart/mongo_dart.dart' show Db;
import 'package:horse_factory/constants/database.dart';
import 'package:horse_factory/models/user.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  String userName = '';
  String email = '';
  String password = '';
  String profilePictureUrl = '';

  Image? selectedImage;

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer un nom d\'utilisateur';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty || !value.contains('@')) {
      return 'Veuillez entrer une adresse e-mail valide';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer un mot de passe';
    }
    return null;
  }

  Future<void> selectProfilePicture() async {
    var status = await Permission.photos.request();
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('L\'accès à la galerie est requis pour sélectionner une photo de profil.'),
        ),
      );
      return;
    }

    final imagePicker = ImagePicker();
    final XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedImage = Image.file(File(image.path));
        profilePictureUrl = image.path;
      });
    }
  }

  Future<void> saveUserToMongoDB(User user) async {
    try {
      var db = await Db.create(MONGODB_URL);
      await db.open();

      final usersCollection = db.collection(COLLECTION_NAME);

      final userMap = user.toMap();

      await usersCollection.insert(userMap);

      await db.close();

      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Une erreur s\'est produite lors de l\'inscription : $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inscription'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Nom d\'utilisateur'),
                validator: validateUsername,
                onSaved: (value) {
                  userName = value!;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'E-mail'),
                validator: validateEmail,
                onSaved: (value) {
                  email = value!;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Mot de passe'),
                obscureText: true,
                validator: validatePassword,
                onSaved: (value) {
                  password = value!;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: selectProfilePicture,
                child: Text('Sélectionner une photo de profil'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final user = User(
                      userName: userName,
                      email: email,
                      password: password,
                      profilePictureUrl: profilePictureUrl,
                    );
                    await saveUserToMongoDB(user);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Veuillez corriger les erreurs dans le formulaire.'),
                      ),
                    );
                  }
                },
                child: Text('S\'inscrire'),
              ),
              if (selectedImage != null)
                Container(
                  width: 50,
                  height: 50,
                  child: selectedImage,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
