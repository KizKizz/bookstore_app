// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

class checkoutNotif with ChangeNotifier {
  bool _isCheckout = false;
  bool _isPriceChanges = false;
  bool _isAppMaximized = false;

  bool get isCheckout => _isCheckout;
  bool get isPriceChanges => _isPriceChanges;
  bool get isAppMaximized => _isAppMaximized;

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

  void appMaximize() {
    _isAppMaximized = true;
    notifyListeners();
  }

  void appRestore() {
    _isAppMaximized = false;
    notifyListeners();
  }
}
