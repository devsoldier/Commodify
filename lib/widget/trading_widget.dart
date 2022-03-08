import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';
import '../providers/models.dart';
// import '../providers/interval.dart';
import 'dart:async';
import 'dart:math';
import '../providers/auth.dart';
// import '../widget/dashboard_widget.dart';

class TradingWidget extends StatefulWidget {
  @override
  _TradingWidgetState createState() => _TradingWidgetState();
}

class _TradingWidgetState extends State<TradingWidget> {
  final List<Commodity> _chartData = [];
  List<dynamic> timeConverted = [];
  List<dynamic> loadedData = [];
  late TrackballBehavior _trackballBehavior;
  late ZoomPanBehavior _zoomPanBehavior;
  String _selectedCommodity = 'Gold/USD';
  List commodities = [
    'Gold/USD',
    'Platinum/USD',
    'Silver/USD',
  ];
  final GlobalKey<FormState> _buysellkey = GlobalKey();
  FocusNode _buysellfield = FocusNode();
  final TextEditingController _buysellController = TextEditingController();
  late double _buysellData;

  bool maximize = true;
  bool stopLoop = true;

  final channel = IOWebSocketChannel.connect(
      Uri.parse('wss://ws.binaryws.com/websockets/v3?app_id=1089'));

  final channel2 = IOWebSocketChannel.connect(
      Uri.parse('wss://ws.binaryws.com/websockets/v3?app_id=1089'));

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  void getTickOnce() {
    channel.sink.add(
        '{  "ticks_history": "R_50",  "adjust_start_time": 1,  "count": 10,"end": "latest","start": 1,"style": "candles"}');
  }

  void getTickStream() {
    channel2.sink.add('{  "ticks": "R_50",  "subscribe": 1}');
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
      final extractedData = jsonDecode(data);

      setStateIfMounted(() {
        for (int i = 0; i < extractedData.length - 3; i++) {
          timeConverted.insert(
              0,
              DateTime.fromMillisecondsSinceEpoch(
                  extractedData['tick']['epoch'] * 1000));
          loadedData.insert(0, extractedData['tick']['quote']);

          _chartData.add(Commodity(
              close: loadedData[loadedData.length - 1],
              epoch: timeConverted[i],
              high: loadedData.cast<num>().reduce(max),
              low: loadedData.cast<num>().reduce(min),
              open: loadedData[0]));
          // print('close:${_chartData[i].close}');
          // print('epoch:${_chartData[i].epoch}');
          // print('high:${_chartData[i].high}');
          // print('low:${_chartData[i].low}');
          // print('open:${_chartData[i].open}');
          // print('length:${_chartData.length}');
          // print('---------------------------');
        }
      });
    });
  }

  @override
  void initState() {
    // secTimer();
    // getbalance();
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

  Future<void> purchase() async {
    _buysellkey.currentState!.save();
    await Provider.of<Auth>(context, listen: false).buy(_buysellData);
  }

  Future<void> sell() async {
    _buysellkey.currentState!.save();
    await Provider.of<Auth>(context, listen: false).sell(_buysellData);
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

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final balancedata = Provider.of<Auth>(context);

    Widget gold = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset('assets/navbar/gold 1.png'),
        Text('Gold/USD'),
        SizedBox(width: 50)
      ],
    );
    Widget platinum = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
            height: 50,
            width: 50,
            child: Image.asset('assets/navbar/platinum.png')),
        Text('Platinum/USD'),
        SizedBox(width: 50)
      ],
    );
    Widget silver = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
            height: 50,
            width: 50,
            child: Image.asset('assets/navbar/silver.png')),
        Text('Silver/USD'),
        SizedBox(width: 50)
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
              : MediaQuery.of(context).size.height * 0.7,
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
          bottom: -20,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25.0),
            child: Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width * 0.96,
              height: MediaQuery.of(context).size.height * 0.11,
            ),
          ),
        ),
        Positioned(
          bottom: 15,
          left: 190,
          child: GestureDetector(
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
        ),
        graph,
      ],
    );
    return (maximize == false)
        ? minimized
        : Stack(
            children: <Widget>[
              graph,
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
              Positioned(
                bottom: 230,
                left: 190,
                child: GestureDetector(
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
              ),
              Positioned(
                bottom: 200,
                left: 30,
                child: Column(
                  children: <Widget>[
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
                  ],
                ),
              ),
              Positioned(
                bottom: 150,
                left: 18,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.only(bottomLeft: Radius.circular(30)),
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
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(27, 84, 169, 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        dropdownColor: Color.fromRGBO(27, 84, 169, 1),
                        style: TextStyle(color: Colors.white),
                        isExpanded: true,
                        value: _selectedCommodity,
                        onChanged: (newval) {
                          setState(() {
                            _selectedCommodity = newval as String;
                            // secTimer();
                          });
                        },
                        // elevation: 16,
                        items: commodities.map((newval) {
                          return DropdownMenuItem(
                            value: newval,
                            child: (newval == 'Gold/USD')
                                ? gold
                                : (newval == 'Platinum/USD')
                                    ? platinum
                                    : (newval == 'Silver/USD')
                                        ? silver
                                        : Text('haha'),
                          );
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
              ),
              Positioned(
                bottom: 100,
                left: 18,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.only(bottomLeft: Radius.circular(30)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0.0, 4.0), //(x,y)
                        blurRadius: 5.0,
                      ),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                          height: 45,
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(249, 247, 247, 1),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('Price Index'),
                              SizedBox(width: 50),
                              (loadedData.length < 3)
                                  ? Text('\$ -')
                                  : (loadedData[0] > loadedData[1])
                                      ? Text(
                                          '\$${loadedData[0]}',
                                          style: TextStyle(color: Colors.green),
                                        )
                                      : /* (loadedData[0] < loadedData[1]) */
                                      /* ? */ Text('\$${loadedData[0]}',
                                          style: TextStyle(color: Colors.red))
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 53,
                bottom: 50,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.73,
                  child: FittedBox(
                    child: Image.asset('assets/navbar/Rectangle 6332.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Positioned(
                bottom: -1,
                left: 40,
                child: Form(
                  key: _buysellkey,
                  child: Column(
                    children: [
                      Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width * 0.73,
                        child: TextFormField(
                            keyboardType: TextInputType.number,
                            focusNode: _buysellfield,
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
                      Container(
                        padding: EdgeInsets.only(left: 6.5),
                        child: Row(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  runbothpurchase();
                                });
                              },
                              child: Image.asset(
                                'assets/navbar/buybtn.png',
                              ),
                            ),
                            SizedBox(width: 25),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  runbothsell();
                                });
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
                ),
              ),
            ],
          );
  }
}
