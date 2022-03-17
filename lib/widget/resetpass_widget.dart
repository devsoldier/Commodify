import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

class ResetPassWidget extends StatefulWidget {
  @override
  _ResetPassWidgetState createState() => _ResetPassWidgetState();
}

class _ResetPassWidgetState extends State<ResetPassWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  FocusNode _emailfield = FocusNode();
  FocusNode _passwordfield = FocusNode();
  FocusNode _confirmpasswordfield = FocusNode();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController =
      TextEditingController();

  Map<String, String> _authData = {
    "email": "",
    "password": "",
  };

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    Provider.of<Auth>(context, listen: false).reset(
      _authData["email"]!,
      _authData["password"]!,
    );
  }

  @override
  void dispose() {
    _emailfield.dispose();
    _passwordfield.dispose();
    _confirmpasswordfield.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                key: _formKey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        SizedBox(height: 10),
                        Container(
                          child: Text('Reset Password',
                              style: TextStyle(
                                  fontSize: 35, fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(height: 10),
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
                                SizedBox(height: 5),
                                Container(
                                  width: (MediaQuery.of(context).size.width *
                                      0.75),
                                  height: 40,
                                  child: TextFormField(
                                    enabled: false,
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
                            )
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
                                SizedBox(height: 5),
                                Container(
                                  width: (MediaQuery.of(context).size.width *
                                      0.75),
                                  height: 40,
                                  child: TextFormField(
                                    obscureText: true,
                                    enabled: false,
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
                                SizedBox(height: 10),
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
                                SizedBox(height: 5),
                                Container(
                                  width: (MediaQuery.of(context).size.width *
                                      0.75),
                                  height: 40,
                                  child: TextFormField(
                                    enabled: false,
                                    obscureText: true,
                                    controller: _confirmpasswordController,
                                    focusNode: _confirmpasswordfield,
                                    validator: (value) {
                                      if (value!.isEmpty) return 'Empty';
                                      if (value != _passwordController.text)
                                        return 'Does Not Match';
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
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        GestureDetector(
                            onTap: _submit,
                            child:
                                Image.asset('assets/navbar/reset button.png')),
                        Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushReplacementNamed(
                                        LoginScreen.routeName);
                                  },
                                  child: Text(
                                    'Back to Login form',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Color.fromRGBO(
                                        0,
                                        178,
                                        255,
                                        1,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
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
