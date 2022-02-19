import 'package:flutter/material.dart';

class SignUpWidget extends StatefulWidget {
  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget>
    with SingleTickerProviderStateMixin {
  bool? _rememberMe = false;

  FocusNode _emailfield = FocusNode();
  FocusNode _passwordfield = FocusNode();

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
                  height: (_emailfield.hasFocus || _passwordfield.hasFocus)
                      ? (MediaQuery.of(context).size.height * 0.15)
                      : (MediaQuery.of(context).size.height * 0.42)),
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
          bottom: 320,
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
          bottom: 280,
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
          bottom: 230,
          left: 50,
          child: Container(
            width: (MediaQuery.of(context).size.width * 0.75),
            height: 40,
            child: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
              ),
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_emailfield);
              },
            ),
          ),
        ),
        Positioned(
          bottom: 200,
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
          bottom: 150,
          left: 50,
          child: Container(
            width: (MediaQuery.of(context).size.width * 0.75),
            height: 40,
            child: TextFormField(
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
          bottom: 100,
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
