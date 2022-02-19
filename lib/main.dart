import 'package:flutter/material.dart';
import './screens/graph.dart';
import 'screens/login_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CMD',
      theme: ThemeData(
        fontFamily: 'Roboto',
      ),
      home: SignUpScreen(),
    );
  }
}
