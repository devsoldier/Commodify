import 'package:drc/screens/login_screen.dart';
import 'package:flutter/material.dart';
import '../widget/signup_widget.dart';
import '../screens/login_screen.dart';

class SignUpScreen extends StatelessWidget {
  static const routeName = '/signup';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: (MediaQuery.of(context).size.height * 0.5),
            alignment: Alignment(0, 10),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/signup/18410 1.png'),
                fit: BoxFit.cover,
              ),
              color: Color.fromRGBO(25, 72, 134, 1.0),
            ),
          ),
          Positioned(
            top: 35,
            right: 130,
            child: Container(
              child: Image.asset('assets/signup/pc-person 1.png',
                  height: double.infinity, width: double.infinity),
              height: 220,
              width: 140,
            ),
          ),
          Positioned(
            bottom: 10,
            left: 96.7,
            child: Container(
              child: Image.asset(
                'assets/signup/Already have an account_.png',
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 116,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(LoginScreen.routeName);
              },
              child: Container(
                // color: Colors.black,
                child: Text(
                  'Login',
                  style: TextStyle(
                      color: Color.fromRGBO(0, 178, 255, 1.0),
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          SignUpWidget(),
          Positioned(
            bottom: 43,
            left: 175,
            child: Text(
              'Sign Up',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          Positioned(
            bottom: 8,
            left: 100,
            child: Row(
              children: <Widget>[
                Image.asset(
                  'assets/signup/Already have an account_.png',
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .pushReplacementNamed(LoginScreen.routeName);
                  },
                  child: Text(
                    ' Login',
                    style: TextStyle(
                      color: Colors.blue[400],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
