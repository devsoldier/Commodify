import 'package:drc/widget/activity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import './transaction_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../model/http_exception.dart';

class WalletWidget extends StatefulWidget {
  // const WalletWidget({ Key? key }) : super(key: key);

  @override
  _WalletWidgetState createState() => _WalletWidgetState();
}

class _WalletWidgetState extends State<WalletWidget> {
  RegExp regex = RegExp("(?=(?:.*[!@#\$%^&*()\\-_=+{};:,<>]))");
  bool currentTab = true;
  bool? online = false;
  bool? card = false;
  int initialPage = 0;
  late double withdrawamount;
  // List paymentMethod = [];
  final GlobalKey<FormState> _carddetail = GlobalKey();
  final GlobalKey<FormState> _withdrawamount = GlobalKey();
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

  Future<void> _topup() async {
    try {
      await Provider.of<Auth>(context, listen: false).istopup();
    } catch (error) {
      const errorMessage = 'Top-up failed';
      _showErrorDialog(errorMessage);
    }
  }

  Future<void> _withdraw() async {
    if (!_withdrawamount.currentState!.validate()) {
      // Invalid!
      return;
    }
    _withdrawamount.currentState!.save();

    try {
      // await Provider.of<Auth>(context, listen: false).isAuth();
      await Provider.of<Auth>(context, listen: false)
          .iswithdraw(withdrawamount);
    } on HttpException catch (error) {
      var errorMessage = 'Failed withdraw';
      if (error.toString().contains('Insufficient balance')) {
        errorMessage = 'Insufficient balance.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage = 'Withdraw failed.';
      _showErrorDialog(errorMessage);
    }
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
      builder: (ctx) => Form(
        key: _withdrawamount,
        child: AlertDialog(
          title: Text('WITHDRAWAL',
              style: TextStyle(
                color: Color.fromRGBO(18, 39, 70, 1),
                fontWeight: FontWeight.bold,
              )),
          content: Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 0.1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text('Amount',
                      style: TextStyle(
                        color: Color.fromRGBO(18, 39, 70, 1),
                        fontWeight: FontWeight.bold,
                      )),
                ),
                Container(
                  alignment: Alignment.center,
                  color: Color.fromRGBO(229, 229, 229, 1),
                  height: 40,
                  width: 250,
                  child: TextFormField(
                    validator: (value) {
                      if (regex.hasMatch(value!)) return 'numbers only';
                      if (value.isEmpty || int.parse(value) < 0)
                        return 'add value more than 0';
                    },
                    textAlign: TextAlign.center,
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
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        Navigator.pop(context);
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22.0),
                        border: Border.all(
                          color: Color.fromRGBO(7, 148, 220, 1),
                        ),
                      ),
                      height: 30,
                      width: 90,
                      child: Container(
                        alignment: Alignment.center,
                        child: Text('Cancel',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(25, 72, 134, 1))),
                      ),
                    ),
                  ),
                  // SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        withdrawbalance();
                        showsnackbar();
                        // Navigator.pop(context);
                      });
                    },
                    child: Container(
                      height: 30,
                      width: 90,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(22.0),
                        child: Container(
                          alignment: Alignment.center,
                          child: Text('Withdraw',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
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
            ),
          ],
        ),
      ),
    );
  }

  _showTopupDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('TOP-UP',
            style: TextStyle(
              color: Color.fromRGBO(18, 39, 70, 1),
              fontWeight: FontWeight.bold,
            )),
        content: Container(
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width * 0.1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                child: Text('Amount',
                    style: TextStyle(
                      color: Color.fromRGBO(18, 39, 70, 1),
                      fontWeight: FontWeight.bold,
                    )),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Container(child: Text('\$500'))],
              )
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
                      Navigator.pop(context);
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22.0),
                        border:
                            Border.all(color: Color.fromRGBO(7, 148, 220, 1))),
                    height: 30,
                    width: 90,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text('Cancel',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(25, 72, 134, 1))),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      topupbalance();
                      showsnackbar();
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
                        child: Text('Top-up',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
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
                              online = false;
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
                              card = false;
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
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Container(
                            alignment: Alignment.center,
                            child: Text('XXXXXX-XXXXXX-XXXXXX'),
                            color: Color.fromRGBO(229, 229, 229, 1),
                            width: MediaQuery.of(context).size.width * 0.6,
                            height: 35,
                          ),
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
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Container(
                              alignment: Alignment.center,
                              child: Text('4'),
                              color: Color.fromRGBO(229, 229, 229, 1),
                              width: MediaQuery.of(context).size.width * 0.6,
                              height: 35,
                            ),
                          ),
                        ),
                        //year
                        Container(
                          width: (MediaQuery.of(context).size.width * 0.20),
                          height: 40,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Container(
                              alignment: Alignment.center,
                              child: Text('2022'),
                              color: Color.fromRGBO(229, 229, 229, 1),
                              width: MediaQuery.of(context).size.width * 0.6,
                              height: 35,
                            ),
                          ),
                        ),
                        SizedBox(width: 55),
                        //CCV
                        Container(
                          width: (MediaQuery.of(context).size.width * 0.20),
                          height: 40,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Container(
                              alignment: Alignment.center,
                              child: Text('XXX'),
                              color: Color.fromRGBO(229, 229, 229, 1),
                              width: MediaQuery.of(context).size.width * 0.6,
                              height: 35,
                            ),
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
