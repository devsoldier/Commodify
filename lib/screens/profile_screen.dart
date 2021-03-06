import 'package:drc/widget/profile_widget.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          child: Container(
            color: Color.fromRGBO(10, 38, 83, 1.0),
            // alignment: Alignment.center,
          ),
        ),
        Positioned(
          bottom: -350,
          left: -400,
          child: Container(
            height: 1000,
            width: 1000,
            child: Image.asset('assets/navbar/eclipse vector.png',
                height: double.infinity, width: double.infinity),
          ),
        ),
        ProfileWidget(),
      ],
    );
  }
}
