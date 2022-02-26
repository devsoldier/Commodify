import 'package:flutter/cupertino.dart';

class TimeInterval with ChangeNotifier {
  late final String selectedInterval;

  void getinterval(String val) {
    selectedInterval = val;
    notifyListeners();
  }
}
