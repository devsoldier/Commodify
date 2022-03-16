import 'package:provider/provider.dart';
import '../providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';
import 'dart:async';
import '../screens/graph.dart';
import './assets_chart.dart';

class DashboardWidget extends StatefulWidget {
  @override
  _DashboardWidgetState createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  bool _isLoading = true;

  void getBAL() {
    Provider.of<Auth>(context, listen: false).getbalance();
  }

  void _getuser() {
    Provider.of<Auth>(context, listen: false).getuser();
  }

  void _getasset() {
    Provider.of<Auth>(context, listen: false).getasset();
  }

  final channel = IOWebSocketChannel.connect(
      Uri.parse('wss://ws.binaryws.com/websockets/v3?app_id=1089'));

  void forceLoad() {
    Timer(Duration(milliseconds: 1250), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Widget loadpage = Center(child: CircularProgressIndicator());

  @override
  void initState() {
    // Future(() {
    //   final snackBar = SnackBar(
    //     content: Consumer<Auth>(
    //         builder: (_, data, __) => (data.message[0].isEmpty)
    //             ? CircularProgressIndicator()
    //             : Text(data.message[0])),
    //   );
    //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
    // });
    getBAL();
    _getuser();
    _getasset();
    forceLoad();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<Auth>(context);
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Stack(
        children: [
          Container(height: MediaQuery.of(context).size.height * 1.415),
          Positioned(
            top: 0,
            left: 7,
            child: Row(
              children: <Widget>[
                Text(
                  'Welcome back,',
                  style: TextStyle(color: Colors.white),
                ),
                /* (_isLoading == true)
                    ? Container(width: 15, height: 15, child: loadpage)
                    :  */

                (data.user.isEmpty)
                    ? Container(width: 15, height: 15, child: loadpage)
                    : Text(
                        ' ${data.user[0].first_name} ${data.user[0].last_name}!',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )
              ],
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.04,
            left: MediaQuery.of(context).size.width * 0.02,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                color: Color.fromRGBO(0, 178, 255, 0.6),
                width: MediaQuery.of(context).size.width * 0.96,
                height: MediaQuery.of(context).size.height * 0.1350,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        height: 75,
                        width: 75,
                        child: Image.asset('assets/navbar/Vector.png')),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Text(
                            'Current Balance',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                        Container(
                          child: Consumer<Auth>(
                            builder: (_, balancedata, __) =>
                                (_isLoading == true)
                                    ? Container(
                                        width: 15, height: 15, child: loadpage)
                                    : Text(
                                        '\$${(balancedata.balance).toStringAsFixed(2)}',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 28),
                                      ),
                          ),
                        ),
                        //   Container(
                        //     child: Text(
                        //       '\$960.00',
                        //       style: TextStyle(
                        //           color: Colors.white,
                        //           fontWeight: FontWeight.bold,
                        //           fontSize: 28),
                        //     ),
                        //   ),
                        // ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width * 0.025,
            top: MediaQuery.of(context).size.height * 0.18,
            child: ClipRRect(
              // borderRadius: BorderRadius.only(
              //     topLeft: Radius.circular(22.0),
              //     topRight: Radius.circular(22.0)),
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                alignment: Alignment.centerLeft,
                color: Colors.white,
                width: MediaQuery.of(context).size.width * 0.95,
                height: MediaQuery.of(context).size.height * 1.23,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width * 0.88,
                            height: MediaQuery.of(context).size.height * 0.6,
                            // color: Colors.grey,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(249, 247, 247, 1),
                              // color: Colors.black,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: AssetsChart()),
                      ],
                    ),
                    Graph(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
