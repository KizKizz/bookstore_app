import 'package:bookstore_project/table_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_page.dart';
import 'main_page.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => tableAdderSwitch()),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.light);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  bool isLoggedin = false, isDarkMode = false;

  @override
  void initState() {
    super.initState();
    loginCheck();
    
  }

  //Loading counter value on start
  void loginCheck() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedin = (prefs.getBool('isLoggedin') ?? false);

      //darkmode check
      isDarkMode = (prefs.getBool('isDarkMode') ?? false);
      if (isDarkMode) {
        MyApp.themeNotifier.value = ThemeMode.dark;
      }
    });
  }

  Widget loginState() {
    Widget temp = const MainPage();
    if (!isLoggedin) {
      temp = const LoginPage();
    } else {
      temp = const MainPage();
    }
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: MyApp.themeNotifier,
        builder: (_, ThemeMode currentMode, __) {
          return MaterialApp(
            // Remove the debug banner
            debugShowCheckedModeBanner: false,
            title: 'BookStore',
            theme: ThemeData(
              primarySwatch: Colors.teal,
            ),
            darkTheme: ThemeData.dark(),
            themeMode: currentMode,
            home: loginState(),
          );
        });
  }
}
