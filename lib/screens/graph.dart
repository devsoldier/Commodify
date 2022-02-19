import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
// import '../providers/commo.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';
import '../providers/models.dart';
import 'dart:async';

class Graph extends StatefulWidget {
  @override
  _GraphState createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  final List<Commodity> _chartData = [];
  late TrackballBehavior _trackballBehavior;
  dynamic tickCount;
  bool stopLoop = true;

  final channel = IOWebSocketChannel.connect(
      Uri.parse('wss://ws.binaryws.com/websockets/v3?app_id=1089'));

  final channel2 = IOWebSocketChannel.connect(
      Uri.parse('wss://ws.binaryws.com/websockets/v3?app_id=1089'));

  void secTimer() {
    if (stopLoop == true) {
      Timer.periodic(Duration(seconds: 3), (timer) {
        if (stopLoop == false) {
          timer.cancel();
          channel.sink.close();
        }
        setState(() {
          getTickStream();
          // handShake();
          // int count = 0;
          // count++;
          // tickCount = count;
        });
      });
    }
  }

  void getTickOnce() {
    channel.sink.add(
        '{  "ticks_history": "R_50",  "adjust_start_time": 1,  "count": 10,"end": "latest","start": 1,"style": "candles"}');
  }

  void getTickStream() {
    channel2.sink.add(
        '{  "ticks_history": "R_50",  "adjust_start_time": 1,  "count": 10,"end": "latest","start": 1,"style": "candles"}');
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
        print(_chartData);
      });
    });
  }

  void handShake() {
    channel2.stream.listen((data) {
      final extractedData = jsonDecode(data);
      setState(() {
        List<dynamic> timeConverted = [];
        for (int i = 0; i < extractedData['candles'].length; i++) {
          timeConverted.add(DateTime.fromMillisecondsSinceEpoch(
              extractedData['candles'][i]['epoch'] * 1000));
          _chartData.removeLast();
          _chartData.insert(
            0,
            Commodity(
              close: extractedData['candles'][i]['close'],
              epoch: timeConverted[i],
              high: extractedData['candles'][i]['high'],
              low: extractedData['candles'][i]['low'],
              open: extractedData['candles'][i]['open'],
            ),
          );
          print(_chartData);
        }
      });
    });
  }

  @override
  void initState() {
    setState(() {});
    secTimer();
    getTickOnce();
    getTickStream();
    handShake();
    initialValue();
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
        Positioned(
          top: 100,
          left: 50,
          child: Column(
            children: <Widget>[
              Container(
                height: (MediaQuery.of(context).size.height * 0.6),
                width: (MediaQuery.of(context).size.height * 0.5),
                child: SfCartesianChart(
                  title: ChartTitle(text: 'GOLD - 2016'),
                  legend: Legend(isVisible: true),
                  trackballBehavior: _trackballBehavior,
                  series: <CandleSeries>[
                    CandleSeries<Commodity, DateTime>(
                        dataSource: _chartData,
                        name: 'GOLD',
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
                      // minimum: 150,
                      // maximum: 300,
                      // interval: 10,
                      numberFormat:
                          NumberFormat.simpleCurrency(decimalDigits: 0)),
                ),
                // ),
                // ElevatedButton(
                //   child: Text('press to kill T_T'),
                //   style: ElevatedButton.styleFrom(
                //     primary: stopLoop ? Colors.teal : Colors.red,
                //   ),
                //   onPressed: () {
                //     setState(() {
                //       if (stopLoop == true) {
                //         stopLoop = false;
                //       } else if (stopLoop == false) {
                //         stopLoop = true;
                //         secTimer();
                //       }
                //     });
                //   },
                // ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
