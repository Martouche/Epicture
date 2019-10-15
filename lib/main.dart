import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/dashboard': (context) => Dashboard(),
      },
      title: 'Epicture',
      home: Home(),
    );
  }
}