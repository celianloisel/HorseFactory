import 'package:flutter/material.dart';
import 'package:horse_factory/pages/registration_page.dart';
import 'package:provider/provider.dart';

import '../models/auth.dart';
import '../utils/mongo_database.dart';
import '../widgets/bottom_navigation_bar_widget.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final mongoDatabase = MongoDatabase();

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      final userName = _userNameController.text;
      final password = _passwordController.text;

      try {
        final user = await mongoDatabase.checkUserInMongoDB(userName);

        if (user != null && user.password == password) {
          await mongoDatabase.signInWithUserNameAndPassword(
              userName, password, context);
          Provider.of<AuthModel>(context, listen: false).login(user);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => BottomNavigationBarWidget(user: user)));
        } else {
          if (user == null) {
            showError('Aucun utilisateur trouvé avec ce nom d\'utilisateur.');
          } else {
            showError(
                'L\'authentification a échoué. Veuillez vérifier vos informations.');
          }
        }
      } catch (e) {
        showError(
            'Une erreur s\'est produite lors de l\'authentification : $e');
      }
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _showPasswordResetDialog() {
    TextEditingController userNameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController newPasswordController = TextEditingController();
    TextEditingController confirmNewPasswordController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Réinitialisation du mot de passe'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: userNameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                controller: newPasswordController,
                decoration: InputDecoration(labelText: 'Nouveau mot de passe'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Le mot de passe ne peut pas être vide.';
                  } else if (value.length < 6) {
                    return 'Le mot de passe doit comporter au moins 6 caractères.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: confirmNewPasswordController,
                decoration: InputDecoration(
                    labelText: 'Confirmer Nouveau Mot de Passe'),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                String userName = userNameController.text;
                String email = emailController.text;
                String newPassword = newPasswordController.text;
                String confirmNewPassword = confirmNewPasswordController.text;

                if (newPassword.length < 6) {
                  showError(
                      'Le mot de passe doit comporter au moins 6 caractères.');
                  return;
                }

                if (newPassword == confirmNewPassword) {
                  try {
                    await mongoDatabase.resetPassword(
                        userName, email, newPassword);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Mot de passe réinitialisé avec succès.'),
                      ),
                    );
                    Navigator.of(context).pop();
                  } catch (e) {
                    showError(
                        'Une erreur s\'est produite lors de la réinitialisation du mot de passe : $e');
                  }
                } else {
                  showError('Les mots de passe ne correspondent pas.');
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextFormField(
                          controller: _userNameController,
                          decoration: InputDecoration(labelText: 'Username'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your username';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(labelText: 'Password'),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            _login();
                          },
                          child: Text('Log In'),
                        ),
                        SizedBox(height: 10),
                        TextButton(
                          onPressed: () {
                            _showPasswordResetDialog();
                          },
                          child: Text('Mot de passe oublié ?'),
                        ),
                        SizedBox(height: 5),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegistrationPage()));
                          },
                          child: Text("Pas encore de compte ?"),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
