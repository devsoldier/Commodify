import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'dart:convert';
import '../model/http_exception.dart';
import './models.dart';

class BusStop with ChangeNotifier {
  late String commodity;

  void storethis(String proxycommodity) {
    commodity = proxycommodity;
  }
}
