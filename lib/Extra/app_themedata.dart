import 'package:flutter/material.dart';

class AppThemedata extends StatefulWidget {
  const AppThemedata({Key? key}) : super(key: key);

  @override
  _AppThemedataState createState() => _AppThemedataState();
}

ThemeData _darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.amber,
  colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.red),
);

ThemeData _lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.pink));

bool _light = true;

class _AppThemedataState extends State<AppThemedata> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: _light ? _lightTheme : _darkTheme,
        title: 'Material App',
        darkTheme: _darkTheme);
  }
}
