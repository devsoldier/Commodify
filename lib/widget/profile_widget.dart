import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../screens/login_screen.dart';
import '../model/http_exception.dart';

class ProfileWidget extends StatefulWidget {
  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  bool _isLoading = true;
  bool isEdited = false;
  bool currentTab = true;
  int initialPage = 0;
  late dynamic phonenum;
  // late String email;
  // late String password;
  Map<String, String> updateData = {"email": "", "password": ""};
  final GlobalKey<FormState> _phonekey = GlobalKey();
  final GlobalKey<FormState> _emailpasskey = GlobalKey();
  FocusNode _phone = FocusNode();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _getuser() {
    Provider.of<Auth>(context, listen: false).getuser();
  }

  Future<void> _updatephone() async {
    if (!_phonekey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _phonekey.currentState!.save();
    try {
      await Provider.of<Auth>(context, listen: false).updatephone(phonenum);
    } on HttpException catch (error) {
    } catch (error) {
      const errorMessage = 'Failed to update.';
      _showErrorDialog(errorMessage);
    }
  }

  void logout() {
    Provider.of<Auth>(context, listen: false).logout();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          ElevatedButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _updatepassword() async {
    if (_phonekey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _phonekey.currentState!.save();
    try {
      await Provider.of<Auth>(context, listen: false).reset(
        updateData["email"]!,
        updateData["password"]!,
      );
    } on HttpException catch (error) {
      var errorMessage = 'Failed to Update';
      if (error.toString().contains('valid password')) {
        errorMessage = 'Please provide a valid password.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage = 'Update Failed';
      _showErrorDialog(errorMessage);
    }
  }

  @override
  void initState() {
    _getuser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<Auth>(context);
    Widget loadpage = Center(child: CircularProgressIndicator());
    Widget personalpage = Form(
        key: _phonekey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Image.asset('assets/navbar/usersymbol.png'),
                    SizedBox(height: 40),
                    Image.asset('assets/navbar/phone.png'),
                  ],
                ),
                Column(
                  children: [
                    Consumer<Auth>(
                        builder: (_, datauser, __) => (datauser.user.isEmpty)
                            ? Container(width: 15, height: 15, child: loadpage)
                            : Container(
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: Row(
                                  // height: 35,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        datauser.user[0].user_id,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Color.fromRGBO(10, 38, 83, 1),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                    SizedBox(height: 40),
                    (data.user.isEmpty)
                        ? Container(width: 15, height: 15, child: loadpage)
                        : Container(
                            width: (MediaQuery.of(context).size.width * 0.6),
                            height: 35,
                            child: TextFormField(
                              enabled: isEdited,
                              focusNode: _phone,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Invalid phone number';
                                }
                                if (value.length < 7) {
                                  return 'Invalid phone number';
                                }
                              },
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                fillColor: Color.fromRGBO(229, 229, 229, 1),
                                filled: !isEdited,
                                labelText: (data.user[0].phone_number != 0 &&
                                        data.user.isEmpty)
                                    ? 'Press edit to add phone number'
                                    : '${data.user[0].phone_number}',
                                labelStyle: TextStyle(color: Colors.black),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5.0),
                                  ),
                                ),
                              ),
                              onChanged: (value) {
                                phonenum = int.parse(value);
                                isEdited = false;
                              },
                              controller: _phoneController,
                            ),
                          ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 40),
            (isEdited == false)
                ? Container(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isEdited = true;
                        });
                      },
                      child: Image.asset('assets/navbar/editbtn.png'),
                    ),
                  )
                : Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isEdited = false;
                            });
                          },
                          child: Image.asset('assets/navbar/cancelbtn.png'),
                        ),
                        GestureDetector(
                            onTap: () {
                              _updatephone();
                              _getuser();
                            },
                            child: Image.asset('assets/navbar/savebtn.png')),
                      ],
                    ),
                  ),
          ],
        ));

    return Stack(
      children: <Widget>[
        //BLUE SPACE
        Positioned(
          top: MediaQuery.of(context).size.height * 0.04,
          left: MediaQuery.of(context).size.width * 0.02,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Container(
              color: Color.fromRGBO(0, 178, 255, 0.6),
              width: MediaQuery.of(context).size.width * 0.96,
              height: MediaQuery.of(context).size.height * 0.1350,
              child:
                  //BLUESPACE CONTENT
                  Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(),
                  Container(
                      height: 75,
                      width: 75,
                      child: Image.asset('assets/navbar/Vector.png')),
                  (data.user.isEmpty)
                      ? CircularProgressIndicator()
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                // color: Colors.black,
                                alignment: Alignment.center,
                                height: 35,
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: Text(
                                    data.user[0].first_name,
                                    style: TextStyle(
                                        fontSize: 100, color: Colors.white),
                                  ),
                                )),
                            Container(
                              alignment: Alignment.center,
                              height: 35,
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: FittedBox(
                                fit: BoxFit.cover,
                                child: Text(
                                  data.user[0].last_name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 100,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                            SizedBox(),
                          ],
                        ),
                ],
              ),
            ),
          ),
        ),
        //WHITE SPACE
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
              height: MediaQuery.of(context).size.height * 0.60,
              child: Column(
                children: <Widget>[
                  Container(
                    height: 40,
                    // width: MediaQuery.of(context).size.width * 1,
                    child: ToggleSwitch(
                      minWidth: double.infinity,
                      cornerRadius: 22.0,
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
                          isEdited = false;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.015),
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
                    child: (initialPage == 0)
                        ? personalpage
                        : Form(
                            key: _phonekey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      children: [
                                        Image.asset(
                                            'assets/navbar/message.png'),
                                        SizedBox(height: 40),
                                        Image.asset('assets/navbar/Lock.png',
                                            width: 30, height: 30)
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        (isEdited == false)
                                            ? Container(
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    child: Text(data
                                                        .user[0].user_email),
                                                    color: Color.fromRGBO(
                                                        229, 229, 229, 1),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.6,
                                                    height: 35,
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                width: (MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.6),
                                                height: 35,
                                                child: TextFormField(
                                                  enabled: !isEdited,
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return 'Invalid email!';
                                                    }
                                                  },
                                                  decoration: InputDecoration(
                                                    fillColor: Color.fromRGBO(
                                                        229, 229, 229, 1),
                                                    filled: !isEdited,
                                                    labelText:
                                                        (data.user.isEmpty)
                                                            ? ''
                                                            : data.user[0]
                                                                .user_email,
                                                    labelStyle: TextStyle(
                                                        color: Colors.black),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(5.0),
                                                      ),
                                                    ),
                                                  ),
                                                  onSaved: (_) {
                                                    updateData["email"] =
                                                        data.user[0].user_email;

                                                    // isEdited = false;
                                                  },
                                                ),
                                              ),
                                        SizedBox(height: 40),
                                        (isEdited == false)
                                            ? Container(
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    child: Text('***********'),
                                                    color: Color.fromRGBO(
                                                        229, 229, 229, 1),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.6,
                                                    height: 35,
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                width: (MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.6),
                                                height: 35,
                                                child: TextFormField(
                                                  enabled: isEdited,
                                                  controller:
                                                      _passwordController,
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return 'Invalid password!';
                                                    }
                                                  },

                                                  decoration: InputDecoration(
                                                    fillColor: Color.fromRGBO(
                                                        229, 229, 229, 1),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(5.0),
                                                      ),
                                                    ),
                                                  ),
                                                  onSaved: (value) {
                                                    updateData["password"] =
                                                        value.toString();
                                                    // isEdited = false;
                                                    // _updatepassword(
                                                    //     data.emailuser, value);
                                                  },
                                                  // controller: _phoneController,
                                                ),
                                              ),
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(height: 40),
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
                                    : Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
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
                                            GestureDetector(
                                                onTap: () {
                                                  _updatepassword();
                                                  _getuser();
                                                },
                                                child: Image.asset(
                                                    'assets/navbar/savebtn.png')),
                                          ],
                                        ),
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
              GestureDetector(
                onTap: () {
                  logout();
                  Navigator.of(context)
                      .pushReplacementNamed(LoginScreen.routeName);
                },
                child: Container(
                  child: Image.asset('assets/navbar/logout.png'),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01)
            ],
          ),
        ),
      ],
    );
  }
}
