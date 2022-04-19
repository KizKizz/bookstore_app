import 'dart:convert';

import 'package:bookstore_project/Data/customer_data_handler.dart';
import 'package:bookstore_project/Data/employee_data_handler.dart';
import 'package:bookstore_project/Data/order_data_handler.dart';
import 'package:bookstore_project/Data/sales_record_data_handler.dart';
import 'package:bookstore_project/main.dart';
import 'package:bookstore_project/main_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Data/author_data_handler.dart';
import 'Data/book_data_handler.dart';

bool isManager = false;
late List<bool> dataLoaded = List.generate(6, (index) => false);

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  late List<AnimationController> loadingAniController = [];

  @override
  void initState() {
    loadingAniController = List.generate(
      6,
      (index) => AnimationController(
        vsync: this,
        //duration: Duration(seconds: _loadingDuration),
      )..addListener(() {
          setState(() {});
        }),
    );
    super.initState();
  }

  @override
  void dispose() {
    for (var item in loadingAniController) {
      item.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //Logo Space
                      // const Text(
                      //   'Bookstore Management App',
                      //   textAlign: TextAlign.center,
                      //   style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                      // ),
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

                      //Login Stack
                      Stack(
                        children: [
                          //Manager login page
                          if (isManager)
                            Column(
                              children: [
                                Container(
                                  width: 500,
                                  constraints: const BoxConstraints(
                                      minWidth: 200, maxWidth: 400),
                                  padding: const EdgeInsets.only(
                                      top: 40, bottom: 10, left: 5, right: 5),
                                  child: Text('Manager login:',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Theme.of(context).hintColor)),
                                ),
                                Container(
                                  constraints: const BoxConstraints(
                                      minWidth: 200, maxWidth: 400),
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10, left: 15, right: 15),
                                  child: const TextField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Login ID',
                                      hintText: 'Enter your login ID',
                                    ),
                                  ),
                                ),
                                Container(
                                  constraints: const BoxConstraints(
                                      minWidth: 200, maxWidth: 400),
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10, left: 15, right: 15),
                                  child: const TextField(
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Password',
                                      hintText: 'Enter your password',
                                    ),
                                  ),
                                ),
                                Container(
                                    constraints: const BoxConstraints(
                                        minWidth: 200, maxWidth: 400),
                                    padding: const EdgeInsets.only(
                                        top: 10,
                                        bottom: 10,
                                        left: 15,
                                        right: 15),
                                    child: SizedBox(
                                      width: 250,
                                      height: 50,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              padding: const EdgeInsets.only(
                                                  bottom: 11)),
                                          onPressed: () async {
                                            final prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            prefs.setBool(
                                                'isLoggedinEmployee', false);
                                            prefs.setBool(
                                                'isLoggedinManager', true);
                                            Navigator.pushReplacement(
                                              context,
                                              PageRouteBuilder(
                                                pageBuilder: (context,
                                                        animation1,
                                                        animation2) =>
                                                    const MainPage(),
                                                transitionDuration:
                                                    Duration.zero,
                                                reverseTransitionDuration:
                                                    Duration.zero,
                                              ),
                                            );
                                          },
                                          child: const Text(
                                            'Login',
                                            style: TextStyle(fontSize: 30),
                                          )),
                                    )),
                                Container(
                                    constraints: const BoxConstraints(
                                        minWidth: 200, maxWidth: 400),
                                    padding: const EdgeInsets.only(
                                        top: 10,
                                        bottom: 10,
                                        left: 15,
                                        right: 15),
                                    child: TextButton(
                                        onPressed: () {
                                          isManager = false;
                                          setState(() {});
                                        },
                                        child: const Text(
                                            'Not a manager? Click here to return.',
                                            style: TextStyle(
                                              fontSize: 15,
                                            ))))
                              ],
                            ),

                          //Login Selection Screen
                          if (!isManager &&
                              dataLoaded.indexWhere((e) => e == false) == -1)
                            Column(
                              children: [
                                Container(
                                    width: 500,
                                    constraints: const BoxConstraints(
                                        minWidth: 200, maxWidth: 400),
                                    padding: const EdgeInsets.only(
                                        top: 40, bottom: 10, left: 5, right: 5),
                                    child: Text(
                                      'Login as:',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Theme.of(context).hintColor),
                                    )),
                                Container(
                                    constraints: const BoxConstraints(
                                        minWidth: 200, maxWidth: 400),
                                    padding: const EdgeInsets.only(
                                        top: 10,
                                        bottom: 10,
                                        left: 15,
                                        right: 15),
                                    child: SizedBox(
                                      width: 250,
                                      height: 50,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              padding: const EdgeInsets.only(
                                                  bottom: 11)),
                                          onPressed: () {
                                            isManager = true;
                                            setState(() {});
                                          },
                                          child: const Text(
                                            'Manager',
                                            style: TextStyle(fontSize: 30),
                                          )),
                                    )),
                                Container(
                                    constraints: const BoxConstraints(
                                        minWidth: 200, maxWidth: 400),
                                    padding: const EdgeInsets.only(
                                        top: 10,
                                        bottom: 10,
                                        left: 15,
                                        right: 15),
                                    child: SizedBox(
                                      width: 250,
                                      height: 50,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: const Color.fromRGBO(
                                                  72, 125, 238, 1),
                                              padding: const EdgeInsets.only(
                                                  bottom: 11)),
                                          onPressed: () async {
                                            final prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            prefs.setBool(
                                                'isLoggedinEmployee', true);
                                            prefs.setBool(
                                                'isLoggedinManager', false);
                                            Navigator.pushReplacement(
                                              context,
                                              PageRouteBuilder(
                                                pageBuilder: (context,
                                                        animation1,
                                                        animation2) =>
                                                    const MainPage(),
                                                // transitionDuration: Duration.zero,
                                                // reverseTransitionDuration:
                                                //     Duration.zero,
                                              ),
                                            );
                                          },
                                          child: const Text(
                                            'Employee',
                                            style: TextStyle(fontSize: 30),
                                          )),
                                    )),
                                //Spacer
                                //const SizedBox(height: 125)
                              ],
                            ),

                          if (!isManager &&
                              dataLoaded.indexWhere((e) => e == false) > -1)
                            Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(
                                      top: 20, bottom: 10),
                                  child: const Text(
                                    'Getting Information',
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                FutureBuilder(
                                    future: DefaultAssetBundle.of(context)
                                        .loadString(
                                            'assets/jsondatabase/book_data.json'),
                                    builder: (context, snapshot) {
                                      if (snapshot.data.toString().isNotEmpty &&
                                          snapshot.hasData &&
                                          mainBookListCopy.isEmpty) {
                                        var jsonResponse = jsonDecode(
                                            snapshot.data.toString());
                                        convertBookData(jsonResponse);
                                        loadingAniController[0].duration =
                                            Duration(
                                                seconds:
                                                    mainBookListCopy.length);
                                        loadingAniController[0].forward();
                                        dataLoaded[0] = true;
                                      }
                                      return SizedBox(
                                        width: 400,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 95,
                                              padding: const EdgeInsets.only(
                                                  top: 5, bottom: 5),
                                              child: const Text(
                                                'Books',
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.all(10),
                                                child: LinearProgressIndicator(
                                                  backgroundColor: Colors.red,
                                                  color: Colors.lightBlueAccent,
                                                  minHeight: 20,
                                                  value: loadingAniController[0]
                                                      .value,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                FutureBuilder(
                                    future: DefaultAssetBundle.of(context)
                                        .loadString(
                                            'assets/jsondatabase/author_data.json'),
                                    builder: (context, snapshot) {
                                      if (snapshot.data.toString().isEmpty) {
                                        getAuthorsFromBook();
                                      } else if (snapshot.hasData &&
                                          mainAuthorListCopy.isEmpty) {
                                        var jsonResponse = jsonDecode(
                                            snapshot.data.toString());
                                        convertauthorData(jsonResponse);
                                        loadingAniController[1].duration =
                                            Duration(
                                                seconds:
                                                    mainAuthorListCopy.length);
                                        loadingAniController[1].forward();
                                        dataLoaded[1] = true;
                                      }
                                      return SizedBox(
                                        width: 400,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 95,
                                              padding: const EdgeInsets.only(
                                                  top: 5, bottom: 5),
                                              child: const Text(
                                                'Authors',
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.all(10),
                                                child: LinearProgressIndicator(
                                                  backgroundColor: Colors.red,
                                                  color: Colors.lightBlueAccent,
                                                  minHeight: 20,
                                                  value: loadingAniController[1]
                                                      .value,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                FutureBuilder(
                                    future: DefaultAssetBundle.of(context)
                                        .loadString(
                                            'assets/jsondatabase/order_data.json'),
                                    builder: (context, snapshot) {
                                      if (snapshot.data.toString().isNotEmpty &&
                                          snapshot.hasData &&
                                          mainOrderListCopy.isEmpty) {
                                        var jsonResponse = jsonDecode(
                                            snapshot.data.toString());
                                        convertOrderData(jsonResponse);
                                        loadingAniController[2].duration =
                                            Duration(
                                                seconds:
                                                    mainOrderListCopy.length);
                                        loadingAniController[2].forward();
                                        dataLoaded[2] = true;
                                      }
                                      return SizedBox(
                                        width: 400,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 95,
                                              padding: const EdgeInsets.only(
                                                  top: 5, bottom: 5),
                                              child: const Text(
                                                'Orders',
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.all(10),
                                                child: LinearProgressIndicator(
                                                  backgroundColor: Colors.red,
                                                  color: Colors.lightBlueAccent,
                                                  minHeight: 20,
                                                  value: loadingAniController[2]
                                                      .value,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                FutureBuilder(
                                    future: DefaultAssetBundle.of(context)
                                        .loadString(
                                            'assets/jsondatabase/sales_record_data.json'),
                                    builder: (context, snapshot) {
                                      if (snapshot.data.toString().isNotEmpty &&
                                          snapshot.hasData &&
                                          mainSalesRecordListCopy.isEmpty) {
                                        var jsonResponse = jsonDecode(
                                            snapshot.data.toString());
                                        convertSalesRecordData(jsonResponse);
                                        loadingAniController[3].duration =
                                            Duration(
                                                seconds: mainSalesRecordListCopy
                                                    .length);
                                        loadingAniController[3].forward();
                                        dataLoaded[3] = true;
                                      }
                                      return SizedBox(
                                        width: 400,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 95,
                                              padding: const EdgeInsets.only(
                                                  top: 5, bottom: 5),
                                              child: const Text(
                                                'Sales',
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.all(10),
                                                child: LinearProgressIndicator(
                                                  backgroundColor: Colors.red,
                                                  color: Colors.lightBlueAccent,
                                                  minHeight: 20,
                                                  value: loadingAniController[3]
                                                      .value,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                FutureBuilder(
                                    future: DefaultAssetBundle.of(context)
                                        .loadString(
                                            'assets/jsondatabase/customer_data.json'),
                                    builder: (context, snapshot) {
                                      if (snapshot.data.toString().isNotEmpty &&
                                          snapshot.hasData &&
                                          mainCustomerListCopy.isEmpty) {
                                        var jsonResponse = jsonDecode(
                                            snapshot.data.toString());
                                        convertCustomerData(jsonResponse);
                                        loadingAniController[4].duration =
                                            Duration(
                                                seconds: mainCustomerListCopy
                                                    .length);
                                        loadingAniController[4].forward();
                                        dataLoaded[4] = true;
                                      }
                                      return SizedBox(
                                        width: 400,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 95,
                                              padding: const EdgeInsets.only(
                                                  top: 5, bottom: 5),
                                              child: const Text(
                                                'Customers',
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.all(10),
                                                child: LinearProgressIndicator(
                                                  backgroundColor: Colors.red,
                                                  color: Colors.lightBlueAccent,
                                                  minHeight: 20,
                                                  value: loadingAniController[4]
                                                      .value,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                FutureBuilder(
                                    future: DefaultAssetBundle.of(context)
                                        .loadString(
                                            'assets/jsondatabase/employee_data.json'),
                                    builder: (context, snapshot) {
                                      if (snapshot.data.toString().isNotEmpty &&
                                          snapshot.hasData &&
                                          mainEmployeeListCopy.isEmpty) {
                                        var jsonResponse = jsonDecode(
                                            snapshot.data.toString());
                                        convertEmployeeData(jsonResponse);
                                        loadingAniController[5].duration =
                                            Duration(
                                                seconds: mainEmployeeListCopy
                                                    .length);
                                        loadingAniController[5].forward();
                                        dataLoaded[5] = true;
                                      }
                                      return SizedBox(
                                        width: 400,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 95,
                                              padding: const EdgeInsets.only(
                                                  top: 5, bottom: 5),
                                              child: const Text(
                                                'Employees',
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.all(10),
                                                child: LinearProgressIndicator(
                                                  backgroundColor: Colors.red,
                                                  color: Colors.lightBlueAccent,
                                                  minHeight: 20,
                                                  value: loadingAniController[5]
                                                      .value,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                              ],
                            ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (MyApp.themeNotifier.value == ThemeMode.dark)
              FloatingActionButton.extended(
                //backgroundColor: Colors.deepOrange[800],
                icon: const Icon(Icons.light_mode),
                label: const Text(
                  'Light Theme',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                onPressed: (() async {
                  final prefs = await SharedPreferences.getInstance();
                  MyApp.themeNotifier.value = ThemeMode.light;
                  prefs.setBool('isDarkMode', false);
                  setState(() {});
                }),
              ),
            if (MyApp.themeNotifier.value == ThemeMode.light)
              FloatingActionButton.extended(
                //backgroundColor: Colors.deepOrange[800],
                icon: const Icon(Icons.dark_mode),
                label: const Text(
                  'Dark Theme',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                onPressed: (() async {
                  final prefs = await SharedPreferences.getInstance();
                  prefs.setBool('isDarkMode', true);
                  MyApp.themeNotifier.value = ThemeMode.dark;
                }),
              )
          ],
        ));
  }
}
