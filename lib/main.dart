import 'package:drc/screens/dashboard_screen.dart';
import 'package:drc/widget/navbar.dart';
import 'package:flutter/material.dart';
// import './screens/graph.dart';
import 'screens/login_screen.dart';
import 'widget/navbar.dart';
import 'package:provider/provider.dart';
import './screens/signup_screen.dart';
import './providers/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'CMD',
          theme: ThemeData(
            fontFamily: 'Roboto',
          ),
          home: (auth.isAuthenticated == true)
              ? DashboardScreen()
              : SignUpScreen(),
          routes: {
            SignUpScreen.routeName: (ctx) => SignUpScreen(),
            LoginScreen.routeName: (ctx) => LoginScreen(),
            NavBar.routeName: (ctx) => NavBar(),
            DashboardScreen.routeName: (ctx) => DashboardScreen(),
          },
        ),
      ),
    );
  }
}
