import 'package:drc/screens/signup_screen.dart';
import 'package:drc/widget/navbar.dart';
import 'package:flutter/material.dart';
import './screens/graph.dart';
import 'screens/login_screen.dart';
import 'widget/navbar.dart';

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
        routes: {
          LoginScreen.routeName: (ctx) => LoginScreen(),
          NavBar.routeName: (ctx) => NavBar(),
        });
  }
}
