import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
// import 'package:jwt_decode/jwt_decode.dart';
import 'dart:convert';
import '../model/http_exception.dart';
import './models.dart';

class Auth with ChangeNotifier {
  final List<String> token = [];

  bool? isAuthenticated;
  List<String> message = [''];
  late dynamic balance;
  late String intervaldata;
  // late String errormessage;
  List<TransactionHistory> history = [];
  List<TransactionHistory> historybuy = [];
  List<TransactionHistory> historysell = [];
  List<TransactionHistory> historylatestdate = [];
  List<TransactionHistory> historyoldestdate = [];
  List<TransactionHistory> historybuylatestdate = [];
  List<TransactionHistory> historyselllatestdate = [];
  List<TransactionHistory> historyfiltered = [];

  List<UserDetail> user = [];
  // List<String> emailuser = [];

  List<dynamic> phonenumber = [];
  List<UserAsset> asset = [];

  // Map<String,dynamic,Color> assetdata = {"gold":""};

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
    final url = Uri.parse('https://be.tradehikers.xyz/user/signup');
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
      if (responseData == "User already exist!!") {
        throw HttpException(responseData);
      } else if (responseData['errors'] != null) {
        for (int i = 0; i < responseData["errors"].length; i++) {
          throw HttpException(responseData['errors'][i]['msg']);
        }
      }
      // message.insert(0, "Successful Signup");
      print("message:${responseData}");
      token.insert(0, responseData['token']);
      notifyListeners();

