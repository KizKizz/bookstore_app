import 'dart:convert';
import 'dart:io';

import 'author_data_handler.dart';
import 'book_data_handler.dart';
import 'customer_data_handler.dart';
import 'employee_data_handler.dart';
import 'order_data_handler.dart';
import 'sales_record_data_handler.dart';

Future<void> dataPreload() async {
  await readBookData(bookDataJson);
  await readAuthorData(authorDataJson);
  await readCustomerData(customerDataJson);
  await readEmployeeData(employeeDataJson);
  await readOrderData(orderDataJson);
  await readSalesData(salesRecordDataJson);
}

Future<void> readBookData(File file) async {
  String contents = await file.readAsString();
  if (contents.isNotEmpty) {
    var jsonResponse = jsonDecode(contents);
    convertBookData(jsonResponse);
  }
}

Future<void> readAuthorData(File file) async {
  String contents = await file.readAsString();
  if (contents.isNotEmpty) {
    var jsonResponse = jsonDecode(contents);
    convertauthorData(jsonResponse);
  } else {
    getAuthorsFromBook();
  }
}

Future<void> readCustomerData(File file) async {
  String contents = await file.readAsString();
  if (contents.isNotEmpty) {
    var jsonResponse = jsonDecode(contents);
    convertCustomerData(jsonResponse);
  }
}

Future<void> readEmployeeData(File file) async {
  String contents = await file.readAsString();
  if (contents.isNotEmpty) {
    var jsonResponse = jsonDecode(contents);
    convertEmployeeData(jsonResponse);
  }
}

Future<void> readOrderData(File file) async {
  String contents = await file.readAsString();
  if (contents.isNotEmpty) {
    var jsonResponse = jsonDecode(contents);
    convertOrderData(jsonResponse);
  }
}

Future<void> readSalesData(File file) async {
  String contents = await file.readAsString();
  if (contents.isNotEmpty) {
    var jsonResponse = jsonDecode(contents);
    convertSalesRecordData(jsonResponse);
  }
}
