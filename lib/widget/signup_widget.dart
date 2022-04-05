import 'package:drc/screens/signup_screen.dart';
import 'package:drc/widget/navbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../model/http_exception.dart';
import '../screens/login_screen.dart';

class SignUpWidget extends StatefulWidget {
  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  bool? _tnc = false;
  bool _isLoading = false;
  // bool _keyboardVisible = false;
  // bool isOpen;
  final oneuppercase = RegExp("(?=(?:.*[A-Z]){1,})");
  final onelowercase = RegExp("(?=(?:.*[A-Z]){1,})");
  final onedigit = RegExp("(?=(?:.*\\d){1,})");
  final onespecialcharacter =
      RegExp("(?=(?:.*[!@#\$%^&*()\\-_=+{};:,<.>]){1,})");
  RegExp regex =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  final GlobalKey<FormState> _formKey = GlobalKey();

  FocusNode _fname = FocusNode();
  FocusNode _lname = FocusNode();
  FocusNode _emailfield = FocusNode();
  FocusNode _passwordfield = FocusNode();
  FocusNode _confirmpasswordfield = FocusNode();

  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _lnameController = TextEditingController();
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

  void _showsuccessDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Successful Signup!'),
        content:
            Consumer<Auth>(builder: (_, data, __) => Text(data.message[0])),
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
      var errorMessage = 'Signup failed';
      if (error.toString().contains('name')) {
        errorMessage = 'Please provide valid name.';
      } else if (error.toString().contains('email address')) {
        errorMessage = 'Please provide valid email address.';
      } else if (error.toString().contains('password')) {
        errorMessage = 'Please provide valid password.';
      } else if (error.toString().contains('already exist')) {
        errorMessage = 'User already exist.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage = 'Failed to Signup';
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
    // print(_authData);
  }

  Future<void> _verify() {
    return Provider.of<Auth>(context, listen: false).isAuth();
  }

  Future<void> runBoth() {
    return _submit().then((_) => _verify());
  }

  // String? validatePassword(String value) {
  //   RegExp regex =
  //       RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  //   if (value.isEmpty) {
  //     return 'Please enter password';
  //   }
  //   if (!regex.hasMatch(value)) {
  //     return 'Enter valid password';
  //   } else {
  //     return null;
  //   }
  // }

  String? get _errorTextpassword {
    final text = _passwordController.value.text;
    final oneuppercase = RegExp("(?=(?:.*[A-Z]){1,})");
    final onelowercase = RegExp("(?=(?:.*[A-Z]){1,})");
    final onedigit = RegExp("(?=(?:.*\\d){1,})");
    final onespecialcharacter =
        RegExp("(?=(?:.*[!@#\$%^&*()\\-_=+{};:,<.>]){1,})");
    if (!oneuppercase.hasMatch(text)) {
      return 'must contain 1 uppercase';
    }
    if (!onelowercase.hasMatch(text)) {
      return 'must contain 1 lowercase';
    }
    if (!onedigit.hasMatch(text)) {
      return 'must contain 1 number';
    }
    if (!onespecialcharacter.hasMatch(text)) {
      return 'must contain 1 special character';
    }
    /*    if (text.isEmpty || text.length < 8) {
      return 'add more characters';
    } */
    if (text.length == 1 && text.length < 8) {
      return 'add 7 more characters';
    }
    if (text.length == 2 && text.length < 8) {
      return 'add 6 more characters';
    }
    if (text.length == 3 && text.length < 8) {
      return 'add 5 more characters';
    }
    if (text.length == 4 && text.length < 8) {
      return 'add 4 more characters';
    }
    if (text.length == 5 && text.length < 8) {
      return 'add 3 more characters';
    }
    if (text.length == 6 && text.length < 8) {
      return 'add 2 more characters';
    }
    if (text.length == 7 && text.length < 8) {
      return 'add 1 more characters';
    } else {
      return null;
    }
  }

