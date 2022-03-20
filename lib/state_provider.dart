// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

class checkoutNotif with ChangeNotifier {
  bool _isCheckout = false;
  bool _isPriceChanges = false;

  bool get isCheckout => _isCheckout;
  bool get isPriceChanges => _isPriceChanges;

  void checkoutOn() {
    _isCheckout = true;
    notifyListeners();
  }

  void checkoutOff() {
    _isCheckout = false;
    notifyListeners();
  }

  void checkoutPriceChangesOn() {
    _isPriceChanges = true;
    notifyListeners();
  }

  void checkoutPriceChangesOff() {
    _isPriceChanges = false;
    notifyListeners();
  }
}
