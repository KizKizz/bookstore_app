// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

class tableAdderSwitch with ChangeNotifier {
  bool _isAddingMode = false;

  bool get isAddingMode => _isAddingMode;

  void addingModeOn() {
    _isAddingMode = true;
    notifyListeners();
  }

  void addingModeOff() {
    _isAddingMode = false;
    notifyListeners();
  }
}
