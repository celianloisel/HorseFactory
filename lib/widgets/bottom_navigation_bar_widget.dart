import 'package:flutter/material.dart';
import 'package:horse_factory/pages/home_page.dart';
import 'package:horse_factory/pages/test_page.dart';
import '../models/user.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  final User? user;

  const BottomNavigationBarWidget({Key? key, required this.user}) : super(key: key);

  @override
  _BottomNavigationBarWidgetState createState() => _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  int _selectedIndex = 0;
  late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();

    // Vérifiez si l'utilisateur est null et créez un utilisateur par défaut en cas de null
    final user = widget.user ?? User(
      email: 'example@email.com',
      password: 'your_password',
      profilePictureUrl: 'https://example.com/profile.png',
      userName: 'your_username',
    );

    _widgetOptions = <Widget>[
      HomePage(user: user),
      const TestPage(title: "Test Page"),
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
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
