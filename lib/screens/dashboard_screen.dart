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
        Positioned(
          bottom: 100,
          left: 13,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  spreadRadius: 3,
                  blurRadius: 10,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 5, left: 15),
                    child: (Text('Market Overview',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(9, 51, 116, 1)))),
                    height: (MediaQuery.of(context).size.height * 0.35),
                    width: (MediaQuery.of(context).size.width * 0.93),
                    color: Color.fromRGBO(249, 247, 247, 1),
                  ),
                ],
              ),
            ),
          ),
        ),
        Graph(),
        DashboardWidget(),
      ],
    );
  }
}
