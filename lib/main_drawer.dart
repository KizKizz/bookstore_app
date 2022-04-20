import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(padding: EdgeInsets.zero, children: [
        SizedBox(
          height: 65,
          child: DrawerHeader(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Help Menu',
                  style: TextStyle(fontSize: 25),
                ),
                IconButton(
                  onPressed: (() => Navigator.pop(context)),
                  icon: const Icon(Icons.clear),
                )
              ],
            ),
          ),
        ),
        Container(
          alignment: Alignment.bottomLeft,
          child: TextButton(
              onPressed: () {
                _launchDLURLBrowser();
              },
              child: const Text('Get Windows App Version')),
        )
      ]),
    );
  }
}

_launchDLURLBrowser() async {
  const url = 'https://github.com/KizKizz/KizKizz.github.io/releases';
  if (!await launch(url)) throw 'Could not launch $url';
}
