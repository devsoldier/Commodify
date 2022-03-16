import 'package:drc/widget/activity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import './transaction_widget.dart';

class WalletWidget extends StatefulWidget {
  // const WalletWidget({ Key? key }) : super(key: key);

  @override
  _WalletWidgetState createState() => _WalletWidgetState();
}

class _WalletWidgetState extends State<WalletWidget> {
  bool currentTab = true;
  bool? online = false;
  bool? card = false;
  int initialPage = 0;
  late double withdrawamount;
  // List paymentMethod = [];
  final GlobalKey<FormState> _carddetail = GlobalKey();
  // final GlobalKey<FormState> _withdrawamount = GlobalKey();
  // final GlobalKey<FormState> _topupamount = GlobalKey();

  FocusNode _cardnumber = FocusNode();
  FocusNode _month = FocusNode();
  FocusNode _year = FocusNode();
  FocusNode _ccv = FocusNode();
  FocusNode _withdrawnode = FocusNode();

  final TextEditingController _cardnumberController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _ccvController = TextEditingController();
  final TextEditingController _withdrawController = TextEditingController();

  Future<void> _topup() async {
    await Provider.of<Auth>(context, listen: false).istopup();
  }

  Future<void> _withdraw() async {
    await Provider.of<Auth>(context, listen: false).iswithdraw(withdrawamount);
  }

  Future<void> updatebalance() async {
    await Provider.of<Auth>(context, listen: false).getbalance();
  }

  Future<void> topupbalance() async {
    _topup().then((_) => updatebalance());
  }

  Future<void> withdrawbalance() async {
    _withdraw().then((_) => updatebalance());
  }

  _showWithdrawDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('WITHDRAWAL'),
        content: Container(
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width * 0.1,
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                child: Text('Amount'),
              ),
              Container(
                color: Color.fromRGBO(229, 229, 229, 1),
                height: 40,
                width: 250,
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Enter Amount',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    withdrawamount = double.parse(value);
                  },
                  controller: _withdrawController,
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          Container(
            // color: Colors.black,
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    setState(() {
                      withdrawbalance();
                      Navigator.pop(context);
                    });
                  },
                  child: Image.asset(
                    'assets/navbar/withdraw btn.png',
                  ),
                ),
                SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                  child: Image.asset(
                    'assets/navbar/cancel btn.png',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _showTopupDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('TOP-UP'),
        content: Container(
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width * 0.1,
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                child: Text('Amount'),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          Container(
            // color: Colors.black,
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    setState(() {
                      topupbalance();
                      Navigator.pop(context);
                    });
                  },
                  child: Image.asset(
                    'assets/navbar/topup btn.png',
                  ),
                ),
                SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                  child: Image.asset(
                    'assets/navbar/cancel btn.png',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String monthValidator(String value) {
    final n = num.tryParse(value);
    if (n! > 13) {
      return 'enter valid month';
    }
    return 'null';
  }

  Future<void> _submit() async {
    if (!_carddetail.currentState!.validate()) {
      return;
    }
    _carddetail.currentState!.save();
  }

  @override
  void initState() {
    super.initState();
  }

// TODO: implement dispose
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final balancedata = Provider.of<Auth>(context);
    // Widget Activity = ;

    Widget Payment = Container(
      width: MediaQuery.of(context).size.width * 0.9,
      // color: Colors.black12,
      child: Form(
        key: _carddetail,
        child: Column(
          children: <Widget>[
            Container(
              child: Row(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        child: Checkbox(
                          value: card,
                          onChanged: (value) {
                            setState(() {
                              card = value;
                            });
                          },
                        ),
                      ),
                      Container(
                        child: Image.asset(
                          'assets/navbar/Visa.png',
                        ),
                      ),
                      Container(
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
                      SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        child: Checkbox(
                          value: online,
                          onChanged: (value) {
                            setState(() {
                              online = value;
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
                      //CARDNUMBER
                      Container(
                        alignment: Alignment.centerLeft,
                        width: (MediaQuery.of(context).size.width * 0.75),
                        height: 40,
                        child: TextFormField(
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(16)
                          ],
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
                        //MONTH
                        Container(
                          width: (MediaQuery.of(context).size.width * 0.11),
                          height: 40,
                          child: TextFormField(
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(2)
                            ],
                            keyboardType: TextInputType.number,
                            controller: _monthController,
                            focusNode: _month,
                            validator: (value) {
                              if (value!.isEmpty || int.parse(value) > 13) {
                                return 'enter correct value';
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
                        //year
                        Container(
                          width: (MediaQuery.of(context).size.width * 0.20),
                          height: 40,
                          child: TextFormField(
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(4)
                            ],
                            keyboardType: TextInputType.number,
                            controller: _yearController,
                            focusNode: _year,
                            validator: (value) {
                              if (value!.isEmpty) {
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
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(3)
                            ],
                            keyboardType: TextInputType.number,
                            controller: _ccvController,
                            focusNode: _ccv,
                            validator: (value) {
                              if (value!.isEmpty) {
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
                  GestureDetector(
                    onTap: _submit,
                    child: Image.asset(
                      'assets/navbar/save button.png',
                    ),
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
          top: MediaQuery.of(context).size.height * 0.04,
          left: MediaQuery.of(context).size.width * 0.02,
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
                    child: Consumer<Auth>(
                      builder: (_, auth, __) => Text(
                        '\$${(auth.balance).toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.137,
          left: MediaQuery.of(context).size.width * 0.02,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Container(
              padding: EdgeInsets.only(
                top: 5,
                left: 100,
                right: 100,
              ),
              alignment: Alignment.center,
              color: Color.fromRGBO(249, 247, 247, 1),
              width: MediaQuery.of(context).size.width * 0.96,
              height: MediaQuery.of(context).size.height * 0.120,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    // height: 100,
                    // width: 100,
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: GestureDetector(
                            onTap: _showWithdrawDialog,
                            child: Image.asset(
                              'assets/navbar/withdrawtbn.png',
                              height: 60,
                              width: 60,
                            ),
                          ),
                        ),
                        Text(
                          'Withdraw',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                        child: GestureDetector(
                          onTap: _showTopupDialog,
                          child: Image.asset(
                            'assets/navbar/topupbtn.png',
                            height: 60,
                            width: 60,
                          ),
                        ),
                      ),
                      Text(
                        'Top-up',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: MediaQuery.of(context).size.width * 0.04,
          bottom: 0,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(22.0),
              topRight: Radius.circular(22.0),
            ),
            child: Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width * 0.92,
              height: MediaQuery.of(context).size.height * 0.5,
              child: Column(
                children: [
                  Container(
                    height: 40,
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
                  ((initialPage == 0)
                      ? Payment
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Container(
                                // color: Colors.black,
                                child: Activity(),
                              ),
                            ),
                          ],
                        )),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
