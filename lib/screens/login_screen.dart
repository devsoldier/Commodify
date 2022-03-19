import 'package:drc/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import '../widget/login_widget.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/login';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: (MediaQuery.of(context).size.height * 1.0),
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
          Center(
            // top: MediaQuery.of(context).size.height * 0.07,
            // right: MediaQuery.of(context).size.width * 0.3,
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Container(
                  alignment: Alignment.topCenter,
                  child: Image.asset('assets/signup/pc-person 1.png',
                      height: double.infinity, width: double.infinity),
                  height: 220,
                  width: 140,
                ),
              ],
            ),
          ),
          // LoginWidget(),
          LoginWidget(),

          Center(
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account yet?',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black38),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushReplacementNamed(SignUpScreen.routeName);
                        },
                        child: Text(
                          ' Sign Up',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(0, 178, 255, 1)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
