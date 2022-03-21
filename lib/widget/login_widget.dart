import 'package:drc/screens/resetpass_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../model/http_exception.dart';
import '../widget/navbar.dart';
import 'dart:async';
import '../screens/signup_screen.dart';

class LoginWidget extends StatefulWidget {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  bool? _rememberMe = false;
  bool _isLoading = false;
  final GlobalKey<FormState> _loginKey = GlobalKey();

  FocusNode _emailfield = FocusNode();
  FocusNode _passwordfield = FocusNode();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Map<String, String> _authData = {
    "email": "",
    "password": "",
  };

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

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

  Future<void> _submit() async {
    if (!_loginKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _loginKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });
    try {
      // await Provider.of<Auth>(context, listen: false).isAuth();
      await Provider.of<Auth>(context, listen: false).login(
        _authData["email"]!,
        _authData["password"]!,
      );
    } on HttpException catch (error) {
      var errorMessage = 'Login Failed';
      if (error.toString().contains('Credentials Invalid')) {
        errorMessage = 'Credentials invalid.';
      } else if (error.toString().contains('Credentials Incorrect')) {
        errorMessage = 'Credentials incorrect.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage = 'Failed to login.';
      _showErrorDialog(errorMessage);
    }
    setStateIfMounted(() {
      _isLoading = false;
    });
  }

  Future<void> _verify() {
    return Provider.of<Auth>(context, listen: false).isAuth();
  }

  Future<void> _getasset() {
    return Provider.of<Auth>(context, listen: false).getasset();
  }

  Future<void> runBoth() {
    return _submit().then((_) => _verify());
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailfield.dispose();
    _passwordfield.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    return Stack(
      children: [
        Positioned(
          bottom: -20,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
            ),
            child: Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.height * 0.63,
              child: Form(
                key: _loginKey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(height: 10),
                        Container(
                          child: Text('Login',
                              style: TextStyle(
                                  fontSize: 35, fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(height: 30),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    'Email',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  width: (MediaQuery.of(context).size.width *
                                      0.75),
                                  height: 40,
                                  child: TextFormField(
                                    toolbarOptions: ToolbarOptions(
                                        copy: false,
                                        paste: false,
                                        cut: false,
                                        selectAll: true
                                        //by default all are disabled 'false'
                                        ),
                                    keyboardType: TextInputType.emailAddress,
                                    focusNode: _emailfield,
                                    validator: (value) {
                                      if (value!.isEmpty ||
                                          !value.contains('@')) {
                                        return 'Invalid email!';
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
                                    onSaved: (value) {
                                      _authData["email"] = value.toString();
                                      FocusScope.of(context)
                                          .requestFocus(_passwordfield);
                                    },
                                  ),
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    'Password',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  width: (MediaQuery.of(context).size.width *
                                      0.75),
                                  height: 40,
                                  child: TextFormField(
                                    toolbarOptions: ToolbarOptions(
                                        copy: false,
                                        paste: false,
                                        cut: false,
                                        selectAll: true
                                        //by default all are disabled 'false'
                                        ),
                                    obscureText: true,
                                    controller: _passwordController,
                                    focusNode: _passwordfield,
                                    validator: (value) {
                                      if (value!.isEmpty || value.length < 5) {
                                        return 'Password is too short!';
                                      }
                                    },
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5.0),
                                        ),
                                      ),
                                    ),
                                    onSaved: (value) {
                                      _authData["password"] = value!;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            // Container(
                            //   child: Checkbox(
                            //     value: _rememberMe,
                            //     onChanged: (value) {
                            //       setState(() {
                            //         _rememberMe = value;
                            //       });
                            //     },
                            //   ),
                            // ),
                            // Text('Remember Me'),
                            // SizedBox(
                            //     width:
                            //         MediaQuery.of(context).size.width * 0.08),

                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushReplacementNamed(
                                    ResetPassScreen.routeName);
                              },
                              child: Text(
                                'Forget Password?',
                                style: TextStyle(
                                  color: Color.fromRGBO(42, 123, 217, 1.0),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        GestureDetector(
                          onTap: () async {
                            await runBoth();
                            // await _getasset();
                            (auth.isAuthenticated == true)
                                ? Navigator.of(context)
                                    .pushReplacementNamed(NavBar.routeName)
                                : _showErrorDialog('not authenticated');
                          },
                          // runBoth,
                          child: Container(
                            child: Image.asset(
                              'assets/signup/login button.png',
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    )
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
