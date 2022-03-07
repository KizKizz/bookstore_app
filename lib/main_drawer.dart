import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  @override
  Widget build(BuildContext context) {
    bool darkModeOn = false;
    if (MyApp.themeNotifier.value == ThemeMode.light) {
      darkModeOn = false;
    } else {
      darkModeOn = true;
    }

    return Drawer(
      child: ListView(padding: EdgeInsets.zero, children: [
        const SizedBox(
          height: 65,
          child: DrawerHeader(
            child: Text(
              'Settings',
              style: TextStyle(fontSize: 25),
            ),
          ),
        ),
        
        Row(
          children: [
            const Padding(padding: EdgeInsets.only(left: 15)),
            const Text('Dark Theme'),            
            Column(
              children: [
                const Padding(padding: EdgeInsets.only(bottom: 5)),
                Switch(
                  value: darkModeOn,
                  onChanged: (value) async {
                    // obtain shared preferences
                    final prefs = await SharedPreferences.getInstance();
                    setState(() {
                      if (MyApp.themeNotifier.value == ThemeMode.light) {
                        darkModeOn = true;
                        prefs.setBool('isDarkMode', true);
                        MyApp.themeNotifier.value = ThemeMode.dark;
                      } else {
                        darkModeOn = false;
                        MyApp.themeNotifier.value = ThemeMode.light;
                        prefs.setBool('isDarkMode', false);
                      }   
                    });
                  }),
              ],
            ),
          ],
        ),

        // IconButton(
        //   //color: Colors.transparent,
        //   icon: Icon(MyApp.themeNotifier.value == ThemeMode.light
        //       ? Icons.dark_mode
        //       : Icons.light_mode),
        //   onPressed: () {
        //     MyApp.themeNotifier.value =
        //         MyApp.themeNotifier.value == ThemeMode.light
        //             ? ThemeMode.dark
        //             : ThemeMode.light;
        //   }
        // ),

        ListTile(
          title: const Text('Item 1'),
          onTap: () {
            MyApp.themeNotifier.value =
                MyApp.themeNotifier.value == ThemeMode.light
                    ? ThemeMode.dark
                    : ThemeMode.light;
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: const Text('Item 2'),
          onTap: () {
            // Update the state of the app
            // ...
            // Then close the drawer
            Navigator.pop(context);
          },
        ),
      ]),
    );
  }
}
