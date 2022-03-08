import 'package:drc/widget/transaction_widget.dart';
import 'package:flutter/material.dart';
import '../widget/transaction_widget2.dart';

class TransactionScreen extends StatelessWidget {
  static const routeName = '/transaction';

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
          top: 12,
          left: 17,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22.0),
            child: Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width * 0.915,
              height: MediaQuery.of(context).size.height,
            ),
          ),
        ),
        Positioned(
          top: 20,
          left: 40,
          child: Column(
            children: <Widget>[
              Column(
                children: [
                  // Container(
                  //   child: Text(
                  //     'History Lists',
                  //     style: TextStyle(
                  //       fontWeight: FontWeight.bold,
                  //       fontSize: 16,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              Container(
                // width: MediaQuery.of(context).size.width * 0.8,
                // height: MediaQuery.of(context).size.width * 0.7,
                child: TransactionWidget(),
              ),
            ],
          ),
        ),
        // Positioned(
        //   child: TransactionWidget(),
        // ),
        // TransactionWidget(),
      ],
    );
  }
}
