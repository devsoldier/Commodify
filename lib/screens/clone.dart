// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:intl/intl.dart';
// import 'package:web_socket_channel/io.dart';
// import 'dart:convert';
// import '../providers/models.dart';
// import 'dart:async';
// import 'dart:math';

// class Clone extends StatefulWidget {
//   const Clone({Key? key}) : super(key: key);

//   @override
//   _CloneState createState() => _CloneState();
// }

// class _CloneState extends State<Clone> {
//   List<Commodity> _chartData = [];
//   late TrackballBehavior _trackballBehavior;
//   late ZoomPanBehavior _zoomPanBehavior;

//   final channel = IOWebSocketChannel.connect(
//       Uri.parse('wss://ws.binaryws.com/websockets/v3?app_id=1089'));

//   final channel2 = IOWebSocketChannel.connect(
//       Uri.parse('wss://ws.binaryws.com/websockets/v3?app_id=1089'));

//   void getTickOnce() {
//     channel.sink.add(
//         '{  "ticks_history": "R_50",  "adjust_start_time": 1,  "count": 10,"end": "latest","start": 1,"style": "candles"}');
//   }

//   void getTickStream() {
//     channel2.sink.add('{  "ticks": "R_50",  "subscribe": 1}');
//   }

//   void initialValue() {
//     channel.stream.listen((data) {
//       final extractedData = jsonDecode(data);
//       setState(() {
//         List<dynamic> timeConverted = [];
//         for (int i = 0; i < extractedData['candles'].length; i++) {
//           timeConverted.add(DateTime.fromMillisecondsSinceEpoch(
//               extractedData['candles'][i]['epoch'] * 1000));

//           _chartData.add(
//             Commodity(
//               close: extractedData['candles'][i]['close'],
//               epoch: timeConverted[i],
//               high: extractedData['candles'][i]['high'],
//               low: extractedData['candles'][i]['low'],
//               open: extractedData['candles'][i]['open'],
//             ),
//           );
//         }

//         // print(_chartData);
//       });
//     });
//   }

//   void handShake() {
//     channel2.stream.listen((data) {
//       final extractedData = jsonDecode(data);
//       List<dynamic> timeConverted = [];
//       List<dynamic> loadedData = [];
//       setState(() {
//         for (int i = 0; i < extractedData.length - 3; i++) {
//           timeConverted.insert(
//               0,
//               DateTime.fromMillisecondsSinceEpoch(
//                   extractedData['tick']['epoch'] * 1000));
//           loadedData.add(extractedData['tick']['quote']);
//           _chartData.add(Commodity(
//               close: loadedData[loadedData.length - 1],
//               epoch: timeConverted[i],
//               high: loadedData.cast<num>().reduce(max),
//               low: loadedData.cast<num>().reduce(min),
//               open: loadedData[0]));
//           print('close:${_chartData[i].close}');
//           print('epoch:${_chartData[i].epoch}');
//           print('high:${_chartData[i].high}');
//           print('low:${_chartData[i].low}');
//           print('open:${_chartData[i].open}');
//           print('length:${_chartData.length}');
//           print('---------------------------');
//         }
//       });
//     });
//   }

//   @override
//   void initState() {
//     getTickOnce();
//     getTickStream();
//     handShake();
//     initialValue();
//     _zoomPanBehavior = ZoomPanBehavior(
//         enablePinching: true,
//         enableDoubleTapZooming: true,
//         enableMouseWheelZooming: true);
//     _trackballBehavior = TrackballBehavior(
//         enable: true, activationMode: ActivationMode.singleTap);
//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         // Positioned(
//         //   top: 202,
//         //   right: 35,
//         //   child: ClipRRect(
//         //     borderRadius: BorderRadius.circular(10.0),
//         //     child: Container(
//         //       decoration: BoxDecoration(
//         //           // border: Border.all(color: Colors.black54),
//         //           borderRadius: BorderRadius.circular(12)),
//         //       width: MediaQuery.of(context).size.width * 0.25,
//         //       height: MediaQuery.of(context).size.height * 0.05,
//         //       child: DropdownButton(
//         //         isExpanded: true,
//         //         value: _selectedInterval,
//         //         onChanged: (newval) {
//         //           setState(() {
//         //             _selectedInterval = newval as String;
//         //             secTimer();
//         //           });
//         //         },
//         //         elevation: 16,
//         //         items: intervals.map((newval) {
//         //           return DropdownMenuItem(
//         //             value: newval,
//         //             child: Text(newval),
//         //           );
//         //         }).toList(),
//         //       ),
//         //     ),
//         //   ),
//         // ),
//         Positioned(
//           bottom: 105,
//           left: 24,
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(10.0),
//             child: Container(
//               width: MediaQuery.of(context).size.width * 0.88,
//               height: MediaQuery.of(context).size.height * 0.3,
//               color: Color.fromRGBO(15, 34, 66, 1),
//               child: Column(
//                 children: <Widget>[
//                   Expanded(
//                     child: SfCartesianChart(
//                       // title: ChartTitle(text: 'GOLD - 2016'),
//                       legend: Legend(isVisible: false),
//                       zoomPanBehavior: _zoomPanBehavior,
//                       trackballBehavior: _trackballBehavior,
//                       series: <CandleSeries>[
//                         CandleSeries<Commodity, DateTime>(
//                             dataSource: _chartData,
//                             name: 'GOLD',
//                             xValueMapper: (Commodity sales, _) => sales.epoch,
//                             lowValueMapper: (Commodity sales, _) => sales.low,
//                             highValueMapper: (Commodity sales, _) => sales.high,
//                             openValueMapper: (Commodity sales, _) => sales.open,
//                             closeValueMapper: (Commodity sales, _) =>
//                                 sales.close)
//                       ],
//                       primaryXAxis: DateTimeAxis(
//                           dateFormat: DateFormat('hh:mm:ss'),
//                           majorGridLines: MajorGridLines(width: 0)),
//                       primaryYAxis: NumericAxis(
//                           // minimum: 150,
//                           // maximum: 300,
//                           // interval: 10,
//                           numberFormat:
//                               NumberFormat.simpleCurrency(decimalDigits: 0)),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
