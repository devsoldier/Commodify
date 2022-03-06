// import 'package:drc/widget/navbar.dart';
import 'package:drc/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../model/http_exception.dart';
import '../widget/navbar.dart';

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
    setStateIfMounted(() {
      _isLoading = false;
    });
    // print(_authData);
  }

  Future<void> _verify() async {
    await Provider.of<Auth>(context, listen: false).isAuth();
  }

  Future<void> runBoth() async {
    _submit().then((_) => _verify());
  }

  Future<void> _getbal() async {
    await Provider.of<Auth>(context, listen: false).getbalance();
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
      children: <Widget>[
        Positioned(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                  height: (_emailfield.hasPrimaryFocus ||
                          _passwordfield.hasPrimaryFocus)
                      ? (MediaQuery.of(context).size.height * 0.00)
                      : (MediaQuery.of(context).size.height * 0.37)),
              Expanded(
                child: Container(
                  // height: 20,
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
          right: 167.5,
          child: Container(
            child: Text(
              'Login',
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 325,
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
          bottom: 250,
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
          bottom: 105,
          left: 50,
          child: Form(
            key: _loginKey,
            child: Column(
              children: <Widget>[
                //EMAIL
                Container(
                  width: (MediaQuery.of(context).size.width * 0.75),
                  height: 40,
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
                SizedBox(height: 33),
                Container(
                  width: (MediaQuery.of(context).size.width * 0.75),
                  height: 40,
                  child: TextFormField(
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
                SizedBox(height: 58),
                // if (_isLoading)
                //   CircularProgressIndicator()
                // else
                GestureDetector(
                  onTap: () async {
                    await runBoth().then((_) => (auth.isAuthenticated == true)
                        ? Navigator.of(context)
                            .pushReplacementNamed(NavBar.routeName)
                        : SignUpScreen());
                  },
                  // runBoth,
                  child: Container(
                    child: Image.asset(
                      'assets/signup/Rectangle 6317.png',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 160,
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
              Text('Remember Me'),
            ],
          ),
        ),
      ],
    );
  }
}
