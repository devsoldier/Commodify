import 'package:drc/screens/login_screen.dart';
import 'package:flutter/material.dart';

// import '../screens/login_screen.dart';
import '../widget/signup_widget.dart';

class SignUpScreen extends StatelessWidget {
  static const routeName = '/signup';
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
          SignUpWidget(),
          // signup.SignUpWidget(),
          // Center(
          //   child: Container(
          //     alignment: Alignment.bottomCenter,
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.end,
          //       children: [
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: <Widget>[
          //             // Image.asset(
          //             //   'assets/signup/Already have an account_.png',
          //             // ),
          //             Text(
          //               'Already have an account?',
          //               style: TextStyle(
          //                   fontWeight: FontWeight.bold, color: Colors.black38),
          //             ),
          //             GestureDetector(
          //               onTap: () {
          //                 Navigator.of(context)
          //                     .pushReplacementNamed(LoginScreen.routeName);
          //               },
          //               child: Text(
          //                 ' Login',
          //                 style: TextStyle(
          //                   color: Colors.blue[400],
          //                   fontWeight: FontWeight.bold,
          //                 ),
          //               ),
          //             )
          //           ],
          //         ),
          //         SizedBox(height: 15),
          //       ],
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
