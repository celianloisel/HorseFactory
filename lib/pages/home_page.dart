import 'package:flutter/material.dart';
import 'package:horse_factory/appBar/home_appBar.dart';
import 'package:horse_factory/models/user.dart';

class HomePage extends StatelessWidget {
  late User user;

  HomePage({required this.user});

  @override
  Widget build(BuildContext context) {
    String welcomeMessage = 'Bienvenue, Utilisateur ${user?.email}';

    if (user?.userName != null && user!.userName.isNotEmpty) {
      welcomeMessage = 'Bienvenue, ${user.userName}';
    }

    return Scaffold(
      appBar: HomeAppBar(user: user),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/box_chevaux.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                welcomeMessage,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
