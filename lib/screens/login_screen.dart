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
          LoginWidget(),
          Positioned(
            bottom: 122,
            left: 185,
            child: Text(
              'Login',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          Positioned(
            bottom: 80,
            left: 86.7,
            child: Container(
              child: Image.asset(
                'assets/signup/login wtih.png',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
