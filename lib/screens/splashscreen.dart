import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'signup_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen.withScreenFunction(
      splashIconSize: 750,
      duration: 5000,
      splash: Stack(
        children: [
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      'COMMODIFY',
                      style: TextStyle(
                          fontFamily: 'ReadexPro',
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Container(
                      width: 200,
                      height: 200,
                      /* decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.0),
                color: Color.fromRGBO(0, 178, 255, 1),
              ), */
                      child: Lottie.asset(
                          'assets/lottie/23662-laptop-animation-pink-navy-blue-white.json'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          /*  Positioned(
            top: 200,
            left: MediaQuery.of(context).size.width * 0.2,
            child: Text(
              'COMMODIFY',
              style: TextStyle(
                  fontFamily: 'ReadexPro',
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          Center(
            child: Container(
              width: 200,
              height: 200,
              /* decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.0),
                color: Color.fromRGBO(0, 178, 255, 1),
              ), */
              child: Lottie.asset(
                  'assets/lottie/23662-laptop-animation-pink-navy-blue-white.json'),
            ),
          ), */
        ],
      ),
      screenFunction: () async {
        return SignUpScreen();
      },
    );
  }
}
