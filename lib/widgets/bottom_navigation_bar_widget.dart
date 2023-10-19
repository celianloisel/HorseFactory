import 'package:flutter/material.dart';
import 'package:horse_factory/pages/home_page.dart';
import 'package:horse_factory/pages/lessons_page.dart';
import 'package:horse_factory/pages/stable_page.dart';
import 'package:horse_factory/pages/test_page.dart';
import 'package:horse_factory/pages/update.dart';

import '../models/user.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  final User? user;

  const BottomNavigationBarWidget({Key? key, required this.user})
      : super(key: key);

  @override
  _BottomNavigationBarWidgetState createState() =>
      _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  int _selectedIndex = 0;
  late List<Widget> _widgetOptions;


  @override
  void initState() {
    super.initState();

    final user = widget.user ??
        User(
          email: 'example@email.com',
          password: 'your_password',
          profilePictureUrl: 'https://example.com/profile.png',
          userName: 'your_username',
          age: 'your_age',
          phoneNumber: 'your_phone_number',
          ffe: 'your_ffe',
        );

    _widgetOptions = <Widget>[
      HomePage(user: user),
      StablePage(title: "Stable", user: user),
      const TestPage(title: "Test Page"),
      const EditProfile(title: "test")
      LessonsPage(user: user)
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.house),
            label: 'Stable',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Test',
          ),
          BottomNavigationBarItem(
            icon:  Icon(Icons.account_circle_outlined),
            label: 'users',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business_sharp),
            label: 'Lessons',
          )
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black, 
      ),
    );
  }
}
