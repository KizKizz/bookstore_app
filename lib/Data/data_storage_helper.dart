import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';

import 'author_data_handler.dart';
import 'book_data_handler.dart';
import 'customer_data_handler.dart';
import 'employee_data_handler.dart';
import 'order_data_handler.dart';
import 'sales_record_data_handler.dart';

//assets data
final File bookDataJson = File('assets/jsondatabase/book_data.json');
final File authorDataJson = File('assets/jsondatabase/author_data.json');
final File customerDataJson = File('assets/jsondatabase/customer_data.json');
final File employeeDataJson = File('assets/jsondatabase/employee_data.json');
final File orderDataJson = File('assets/jsondatabase/order_data.json');
final File salesRecordDataJson =
    File('assets/jsondatabase/sales_record_data.json');

//Local data
final String appDirPath = Directory.current.path;
final File localBookDatabase =
    File(appDirPath + '\\Database\\book_database.json');
final File localAuthorDatabase =
    File(appDirPath + '\\Database\\author_database.json');
final File localCustomerDatabase =
    File(appDirPath + '\\Database\\customer_database.json');
final File localEmployeeDatabase =
    File(appDirPath + '\\Database\\employee_database.json');
final File localOrderDatabase =
    File(appDirPath + '\\Database\\order_database.json');
final File localSalesRecordDatabase =
    File(appDirPath + '\\Database\\sales_record_database.json');

//Runtime Lists
List<Book> mainBookList = [], mainBookListCopy = [];
List<Author> mainAuthorList = [], mainAuthorListCopy = [];
List<Customer> mainCustomerList = [], mainCustomerListCopy = [];
List<Employee> mainEmployeeList = [], mainEmployeeListCopy = [];
List<Order> mainOrderList = [], mainOrderListCopy = [];
List<SalesRecord> mainSalesRecordList = [], mainSalesRecordListCopy = [];

Future<void> clearRuntimeLists() async {
  mainBookList.clear();
  mainBookListCopy.clear();
  mainAuthorList.clear();
  mainAuthorListCopy.clear();
  mainCustomerList.clear();
  mainCustomerListCopy.clear();
  mainEmployeeList.clear();
  mainEmployeeListCopy.clear();
  mainOrderList.clear();
  mainOrderListCopy.clear();
  mainSalesRecordList.clear();
  mainSalesRecordListCopy.clear();
}

bool localDatabaseCheck() {
  return localBookDatabase.existsSync() &&
      localAuthorDatabase.existsSync() &&
      localCustomerDatabase.existsSync() &&
      localEmployeeDatabase.existsSync() &&
      localOrderDatabase.existsSync() &&
      localSalesRecordDatabase.existsSync();
}

Future<void> localDatabaseCreate() async {
  await localBookDatabase.create(recursive: true);
  await localAuthorDatabase.create(recursive: true);
  await localCustomerDatabase.create(recursive: true);
  await localEmployeeDatabase.create(recursive: true);
  await localOrderDatabase.create(recursive: true);
  await localSalesRecordDatabase.create(recursive: true);

  if (localDatabaseCheck()) {assetsDataCopy();}
}

