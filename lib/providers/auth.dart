import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'dart:convert';
import '../model/http_exception.dart';
import './models.dart';

class Auth with ChangeNotifier {
  late String _token;
  bool? isAuthenticated;
  late dynamic balance;
  List<TransactionHistory> history = [];
  List<TransactionHistory> historybuy = [];
  List<TransactionHistory> historysell = [];
  List<TransactionHistory> historylatestdate = [];
  List<TransactionHistory> historyoldestdate = [];
  List<TransactionHistory> historybuylatestdate = [];
  List<TransactionHistory> historyselllatestdate = [];
  List<UserDetail> user = [];

  Future<void> signup(
      String fname, String lname, String email, String password) async {
    final url = Uri.parse('http://157.245.57.54:5000/user/signup');
    var resBody = {};
    resBody["first_name"] = fname;
    resBody["last_name"] = lname;
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
      print(responseData);
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
    // print(amount);
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
    // print(balance);
    // print(responseData);
    notifyListeners();
  }

  Future<void> gethistory() async {
    history.clear();
    final url = Uri.parse('http://157.245.57.54:5000/display/transaction');
    // var resBody = amount;
    // var Body = json.encode({"withdraw_amount": resBody});
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        // "token": _token,
        "token":
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjoiMmQzZGU1MzMtN2M1NS00Y2ZmLWE0ZGMtYWE2NTM2M2M1ZDQ0IiwiaWF0IjoxNjQ2NzA2MzQxLCJleHAiOjE2NDY3OTI3NDF9.aZMKdwcg7v-JJhaBcVpFAIvMAKxyNNebnCMiU-9O3Ko"
      },
    );
    final responseData = json.decode(response.body);
    List<dynamic> timeConverted = [];

    for (int i = 0; i < responseData.length; i++) {
      timeConverted.add(DateTime.fromMillisecondsSinceEpoch(
          responseData[i]['timestamp'] * 1000));

      history.add(
        TransactionHistory(
            user_id: responseData[i]["user_id"],
            epoch: timeConverted[i],
            tx_amount: responseData[i]["tx_amount"],
            tx_type: responseData[i]["tx_type"],
            tx_asset: responseData[i]["tx_asset"],
            tx_id: responseData[i]["tx_id"]),
      );
      historyoldestdate = history;
      historyoldestdate.sort((a, b) => a.epoch.compareTo(b.epoch));
      historylatestdate = history.reversed.toList();
    }

    historybuy = history
        .where((x) => x.tx_type.toLowerCase().contains("buy".toLowerCase()))
        .toList();
    historysell = history
        .where((x) => x.tx_type.toLowerCase().contains("sell".toLowerCase()))
        .toList();
    historybuylatestdate = historylatestdate
        .where((x) => x.tx_type.toLowerCase().contains("buy".toLowerCase()))
        .toList();
    historyselllatestdate = historylatestdate
        .where((x) => x.tx_type.toLowerCase().contains("sell".toLowerCase()))
        .toList();

    print('old to new: ${historyoldestdate}');
    print('---------------------------------------');
    print('new to old : ${historylatestdate}');
    print('---------------------------------------');
    // print('normal:${history[0]}');
    // print('buy: ${historybuy.length}');
    // print('sell: ${historysell.length}');
    // print('all: ${history.length}');
    // print('sortnew: ${historylatestdate.length}');
    // print('sortold:${historyoldestdate.length}');

    notifyListeners();
  }

  Future<void> getuser() async {
    final url = Uri.parse('http://157.245.57.54:5000/display/user');
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

    for (int i = 0; i < responseData.length; i++) {
      user.add(
        UserDetail(
          user_id: responseData[i]["user_id"],
          user_email: responseData[i]["user_email"],
          first_name: responseData[i]["first_name"],
          last_name: responseData[i]["last_name"],
        ),
      );
    }

    print(responseData);

    print(user);
    notifyListeners();
  }
}
