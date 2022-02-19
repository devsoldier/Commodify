import 'package:flutter/material.dart';
import '../widget/login_widget.dart';

class SignUpScreen extends StatelessWidget {
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
            top: 50,
            right: 120,
            child: Container(
              height: 290,
              width: 150,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/signup/header.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SignUpWidget(),
        ],
      ),
    );
  }
}
