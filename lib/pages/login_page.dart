import 'package:flutter/material.dart';
import 'package:horse_factory/pages/home_page.dart';
import 'package:horse_factory/pages/registration_page.dart';
import 'package:horse_factory/services/authentication_service.dart';
import 'package:provider/provider.dart';

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
                        SizedBox(height: 20),
                        TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationPage()));
                          },
                          child: Text("Don't have an account? Register here"),
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