Future<void> assetsDataCopy() async {
  //copy data
  String dataResponse = '';
  if (dataResponse.isEmpty && localBookDatabase.lengthSync() == 0) {
    dataResponse = await rootBundle.loadString(bookDataJson.path);
    if (dataResponse.isNotEmpty) {
      await localBookDatabase.writeAsString(dataResponse);
      dataResponse = '';
    }
  }
  if (dataResponse.isEmpty && localAuthorDatabase.lengthSync() == 0) {
    dataResponse = await rootBundle.loadString(authorDataJson.path);
    if (dataResponse.isNotEmpty) {
      await localAuthorDatabase.writeAsString(dataResponse);
      dataResponse = '';
    }
  }
  if (dataResponse.isEmpty && localCustomerDatabase.lengthSync() == 0) {
    dataResponse = await rootBundle.loadString(customerDataJson.path);
    if (dataResponse.isNotEmpty) {
      await localCustomerDatabase.writeAsString(dataResponse);
      dataResponse = '';
    }
  }
  if (dataResponse.isEmpty && localEmployeeDatabase.lengthSync() == 0) {
    dataResponse = await rootBundle.loadString(employeeDataJson.path);
    if (dataResponse.isNotEmpty) {
      await localEmployeeDatabase.writeAsString(dataResponse);
      dataResponse = '';
    }
  }
  if (dataResponse.isEmpty && localOrderDatabase.lengthSync() == 0) {
    dataResponse = await rootBundle.loadString(orderDataJson.path);
    if (dataResponse.isNotEmpty) {
      await localOrderDatabase.writeAsString(dataResponse);
      dataResponse = '';
    }
  }
  if (dataResponse.isEmpty && localSalesRecordDatabase.lengthSync() == 0) {
    dataResponse = await rootBundle.loadString(salesRecordDataJson.path);
    if (dataResponse.isNotEmpty) {
      await localSalesRecordDatabase.writeAsString(dataResponse);
      dataResponse = '';
    }
  }
}

void localDatabaseUpdate(String databaseType) {
  if (databaseType == 'books') {
    mainBookListCopy.map((book) => book.toJson()).toList();
    localBookDatabase.writeAsStringSync(json.encode(mainBookListCopy));
  } else if (databaseType == 'authors') {
    mainAuthorListCopy.map((author) => author.toJson()).toList();
    localAuthorDatabase.writeAsStringSync(json.encode(mainAuthorListCopy));
  } else if (databaseType == 'customers') {
    mainCustomerListCopy.map((customer) => customer.toJson()).toList();
    localCustomerDatabase.writeAsStringSync(json.encode(mainCustomerListCopy));
  } else if (databaseType == 'employees') {
    mainEmployeeListCopy.map((employee) => employee.toJson()).toList();
    localEmployeeDatabase.writeAsStringSync(json.encode(mainEmployeeListCopy));
  } else if (databaseType == 'orders') {
    mainOrderListCopy.map((order) => order.toJson()).toList();
    localOrderDatabase.writeAsStringSync(json.encode(mainOrderListCopy));
  } else if (databaseType == 'salesRecords') {
    mainSalesRecordListCopy.map((sales) => sales.toJson()).toList();
    localSalesRecordDatabase
        .writeAsStringSync(json.encode(mainSalesRecordListCopy));
  }
}

Future<void> localDatabaseLoad() async {
  clearRuntimeLists();
  if (!localDatabaseCheck()) {
    await localDatabaseCreate();
  }

  if (localDatabaseCheck()) {
    if (mainBookListCopy.isEmpty && localBookDatabase.lengthSync() > 0) {
      convertBookData(jsonDecode(await localBookDatabase.readAsString()));
    }
    if (mainAuthorListCopy.isEmpty && localAuthorDatabase.lengthSync() > 0) {
      convertauthorData(jsonDecode(await localAuthorDatabase.readAsString()));
    } 
    if (mainCustomerListCopy.isEmpty &&
        localCustomerDatabase.lengthSync() > 0) {
      convertCustomerData(
          jsonDecode(await localCustomerDatabase.readAsString()));
    }
    if (mainEmployeeListCopy.isEmpty &&
        localEmployeeDatabase.lengthSync() > 0) {
      convertEmployeeData(
          jsonDecode(await localEmployeeDatabase.readAsString()));
    }
    if (mainOrderListCopy.isEmpty && localOrderDatabase.lengthSync() > 0) {
      convertOrderData(jsonDecode(await localOrderDatabase.readAsString()));
    }
    if (mainSalesRecordListCopy.isEmpty &&
        localSalesRecordDatabase.lengthSync() > 0) {
      convertSalesRecordData(
          jsonDecode(await localSalesRecordDatabase.readAsString()));
    }
  }
}
