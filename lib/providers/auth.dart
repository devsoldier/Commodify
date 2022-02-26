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

  bool? get isoyo {
    print(isAuthenticated);
    return isAuthenticated;
  }

  Future<void> signup(String name, String email, String password) async {
    final url = Uri.parse('http://192.168.100.130:5000/auth/signup');
    var resBody = {};
    resBody["name"] = name;
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
    final url = Uri.parse('http://192.168.100.130:5000/auth/login');
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
      print(_token);
      // _expiryDate = DateTime.now().add(
      //   Duration(
      //     seconds: int.parse(
      //       responseData['expiresIn'],
      //     ),
      //   ),
      // );
      notifyListeners();
      print(json.decode(response.body));
      print(body);
    } catch (error) {
      throw error;
    }
  }

  Future<void> isAuth() async {
    final url = Uri.parse('http://192.168.100.130:5000/auth/verify');
    final response = await http.get(
      url,
      headers: {
        "token": _token,
      },
    );
    isAuthenticated = json.decode(response.body);
    // print(isAuthenticated);
    notifyListeners();
  }
}
