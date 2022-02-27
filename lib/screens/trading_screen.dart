import 'package:flutter/material.dart';
import '../widget/trading_widget.dart';

class TradingScreen extends StatelessWidget {
  static const routeName = '/trading';

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
          left: 7,
          bottom: -20,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25.0),
            child: Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width * 0.96,
              height: MediaQuery.of(context).size.height * 0.41,
            ),
          ),
        ),
        TradingWidget(),
      ],
    );
  }
}
