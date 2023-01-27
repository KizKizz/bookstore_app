import 'dart:math';

import 'package:bookstore_app/Data/data_storage_helper.dart';

String idGenerator(String leadChar) {
  int _length = 7;
  const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rng = Random.secure();
  String newId = leadChar +
      List.generate(_length, (index) => _chars[_rng.nextInt(_chars.length)])
          .join();
  while (!idDupCheck(leadChar, newId)) {
    newId = leadChar +
        List.generate(_length, (index) => _chars[_rng.nextInt(_chars.length)])
            .join();
  }

  return newId;
}

bool idDupCheck(String leadChar, String newId) {
  if (leadChar == 'B') {
    final found = mainBookListCopy.indexWhere((element) => element.id == newId);
    if (found > -1) {
      return false;
    }
  } else if (leadChar == 'A') {
    final found = mainAuthorListCopy.indexWhere((element) => element.id == newId);
    if (found > -1) {
      return false;
    }
  } else if (leadChar == 'C') {
    final found = mainCustomerListCopy.indexWhere((element) => element.id == newId);
    if (found > -1) {
      return false;
    }
  } else if (leadChar == 'E') {
    final found = mainEmployeeListCopy.indexWhere((element) => element.id == newId);
    if (found > -1) {
      return false;
    }
  } else if (leadChar == 'O') {
    final found =
        mainOrderListCopy.indexWhere((element) => element.orderId == newId);
    if (found > -1) {
      return false;
    }
  }
  return true;
}
