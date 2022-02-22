import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'dart:convert';

class Auth with ChangeNotifier {
  late String _token;
  late DateTime _expiryDate;
  late String _userId;

  Future<void> signup(String name, String email, String password) async {
    final url = Uri.parse('http://192.168.100.130:5000/auth/signup');
    var resBody = {};
    resBody["name"] = name;
    resBody["email"] = email;
    resBody["password"] = password;
    String body = json.encode(resBody);
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: (body),
    );
    print(json.decode(response.body));
    print(body);
  }

  Future<void> login(String email, String password) async {
    final url = Uri.parse('http://192.168.100.130:5000/auth/login');
    var resBody = {};
    resBody["email"] = email;
    resBody["password"] = password;
    String body = json.encode(resBody);
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: (body),
    );
    print(json.decode(response.body));
    print(body);
  }
}
