import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../model/http_exception.dart';
// import 'dart:convert';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class SignUpWidget extends StatefulWidget {
  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  bool? _tnc = false;
  bool _isLoading = false;
  bool _keyboardVisible = false;
  // bool isOpen;
  final GlobalKey<FormState> _formKey = GlobalKey();

  FocusNode _fname = FocusNode();
  FocusNode _lname = FocusNode();
  FocusNode _emailfield = FocusNode();
  FocusNode _passwordfield = FocusNode();
  FocusNode _confirmpasswordfield = FocusNode();

  // final TextEditingController _fnameController = TextEditingController();
  // final TextEditingController _lnameController = TextEditingController();
  // final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController =
      TextEditingController();

  Map<String, String> _authData = {
    "name": "",
    "email": "",
    "password": "",
  };

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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Auth>(context, listen: false).signup(
        _authData["first_name"]!,
        _authData["last_name"]!,
        _authData["email"]!,
        _authData["password"]!,
      );
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
    // print(_authData);
  }

  // String? validatePassword(String value) {
  //   RegExp regex =
  //       RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  //   if (value.isEmpty) {
  //     return 'Please enter password';
  //   } else {
  //     if (!regex.hasMatch(value)) {
  //       return 'Enter valid password';
  //     } else {
  //       return null;
  //     }
  //   }
  // }

  detectKeyboard() {
    if (MediaQuery.of(context).viewInsets.bottom != 0) {
      setState(() {
        _keyboardVisible = true;
      });
    }
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
    return Stack(
      children: <Widget>[
        Positioned(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                  height: (_emailfield.hasPrimaryFocus ||
                          _passwordfield.hasPrimaryFocus ||
                          _fname.hasPrimaryFocus ||
                          _lname.hasPrimaryFocus ||
                          _confirmpasswordfield
                              .hasPrimaryFocus /* _keyboardVisible */)
                      ? (MediaQuery.of(context).size.height * 0.00)
                      : (MediaQuery.of(context).size.height * 0.37)),
              Expanded(
                child: Container(
                  height: 20,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.55,
          right: MediaQuery.of(context).size.width * 0.31,
          child: Container(
            child: Text(
              'Sign Up',
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.width * 0.07,
          left: MediaQuery.of(context).size.width * 0.14,
          child: Form(
            key: _formKey,
            child: Container(
              margin: EdgeInsets.only(right: 60),
              // padding: EdgeInsets.only(right: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //FULL NAME
                  Row(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: Text(
                              'First Name',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            width: (MediaQuery.of(context).size.width * 0.350),
                            height: 35,
                            child: TextFormField(
                              focusNode: _fname,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5.0),
                                  ),
                                ),
                              ),
                              onSaved: (value) {
                                _authData["first_name"] = value.toString();
                                FocusScope.of(context).requestFocus(_lname);
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: Text(
                              'Last Name',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            width: (MediaQuery.of(context).size.width * 0.35),
                            height: 35,
                            child: TextFormField(
                              focusNode: _lname,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5.0),
                                  ),
                                ),
                              ),
                              onSaved: (value) {
                                _authData["last_name"] = value.toString();
                                FocusScope.of(context)
                                    .requestFocus(_emailfield);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  //EMAIL
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    width: (MediaQuery.of(context).size.width * 0.75),
                    height: 35,
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      focusNode: _emailfield,
                      validator: (value) {
                        if (value!.isEmpty || !value.contains('@')) {
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
                        FocusScope.of(context).requestFocus(_passwordfield);
                      },
                    ),
                  ),

                  //PASSWORD
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    width: (MediaQuery.of(context).size.width * 0.75),
                    height: 35,
                    child: TextFormField(
                      obscureText: true,
                      controller: _passwordController,
                      focusNode: _passwordfield,
                      validator: /* ((value) =>
                              validatePassword(value.toString())), */
                          (value) {
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
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_confirmpasswordfield);
                      },
                    ),
                  ),

                  //CONFIRM PASSWORD
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  Text(
                    'Confirm Password',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    width: (MediaQuery.of(context).size.width * 0.75),
                    height: 35,
                    child: TextFormField(
                      obscureText: true,
                      controller: _confirmpasswordController,
                      focusNode: _confirmpasswordfield,
                      validator: (value) {
                        if (value!.isEmpty) return 'Empty';
                        if (value != _passwordController.text)
                          return 'Not Match';
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
                        _authData["password"] = value!;
                      },
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        child: Checkbox(
                          value: _tnc,
                          onChanged: (value) {
                            setState(() {
                              _tnc = value;
                            });
                          },
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: "I agree to the ",
                          style: TextStyle(color: Colors.black87),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'terms and conditions',
                                style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // SizedBox(height: MediaQuery.of(context).size.height * 0.047),
                  Row(
                    children: <Widget>[
                      SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                      if (_tnc == false)
                        Image.asset(
                          'assets/signup/signup btn grey.png',
                        )
                      else
                        GestureDetector(
                          onTap: _submit,
                          child: Container(
                            child: Image.asset(
                              'assets/signup/signup btn.png',
                            ),
                          ),
                        ),
                    ],
                  ),
                  // SizedBox(height: MediaQuery.of(context).size.height * 0.036),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