      // print(body);
    } catch (error) {
      throw error;
    }
  }

  void intervalpass(String interval) {
    intervaldata = interval;
    print("interval data: ${intervaldata}");
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    // token.clear();
    // final url = Uri.parse('https://be.tradehikers.xyz/user/login');
    final url = Uri.parse('https://be.tradehikers.xyz/user/login');
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
      if (responseData == 'Credentials Invalid') {
        throw HttpException(responseData);
      } else if (responseData == 'Credentials Incorrect') {
        throw HttpException(responseData);
      }

      // print(responseData);
      // message.insert(0, 'Successful login');
      token.insert(0, responseData['token']);
      print(token[0]);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> reset(String email, String password) async {
    message.clear();
    message.insert(0, '');

    final url = Uri.parse('https://be.tradehikers.xyz/resetPassword');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({"email": email, "password": password}),
      );
      final responseData = json.decode(response.body);
      if (responseData['errors'] != null) {
        for (int i = 0; i < responseData["errors"].length; i++) {
          throw HttpException(responseData['errors'][i]['msg']);
        }
      }
      message.insert(0, 'Update Successful');
      print(message);
      print(responseData);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> isAuth() async {
    final url = Uri.parse('https://be.tradehikers.xyz/user/verify');
    final response = await http.get(
      url,
      headers: {
        "token": token[0],
      },
    );
    isAuthenticated = json.decode(response.body);
    print(isAuthenticated);
    print(token);
    notifyListeners();
  }

  Future<void> istopup() async {
    message.clear();
    message.insert(0, '');
    final url = Uri.parse('https://be.tradehikers.xyz/topup');
    try {
      final response = await http.put(
        url,
        headers: {
          "token": token[0],
        },
      );

      message.insert(0, 'Topup Successful');
      print('TOPUP:${json.decode(response.body)}');
      // print(token);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> buy(double amount, String product) async {
    message.clear();
    message.insert(0, '');
    final url = Uri.parse('https://be.tradehikers.xyz/buy/${product}');

    var resBody = amount;
    var Body = json.encode({"buy_amount": resBody});
    try {
      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "token": token[0],
        },
        body: Body,
      );
      final responseData = json.decode(response.body);
      if (responseData == 'Invalid Amount to Purchase') {
        throw HttpException(responseData);
      } else if (responseData == 'Insufficient Balance') {
        throw HttpException(responseData);
      }
      message.insert(0, responseData);
      print(message);
      print('BUY:${json.decode(response.body)}');
      // print(amount);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> sell(double amount, String product) async {
    message.clear();
    message.insert(0, '');
    final url = Uri.parse('https://be.tradehikers.xyz/sell/${product}');
    var resBody = amount;
    var Body = json.encode({"sell_amount": resBody});
    try {
      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "token": token[0],
        },
        body: Body,
      );
      final responseData = json.decode(response.body);
      if (responseData == 'Not enough gold to sell') {
        throw HttpException(responseData);
      } else if (responseData == 'Not enough palladium to sell') {
        throw HttpException(responseData);
      } else if (responseData == 'Not enough platinum to sell') {
        throw HttpException(responseData);
      } else if (responseData == 'Not enough silver to sell') {
        throw HttpException(responseData);
      }
      message.insert(0, responseData);
      print(message);
      print('SELL:${json.decode(response.body)}');
      // print(amount);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> iswithdraw(double amount) async {
    message.clear();
    message.insert(0, '');
    final url = Uri.parse('https://be.tradehikers.xyz/withdraw');
    var resBody = amount;
    var Body = json.encode({"withdraw_amount": resBody});
    try {
      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "token": token[0],
        },
        body: Body,
      );
      final responseData = json.decode(response.body);
      if (responseData == 'Insufficient balance') {
        throw HttpException(responseData);
      }

      message.insert(0, 'Withdraw Successful');
      print('WITHDRAW:${json.decode(response.body)}');

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> getbalance() async {
    final url = Uri.parse('https://be.tradehikers.xyz/display/balance');

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "token": token[0],
      },
    );
    final responseData = json.decode(response.body);
    balance = responseData[0]['balance'];
    print('BALANCE:${responseData}');
    notifyListeners();
  }

  Future<void> getuser() async {
    // user.clear();
    // emailuser.clear();
    // phonenumber.clear();
    final url = Uri.parse('https://be.tradehikers.xyz/display/user');
    // var resBody = amount;
    // var Body = json.encode({"withdraw_amount": resBody});
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "token": token[0],
      },
    );
    final responseData = json.decode(response.body);
    // emailuser.insert(0, responseData[0]["user_email"]);
    for (int i = 0; i < responseData.length; i++) {
      if (responseData[i]["phone_number"] != null) {
        phonenumber.insert(0, responseData[i]["phone_number"]);
      } else if (responseData[i]["phone_number"] == null) {
        phonenumber.insert(0, "0");
      }
      user.insert(
        0,
        UserDetail(
          user_id: responseData[i]["user_id"],
          user_email: responseData[i]["user_email"],
          first_name: responseData[i]["first_name"],
          last_name: responseData[i]["last_name"],
          phone_number: phonenumber[i],
        ),
      );
      user.removeAt(1);
    }

    // print(responseData);
    print(user[0]);
    notifyListeners();
  }

  // List assetdata = [];
  List<dynamic> assettype = [];
  List assetamount = [];
  List<dynamic> assetcolor = [];
  List<AssetData> pieasset = [];

  Future<void> getasset() async {
    // asset.clear();
    // assetdata.clear();
    assetcolor.clear();
    assetamount.clear();

    pieasset.clear();
    // assetamount.insert(0, [0, 0, 0, 0]);

    final url = Uri.parse('https://be.tradehikers.xyz/display/asset');
    // var resBody = amount;
    // var Body = json.encode({"withdraw_amount": resBody});
    assettype.insertAll(0, ["Gold", "Platinum", "Silver", "Palladium"]);
    assetcolor.insertAll(0, [
      Color.fromRGBO(255, 197, 51, 1),
      Color.fromRGBO(2, 211, 204, 1),
      Color.fromRGBO(188, 149, 223, 1),
      Color.fromRGBO(242, 114, 111, 1)
    ]);

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "token": token[0],
      },
    );
    final responseData = json.decode(response.body);

    // print('gold amount: ${responseData[0]["gold_amount"]}');
    // print(responseData);

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
    assetamount.insertAll(0, [
      responseData[0]["gold_amount"],
      responseData[0]["platinum_amount"],
      responseData[0]["silver_amount"],
      responseData[0]["palladium_amount"],
    ]);

    for (int i = 0; i < assettype.length; i++) {
      pieasset.insert(0,
          AssetData(x: assettype[i], y: assetamount[i], color: assetcolor[i]));
    }

    print('PIE ASSET: ${pieasset.length}');
    print('ASSET AMOUNT: ${assetamount.length}');
    // print('PIE ASSET: ${pieasset[0].y}');
    // print('PIE ASSET: ${pieasset[1].y}');
    print('ASSET:${asset}');

    notifyListeners();
  }

  Future<void> gethistory(String filteroption, String sortoption) async {
    history.clear();
    historyfiltered.clear();
    final url = Uri.parse('https://be.tradehikers.xyz/display/transaction');
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "token": token[0],
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
    print(responseData[0]['timestamp'].runtimeType);
    notifyListeners();
  }

  Future<void> getpaymenthistory(String filteroption, String sortoption) async {
    phistory.clear();
    final url = Uri.parse('https://be.tradehikers.xyz/display/payment');

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "token": token[0],
      },
    );
    final responseData = json.decode(response.body);
    List<dynamic> timeConverted = [];

    for (int i = 0; i < responseData.length; i++) {
      timeConverted.add(DateTime.fromMillisecondsSinceEpoch(
          int.parse(responseData[i]['payment_timestamp']) * 1000));

      phistory.add(
        PaymentHistory(
            user_id: responseData[i]["user_id"],
            payment_type: responseData[i]["payment_type"],
            payment_amount: responseData[i]["payment_amount"],
            payment_status: responseData[i]["payment_status"],
            payment_timestamp: timeConverted[i],
            payment_id: responseData[i]["payment_id"].toString()),
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
    // print(responseData[0]['payment_timestamp'].runtimeType);
    notifyListeners();
  }

  Future<void> updatephone(num phonenum) async {
    message.clear();
    message.insert(0, '');
    // asset.clear();
    final url = Uri.parse('https://be.tradehikers.xyz/updateUser');
    // var resBody = amount;
    // var Body = json.encode({"withdraw_amount": resBody});

    final response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        "token": token[0],
      },
      body: json.encode({"phone_number": phonenum}),
    );
    print(phonenum);
    message.insert(0, "Update Successful");
    final responseData = json.decode(response.body);
    print(responseData);
    notifyListeners();
  }

  void logout() {
    token.clear();
    isAuthenticated = false;
  }
}
