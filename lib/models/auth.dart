import 'package:flutter/cupertino.dart';
import 'package:horse_factory/models/user.dart';

class AuthModel extends ChangeNotifier {
  User? _user;

  User? get user => _user;

  String? _error;

  String? get error => _error;

  void login(User user) {
    if (_user != null) {
      _error = "L'utilisateur est déjà connecté.";
      return;
    }

    _error = "L'authentification a échoué. Veuillez vérifier vos informations.";

    _user = user;
    _error = null;
    notifyListeners();
  }

  void updateUser(User updatedUser) {
    _user = updatedUser;
    notifyListeners();
  }

  void logout() {
    print('Log out du auth');
    if (_user == null) {
      _error = "L'utilisateur est déjà déconnecté.";
      return;
    }
    _user = null;
    _error = null;
    notifyListeners();
  }
}
