import 'package:flutter/material.dart';

class ForgetPasswordViewModel extends ChangeNotifier {
  String email = '';

  void updateEmail(String value) {
    email = value;
    notifyListeners();
  }
}
