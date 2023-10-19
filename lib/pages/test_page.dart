import 'package:flutter/material.dart';

class TestPage extends StatelessWidget {
  const TestPage({Key? key, required this.title}) : super(key: key);

  final String title;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text(title),
      ),
      body: const Center(
        child: Text('Test'),
      ),
    );
  }
}