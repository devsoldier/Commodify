import 'package:flutter/material.dart';

class SignUpWidget extends StatefulWidget {
  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  bool? _rememberMe = false;

  FocusNode _fullname = FocusNode();
  FocusNode _emailfield = FocusNode();
  FocusNode _passwordfield = FocusNode();
  FocusNode _confirmpasswordfield = FocusNode();

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
          bottom: 300,
          left: 50,
          child: Container(
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
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_emailfield);
              },
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
          bottom: 235,
          left: 50,
          child: Container(
            width: (MediaQuery.of(context).size.width * 0.75),
            height: 35,
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
          bottom: 170,
          left: 50,
          child: Container(
            width: (MediaQuery.of(context).size.width * 0.75),
            height: 35,
            child: TextFormField(
              focusNode: _passwordfield,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
              ),
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_confirmpasswordfield);
              },
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
          bottom: 105,
          left: 50,
          child: Container(
            width: (MediaQuery.of(context).size.width * 0.75),
            height: 35,
            child: TextFormField(
              focusNode: _confirmpasswordfield,
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
          bottom: 20,
          left: 80,
          child: Container(
            child: Image.asset(
              'assets/signup/Rectangle 6317.png',
            ),
          ),
        )
      ],
    );
  }
}