  String? get _errorTextConfirmpassword {
    final text = _confirmpasswordController.value.text;

    final oneuppercase = RegExp("(?=(?:.*[A-Z]){1,})");
    final onelowercase = RegExp("(?=(?:.*[A-Z]){1,})");
    final onedigit = RegExp("(?=(?:.*\\d){1,})");
    final onespecialcharacter =
        RegExp("(?=(?:.*[!@#\$%^&*()\\-_=+{};:,<.>]){1,})");
    if (text != _passwordController.text) {
      return 'password does not match';
    } else if (!oneuppercase.hasMatch(text)) {
      return 'must contain 1 uppercase';
    } else if (!onelowercase.hasMatch(text)) {
      return 'must contain 1 lowercase';
    } else if (!onedigit.hasMatch(text)) {
      return 'must contain 1 number';
    } else if (!onespecialcharacter.hasMatch(text)) {
      return 'must contain 1 special character';
    } else if (text.isEmpty || text.length < 8) {
      return 'add more characters';
    } else if (text.isEmpty || text.length < 8) {
      return 'add more characters';
    } else {
      return null;
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
    final data = Provider.of<Auth>(context);
    return Stack(
      children: <Widget>[
        Positioned(
          bottom: 0,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
            ),
            child: Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.height * 0.63,
              child: Form(
                key: _formKey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        SizedBox(height: 10),
                        Container(
                          child: Text('Sign Up',
                              style: TextStyle(
                                  fontSize: 35, fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(height: 10),
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
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
                                  width: (MediaQuery.of(context).size.width *
                                      0.350),
                                  height: 35,
                                  child: TextFormField(
                                    toolbarOptions: ToolbarOptions(
                                        copy: false,
                                        paste: false,
                                        cut: false,
                                        selectAll: true
                                        //by default all are disabled 'false'
                                        ),
                                    focusNode: _fname,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter first name!';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      // errorStyle:,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5.0),
                                        ),
                                      ),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        _authData["first_name"] =
                                            value.toString();
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.05),
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
                                  width: (MediaQuery.of(context).size.width *
                                      0.35),
                                  height: 35,
                                  child: TextFormField(
                                    toolbarOptions: ToolbarOptions(
                                        copy: false,
                                        paste: false,
                                        cut: false,
                                        selectAll: true
                                        //by default all are disabled 'false'
                                        ),
                                    focusNode: _lname,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter first name!';
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
                                      setState(() {
                                        _authData["last_name"] =
                                            value.toString();
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            //EMAIL
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Email',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  width: (MediaQuery.of(context).size.width *
                                      0.75),
                                  height: 35,
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
                                      } else if (!value.contains('.com')) {
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
                                    onChanged: (value) {
                                      setState(() {
                                        _authData["email"] = value.toString();
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            //PASSWORD
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Password',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  width: (MediaQuery.of(context).size.width *
                                      0.75),
                                  height: 35,
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
                                      if (!oneuppercase.hasMatch(value!) ||
                                          !onelowercase.hasMatch(value) ||
                                          !onedigit.hasMatch(value) ||
                                          !onespecialcharacter
                                              .hasMatch(value)) {
                                        return 'invalid password';
                                      }
                                      // if (!onelowercase.hasMatch(value)) {
                                      //   return 'must contain 1 lowercase';
                                      // }
                                      // if (!onedigit.hasMatch(value)) {
                                      //   return 'must contain 1 number';
                                      // }
                                      // if (!onespecialcharacter
                                      //     .hasMatch(value)) {
                                      //   return 'must contain 1 special character';
                                      // }
                                      if (value.isEmpty || value.length < 8) {
                                        return 'add more characters';
                                      } else {
                                        return null;
                                      }
                                    },
                                    decoration: InputDecoration(
                                      errorText:
                                          (_passwordfield.hasPrimaryFocus)
                                              ? _errorTextpassword
                                              : null,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5.0),
                                        ),
                                      ),
                                    ),
                                    onChanged: (value) {
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            //CONFIRM PASSWORD
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Confirm Password',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  width: (MediaQuery.of(context).size.width *
                                      0.75),
                                  height: 35,
                                  child: TextFormField(
                                    toolbarOptions: ToolbarOptions(
                                        copy: false,
                                        paste: false,
                                        cut: false,
                                        selectAll: true
                                        //by default all are disabled 'false'
                                        ),
                                    obscureText: true,
                                    controller: _confirmpasswordController,
                                    focusNode: _confirmpasswordfield,
                                    validator: (value) {
                                      if (value!.isEmpty ||
                                          value != _passwordController.text)
                                        return 'does not match';
                                      else if (!oneuppercase.hasMatch(value)) {
                                        return 'must contain 1 uppercase';
                                      } else if (!onelowercase
                                          .hasMatch(value)) {
                                        return 'must contain 1 lowercase';
                                      } else if (!onedigit.hasMatch(value)) {
                                        return 'must contain 1 number';
                                      } else if (!onespecialcharacter
                                          .hasMatch(value)) {
                                        return 'must contain 1 special character';
                                      } else if (value.isEmpty ||
                                          value.length < 8) {
                                        return 'add more characters';
                                      } else if (value.isEmpty ||
                                          value.length < 8) {
                                        return 'add more characters';
                                      } else {
                                        return null;
                                      }
                                    },
                                    decoration: InputDecoration(
                                      errorText: (_confirmpasswordfield
                                              .hasPrimaryFocus)
                                          ? _errorTextConfirmpassword
                                          : null,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5.0),
                                        ),
                                      ),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        _authData["password"] = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
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
                            SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.05),
                            if (_tnc == false)
                              Image.asset(
                                'assets/signup/signup btn grey.png',
                              )
                            else if (_tnc == true)
                              GestureDetector(
                                onTap: () async {
                                  await runBoth();
                                  (data.isAuthenticated == true)
                                      ? Navigator.of(context)
                                          .pushReplacementNamed(
                                              NavBar.routeName)
                                      : _showErrorDialog('not authenticated');
                                },
                                child: Container(
                                  child: Image.asset(
                                    'assets/signup/signup btn.png',
                                  ),
                                ),
                              ),
                          ],
                        ),
                        Center(
                          child: Container(
                            alignment: Alignment.bottomCenter,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    // Image.asset(
                                    //   'assets/signup/Already have an account_.png',
                                    // ),
                                    Text(
                                      'Already have an account?',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black38),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context)
                                            .pushReplacementNamed(
                                                LoginScreen.routeName);
                                      },
                                      child: Text(
                                        ' Login',
                                        style: TextStyle(
                                          color: Colors.blue[400],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 15),
                              ],
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
        )
      ],
    );
  }
}
