// ignore: avoid_web_libraries_in_flutter
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:bookstore_project/state_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Data/data_preloader.dart';
import 'Extra/app_window.dart';
import 'login_page.dart';
import 'main_page.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => checkoutNotif()),
  ], child: const MyApp()));

  doWhenWindowReady(() {
    const initialSize = Size(1300, 850);
    appWindow.minSize = const Size(852, 480);
    appWindow.size = initialSize;
    //appWindow.alignment = Alignment.center;
    appWindow.title = 'Antique Publications Bookstore';
    appWindow.show();
  });
  //Prevent brower right click on web
  //window.document.onContextMenu.listen((evt) => evt.preventDefault());
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
  bool isLoggedinManager = false,
      isLoggedinEmployee = false,
      isDarkMode = false;

  @override
  void initState() {
    super.initState();
    loginCheck();
    const DataPreloader();
  }

  //Loading counter value on start
  void loginCheck() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      //Save login state
      // isLoggedinManager = (prefs.getBool('isLoggedinManager') ?? false);
      // isLoggedinEmployee = (prefs.getBool('isLoggedinEmployee') ?? false);

      //darkmode check
      isDarkMode = (prefs.getBool('isDarkMode') ?? false);
      if (isDarkMode) {
        MyApp.themeNotifier.value = ThemeMode.dark;
      }
    });
  }

  Widget loginState() {
    Widget temp = const MainPage();
    if (!isLoggedinManager && !isLoggedinEmployee) {
      temp = const LoginPage();
    } else if (isLoggedinManager) {
      isManager = true;
      temp = const MainPage();
    } else if (isLoggedinEmployee) {
      isManager = false;
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
              home: Scaffold(
                  body: WindowBorder(
                      color: borderColor,
                      width: 1,
                      child: Column(children: [
                        WindowTitleBarBox(
                            child: Row(
                              children: [
                                Expanded(child: MoveWindow()),
                                WindowButtons()
                        ])),

                        Expanded(child: loginState())
                      
                      ]))));
        });
  }
}

