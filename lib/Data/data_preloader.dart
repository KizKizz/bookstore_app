import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'author_data_handler.dart';
import 'book_data_handler.dart';
import 'customer_data_handler.dart';
import 'employee_data_handler.dart';
import 'order_data_handler.dart';
import 'sales_record_data_handler.dart';

// Future<void> dataPreload() async {
//   await readBookData(bookDataJson);
//   await readAuthorData(authorDataJson);
//   await readCustomerData(customerDataJson);
//   await readEmployeeData(employeeDataJson);
//   await readOrderData(orderDataJson);
//   await readSalesData(salesRecordDataJson);
// }

// Future<void> readBookData(File file) async {
//   String contents = await file.readAsString();
//   if (contents.isNotEmpty) {
//     var jsonResponse = jsonDecode(contents);
//     convertBookData(jsonResponse);
//   }
// }

// Future<void> readAuthorData(File file) async {
//   String contents = await file.readAsString();
//   if (contents.isNotEmpty) {
//     var jsonResponse = jsonDecode(contents);
//     convertauthorData(jsonResponse);
//   } else {
//     getAuthorsFromBook();
//   }
// }

// Future<void> readCustomerData(File file) async {
//   String contents = await file.readAsString();
//   if (contents.isNotEmpty) {
//     var jsonResponse = jsonDecode(contents);
//     convertCustomerData(jsonResponse);
//   }
// }

// Future<void> readEmployeeData(File file) async {
//   String contents = await file.readAsString();
//   if (contents.isNotEmpty) {
//     var jsonResponse = jsonDecode(contents);
//     convertEmployeeData(jsonResponse);
//   }
// }

// Future<void> readOrderData(File file) async {
//   String contents = await file.readAsString();
//   if (contents.isNotEmpty) {
//     var jsonResponse = jsonDecode(contents);
//     convertOrderData(jsonResponse);
//   }
// }

// Future<void> readSalesData(File file) async {
//   String contents = await file.readAsString();
//   if (contents.isNotEmpty) {
//     var jsonResponse = jsonDecode(contents);
//     convertSalesRecordData(jsonResponse);
//   }
// }

class DataPreloader extends StatefulWidget {
  const DataPreloader({Key? key}) : super(key: key);

  @override
  _DataPreloaderState createState() => _DataPreloaderState();
}

class _DataPreloaderState extends State<DataPreloader> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (Theme.of(context).brightness != Brightness.dark)
                Container(
                    padding: const EdgeInsets.only(top: 20),
                    width: 500,
                    height: 350,
                    child: Image.asset('assets/Logo/logo_light.png')),
              if (Theme.of(context).brightness == Brightness.dark)
                Container(
                    padding: const EdgeInsets.only(top: 20),
                    width: 500,
                    height: 350,
                    child: Image.asset('assets/Logo/logo_dark.png')),
              Container(
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                child: const Text(
                  'Getting Information',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                ),
              ),

              FutureBuilder(
                  future: DefaultAssetBundle.of(context)
                      .loadString('assets/jsondatabase/book_data.json'),
                  builder: (context, snapshot) {
                    if (snapshot.data.toString().isNotEmpty &&
                        snapshot.hasData &&
                        mainBookListCopy.isEmpty) {
                      var jsonResponse = jsonDecode(snapshot.data.toString());
                      convertBookData(jsonResponse);
                      //getAuthorsFromBook();
                      //debugPrint('test ${jsonResponse}');
                    }
                    //Build table
                    return SizedBox(
                      width: 400,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 100,
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: const Text(
                              'Books',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              child: LinearProgressIndicator(
                                backgroundColor: Colors.red,
                                color: Colors.lightBlueAccent,
                                minHeight: 30,
                                value: mainBookListCopy.length.toDouble(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              FutureBuilder(
            future: DefaultAssetBundle.of(context)
                .loadString('assets/jsondatabase/author_data.json'),
            builder: (context, snapshot) {
              if (snapshot.data.toString().isEmpty) {
                getAuthorsFromBook();
              } else if (snapshot.hasData &&
                  mainAuthorListCopy.isEmpty) {
                var jsonResponse = jsonDecode(snapshot.data.toString());
                convertauthorData(jsonResponse);
                //debugPrint('test ${jsonResponse}');
              }
              //Build table
              return SizedBox(
                width: 400,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: const Text(
                        'Authors',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.red,
                          color: Colors.lightBlueAccent,
                          minHeight: 30,
                          value: mainBookListCopy.length.toDouble(),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            
            ],
          ),
        ),
      ),
    );
  }
}
