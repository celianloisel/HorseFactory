import 'package:horse_factory/models/user.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';

import '../utils/mongo_database.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  String userName = '';
  String email = '';
  String password = '';
  String age = '';
  String phoneNumber = '';
  String ffe = '';
  Uint8List? profileImageBytes;
  Image? selectedImage;
  bool isLoading = false;

  final mongoDatabase = MongoDatabase();

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
    if (value.length < 6) {
      return 'Le mot de passe doit comporter au moins 6 caractères';
    }
    return null;
  }

  void selectProfilePicture() async {
    final imagePicker = ImagePicker();
    final XFile? image = await imagePicker.pickImage(source: ImageSource.gallery, imageQuality: 80, maxHeight: 250, maxWidth: 250);

    if (image != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final newFile = File('${appDir.path}/$fileName.jpg');

      final bytes = await image.readAsBytes();

      final codec = await ui.instantiateImageCodec(Uint8List.fromList(bytes));
      final frameInfo = await codec.getNextFrame();

      final imageByteData = await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);
      final resizedBytes = imageByteData!.buffer.asUint8List();

      await newFile.writeAsBytes(resizedBytes);

      setState(() {
        profileImageBytes = resizedBytes;
        selectedImage = Image.file(newFile);
      });
    }
  }

  ElevatedButton buildRegistrationButton() {
    return ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          if (profileImageBytes == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Veuillez choisir une image de profil.'),
              ),
            );
          } else {
            _formKey.currentState!.save();
            final user = User(
              userName: userName,
              email: email,
              password: password,
              age: age,
              phoneNumber: phoneNumber,
              ffe: ffe,
              profileImageBytes: profileImageBytes,
            );

            setState(() {
              isLoading = true;
            });

            try {
              await mongoDatabase.saveUserToMongoDB(user);
              Navigator.of(context).pop();
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Une erreur s\'est produite lors de l\'inscription : $e'),
                ),
              );
            } finally {
              setState(() {
                isLoading = false;
              });
            }
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Veuillez corriger les erreurs dans le formulaire.'),
            ),
          );
        }
      },
      child: isLoading
          ? CircularProgressIndicator()
          : Text('S\'inscrire'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inscription'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: <Widget>[
            Center(
              child: isLoading
                  ? CircularProgressIndicator()
                  : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
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
                      GestureDetector(
                        onTap: selectProfilePicture,
                        child: Stack(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: selectedImage != null
                                      ? selectedImage!.image
                                      : AssetImage('assets/default_profile_image.png') as ImageProvider,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      buildRegistrationButton(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
