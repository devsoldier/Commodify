import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';
import '../providers/models.dart';
// import '../providers/interval.dart';
import 'dart:async';
// import '../widget/dashboard_widget.dart';

class TradingWidget extends StatefulWidget {
  @override
  _TradingWidgetState createState() => _TradingWidgetState();
}

class _TradingWidgetState extends State<TradingWidget> {
  final List<Commodity> _chartData = [];
  late TrackballBehavior _trackballBehavior;
  late ZoomPanBehavior _zoomPanBehavior;
  String _selectedCommodity = 'GOLD/USD';
  List commodities = [
    'GOLD/USD',
    '??',
    '???',
  ];

  bool stopLoop = true;

  final channel = IOWebSocketChannel.connect(
      Uri.parse('wss://ws.binaryws.com/websockets/v3?app_id=1089'));

  final channel2 = IOWebSocketChannel.connect(
      Uri.parse('wss://ws.binaryws.com/websockets/v3?app_id=1089'));

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  secTimer() {
    Timer.periodic(Duration(minutes: 1), (timer) {
      if (stopLoop == false) {
        timer.cancel();
        // channel2.sink.close();
      }
      setStateIfMounted(() {
        getTickStream();
      });
    });
  }

  void getTickOnce() {
    channel.sink.add(
        '{  "ticks_history": "R_50",  "adjust_start_time": 1,  "count": 10,"end": "latest","start": 1,"style": "candles"}');
  }

  void getTickStream() {
    channel2.sink.add(
        '{  "ticks_history": "R_50",  "adjust_start_time": 1,  "count": 1,"end": "latest","start": 1,"style": "candles"}');
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
        // print(_chartData);
      });
    });
  }

  void handShake() {
    channel2.stream.listen((data) {
      setState(() {
        final extractedData = jsonDecode(data);
        // print(extractedData);

        List<dynamic> timeConverted = [];
        for (int i = 0; i < extractedData['candles'].length; i++) {
          timeConverted.add(DateTime.fromMillisecondsSinceEpoch(
              extractedData['candles'][i]['epoch'] * 1000));
          // _chartData.removeAt(1);
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
          // print(_chartData);
          print(timeConverted);
        }
      });
    });
  }

  @override
  void initState() {
    secTimer();
    getTickOnce();
    getTickStream();
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
        Positioned(
          top: 10,
          left: 0,
          child: ClipRRect(
            // borderRadius: BorderRadius.circular(10.0),
            child: Container(
              width: MediaQuery.of(context).size.width * 1.0,
              height: MediaQuery.of(context).size.height * 0.4,
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
                            name: 'GOLD',
                            xValueMapper: (Commodity sales, _) => sales.epoch,
                            lowValueMapper: (Commodity sales, _) => sales.low,
                            highValueMapper: (Commodity sales, _) => sales.high,
                            openValueMapper: (Commodity sales, _) => sales.open,
                            closeValueMapper: (Commodity sales, _) =>
                                sales.close)
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
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 200,
          left: 30,
          child: Column(
            children: <Widget>[
              Container(
                height: 25,
                // color: Colors.black,
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
                            '\$1000000000000000000',
                            style: TextStyle(
                              color: Color.fromRGBO(0, 51, 116, 1),
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
              // Row(
              //   children: <Widget>[
              //     Container(
              //       height: 25,
              //       color: Colors.black,
              //       child: Text('where am i'),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
        Positioned(
          bottom: 150,
          left: 160,
          child: Container(
            color: Colors.amber,
            height: 25,
            width: 105,
            child: DropdownButton(
              isExpanded: true,
              value: _selectedCommodity,
              onChanged: (newval) {
                setState(() {
                  _selectedCommodity = newval as String;
                  secTimer();
                });
              },
              elevation: 16,
              items: commodities.map((newval) {
                return DropdownMenuItem(
                  value: newval,
                  child: Text(newval),
                );
              }).toList(),
            ),
          ),
        ),
        Positioned(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[Container(child: Column())],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
