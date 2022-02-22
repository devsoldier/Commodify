import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../model/http_exception.dart';
// import 'dart:convert';

class SignUpWidget extends StatefulWidget {
  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  bool? _rememberMe = false;
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey();

  FocusNode _fullname = FocusNode();
  FocusNode _emailfield = FocusNode();
  FocusNode _passwordfield = FocusNode();
  FocusNode _confirmpasswordfield = FocusNode();

  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
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
        _authData["name"]!,
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
                          _fullname.hasPrimaryFocus ||
                          _confirmpasswordfield.hasPrimaryFocus)
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
          bottom: 370,
          right: 130,
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
          bottom: 340,
          left: 50,
          child: Container(
            child: Text(
              'Full Name',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 275,
          left: 50,
          child: Container(
            child: Text(
              'Email',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 210,
          left: 50,
          child: Container(
            child: Text(
              'Password',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 145,
          left: 50,
          child: Container(
            child: Text(
              'Confirm Password',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 60,
          left: 50,
          child: Row(
            children: <Widget>[
              Container(
                child: Checkbox(
                  value: _rememberMe,
                  onChanged: (value) {
                    setState(() {
                      _rememberMe = value;
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
        ),
        Positioned(
          bottom: 23,
          left: 50,
          child: Form(
            key: _formKey,
            child: Container(
              margin: EdgeInsets.only(right: 60),
              // padding: EdgeInsets.only(right: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  //FULL NAME
                  Container(
                    width: (MediaQuery.of(context).size.width * 0.75),
                    height: 35,
                    child: TextFormField(
                      focusNode: _fullname,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5.0),
                          ),
                        ),
                      ),
                      onSaved: (value) {
                        _authData["name"] = value.toString();
                        FocusScope.of(context).requestFocus(_emailfield);
                      },
                    ),
                  ),
                  //EMAIL
                  SizedBox(height: 30),
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
                  SizedBox(height: 30),
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
                  SizedBox(height: 30),
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
                  SizedBox(height: 38),
                  Row(
                    children: <Widget>[
                      if (_isLoading)
                        CircularProgressIndicator()
                      else
                        GestureDetector(
                          onTap: _submit,
                          child: Container(
                            child: Image.asset(
                              'assets/signup/Rectangle 6317.png',
                            ),
                          ),
                        ),
                    ],
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
