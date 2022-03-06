import 'package:flutter/material.dart';
import './graph.dart';
import '../widget/dashboard_widget.dart';

class DashboardScreen extends StatelessWidget {
  static const routeName = '/dashboard';

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
        Positioned(
          top: 24,
          left: 7,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Container(
              color: Color.fromRGBO(0, 178, 255, 0.6),
              width: MediaQuery.of(context).size.width * 0.96,
              height: MediaQuery.of(context).size.height * 0.115,
            ),
          ),
        ),
        Positioned(
          left: 7,
          bottom: -10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width * 0.96,
              height: MediaQuery.of(context).size.height * 0.645,
            ),
          ),
        ),
        Graph(),
        DashboardWidget(),
      ],
    );
  }
}
