import 'package:provider/provider.dart';
import '../providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';
import 'dart:async';
// import '../providers/models.dart';

class DashboardWidget extends StatefulWidget {
  const DashboardWidget({Key? key}) : super(key: key);

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
    return Stack(
      children: <Widget>[
        Positioned(
          top: 5,
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
              Consumer<Auth>(
                  builder: (_, datauser, __) => (datauser.user.isEmpty)
                      ? Container(width: 15, height: 15, child: loadpage)
                      : Text(
                          ' ${datauser.user[0].first_name} ${datauser.user[0].last_name}!',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ))
            ],
          ),
        ),
        Positioned(
          top: 28,
          left: 10,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.95,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  // color: Colors.black,
                  height: 75,
                  width: 75,
                  child: Image.asset('assets/navbar/Vector.png'),
                ),
                Column(
                  children: <Widget>[
                    Container(
                      child: Text(
                        'Current Balance',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      child: Consumer<Auth>(
                        builder: (_, balancedata, __) => (_isLoading == true)
                            ? Container(width: 15, height: 15, child: loadpage)
                            : Text(
                                '\$${(balancedata.balance).toStringAsFixed(2)}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 28),
                              ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.18,
          left: MediaQuery.of(context).size.width * 0.034,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 5,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 5),
                    height: MediaQuery.of(context).size.height * 0.11,
                    width: MediaQuery.of(context).size.width * 0.93,
                    color: Color.fromRGBO(249, 247, 247, 1),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Center(
                            child: ListView(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              children: <Widget>[
                                // Divider(indent: 20),
                                Column(
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black12,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(2),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color.fromRGBO(
                                                  0, 50, 117, 1.0)),
                                          child: Container(
                                            child: IconButton(
                                              icon: Icon(
                                                  Icons
                                                      .favorite_border_outlined,
                                                  color: Color.fromRGBO(
                                                      0, 178, 255, 1.0)),
                                              onPressed: () {},
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text('Favorite'),
                                  ],
                                ),
                                Divider(
                                    indent: MediaQuery.of(context).size.width *
                                        0.18),
                                Column(
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black12,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(2),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color.fromRGBO(
                                                  0, 50, 117, 1.0)),
                                          child: Container(
                                            child: IconButton(
                                              icon: Icon(Icons.search,
                                                  color: Color.fromRGBO(
                                                      0, 178, 255, 1.0)),
                                              onPressed: () {},
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text('Search')
                                  ],
                                ),
                                Divider(
                                    indent: MediaQuery.of(context).size.width *
                                        0.18),
                                Column(
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black12,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(2),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color.fromRGBO(
                                                  0, 50, 117, 1.0)),
                                          child: Container(
                                            child: IconButton(
                                              icon: Icon(
                                                  Icons
                                                      .notifications_active_outlined,
                                                  color: Color.fromRGBO(
                                                      0, 178, 255, 1.0)),
                                              onPressed: () {},
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text('Notification'),
                                  ],
                                ),
                              ],
                            ),
                          ),
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
