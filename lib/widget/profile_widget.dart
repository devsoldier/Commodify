import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

class ProfileWidget extends StatefulWidget {
  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  bool isEdited = false;
  bool currentTab = true;
  int initialPage = 0;
  final GlobalKey<FormState> _phonekey = GlobalKey();
  FocusNode _phone = FocusNode();
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        //BLUE SPACE
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
                  ),
                ],
              ),
            ),
          ),
        ),
        //WHITE SPACE
        Positioned(
          left: 14.5,
          bottom: -20,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22.0),
            child: Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width * 0.915,
              height: MediaQuery.of(context).size.height * 0.63,
              child: Column(
                children: <Widget>[
                  Container(
                    height: 40,
                    child: Expanded(
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
                        labels: ['Personal Info', 'Email & Password'],
                        // radiusStyle: true,
                        onToggle: (index) {
                          setState(() {
                            initialPage = index!;
                          });
                        },
                      ),
                    ),
                  ),
                  //WHITE SPACE CONTENT
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.4,
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
                    child: Form(
                      key: _phonekey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                // mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset('assets/navbar/usersymbol.png'),
                                  Image.asset('assets/navbar/phone.png'),
                                ],
                              ),
                              Column(
                                // mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  /*  Consumer<Auth>(builder:(_,datauser,__)=> */ Text(
                                      'user id here'),
                                  Container(
                                    width: (MediaQuery.of(context).size.width *
                                        0.350),
                                    height: 35,
                                    child: TextFormField(
                                      focusNode: _phone,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5.0),
                                          ),
                                        ),
                                      ),
                                      onSaved: (value) {
                                        // _authData["first_name"] = value.toString();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          (isEdited == false)
                              ? Container(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isEdited = true;
                                      });
                                    },
                                    child: Image.asset(
                                        'assets/navbar/editbtn.png'),
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isEdited = false;
                                        });
                                      },
                                      child: Image.asset(
                                          'assets/navbar/cancelbtn.png'),
                                    ),
                                    Image.asset('assets/navbar/savebtn.png'),
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

        Container(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                child: Image.asset('assets/navbar/logout.png'),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01)
            ],
          ),
        ),
      ],
    );
  }
}
