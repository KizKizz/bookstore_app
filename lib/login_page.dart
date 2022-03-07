import 'package:bookstore_project/main_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
      body: Center(child: SingleChildScrollView(
        child: Column(
          //mainAxisSize: MainAxisSize.min, 
          children: <Widget>[
//Logo
            Container(
              padding: const EdgeInsets.only(top: 60, bottom: 20),
              child: const Center(
                child: Text(
                  "Bookstore Management App",
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    //color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
//Login ID Input
            Container(
              constraints: const BoxConstraints(minWidth: 300, maxWidth: 500),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: const TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Login ID',
                  hintText: 'Enter your ID to login',
                ),
              ),
            ),
//Pass Input
            Container(
              constraints: const BoxConstraints(minWidth: 300, maxWidth: 500),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: const TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  hintText: 'Enter your password',
                ),
              ),
            ),
//Forgot Pass
            TextButton(
                onPressed: () async {
                  //Forgot pass function
                  final prefs = await SharedPreferences.getInstance();
                  // set value
                  prefs.setBool('isLoggedin', false);
                },
                child: const Text(
                  'Forgot Password',
                  style: TextStyle(
                    //color: Colors.blue,
                    fontSize: 15,
                  ),
                )),
//Login Button
            const SizedBox(height: 20),
            SizedBox(
                width: 250,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    //TO DO
                    // obtain shared preferences
                    final prefs = await SharedPreferences.getInstance();
                    // set value
                    prefs.setBool('isLoggedin', true);
                    //Move to next screen
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            const MainPage(),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    );
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      //color: Colors.white,
                      fontSize: 30,
                    ),
                  ),
                )),
//New user
            const SizedBox(height: 130),
            TextButton(
                onPressed: () {
                  //TO DO
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          const LoginPage(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                },
                child: const Text(
                  'New user? Click To Register',
                  style: TextStyle(
                    //color: Colors.black,
                    fontSize: 13,
                  ),
                ))
          ],
        ),
      ),
    ));
  }
}
