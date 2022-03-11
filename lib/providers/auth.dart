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
  List<TransactionHistory> historyfiltered = [];

  List<UserDetail> user = [];
  List<UserAsset> asset = [];

  List<PaymentHistory> phistory = [];
  List<PaymentHistory> phistorytopup = [];
  List<PaymentHistory> phistorywithdraw = [];
  List<PaymentHistory> phistorylatestdate = [];
  List<PaymentHistory> phistoryoldestdate = [];
  List<PaymentHistory> phistorytopuplatestdate = [];
  List<PaymentHistory> phistorywithdrawlatestdate = [];
  List<PaymentHistory> phistoryfiltered = [];

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

      // print(body);
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

  Future<void> buy(double amount, String product) async {
    final url = Uri.parse('http://157.245.57.54:5000/buy/${product}');

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

  Future<void> sell(double amount, String product) async {
    final url = Uri.parse('http://157.245.57.54:5000/sell/${product}');
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

    notifyListeners();
  }

  Future<void> getbalance() async {
    final url = Uri.parse('http://157.245.57.54:5000/display/balance');

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "token": _token,
      },
    );
    final responseData = json.decode(response.body);
    balance = responseData[0]['balance'];

    notifyListeners();
  }

  Future<void> gethistory(String filteroption, String sortoption) async {
    history.clear();
    historyfiltered.clear();
    final url = Uri.parse('http://157.245.57.54:5000/display/transaction');

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "token": _token,
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

    if (filteroption == 'all') {
      if (sortoption == 'sort old') {
        historyfiltered = history;
      } else {
        historyfiltered = historylatestdate;
      }
    }

    if (filteroption == 'buy') {
      if (sortoption == 'sort old') {
        historyfiltered = historybuy;
      } else {
        historyfiltered = historybuy.reversed.toList();
      }
    }

    if (filteroption == 'sell') {
      if (sortoption == 'sort old') {
        historyfiltered = historysell;
      } else {
        historyfiltered = historysell.reversed.toList();
      }
    }

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

    // print(responseData);

    // print(user);
    notifyListeners();
  }

  Future<void> getpaymenthistory(String filteroption, String sortoption) async {
    phistory.clear();
    final url = Uri.parse('http://157.245.57.54:5000/display/payment');

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "token": _token,
      },
    );
    final responseData = json.decode(response.body);
    List<dynamic> timeConverted = [];

    for (int i = 0; i < responseData.length; i++) {
      timeConverted.add(DateTime.fromMillisecondsSinceEpoch(
          responseData[i]['payment_timestamp'] * 1000));

      phistory.add(
        PaymentHistory(
            user_id: responseData[i]["user_id"],
            payment_type: responseData[i]["payment_type"],
            payment_amount: responseData[i]["payment_amount"],
            payment_status: responseData[i]["payment_status"],
            payment_timestamp: timeConverted[i],
            payment_id: responseData[i]["payment_id"]),
      );
      phistoryoldestdate = phistory;
      phistoryoldestdate
          .sort((a, b) => a.payment_timestamp.compareTo(b.payment_timestamp));
      phistorylatestdate = phistory.reversed.toList();
    }
    phistorytopup = phistory
        .where(
            (x) => x.payment_type.toLowerCase().contains("Topup".toLowerCase()))
        .toList();
    phistorywithdraw = phistory
        .where((x) =>
            x.payment_type.toLowerCase().contains("Withdraw".toLowerCase()))
        .toList();
    phistorytopuplatestdate = phistorylatestdate
        .where(
            (x) => x.payment_type.toLowerCase().contains("Topup".toLowerCase()))
        .toList();
    phistorywithdrawlatestdate = phistorylatestdate
        .where((x) =>
            x.payment_type.toLowerCase().contains("Withdraw".toLowerCase()))
        .toList();

    if (filteroption == 'all') {
      if (sortoption == 'sort old') {
        phistoryfiltered = phistory;
      } else {
        phistoryfiltered = phistorylatestdate;
      }
    }

    if (filteroption == 'topup') {
      if (sortoption == 'sort old') {
        phistoryfiltered = phistorytopup;
      } else {
        phistoryfiltered = phistorytopup.reversed.toList();
      }
    }

    if (filteroption == 'withdraw') {
      if (sortoption == 'sort old') {
        phistoryfiltered = phistorywithdraw;
      } else {
        phistoryfiltered = phistorywithdraw.reversed.toList();
      }
    }
    // print(phistoryfiltered);
    // print(phistory);
    notifyListeners();
  }

  Future<void> getasset() async {
    // asset.clear();
    final url = Uri.parse('http://157.245.57.54:5000/display/asset');
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
      asset.insert(
        0,
        UserAsset(
          user_id: responseData[i]["user_id"],
          gold_amount: responseData[i]["gold_amount"],
          platinum_amount: responseData[i]["platinum_amount"],
          silver_amount: responseData[i]["silver_amount"],
          palladium_amount: responseData[i]["palladium_amount"],
        ),
      );
    }
    print(asset);
    notifyListeners();
  }
}
