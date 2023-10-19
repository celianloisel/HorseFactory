import 'package:flutter/material.dart';
import 'package:horse_factory/pages/lessons_page.dart';
import 'package:horse_factory/pages/home_page.dart';
import 'package:horse_factory/pages/test_page.dart';
import '../models/user.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  final User? user;

  const BottomNavigationBarWidget({Key? key, required this.user}) : super(key: key);

  @override
  State<BottomNavigationBarWidget> createState() =>
      _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  int _selectedIndex = 0;
  late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();

    final user = widget.user ?? User(
      email: 'example@email.com',
      password: 'your_password',
      profilePictureUrl: 'https://example.com/profile.png',
      userName: 'your_username',
    );

    final List<Widget> _widgetOptions = <Widget>[
      HomePage(user: user),
      const TestPage(title: "Test Page"),
      const LessonsPage(title: "Lessons")
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
            icon: Icon(Icons.add),
            label: 'Test',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.business_sharp), label: 'Lessons')
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
