import 'package:flutter/material.dart';
import 'package:horse_factory/pages/registration_page.dart';
import 'package:horse_factory/services/authentication_service.dart';
import 'package:mongo_dart/mongo_dart.dart' show Db, ModifierBuilder, where;
import 'package:provider/provider.dart';

import '../constants/database.dart';
import '../models/auth.dart';
import '../widgets/bottom_navigation_bar_widget.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late AuthService _authService;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authService = Provider.of<AuthService>(context);
  }

  Future<void> _login() async {
    print('loginnnnnnnnnnnn');
    if (_formKey.currentState!.validate()) {
      print('Je suis dans if');
      final userName = _userNameController.text;
      final password = _passwordController.text;

      try {
        final user = await _authService.checkUserInMongoDB(userName);

        if (user != null && user.password == password) {
          Provider.of<AuthModel>(context, listen: false).login(user);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNavigationBarWidget(user: user)));
        } else {
          if (user == null) {
            showError('Aucun utilisateur trouvé avec ce nom d\'utilisateur.');
          } else {
            showError('L\'authentification a échoué. Veuillez vérifier vos informations.');
          }
        }
      } catch (e) {
        showError('Une erreur s\'est produite lors de l\'authentification : $e');
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
                decoration: InputDecoration(labelText: 'Nouveau Mot de Passe'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                String userName = userNameController.text;
                String email = emailController.text;
                String newPassword = newPasswordController.text;

                var db = await Db.create(MONGODB_URL);
                await db.open();
                final usersCollection = db.collection(COLLECTION_NAME);

                final query = where.eq('userName', userName).eq('email', email);
                final userMap = await usersCollection.findOne(query);

                if (userMap != null) {
                  // Utilisateur trouvé, mettez à jour le mot de passe avec le nouveau mot de passe saisi
                  final updateBuilder = ModifierBuilder();
                  updateBuilder.set('password', newPassword);

                  await usersCollection.update(query, updateBuilder);

                  // Fermez la boîte de dialogue
                  Navigator.of(context).pop();
                } else {
                  showError('Aucun utilisateur trouvé avec cet username et email.');
                }

                await db.close();
              },
              child: Text('Réinitialiser le mot de passe'),
            ),

            TextButton(
              onPressed: () {
                // Fermez la boîte de dialogue
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
                            Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationPage()));
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
