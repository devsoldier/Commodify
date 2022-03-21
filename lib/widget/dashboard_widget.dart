import 'package:provider/provider.dart';
import '../providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/services.dart';
import '../screens/graph.dart';
import './assets_chart.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class DashboardWidget extends StatefulWidget {
  @override
  _DashboardWidgetState createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  bool _isLoading = true;
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

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

  showerrorsnackbar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    setState(() {});
  }

  @override
  void initState() {
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    getBAL();
    _getuser();
    _getasset();
    forceLoad();
    super.initState();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
      if (_connectionStatus == ConnectivityResult.none) {
        showerrorsnackbar(
            'Internet disconnected. Please check connection to resume.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<Auth>(context);
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Stack(
        children: [
          Container(
              height: /* (data.pieasset.isEmpty)
                  ? MediaQuery.of(context).size.height * 1.02
                  : */
                  (data.assetamount.isEmpty)
                      ? MediaQuery.of(context).size.height * 1.02
                      : (data.pieasset[0].y == 0 &&
                              data.pieasset[1].y == 0 &&
                              data.pieasset[2].y == 0 &&
                              data.pieasset[3].y == 0)
                          ? MediaQuery.of(context).size.height * 1.02
                          : MediaQuery.of(context).size.height * 1.415),
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
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                alignment: Alignment.centerLeft,
                color: Colors.white,
                width: MediaQuery.of(context).size.width * 0.95,
                height: (data.assetamount.isEmpty)
                    ? MediaQuery.of(context).size.height * 0.83
                    : (data.pieasset[0].y == 0 &&
                            data.pieasset[1].y == 0 &&
                            data.pieasset[2].y == 0 &&
                            data.pieasset[3].y == 0)
                        ? MediaQuery.of(context).size.height * 0.83
                        : MediaQuery.of(context).size.height * 1.23,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AssetsChart(),
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
