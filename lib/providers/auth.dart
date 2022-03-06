import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'dart:convert';
import '../model/http_exception.dart';

class Auth with ChangeNotifier {
  late String _token;
  // late DateTime _expiryDate;
  // late String _userId;
  bool? isAuthenticated;
  late double balance;

  // bool? get isoyo {
  //   print(isAuthenticated);
  //   return isAuthenticated;
  // }

  Future<void> signup(String name, String email, String password) async {
    final url = Uri.parse('http://157.245.57.54:5000/user/signup');
    var resBody = {};
    resBody["first_name"] = name;
    resBody["last_name"] = name;
    resBody["email"] = email;
    resBody["password"] = password;
    String body = json.encode(resBody);
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: (body),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['token'];
      notifyListeners();
      print(json.decode(response.body));
      print(body);
    } catch (error) {
      throw error;
    }
  }

  Future<void> login(String email, String password) async {
    final url = Uri.parse('http://157.245.57.54:5000/user/login');
    var resBody = {};
    resBody["email"] = email;
    resBody["password"] = password;
    String body = json.encode(resBody);
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: (body),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['token'];
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> isAuth() async {
    final url = Uri.parse('http://157.245.57.54:5000/user/verify');
    final response = await http.get(
      url,
      headers: {
        "token": _token,
      },
    );
    isAuthenticated = json.decode(response.body);
    print(isAuthenticated);
    print(_token);
    notifyListeners();
  }

  Future<void> istopup() async {
    final url = Uri.parse('http://157.245.57.54:5000/topup');
    final response = await http.put(
      url,
      headers: {
        "token": _token,
      },
    );
    print(json.decode(response.body));
    // print(_token);
    notifyListeners();
  }

  Future<void> buy(double amount) async {
    final url = Uri.parse('http://157.245.57.54:5000/buy/Xau');
    // var resBody = {};
    // resBody["amount"] = amount;
    var resBody = amount;
    var Body = json.encode({"amount": resBody});
    final response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        "token": _token,
      },
      body: Body,
    );
    print(json.decode(response.body));
    print(amount);
    notifyListeners();
  }

  Future<void> sell(double amount) async {
    final url = Uri.parse('http://157.245.57.54:5000/sell/Xau');
    var resBody = amount;
    var Body = json.encode({"amount": resBody});
    final response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        "token": _token,
      },
      body: Body,
    );
    print(json.decode(response.body));
    // print(_token);
    print(amount);
    notifyListeners();
  }

  Future<void> iswithdraw(double amount) async {
    final url = Uri.parse('http://157.245.57.54:5000/withdraw');
    var resBody = amount;
    var Body = json.encode({"withdraw_amount": resBody});
    final response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        "token": _token,
      },
      body: Body,
    );
    print(json.decode(response.body));
    // print(_token);
    print(amount);
    notifyListeners();
  }

  Future<void> getbalance() async {
    final url = Uri.parse('http://157.245.57.54:5000/display/balance');
    // var resBody = amount;
    // var Body = json.encode({"withdraw_amount": resBody});
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "token": _token,
      },
    );
    final responseData = json.decode(response.body);
    balance = responseData[0]['balance'];
    print(balance);
    print(response);
    notifyListeners();
  }
}
