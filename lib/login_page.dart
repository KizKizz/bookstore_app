import 'package:bookstore_project/main.dart';
import 'package:bookstore_project/main_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool isManager = false;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                                        top: 10, bottom: 10, left: 15, right: 15),
                                    child: SizedBox(
                                      width: 250,
                                      height: 50,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.only(bottom: 11)),
                                          onPressed: () async {
                                            final prefs =
                                                await SharedPreferences.getInstance();
                                            prefs.setBool('isLoggedinEmployee', false);
                                            prefs.setBool('isLoggedinManager', true);
                                            Navigator.pushReplacement(
                                              context,
                                              PageRouteBuilder(
                                                pageBuilder:
                                                    (context, animation1, animation2) =>
                                                        const MainPage(),
                                                transitionDuration: Duration.zero,
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
                                        top: 10, bottom: 10, left: 15, right: 15),
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
                          if (!isManager)
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
                                        top: 10, bottom: 10, left: 15, right: 15),
                                    child: SizedBox(
                                      width: 250,
                                      height: 50,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.only(bottom: 11)),
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
                                        top: 10, bottom: 10, left: 15, right: 15),
                                    child: SizedBox(
                                      width: 250,
                                      height: 50,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary:
                                                  const Color.fromRGBO(72, 125, 238, 1),
                                              padding:
                                                  const EdgeInsets.only(bottom: 11)),
                                          onPressed: () async {
                                            final prefs =
                                                await SharedPreferences.getInstance();
                                            prefs.setBool('isLoggedinEmployee', true);
                                            prefs.setBool('isLoggedinManager', false);
                                            Navigator.pushReplacement(
                                              context,
                                              PageRouteBuilder(
                                                pageBuilder:
                                                    (context, animation1, animation2) =>
                                                        const MainPage(),
                                                transitionDuration: Duration.zero,
                                                reverseTransitionDuration:
                                                    Duration.zero,
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
                            )
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
              label: const Text('Light Theme', style: TextStyle(fontWeight: FontWeight.w600),),
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
        )
      );
  }
}