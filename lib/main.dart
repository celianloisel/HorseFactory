import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:horse_factory/utils/mongo_database.dart';
import 'package:horse_factory/widgets/bottom_navigation_bar_widget.dart';

Future<void> main() async {
  await MongoDatabase().connect();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
    ],
  );

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: BottomNavigationBarWidget(),
    );
  }
}
