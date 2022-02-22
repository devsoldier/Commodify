import 'package:drc/widget/navbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

class LoginWidget extends StatefulWidget {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  bool? _rememberMe = false;
  bool? _isLoading = false;
  final GlobalKey<FormState> _loginKey = GlobalKey();

  FocusNode _emailfield = FocusNode();
  FocusNode _passwordfield = FocusNode();

  Map<String, String> _authData = {
    "email": "",
    "password": "",
  };

  Future<void> _submit() async {
    if (!_loginKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _loginKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    await Provider.of<Auth>(context, listen: false).signup(
      _authData["name"]!,
      _authData["email"]!,
      _authData["password"]!,
    );
    setState(() {
      _isLoading = false;
    });
    // print(_authData);
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
        Form(
          key: _loginKey,
          child: Column(
            children: <Widget>[
              Positioned(
                bottom: 280,
                left: 50,
                child: Container(
                  width: (MediaQuery.of(context).size.width * 0.75),
                  height: 40,
                  child: TextFormField(
                    focusNode: _emailfield,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                      ),
                    ),
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_passwordfield);
                    },
                  ),
                ),
              ),
              Positioned(
                bottom: 205,
                left: 50,
                child: Container(
                  width: (MediaQuery.of(context).size.width * 0.75),
                  height: 40,
                  child: TextFormField(
                    focusNode: _passwordfield,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                      ),
                    ),
                    onFieldSubmitted: (_) {},
                  ),
                ),
              ),
            ],
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
        Positioned(
          bottom: 110,
          left: 80,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushReplacementNamed(NavBar.routeName);
            },
            child: Container(
              child: Image.asset(
                'assets/signup/Rectangle 6317.png',
              ),
            ),
          ),
        )
      ],
    );
  }
}
