// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

class tableEdit with ChangeNotifier {
  bool _isEditMode = false;

  bool get isEditMode => _isEditMode;

  void editModeOn() {
    _isEditMode = true;
    notifyListeners();
  }

  void editModeOff() {
    _isEditMode = false;
    notifyListeners();
  }
}
