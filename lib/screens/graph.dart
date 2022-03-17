import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';
import '../providers/models.dart';
// import '../providers/interval.dart';
import 'dart:async';
// import 'dart:math';
// import '../widget/dashboard_widget.dart';

class Graph extends StatefulWidget {
  @override
  _GraphState createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  bool isactiveGold = true;
  bool isactivePalla = false;
  bool isactivePlat = false;
  bool isactiveSilver = false;
  final List<Commodity> _chartData = [];
  final List<dynamic> timeConverted = [];
  late TrackballBehavior _trackballBehavior;
  late ZoomPanBehavior _zoomPanBehavior;
  String _selectedInterval = '1 minute';
  List intervals = [
    '1 minute',
    '2 minutes',
    '3 minutes',
    '4 minutes',
    '5 minutes'
  ];

  String interval = '60';

  String commodity = 'frxXAUUSD';

  List<dynamic> loadedPLAT = [];
  List<dynamic> loadedPALLA = [];
  List<dynamic> loadedGOLD = [];
  List<dynamic> loadedSILVER = [];

  dynamic tickCount;
  bool stopLoop = true;

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
        '{  "ticks_history": "${commodity}",  "adjust_start_time": 1,  "count": 10,"end": "latest","start": 1,"style": "candles"}');
  }

  void getTickStream() {
    channel2.sink.add(
        '{  "ticks_history": "${commodity}",  "adjust_start_time": 1,  "count": 1,"granularity":${interval},  "end": "latest",  "start": 1,  "style": "candles","subscribe":1}');
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

          _chartData.add(
            Commodity(
              close: extractedData['candles'][i]['close'],
              epoch: timeConverted[i],
              high: extractedData['candles'][i]['high'],
              low: extractedData['candles'][i]['low'],
              open: extractedData['candles'][i]['open'],
            ),
          );
        }
      });
    });
  }

  void handShake() {
    channel2.stream.listen((data) {
      final extractedData = jsonDecode(data);
      setState(() {
        timeConverted.insert(
            0,
            DateTime.fromMillisecondsSinceEpoch(
                extractedData['ohlc']['open_time'] * 1000));
        timeConverted.removeAt(3);

        _chartData.add(Commodity(
          close: num.parse(extractedData['ohlc']['close']),
          epoch: DateTime.fromMillisecondsSinceEpoch(
              extractedData['ohlc']['open_time'] * 1000),
          high: num.parse(extractedData['ohlc']['high']),
          low: num.parse(extractedData['ohlc']['low']),
          open: num.parse(extractedData['ohlc']['open']),
        ));
      });
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

        // print(loadedGOLD);
        // print(loadedPLAT);
        // print(loadedPALLA);
        // print(extractedData);
      },
    );
  }

  @override
  void initState() {
    getTickOnce();
    getTickStream();
    tickStreamPLAT();
    tickStreamPALLA();
    tickStreamGOLD();
    tickStreamSILVER();
    getprice();
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.start,
              // bottom: MediaQuery.of(context).size.height * 0.136,
              // left: 13,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.88,
                  height: MediaQuery.of(context).size.height * 0.42,
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Container(
                            // padding: EdgeInsets.only(top: 5, left: 15),
                            child: (Text('Market Overview',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(9, 51, 116, 1)))),
                            // height: (MediaQuery.of(context).size.height * 0.35),
                            // width: (MediaQuery.of(context).size.width * 0.93),
                            // color: Color.fromRGBO(249, 247, 247, 1),
                          ),
                          Flexible(
                            // padding: EdgeInsets.only(left: 20),
                            // color: Colors.black,
                            // width: MediaQuery.of(context).size.width * 0.2,
                            // height: MediaQuery.of(context).size.height * 0.05,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                // isExpanded: true,
                                value: _selectedInterval,
                                onChanged: (newval) {
                                  setState(() {
                                    _selectedInterval = newval as String;
                                    if (newval == '1 minute') {
                                      interval = '60';
                                      getTickStream();
                                      timeConverted.clear();
                                    }
                                    if (newval == '2 minutes') {
                                      interval = '120';
                                      getTickStream();
                                      timeConverted.clear();
                                    }
                                    if (newval == '3 minutes') {
                                      interval = '180';
                                      getTickStream();
                                      timeConverted.clear();
                                    }
                                    if (newval == '4 minutes') {
                                      interval = '240';
                                      getTickStream();
                                      timeConverted.clear();
                                    }
                                    if (newval == '5 minutes') {
                                      interval = '300';
                                      getTickStream();
                                      timeConverted.clear();
                                    }
                                  });
                                },
                                elevation: 16,
                                items: intervals.map((newval) {
                                  return DropdownMenuItem(
                                    value: newval,
                                    child: Text(newval),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.80,
                              height: MediaQuery.of(context).size.height * 0.33,
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
                                            dataSource: _chartData,
                                            // name: 'GOLD',
                                            xValueMapper:
                                                (Commodity sales, _) =>
                                                    sales.epoch,
                                            lowValueMapper:
                                                (Commodity sales, _) =>
                                                    sales.low,
                                            highValueMapper:
                                                (Commodity sales, _) =>
                                                    sales.high,
                                            openValueMapper:
                                                (Commodity sales, _) =>
                                                    sales.open,
                                            closeValueMapper:
                                                (Commodity sales, _) =>
                                                    sales.close)
                                      ],
                                      primaryXAxis: DateTimeAxis(
                                          dateFormat: DateFormat('hh:mm:ss'),
                                          majorGridLines:
                                              MajorGridLines(width: 0)),
                                      primaryYAxis: NumericAxis(
                                          opposedPosition: true,
                                          // minimum: 150,
                                          // maximum: 300,
                                          // interval: 10,
                                          numberFormat:
                                              NumberFormat.simpleCurrency(
                                                  decimalDigits: 0)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  width: MediaQuery.of(context).size.width * 0.88,
                  height: MediaQuery.of(context).size.height * 0.15,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(249, 247, 247, 1),
                    // color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            // padding: EdgeInsets.only(top: 5, left: 15),
                            child: (Text('Assets',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(9, 51, 116, 1)))),
                            // height: (MediaQuery.of(context).size.height * 0.35),
                            // width: (MediaQuery.of(context).size.width * 0.93),
                            // color: Color.fromRGBO(249, 247, 247, 1),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.25,
                          ),
                        ],
                      ),
                      SizedBox(),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            //GOLD
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  commodity = 'frxXAUUSD';
                                  getTickOnce();
                                  getTickStream();
                                  isactiveGold = true;
                                  isactivePalla = false;
                                  isactivePlat = false;
                                  isactiveSilver = false;
                                  _chartData.clear();
                                  timeConverted.clear();
                                });
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.38,
                                height:
                                    MediaQuery.of(context).size.height * 0.09,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Container(
                                    //GOLD
                                    child: Row(
                                      children: [
                                        Container(
                                          child: Image.asset(
                                              'assets/navbar/gold 1.png'),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              child: Text(
                                                'Gold/USD',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10),
                                              ),
                                            ),
                                            (loadedGOLD.length < 3)
                                                ? SizedBox()
                                                : (loadedGOLD[0] >
                                                        loadedGOLD[1])
                                                    ? Row(
                                                        children: [
                                                          Container(
                                                            child: Image.asset(
                                                                'assets/navbar/arrow_right_alt.png',
                                                                height: 35,
                                                                width: 35),
                                                          ),
                                                          Container(
                                                              child: Text(
                                                                  '\$${loadedGOLD[0].toStringAsFixed(2)}',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .green)))
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
                                                          Container(
                                                              child: Text(
                                                                  '\$${loadedGOLD[0].toStringAsFixed(2)}',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .red)))
                                                        ],
                                                      )
                                          ],
                                        ),
                                      ],
                                    ),

                                    decoration: (isactiveGold == false)
                                        ? BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment(0.8,
                                                  0.0), // 10% of the width, so there are ten blinds.
                                              colors: <Color>[
                                                Color.fromRGBO(67, 68, 70, 1),
                                                Color.fromRGBO(9, 51, 116, 0.8),
                                                Color.fromRGBO(3, 33, 45, 1),
                                              ], // red to yellow
                                            ),
                                          )
                                        : BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment(0.8,
                                                  0.0), // 10% of the width, so there are ten blinds.
                                              colors: <Color>[
                                                Color.fromRGBO(66, 142, 243, 1),
                                                Color.fromRGBO(61, 190, 242, 1),
                                                Color.fromRGBO(57, 136, 242, 1),
                                              ], // red to yellow
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                            //PALLA
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  commodity = 'frxXPDUSD';
                                  _chartData.clear();
                                  timeConverted.clear();
                                  getTickOnce();
                                  getTickStream();
                                  isactiveGold = false;
                                  isactivePalla = true;
                                  isactivePlat = false;
                                  isactiveSilver = false;
                                });
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.38,
                                height:
                                    MediaQuery.of(context).size.height * 0.09,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          // height: 35,
                                          // width: 30,
                                          child: Image.asset(
                                            'assets/navbar/silver.png',
                                            width: 50,
                                            height: 50,
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              // height: 35,
                                              // width: 30,
                                              child: Text(
                                                'Palladium/USD',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10),
                                              ),
                                            ),
                                            (loadedPALLA.length < 3)
                                                ? SizedBox()
                                                : (loadedPALLA[0] >
                                                        loadedPALLA[1])
                                                    ? Row(
                                                        children: [
                                                          Container(
                                                            child: Image.asset(
                                                                'assets/navbar/arrow_right_alt.png',
                                                                height: 35,
                                                                width: 35),
                                                          ),
                                                          Container(
                                                              child: Text(
                                                                  '\$${loadedPALLA[0].toStringAsFixed(2)}',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .green)))
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
                                                          Container(
                                                              child: Text(
                                                                  '\$${loadedPALLA[0].toStringAsFixed(2)}',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .red)))
                                                        ],
                                                      )
                                          ],
                                        ),
                                      ],
                                    ),
                                    decoration: (isactivePalla == false)
                                        ? BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment(0.8,
                                                  0.0), // 10% of the width, so there are ten blinds.
                                              colors: <Color>[
                                                Color.fromRGBO(67, 68, 70, 1),
                                                Color.fromRGBO(9, 51, 116, 0.8),
                                                Color.fromRGBO(3, 33, 45, 1),
                                              ], // red to yellow
                                            ),
                                          )
                                        : BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment(0.8,
                                                  0.0), // 10% of the width, so there are ten blinds.
                                              colors: <Color>[
                                                Color.fromRGBO(66, 142, 243, 1),
                                                Color.fromRGBO(61, 190, 242, 1),
                                                Color.fromRGBO(57, 136, 242, 1),
                                              ], // red to yellow
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                            //PLAT
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  commodity = 'frxXPTUSD';
                                  _chartData.clear();
                                  timeConverted.clear();
                                  getTickOnce();
                                  getTickStream();
                                  isactiveGold = false;
                                  isactivePalla = false;
                                  isactivePlat = true;
                                  isactiveSilver = false;
                                });
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.38,
                                height:
                                    MediaQuery.of(context).size.height * 0.09,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          // height: 35,
                                          // width: 30,
                                          child: Image.asset(
                                            'assets/navbar/platinum.png',
                                            width: 50,
                                            height: 50,
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              // height: 35,
                                              // width: 30,
                                              child: Text(
                                                'Platinum/USD',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10),
                                              ),
                                            ),
                                            (loadedPLAT.length < 3)
                                                ? SizedBox()
                                                : (loadedPLAT[0] >
                                                        loadedPLAT[1])
                                                    ? Row(
                                                        children: [
                                                          Container(
                                                            child: Image.asset(
                                                                'assets/navbar/arrow_right_alt.png',
                                                                height: 35,
                                                                width: 35),
                                                          ),
                                                          Container(
                                                              child: Text(
                                                                  '\$${loadedPLAT[0].toStringAsFixed(2)}',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .green)))
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
                                                          Container(
                                                              child: Text(
                                                                  '\$${loadedPLAT[0].toStringAsFixed(2)}',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .red)))
                                                        ],
                                                      )
                                          ],
                                        ),
                                      ],
                                    ),
                                    decoration: (isactivePlat == false)
                                        ? BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment(0.8,
                                                  0.0), // 10% of the width, so there are ten blinds.
                                              colors: <Color>[
                                                Color.fromRGBO(67, 68, 70, 1),
                                                Color.fromRGBO(9, 51, 116, 0.8),
                                                Color.fromRGBO(3, 33, 45, 1),
                                              ], // red to yellow
                                            ),
                                          )
                                        : BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment(0.8,
                                                  0.0), // 10% of the width, so there are ten blinds.
                                              colors: <Color>[
                                                Color.fromRGBO(66, 142, 243, 1),
                                                Color.fromRGBO(61, 190, 242, 1),
                                                Color.fromRGBO(57, 136, 242, 1),
                                              ], // red to yellow
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                            //SILVER
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  commodity = 'frxXAGUSD';
                                  _chartData.clear();
                                  timeConverted.clear();
                                  getTickOnce();
                                  getTickStream();
                                  isactiveGold = false;
                                  isactivePalla = false;
                                  isactivePlat = false;
                                  isactiveSilver = true;
                                });
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.38,
                                height:
                                    MediaQuery.of(context).size.height * 0.09,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            // height: 35,
                                            // width: 30,
                                            child: Image.asset(
                                              'assets/navbar/platinum.png',
                                              width: 50,
                                              height: 50,
                                            ),
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                // height: 35,
                                                // width: 30,
                                                child: Text(
                                                  'Silver/USD',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 10),
                                                ),
                                              ),
                                              (loadedSILVER.length < 3)
                                                  ? SizedBox()
                                                  : (loadedSILVER[0] >
                                                          loadedSILVER[1])
                                                      ? Row(
                                                          children: [
                                                            Container(
                                                              child: Image.asset(
                                                                  'assets/navbar/arrow_right_alt.png',
                                                                  height: 35,
                                                                  width: 35),
                                                            ),
                                                            Container(
                                                                child: Text(
                                                                    '\$${loadedSILVER[0].toStringAsFixed(2)}',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .green)))
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
                                                            Container(
                                                                child: Text(
                                                                    '\$${loadedSILVER[0].toStringAsFixed(2)}',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .red)))
                                                          ],
                                                        )
                                            ],
                                          ),
                                        ],
                                      ),
                                      decoration: (isactiveSilver == false)
                                          ? BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment(0.8,
                                                    0.0), // 10% of the width, so there are ten blinds.
                                                colors: <Color>[
                                                  Color.fromRGBO(67, 68, 70, 1),
                                                  Color.fromRGBO(
                                                      9, 51, 116, 0.8),
                                                  Color.fromRGBO(3, 33, 45, 1),
                                                ], // red to yellow
                                              ),
                                            )
                                          : BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment(0.8,
                                                    0.0), // 10% of the width, so there are ten blinds.
                                                colors: <Color>[
                                                  Color.fromRGBO(
                                                      66, 142, 243, 1),
                                                  Color.fromRGBO(
                                                      61, 190, 242, 1),
                                                  Color.fromRGBO(
                                                      57, 136, 242, 1),
                                                ], // red to yellow
                                              ),
                                            )),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
