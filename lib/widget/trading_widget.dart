import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/services.dart';
import '../providers/models.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
// import '../providers/interval.dart';
import 'dart:async';
import '../model/http_exception.dart';
import '../providers/auth.dart';
// import '../widget/dashboard_widget.dart';

class TradingWidget extends StatefulWidget {
  @override
  _TradingWidgetState createState() => _TradingWidgetState();
}

class _TradingWidgetState extends State<TradingWidget> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final List<Commodity> _chartData = [];
  List<dynamic> timeConverted = [];
  RegExp regex = RegExp("(?=(?:.*[!@#\$%^&*()\\-_=+{};:,<>]))");
  List<dynamic> loadedPLAT = [];
  List<dynamic> loadedPALLA = [];
  List<dynamic> loadedGOLD = [];
  List<dynamic> loadedSILVER = [];
  final List<Commodity> _chartDatagold = [];
  final List<Commodity> _chartDatasilver = [];
  final List<Commodity> _chartDatapalladium = [];
  final List<Commodity> _chartDataplatinum = [];
  late TrackballBehavior _trackballBehavior;
  late ZoomPanBehavior _zoomPanBehavior;
  String _selectedCommodity = 'Gold/USD';
  List commodities = [
    'Gold/USD',
    'Palladium/USD',
    'Platinum/USD',
    'Silver/USD'
  ];
  String interval = '60';
  String commodity = 'frxXAUUSD';
  String placeholder = '';
  final GlobalKey<FormState> _buysellkey = GlobalKey();
  FocusNode _buysellfield = FocusNode();
  final TextEditingController _buysellController = TextEditingController();
  late double _buysellData;
  late String _selectedproduct;

  bool maximize = true;
  bool stopLoop = true;

  showerrorsnackbar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    setState(() {});
  }

  final channel = IOWebSocketChannel.connect(
      Uri.parse('wss://ws.binaryws.com/websockets/v3?app_id=1089'));

  final channel2 = IOWebSocketChannel.connect(
      Uri.parse('wss://ws.binaryws.com/websockets/v3?app_id=1089'));

  final channel3 = IOWebSocketChannel.connect(
      Uri.parse('wss://ws.binaryws.com/websockets/v3?app_id=1089'));

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  void getTickOnce() {
    channel.sink.add(
        '{  "ticks_history": "frxXAUUSD",  "adjust_start_time": 1,  "count": 10,"end": "latest","start": 1,"style": "candles"}');
    channel.sink.add(
        '{  "ticks_history": "frxXAGUSD",  "adjust_start_time": 1,  "count": 10,"end": "latest","start": 1,"style": "candles"}');
    channel.sink.add(
        '{  "ticks_history": "frxXPDUSD",  "adjust_start_time": 1,  "count": 10,"end": "latest","start": 1,"style": "candles"}');
    channel.sink.add(
        '{  "ticks_history": "frxXPTUSD",  "adjust_start_time": 1,  "count": 10,"end": "latest","start": 1,"style": "candles"}');
  }

  void getTickStream() {
    // print('COMMODITY: ${commodity}');
    // print('COMMODITY: ${interval}');
    channel2.sink.add(
        '{  "ticks_history": "frxXAUUSD",  "adjust_start_time": 1,  "count": 1,"granularity":${interval},  "end": "latest",  "start": 1,  "style": "candles","subscribe":1}');
    channel2.sink.add(
        '{  "ticks_history": "frxXAGUSD",  "adjust_start_time": 1,  "count": 1,"granularity":${interval},  "end": "latest",  "start": 1,  "style": "candles","subscribe":1}');
    channel2.sink.add(
        '{  "ticks_history": "frxXPDUSD",  "adjust_start_time": 1,  "count": 1,"granularity":${interval},  "end": "latest",  "start": 1,  "style": "candles","subscribe":1}');
    channel2.sink.add(
        '{  "ticks_history": "frxXPTUSD",  "adjust_start_time": 1,  "count": 1,"granularity":${interval},  "end": "latest",  "start": 1,  "style": "candles","subscribe":1}');
  }

  void tickStreamPLAT() {
    channel3.sink.add('{  "ticks": "frxXPTUSD",  "subscribe": 1}');
  }

  void tickStreamPALLA() {
    channel3.sink.add('{  "ticks": "frxXPDUSD",  "subscribe": 1}');
  }

  void tickStreamGOLD() {
    channel3.sink.add('{  "ticks": "frxXAUUSD",  "subscribe": 1}');
  }

  void tickStreamSILVER() {
    channel3.sink.add('{  "ticks": "frxXAGUSD",  "subscribe": 1}');
  }

  void initialValue() {
    channel.stream.listen((data) {
      final extractedData = jsonDecode(data);
      setState(() {
        List<dynamic> timeConverted = [];
        for (int i = 0; i < extractedData['candles'].length; i++) {
          timeConverted.add(DateTime.fromMillisecondsSinceEpoch(
              extractedData['candles'][i]['epoch'] * 1000));
          if (extractedData['echo_req']['ticks_history'] == "frxXAUUSD") {
            _chartDatagold.add(
              Commodity(
                close: extractedData['candles'][i]['close'],
                epoch: timeConverted[i],
                high: extractedData['candles'][i]['high'],
                low: extractedData['candles'][i]['low'],
                open: extractedData['candles'][i]['open'],
              ),
            );
          }
          if (extractedData['echo_req']['ticks_history'] == "frxXAGUSD") {
            _chartDatasilver.add(
              Commodity(
                close: extractedData['candles'][i]['close'],
                epoch: timeConverted[i],
                high: extractedData['candles'][i]['high'],
                low: extractedData['candles'][i]['low'],
                open: extractedData['candles'][i]['open'],
              ),
            );
          }
          if (extractedData['echo_req']['ticks_history'] == "frxXPDUSD") {
            _chartDatapalladium.add(
              Commodity(
                close: extractedData['candles'][i]['close'],
                epoch: timeConverted[i],
                high: extractedData['candles'][i]['high'],
                low: extractedData['candles'][i]['low'],
                open: extractedData['candles'][i]['open'],
              ),
            );
          }
          if (extractedData['echo_req']['ticks_history'] == "frxXPTUSD") {
            _chartDataplatinum.add(
              Commodity(
                close: extractedData['candles'][i]['close'],
                epoch: timeConverted[i],
                high: extractedData['candles'][i]['high'],
                low: extractedData['candles'][i]['low'],
                open: extractedData['candles'][i]['open'],
              ),
            );
          }
        }
      });
    });
  }

  void handShake() {
    channel2.stream.listen((data) {
      final extractedData = jsonDecode(data);
      final List<dynamic> timeConverted = [];
      // timeConverted.insert(
      //     0,
      //     DateTime.fromMillisecondsSinceEpoch(
      //         extractedData['ohlc']['open_time'] * 1000));
      // timeConverted.removeAt(3);
      if (extractedData['echo_req']['ticks_history'] == "frxXAUUSD") {
        _chartDatagold.add(Commodity(
          close: num.parse(extractedData['ohlc']['close']),
          epoch: DateTime.fromMillisecondsSinceEpoch(
              extractedData['ohlc']['open_time'] * 1000),
          high: num.parse(extractedData['ohlc']['high']),
          low: num.parse(extractedData['ohlc']['low']),
          open: num.parse(extractedData['ohlc']['open']),
        ));
      }
      if (extractedData['echo_req']['ticks_history'] == "frxXAGUSD") {
        _chartDatasilver.add(Commodity(
          close: num.parse(extractedData['ohlc']['close']),
          epoch: DateTime.fromMillisecondsSinceEpoch(
              extractedData['ohlc']['open_time'] * 1000),
          high: num.parse(extractedData['ohlc']['high']),
          low: num.parse(extractedData['ohlc']['low']),
          open: num.parse(extractedData['ohlc']['open']),
        ));
      }
      if (extractedData['echo_req']['ticks_history'] == "frxXPDUSD") {
        _chartDatapalladium.add(Commodity(
          close: num.parse(extractedData['ohlc']['close']),
          epoch: DateTime.fromMillisecondsSinceEpoch(
              extractedData['ohlc']['open_time'] * 1000),
          high: num.parse(extractedData['ohlc']['high']),
          low: num.parse(extractedData['ohlc']['low']),
          open: num.parse(extractedData['ohlc']['open']),
        ));
      }
      if (extractedData['echo_req']['ticks_history'] == "frxXPTUSD") {
        _chartDataplatinum.add(Commodity(
          close: num.parse(extractedData['ohlc']['close']),
          epoch: DateTime.fromMillisecondsSinceEpoch(
              extractedData['ohlc']['open_time'] * 1000),
          high: num.parse(extractedData['ohlc']['high']),
          low: num.parse(extractedData['ohlc']['low']),
          open: num.parse(extractedData['ohlc']['open']),
        ));
      }

      // print(_chartData);
      print("--------------------------------------------------------");
      // print(_chartData.length);
    });
  }

  getprice() {
    channel3.stream.listen(
      (data) {
        final extractedData = jsonDecode(data);
        if (extractedData["echo_req"]["ticks"] == "frxXPTUSD") {
          setState(() {
            for (int i = 0; i < extractedData.length - 3; i++) {
              loadedPLAT.insert(
                0,
                extractedData['tick']['quote'],
              );
              if (loadedPLAT.length > 3) {
                loadedPLAT.removeAt(2);
              }
              // print(loadedData[i].Quote);
            }
          });
        }
        if (extractedData["echo_req"]["ticks"] == "frxXPDUSD") {
          setState(() {
            for (int i = 0; i < extractedData.length - 3; i++) {
              loadedPALLA.insert(
                0,
                extractedData['tick']['quote'],
              );
              if (loadedPALLA.length > 3) {
                loadedPALLA.removeAt(2);
              }
              // print(loadedData[i].Quote);
            }
          });
        }
        if (extractedData["echo_req"]["ticks"] == "frxXAUUSD") {
          setState(() {
            for (int i = 0; i < extractedData.length - 3; i++) {
              loadedGOLD.insert(
                0,
                extractedData['tick']['quote'],
              );
              if (loadedGOLD.length > 3) {
                loadedGOLD.removeAt(2);
              }
              // print(loadedData[i].Quote);
            }
          });
        }
        if (extractedData["echo_req"]["ticks"] == "frxXAGUSD") {
          setState(() {
            for (int i = 0; i < extractedData.length - 3; i++) {
              loadedSILVER.insert(
                0,
                extractedData['tick']['quote'],
              );
              if (loadedSILVER.length > 3) {
                loadedSILVER.removeAt(2);
              }
              // print(loadedData[i].Quote);
            }
          });
        }

        // print(loadedGOLD.length);
        // print(loadedPLAT.length);
        // print(loadedPALLA.length);
        // print(extractedData.length);
      },
    );
  }

  void _showbuysuccessDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Purchase Successful'),
        content: Consumer<Auth>(
            builder: (_, data, __) =>
                (data.message.isEmpty) ? SizedBox() : Text(data.message[0])),
        actions: <Widget>[
          ElevatedButton(
            child: Text('Okay'),
            onPressed: () {
              // _getasset().then((_) => setState(() {}));

              Navigator.of(ctx).pop();
              setState(() {});
            },
          )
        ],
      ),
    );
  }

  void _showsellsuccessDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Trade Successful'),
        content: Consumer<Auth>(
            builder: (_, data, __) =>
                (data.message.isEmpty) ? SizedBox() : Text(data.message[0])),
        actions: <Widget>[
          ElevatedButton(
            child: Text('Okay'),
            onPressed: () {
              // _getasset().then((_) => setState(() {}));

              Navigator.of(ctx).pop();
              setState(() {});
            },
          )
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'An Error Occurred!',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(message),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              setState(() {
                Navigator.pop(context);
              });
            },
            child: Container(
              height: 30,
              width: 90,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22.0),
                child: Container(
                  alignment: Alignment.center,
                  child: Text('Close',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment(0.8, 0.0),
                      colors: <Color>[
                        Color.fromRGBO(0, 178, 255, 1),
                        Color.fromRGBO(25, 72, 134, 1),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _getasset() async {
    await Provider.of<Auth>(context, listen: false).getasset();
  }

  Future<void> purchase() async {
    if (!_buysellkey.currentState!.validate()) {
      return;
    }
    _buysellkey.currentState!.save();
    try {
      await Provider.of<Auth>(context, listen: false)
          .buy(_buysellData, _selectedproduct);
    } on HttpException catch (error) {
      var errorMessage = 'Purchase Failed';
      if (error.toString().contains('Invalid Amount to Purchase')) {
        errorMessage = 'Invalid Amount to Purchase.';
      } else
        _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage = 'Failed to purchase.';
      _showErrorDialog(errorMessage);
    }
    setState(() {});
  }

  Future<void> sell() async {
    if (!_buysellkey.currentState!.validate()) {
      return;
    }
    _buysellkey.currentState!.save();
    try {
      await Provider.of<Auth>(context, listen: false)
          .sell(_buysellData, _selectedproduct);
    } on HttpException catch (error) {
      var errorMessage = 'Trade Failed';
      if (error.toString().contains('Not Enough')) {
        errorMessage = 'failed';
      } else
        _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage = 'Failed to trade.';
      _showErrorDialog(errorMessage);
    }
    setState(() {});
  }

  Future<void> getBal() async {
    await Provider.of<Auth>(context, listen: false).getbalance();
  }

  Future<void> runbothpurchase() async {
    purchase().then((_) => getBal());
  }

  Future<void> runbothsell() async {
    sell().then((_) => getBal());
  }

  showsnackbar() {
    final snackBar = SnackBar(
      content: Consumer<Auth>(
          builder: (_, data, __) => (data.message[0].isEmpty)
              ? Text('')
              : (data.message[0].isNotEmpty)
                  ? Text(data.message[0])
                  : Text('')),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    setState(() {});
  }

  @override
  void initState() {
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    _getasset();
    getprice();
    getTickOnce();
    getTickStream();
    tickStreamPLAT();
    tickStreamPALLA();
    tickStreamGOLD();
    tickStreamSILVER();
    handShake();
    initialValue();
    _zoomPanBehavior = ZoomPanBehavior(
        enablePinching: true,
        enableDoubleTapZooming: true,
        enableMouseWheelZooming: true);
    _trackballBehavior = TrackballBehavior(
        enable: true, activationMode: ActivationMode.singleTap);
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
    final balancedata = Provider.of<Auth>(context);

    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    Widget gold = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset('assets/navbar/gold 1.png'),
        Column(
          children: [
            Text(
              'Gold/USD',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Consumer<Auth>(
                builder: (_, data, __) =>
                    Text('Balance ${data.asset[0].gold_amount}'))
          ],
        ),
        SizedBox(width: 40)
      ],
    );

    Widget platinum = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
            height: 50,
            width: 50,
            child: Image.asset('assets/navbar/platinum.png')),
        Column(
          children: [
            Text(
              'Platinum/USD',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Consumer<Auth>(
                builder: (_, data, __) =>
                    Text('Balance ${data.asset[0].platinum_amount}'))
          ],
        ),
        SizedBox(width: 40)
      ],
    );

    Widget silver = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
            height: 50,
            width: 50,
            child: Image.asset('assets/navbar/silver.png')),
        Column(
          children: [
            Text(
              'Silver/USD',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Consumer<Auth>(
                builder: (_, data, __) =>
                    Text('Balance ${data.asset[0].silver_amount}'))
          ],
        ),
        SizedBox(width: 40)
      ],
    );

    Widget palladium = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
            height: 50,
            width: 50,
            child: Image.asset('assets/navbar/silver.png')),
        Column(
          children: [
            Text('Palladium/USD'),
            Consumer<Auth>(
                builder: (_, data, __) =>
                    Text('Balance ${data.asset[0].palladium_amount}'))
          ],
        ),
        SizedBox(width: 40)
      ],
    );

    Widget graph = Positioned(
      top: 10,
      left: 0,
      child: ClipRRect(
        child: Container(
          width: MediaQuery.of(context).size.width * 1.0,
          height: (maximize == true)
              ? MediaQuery.of(context).size.height * 0.4
              : MediaQuery.of(context).size.height * 0.73,
          color: Color.fromRGBO(15, 34, 66, 1),
          child: Column(
            children: <Widget>[
              Expanded(
                child: SfCartesianChart(
                  // title: ChartTitle(text: 'GOLD - 2016'),
                  legend: Legend(isVisible: false),
                  zoomPanBehavior: _zoomPanBehavior,
                  trackballBehavior: _trackballBehavior,
                  series: <CandleSeries>[
                    CandleSeries<Commodity, DateTime>(
                        dataSource: (commodity == 'frxXAUUSD')
                            ? _chartDatagold
                            : (commodity == 'frxXAGUSD')
                                ? _chartDatasilver
                                : (commodity == 'frxXPDUSD')
                                    ? _chartDatapalladium
                                    : _chartDataplatinum,
                        // name: 'GOLD',
                        xValueMapper: (Commodity sales, _) => sales.epoch,
                        lowValueMapper: (Commodity sales, _) => sales.low,
                        highValueMapper: (Commodity sales, _) => sales.high,
                        openValueMapper: (Commodity sales, _) => sales.open,
                        closeValueMapper: (Commodity sales, _) => sales.close)
                  ],
                  primaryXAxis: DateTimeAxis(
                      dateFormat: DateFormat('hh:mm:ss'),
                      majorGridLines: MajorGridLines(width: 0)),
                  primaryYAxis: NumericAxis(
                      opposedPosition: true,
                      // minimum: 150,
                      // maximum: 300,
                      // interval: 10,
                      numberFormat:
                          NumberFormat.simpleCurrency(decimalDigits: 0)),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    Widget minimized = Stack(
      children: <Widget>[
        Positioned(
          left: 7,
          bottom: 0,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(22.0),
              topRight: Radius.circular(22.0),
            ),
            child: Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width * 0.96,
              height: MediaQuery.of(context).size.height * 0.05,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        maximize = true;
                      });
                    },
                    child: Container(
                      // color: Colors.orange,
                      child: Icon(
                        Icons.arrow_drop_up,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Positioned(
        //   bottom: 15,
        //   left: 190,
        //   child:
        // ),
        graph,
      ],
    );

    return (maximize == false)
        ? minimized
        : Stack(
            children: [
              graph,
              Positioned(
                left: MediaQuery.of(context).size.width * 0.02,
                bottom: 0,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(22.0),
                    topRight: Radius.circular(22.0),
                  ),
                  child: Container(
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width * 0.96,
                    height: MediaQuery.of(context).size.height * 0.38,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              maximize = false;
                            });
                          },
                          child: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black,
                          ),
                        ),
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.05),
                            Container(
                              height: 25,
                              child: Row(
                                children: <Widget>[
                                  Text('BALANCE',
                                      style: TextStyle(
                                        color: Color.fromRGBO(0, 51, 116, 1),
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  SizedBox(width: 25),
                                  Container(
                                    color: Color.fromRGBO(220, 243, 255, 1),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.monetization_on_outlined,
                                          color: Color.fromRGBO(0, 51, 116, 1),
                                        ),
                                        Text(
                                          '\$${(balancedata.balance).toStringAsFixed(2)}',
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(0, 51, 116, 1),
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(30)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0.0, 4.0), //(x,y)
                                blurRadius: 5.0,
                              ),
                            ],
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            height: 45,
                            width: MediaQuery.of(context).size.width * 0.9,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(27, 84, 169, 1),
                              // color: Colors.black,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                  offset: Offset(0, 8),
                                ),
                              ],
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                dropdownColor: Color.fromRGBO(27, 84, 169, 1),
                                style: TextStyle(color: Colors.white),
                                isExpanded: true,
                                value: _selectedCommodity,
                                onChanged: (newval) {
                                  _selectedCommodity = newval as String;
                                  if (newval == 'Gold/USD') {
                                    setState(() {
                                      commodity = 'frxXAUUSD';
                                      tickStreamGOLD();
                                      getTickOnce();
                                      getTickStream();
                                      _getasset();
                                      _chartDatagold.clear();
                                    });
                                  }
                                  if (newval == 'Palladium/USD') {
                                    setState(() {
                                      commodity = 'frxXPDUSD';
                                      tickStreamGOLD();
                                      getTickOnce();
                                      getTickStream();
                                      _getasset();
                                      _chartDatapalladium.clear();
                                    });
                                  }
                                  if (newval == 'Platinum/USD') {
                                    setState(() {
                                      commodity = 'frxXPTUSD';
                                      tickStreamGOLD();
                                      getTickOnce();
                                      getTickStream();
                                      _getasset();
                                      _chartDataplatinum.clear();
                                    });
                                  }
                                  if (newval == 'Silver/USD') {
                                    setState(() {
                                      commodity = 'frxXAGUSD';
                                      tickStreamGOLD();
                                      getTickOnce();
                                      getTickStream();
                                      _getasset();
                                      _chartDatasilver.clear();
                                    });
                                  }
                                  // secTimer();
                                },
                                // elevation: 16,
                                items: commodities.map((newval) {
                                  return DropdownMenuItem(
                                      value: newval,
                                      child: (newval == 'Gold/USD')
                                          ? gold
                                          : (newval == 'Palladium/USD')
                                              ? palladium
                                              : (newval == 'Platinum/USD')
                                                  ? platinum
                                                  : (newval == 'Silver/USD')
                                                      ? silver
                                                      : Text('T_T'));
                                }).toList(),
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.white,
                                ),
                                iconSize: 30,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: 45,
                                width: MediaQuery.of(context).size.width * 0.9,
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(249, 247, 247, 1),
                                  // color: Colors.black,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 4,
                                      offset: Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'Price Index',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromRGBO(9, 51, 116, 1),
                                      ),
                                    ),
                                    SizedBox(width: 50),
                                    //GOLD
                                    (_selectedCommodity == 'Gold/USD')
                                        ? (loadedGOLD.length < 3)
                                            ? Container(
                                                width: 15,
                                                height: 15,
                                                child:
                                                    CircularProgressIndicator())
                                            : (loadedGOLD[0] > loadedGOLD[1])
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Container(
                                                        child: Image.asset(
                                                            'assets/navbar/arrow_right_alt.png',
                                                            height: 35,
                                                            width: 35),
                                                      ),
                                                      Text(
                                                        '\$${loadedGOLD[0]}',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Color.fromRGBO(
                                                              0, 255, 56, 1),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : Row(
                                                    children: [
                                                      Container(
                                                        child: Image.asset(
                                                            'assets/navbar/arrow_right_red.png',
                                                            height: 35,
                                                            width: 35),
                                                      ),
                                                      Text(
                                                        '\$${loadedGOLD[0]}',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.red),
                                                      ),
                                                    ],
                                                  )
                                        :
                                        //PALLADIUM
                                        (_selectedCommodity == 'Palladium/USD')
                                            ? (loadedPALLA.length < 3)
                                                ? Container(
                                                    width: 15,
                                                    height: 15,
                                                    child:
                                                        CircularProgressIndicator())
                                                : (loadedPALLA[0] >
                                                        loadedPALLA[1])
                                                    ? Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          Container(
                                                            child: Image.asset(
                                                                'assets/navbar/arrow_right_alt.png',
                                                                height: 35,
                                                                width: 35),
                                                          ),
                                                          Text(
                                                            '\$${loadedPALLA[0]}',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Color
                                                                  .fromRGBO(
                                                                      0,
                                                                      255,
                                                                      56,
                                                                      1),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          Container(
                                                            child: Image.asset(
                                                                'assets/navbar/arrow_right_red.png',
                                                                height: 35,
                                                                width: 35),
                                                          ),
                                                          Text(
                                                            '\$${loadedPALLA[0]}',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors.red,
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                            :
                                            //PLATINUM
                                            (_selectedCommodity ==
                                                    'Platinum/USD')
                                                ? (loadedPLAT.length < 3)
                                                    ? Container(
                                                        width: 15,
                                                        height: 15,
                                                        child:
                                                            CircularProgressIndicator())
                                                    : (loadedPLAT[0] >
                                                            loadedPLAT[1])
                                                        ? Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              Container(
                                                                child: Image.asset(
                                                                    'assets/navbar/arrow_right_alt.png',
                                                                    height: 35,
                                                                    width: 35),
                                                              ),
                                                              Text(
                                                                '\$${loadedPLAT[0]}',
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          0,
                                                                          255,
                                                                          56,
                                                                          1),
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        : Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              Container(
                                                                child: Image.asset(
                                                                    'assets/navbar/arrow_right_red.png',
                                                                    height: 35,
                                                                    width: 35),
                                                              ),
                                                              Text(
                                                                '\$${loadedPLAT[0]}',
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .red,
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                :
                                                //SILVER
                                                (_selectedCommodity ==
                                                        'Silver/USD')
                                                    ? (loadedSILVER.length < 3)
                                                        ? Container(
                                                            width: 15,
                                                            height: 15,
                                                            child:
                                                                CircularProgressIndicator())
                                                        : (loadedSILVER[0] >
                                                                loadedSILVER[1])
                                                            ? Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceAround,
                                                                children: [
                                                                  Container(
                                                                    child: Image.asset(
                                                                        'assets/navbar/arrow_right_alt.png',
                                                                        height:
                                                                            35,
                                                                        width:
                                                                            35),
                                                                  ),
                                                                  Text(
                                                                    '\$${loadedSILVER[0]}',
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Color
                                                                          .fromRGBO(
                                                                              0,
                                                                              255,
                                                                              56,
                                                                              1),
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            : Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceAround,
                                                                children: [
                                                                  Container(
                                                                    child: Image.asset(
                                                                        'assets/navbar/arrow_right_red.png',
                                                                        height:
                                                                            35,
                                                                        width:
                                                                            35),
                                                                  ),
                                                                  Text(
                                                                    '\$${loadedSILVER[0]}',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .red),
                                                                  ),
                                                                ],
                                                              )
                                                    : Text('nothing'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Form(
                          key: _buysellkey,
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    const BoxShadow(
                                      color: Colors.black26,
                                    ),
                                    const BoxShadow(
                                      color: Colors.white,
                                      spreadRadius: -12.0,
                                      blurRadius: 12.0,
                                    ),
                                  ],
                                ),
                                height: 40,
                                width: MediaQuery.of(context).size.width * 0.73,
                                child: TextFormField(
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    focusNode: _buysellfield,
                                    validator: (value) {
                                      if (regex.hasMatch(value!))
                                        return 'numbers only';
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                    ),
                                    onSaved: (value) {
                                      _buysellData = double.parse(value!);
                                    }),
                              ),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(left: 6.5),
                                    child: Row(
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () async {
                                            setState(() {
                                              if (_selectedCommodity ==
                                                  'Gold/USD') {
                                                setState(() {
                                                  _selectedproduct = 'Xau';
                                                  runbothpurchase();
                                                  _getasset();
                                                });
                                              }
                                              if (_selectedCommodity ==
                                                  'Palladium/USD') {
                                                setState(() {
                                                  _selectedproduct = 'Xpd';
                                                  runbothpurchase();
                                                  _getasset();
                                                });
                                              }
                                              if (_selectedCommodity ==
                                                  'Platinum/USD') {
                                                setState(() {
                                                  _selectedproduct = 'Xpt';
                                                  runbothpurchase();
                                                  _getasset();
                                                });
                                              }
                                              if (_selectedCommodity ==
                                                  'Silver/USD') {
                                                setState(() {
                                                  _selectedproduct = 'Xag';
                                                  runbothpurchase();
                                                  _getasset();
                                                });
                                              }
                                            });
                                            await showsnackbar()
                                                .then((_) => setState(() {}));
                                          },
                                          child: Image.asset(
                                            'assets/navbar/buybtn.png',
                                          ),
                                        ),
                                        SizedBox(width: 25),
                                        GestureDetector(
                                          onTap: () async {
                                            if (_selectedCommodity ==
                                                'Gold/USD') {
                                              setState(() {
                                                _selectedproduct = 'Xau';
                                                runbothsell();
                                                _getasset();
                                              });
                                            }
                                            if (_selectedCommodity ==
                                                'Palladium/USD') {
                                              setState(() {
                                                _selectedproduct = 'Xpd';
                                                runbothsell();
                                                _getasset();
                                              });
                                            }
                                            if (_selectedCommodity ==
                                                'Platinum/USD') {
                                              setState(() {
                                                _selectedproduct = 'Xpt';
                                                runbothsell();
                                                _getasset();
                                              });
                                            }
                                            if (_selectedCommodity ==
                                                'Silver/USD') {
                                              setState(() {
                                                _selectedproduct = 'Xag';
                                                runbothsell();
                                                _getasset();
                                              });
                                            }
                                            await showsnackbar()
                                                .then((_) => setState(() {}));
                                          },
                                          child: Image.asset(
                                            'assets/navbar/sellbtn.png',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
  }
}
