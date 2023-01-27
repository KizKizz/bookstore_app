import 'dart:convert';

import 'package:bookstore_app/Data/customer_data_handler.dart';
import 'package:bookstore_app/Data/data_storage_helper.dart';
import 'package:bookstore_app/Data/employee_data_handler.dart';
import 'package:bookstore_app/Data/order_data_handler.dart';
import 'package:bookstore_app/Data/sales_record_data_handler.dart';
import 'package:bookstore_app/main.dart';
import 'package:bookstore_app/main_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Data/author_data_handler.dart';
import 'Data/book_data_handler.dart';

bool isManager = false;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final String _managerID = 'admin';
  final String _managerPass = 'admin';
  final passFocus = FocusNode();

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
                            Form(
                              key: _formKey,
                              child: Column(
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
                                            color:
                                                Theme.of(context).hintColor)),
                                  ),
                                  Container(
                                    constraints: const BoxConstraints(
                                        minWidth: 200, maxWidth: 400),
                                    padding: const EdgeInsets.only(
                                        top: 10,
                                        bottom: 10,
                                        left: 15,
                                        right: 15),
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Login ID can\'t be empty';
                                        }
                                        if (value != _managerID) {
                                          return 'Login ID is incorrect';
                                        }
                                        return null;
                                      },
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (value) {FocusScope.of(context).requestFocus(passFocus);},
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(),
                                        labelText: 'Login ID',
                                        hintText:
                                            'Enter your login ID (hint: $_managerID)',
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
                                    child: TextFormField(
                                      focusNode: passFocus,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Password can\'t be empty';
                                        }
                                        if (value != _managerPass) {
                                          return 'Password is incorrect';
                                        }
                                        return null;
                                      },
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(),
                                        labelText: 'Password',
                                        hintText: 'Enter your password (hint: $_managerPass)',
                                      ),
                                      onFieldSubmitted: (value) async {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                final prefs =
                                                    await SharedPreferences
                                                        .getInstance();
                                                prefs.setBool(
                                                    'isLoggedinEmployee',
                                                    false);
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
                                              }
                                            },
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
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                final prefs =
                                                    await SharedPreferences
                                                        .getInstance();
                                                prefs.setBool(
                                                    'isLoggedinEmployee',
                                                    false);
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
                                              }
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
                            ),

                          //Login Selection Screen
                          if (!isManager && kIsWeb)
                            FutureBuilder(
                                future: DefaultAssetBundle.of(context)
                                    .loadString(
                                        'assets/jsondatabase/book_data.json'),
                                builder: (context, snapshot) {
                                  if (snapshot.data.toString().isNotEmpty &&
                                      snapshot.hasData &&
                                      mainBookListCopy.isEmpty) {
                                    var jsonResponse =
                                        jsonDecode(snapshot.data.toString());
                                    convertBookData(jsonResponse);
                                  }
                                  return FutureBuilder(
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
                                        }
                                        return FutureBuilder(
                                            future: DefaultAssetBundle.of(
                                                    context)
                                                .loadString(
                                                    'assets/jsondatabase/order_data.json'),
                                            builder: (context, snapshot) {
                                              if (snapshot.data
                                                      .toString()
                                                      .isNotEmpty &&
                                                  snapshot.hasData &&
                                                  mainOrderListCopy.isEmpty) {
                                                var jsonResponse = jsonDecode(
                                                    snapshot.data.toString());
                                                convertOrderData(jsonResponse);
                                              }
                                              return FutureBuilder(
                                                  future: DefaultAssetBundle.of(
                                                          context)
                                                      .loadString(
                                                          'assets/jsondatabase/sales_record_data.json'),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.data
                                                            .toString()
                                                            .isNotEmpty &&
                                                        snapshot.hasData &&
                                                        mainSalesRecordListCopy
                                                            .isEmpty) {
                                                      var jsonResponse =
                                                          jsonDecode(snapshot
                                                              .data
                                                              .toString());
                                                      convertSalesRecordData(
                                                          jsonResponse);
                                                    }
                                                    return FutureBuilder(
                                                        future: DefaultAssetBundle
                                                                .of(context)
                                                            .loadString(
                                                                'assets/jsondatabase/customer_data.json'),
                                                        builder: (context,
                                                            snapshot) {
                                                          if (snapshot.data
                                                                  .toString()
                                                                  .isNotEmpty &&
                                                              snapshot
                                                                  .hasData &&
                                                              mainCustomerListCopy
                                                                  .isEmpty) {
                                                            var jsonResponse =
                                                                jsonDecode(snapshot
                                                                    .data
                                                                    .toString());
                                                            convertCustomerData(
                                                                jsonResponse);
                                                          }
                                                          return FutureBuilder(
                                                              future: DefaultAssetBundle
                                                                      .of(
                                                                          context)
                                                                  .loadString(
                                                                      'assets/jsondatabase/employee_data.json'),
                                                              builder: (context,
                                                                  snapshot) {
                                                                if (snapshot
                                                                        .data
                                                                        .toString()
                                                                        .isNotEmpty &&
                                                                    snapshot
                                                                        .hasData &&
                                                                    mainEmployeeListCopy
                                                                        .isEmpty) {
                                                                  var jsonResponse =
                                                                      jsonDecode(snapshot
                                                                          .data
                                                                          .toString());
                                                                  convertEmployeeData(
                                                                      jsonResponse);
                                                                }
                                                                return Column(
                                                                  children: [
                                                                    Container(
                                                                        width:
                                                                            500,
                                                                        constraints: const BoxConstraints(
                                                                            minWidth:
                                                                                200,
                                                                            maxWidth:
                                                                                400),
                                                                        padding: const EdgeInsets.only(
                                                                            top:
                                                                                40,
                                                                            bottom:
                                                                                10,
                                                                            left:
                                                                                5,
                                                                            right:
                                                                                5),
                                                                        child:
                                                                            Text(
                                                                          'Login as:',
                                                                          style: TextStyle(
                                                                              fontSize: 15,
                                                                              color: Theme.of(context).hintColor),
                                                                        )),
                                                                    Container(
                                                                        constraints: const BoxConstraints(
                                                                            minWidth:
                                                                                200,
                                                                            maxWidth:
                                                                                400),
                                                                        padding: const EdgeInsets.only(
                                                                            top:
                                                                                10,
                                                                            bottom:
                                                                                10,
                                                                            left:
                                                                                15,
                                                                            right:
                                                                                15),
                                                                        child:
                                                                            SizedBox(
                                                                          width:
                                                                              250,
                                                                          height:
                                                                              50,
                                                                          child: ElevatedButton(
                                                                              style: ElevatedButton.styleFrom(padding: const EdgeInsets.only(bottom: 11)),
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
                                                                            minWidth:
                                                                                200,
                                                                            maxWidth:
                                                                                400),
                                                                        padding: const EdgeInsets.only(
                                                                            top:
                                                                                10,
                                                                            bottom:
                                                                                10,
                                                                            left:
                                                                                15,
                                                                            right:
                                                                                15),
                                                                        child:
                                                                            SizedBox(
                                                                          width:
                                                                              250,
                                                                          height:
                                                                              50,
                                                                          child: ElevatedButton(
                                                                              style: ElevatedButton.styleFrom(primary: const Color.fromRGBO(72, 125, 238, 1), padding: const EdgeInsets.only(bottom: 11)),
                                                                              onPressed: () async {
                                                                                final prefs = await SharedPreferences.getInstance();
                                                                                prefs.setBool('isLoggedinEmployee', true);
                                                                                prefs.setBool('isLoggedinManager', false);
                                                                                Navigator.pushReplacement(
                                                                                  context,
                                                                                  PageRouteBuilder(
                                                                                    pageBuilder: (context, animation1, animation2) => const MainPage(),
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
                                                                );
                                                              });
                                                        });
                                                  });
                                            });
                                      });
                                }),

                          if (!isManager && !kIsWeb)
                            FutureBuilder(
                                future: localDatabaseLoad(),
                                builder: (context, snapshot) {
                                  return Column(
                                    children: [
                                      Container(
                                          width: 500,
                                          constraints: const BoxConstraints(
                                              minWidth: 200, maxWidth: 400),
                                          padding: const EdgeInsets.only(
                                              top: 40,
                                              bottom: 10,
                                              left: 5,
                                              right: 5),
                                          child: Text(
                                            'Login as:',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Theme.of(context)
                                                    .hintColor),
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
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 11)),
                                                onPressed: () {
                                                  isManager = true;
                                                  setState(() {});
                                                },
                                                child: const Text(
                                                  'Manager',
                                                  style:
                                                      TextStyle(fontSize: 30),
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
                                                    primary:
                                                        const Color.fromRGBO(
                                                            72, 125, 238, 1),
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 11)),
                                                onPressed: () async {
                                                  final prefs =
                                                      await SharedPreferences
                                                          .getInstance();
                                                  prefs.setBool(
                                                      'isLoggedinEmployee',
                                                      true);
                                                  prefs.setBool(
                                                      'isLoggedinManager',
                                                      false);
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
                                                  style:
                                                      TextStyle(fontSize: 30),
                                                )),
                                          )),
                                      //Spacer
                                      //const SizedBox(height: 125)
                                    ],
                                  );
                                }),
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
