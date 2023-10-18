import 'package:image_picker/image_picker.dart';
import 'package:horse_factory/models/user.dart';
import 'package:flutter/material.dart';
import 'package:horse_factory/pages/login_page.dart';

class Profile extends StatelessWidget {
  final User? user;

  Profile({required this.user});

  bool isValidData(String username, String email) {
    return username == user?.userName && email == user?.email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              // Déconnexion de l'utilisateur
              // Vous pouvez ajouter la logique de déconnexion ici
            },
            child: Text('Déconnexion'),
          ),
        ],
      ),
      body: Center(
        child: user != null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () async {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.photo),
                          title: Text('Sélectionner une photo depuis la galerie'),
                          onTap: () async {
                            Navigator.pop(context);
                            final image = await ImagePicker().pickImage(source: ImageSource.gallery);
                            if (image != null) {
                              String cheminImage = image.path;
                            }
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: CircleAvatar(
                radius: 50,
                backgroundImage: user!.profilePictureUrl != null
                    ? NetworkImage(user!.profilePictureUrl!)
                    : AssetImage('assets/default_profile_image.png') as ImageProvider,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Username: ${user?.userName}',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Email: ${user?.email}',
              style: TextStyle(fontSize: 18),
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    final usernameController = TextEditingController();
                    final emailController = TextEditingController();
                    final newPasswordController = TextEditingController();

                    return AlertDialog(
                      title: Text('Réinitialisation de mot de passe'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: usernameController,
                            decoration: InputDecoration(labelText: 'Nom d\'utilisateur'),
                          ),
                          TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(labelText: 'Email'),
                          ),
                          TextFormField(
                            controller: newPasswordController,
                            decoration: InputDecoration(labelText: 'Nouveau mot de passe'),
                            obscureText: true,
                          ),
                        ],
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () async {
                            final username = usernameController.text;
                            final enteredEmail = emailController.text;
                            final newPassword = newPasswordController.text;

                            if (isValidData(username, enteredEmail)) {
                              // Mettez à jour le mot de passe de l'utilisateur
                              // Vous devez ajouter la logique de mise à jour du mot de passe ici
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Mot de passe mis à jour avec succès.'),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Le nom d\'utilisateur ou l\'adresse e-mail saisi ne correspond pas à l\'utilisateur actuel.'),
                                ),
                              );
                            }
                          },
                          child: Text('Réinitialiser le mot de passe'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Annuler'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Réinitialiser le mot de passe'),
            ),
          ],
        )
            : Text('Utilisateur non trouvé'),
      ),
    );
  }
}
