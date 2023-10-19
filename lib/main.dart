import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:horse_factory/pages/login_page.dart';
import 'package:horse_factory/utils/mongo_database.dart';
import 'package:horse_factory/widgets/bottom_navigation_bar_widget.dart';
import 'package:provider/provider.dart';

import 'models/auth.dart';
import 'models/user.dart';

void main() async {
  try {
    await MongoDatabase().connect();
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
      ],
    );

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthModel()),
          StreamProvider<User?>(
            initialData: null,
            create: (context) => MongoDatabase().user
          ),
        ],
        child: MyApp(),
      ),
    );
  } catch (error) {
    print("Une erreur s'est produite lors de l'initialisation de l'application : $error");
  }
}

class MainApp extends StatelessWidget {
  final User user;

  MainApp({required this.user});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BottomNavigationBarWidget(user: user),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    final authModel = Provider.of<AuthModel>(context);

    return MaterialApp(
      home: authModel.user != null ? BottomNavigationBarWidget(user: authModel.user!) : LoginPage(),
    );
  }

}

