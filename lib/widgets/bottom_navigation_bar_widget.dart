import 'package:flutter/material.dart';
import 'package:horse_factory/pages/lessons_page.dart';
import 'package:horse_factory/pages/home_page.dart';
import 'package:horse_factory/pages/test_page.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  const BottomNavigationBarWidget({Key? key}) : super(key: key);

  @override
  State<BottomNavigationBarWidget> createState() =>
      _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    const HomePage(title: "Home Page"),
    const TestPage(title: "Test Page"),
    const LessonsPage(title: "Lessons")
  ];

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
