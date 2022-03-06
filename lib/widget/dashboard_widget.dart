// ignore_for_file: prefer_const_constructors
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class DashboardWidget extends StatefulWidget {
  const DashboardWidget({Key? key}) : super(key: key);

  @override
  _DashboardWidgetState createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  Future<void> getbalance() async {
    await Provider.of<Auth>(context, listen: false).getbalance();
  }

  @override
  void initState() {
    getbalance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              Text(
                ' Tom!',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
                      child: Text(
                        'miskin',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 28),
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
                                      // alignment: Alignment.center,
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
                                      // alignment: Alignment.center,
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
        Positioned(
          bottom: 12,
          left: 22.5,
          child: Container(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                alignment: Alignment.center,
                // color: Colors.black,
                height: MediaQuery.of(context).size.height * 0.105,
                width: MediaQuery.of(context).size.width * 0.88,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Center(
                        child: ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            Column(
                              children: [
                                Container(
                                    child: Image.asset(
                                        'assets/navbar/gold asset.png'))
                              ],
                            ),
                            Column(
                              children: [
                                Container(
                                    child: Image.asset(
                                        'assets/navbar/Rectangle 6331.png'))
                              ],
                            ),
                            Column(
                              children: [
                                Container(
                                    child: Image.asset(
                                        'assets/navbar/Rectangle 6331.png'))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
