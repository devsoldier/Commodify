import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:toggle_switch/toggle_switch.dart';

class WalletWidget extends StatefulWidget {
  // const WalletWidget({ Key? key }) : super(key: key);

  @override
  _WalletWidgetState createState() => _WalletWidgetState();
}

class _WalletWidgetState extends State<WalletWidget> {
  bool currentTab = true;
  bool? selectedpayment = false;
  int initialPage = 1;
  // List paymentMethod = [];
  final GlobalKey<FormState> _carddetail = GlobalKey();
  FocusNode _cardnumber = FocusNode();
  FocusNode _month = FocusNode();
  FocusNode _year = FocusNode();
  FocusNode _ccv = FocusNode();

  final TextEditingController _cardnumberController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _ccvController = TextEditingController();

  String monthValidator(String value) {
    final n = num.tryParse(value);
    if (n! > 13) {
      return 'enter valid month';
    }
    return 'null';
  }

  @override
  Widget build(BuildContext context) {
    Widget Payment = Positioned(
      bottom: 10,
      left: 17,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        // color: Colors.black12,
        child: Column(
          key: _carddetail,
          children: <Widget>[
            Container(
              child: Row(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        child: Checkbox(
                          value: selectedpayment,
                          onChanged: (value) {
                            setState(() {
                              selectedpayment = value;
                            });
                          },
                        ),
                      ),
                      Container(
                        // color: Colors.black,
                        child: Image.asset(
                          'assets/navbar/Visa.png',
                          /*  height: double.infinity,
                                width: double.infinity */
                        ),
                        /*   height: 220,
                            width: 140, */
                      ),
                      Container(
                        // color: Colors.black,
                        child: Stack(
                          children: <Widget>[
                            Positioned(
                              child:
                                  Image.asset('assets/navbar/Rectangle 6.png'),
                            ),
                            Positioned(
                              left: 7,
                              top: 3,
                              child: Image.asset(
                                  'assets/navbar/Oval 5 + Oval 5 Copy + Oval 5 Copy 3.png'),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 65),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        child: Checkbox(
                          value: selectedpayment,
                          onChanged: (value) {
                            setState(() {
                              selectedpayment = value;
                            });
                          },
                        ),
                      ),
                      Text(
                        'Online Banking',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Color.fromRGBO(9, 51, 116, 1),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      SizedBox(width: 14),
                      Container(
                        alignment: Alignment.centerLeft,
                        // color: Colors.black,
                        child: Text(
                          'Card Number',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color.fromRGBO(9, 51, 116, 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 7),
                  Row(
                    children: <Widget>[
                      SizedBox(width: 14),
                      Container(
                        alignment: Alignment.centerLeft,
                        width: (MediaQuery.of(context).size.width * 0.75),
                        height: 40,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          focusNode: _cardnumber,
                          validator: (value) {
                            if (value!.isEmpty || value.length < 16) {
                              return 'enter valid number!';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                            ),
                          ),
                          onSaved: (value) {},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                      left: 15,
                      right: 105,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Expiration Date',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color.fromRGBO(9, 51, 116, 1),
                          ),
                        ),
                        Text(
                          'CCV',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color.fromRGBO(9, 51, 116, 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 7),
                  Container(
                    padding: EdgeInsets.only(left: 16, right: 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        //month
                        Container(
                          width: (MediaQuery.of(context).size.width * 0.10),
                          height: 40,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: _monthController,
                            focusNode: _month,
                            validator: (value) {
                              monthValidator(value!);
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5.0),
                                ),
                              ),
                            ),
                            onSaved: (value) {},
                          ),
                        ),
                        //year
                        Container(
                          width: (MediaQuery.of(context).size.width * 0.20),
                          height: 40,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: _yearController,
                            focusNode: _year,
                            validator: (value) {
                              if (value!.isEmpty || value.length > 4) {
                                return 'enter valid year!';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5.0),
                                ),
                              ),
                            ),
                            onSaved: (value) {},
                          ),
                        ),
                        SizedBox(width: 55),
                        //CCV
                        Container(
                          width: (MediaQuery.of(context).size.width * 0.20),
                          height: 40,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: _ccvController,
                            focusNode: _ccv,
                            validator: (value) {
                              if (value!.isEmpty || value.length > 3) {
                                return 'enter valid number!';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5.0),
                                ),
                              ),
                            ),
                            onSaved: (value) {},
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              // color: Colors.black,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 19),
                  Image.asset(
                    'assets/navbar/save button.png',
                  ),
                  // Text('Save'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    return Stack(
      children: <Widget>[
        Positioned(
          top: 24,
          left: 7,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Container(
              color: Color.fromRGBO(0, 178, 255, 0.6),
              width: MediaQuery.of(context).size.width * 0.96,
              height: MediaQuery.of(context).size.height * 0.1350,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: 35,
                    // color: Colors.black,
                    child: Text(
                      'Total Balance',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                      '\$10000000000',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 100,
          left: 7,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Container(
              color: Color.fromRGBO(249, 247, 247, 1),
              width: MediaQuery.of(context).size.width * 0.96,
              height: MediaQuery.of(context).size.height * 0.120,
              child: Column(
                children: <Widget>[
                  Container(),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: 14.5,
          bottom: -20,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22.0),
            child: Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width * 0.915,
              height: MediaQuery.of(context).size.height * 0.527,
            ),
          ),
        ),
        Positioned(
          bottom: 300,
          left: 15,
          child: Container(
            // color: Colors.black,
            // height: MediaQuery.of(context).size.height * 0.1,
            height: 40,
            // width: MediaQuery.of(context).size.width * 1.0,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ToggleSwitch(
                    minWidth: double.infinity,
                    cornerRadius: 20.0,
                    activeBgColors: [
                      [Colors.white],
                      [Colors.white],
                      // [Colors.red[800]!]
                    ],
                    activeFgColor: Color.fromRGBO(9, 51, 116, 1),
                    inactiveBgColor: Color.fromRGBO(132, 199, 239, 0.57),
                    inactiveFgColor: Color.fromRGBO(9, 51, 116, 1),
                    initialLabelIndex: initialPage,
                    totalSwitches: 2,
                    labels: ['Payment', 'Activity'],
                    // radiusStyle: true,
                    onToggle: (index) {
                      setState(() {
                        initialPage = index!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        (initialPage == 1) ? Payment : Center(child: Text('nothing')),
        // WIP
        // Positioned(
        //   bottom: 10,
        //   left: 10,
        //   child: ListView.builder(itemBuilder: )
        // ),
      ],
    );
  }
}
