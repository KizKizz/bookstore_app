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
      child: Column(
        children: [
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
          
          Expanded(
            child: ListView(
              controller: ScrollController(),
              padding: EdgeInsets.zero, 
              children: [ 
                const ExpansionTile(
                  title: Text(
                    'Books',
                    style: TextStyle(fontSize: 18),
                  ),
                  childrenPadding: EdgeInsets.all(10),
                  expandedAlignment: Alignment.centerLeft,
                  children: [
                    Text('Help info 1'),
                    Text('Help info 2'),
                    Text('Help info 3'),
                    Text('Help info 4'),
                  ],
                ),
                const ExpansionTile(
                  title: Text(
                    'Authors',
                    style: TextStyle(fontSize: 18),
                  ),
                  childrenPadding: EdgeInsets.all(10),
                  expandedAlignment: Alignment.centerLeft,
                  children: [
                    Text('Help info 1'),
                    Text('Help info 2'),
                    Text('Help info 3'),
                    Text('Help info 4'),
                  ],
                ),
                const ExpansionTile(
                  title: Text(
                    'Orders',
                    style: TextStyle(fontSize: 18),
                  ),
                  childrenPadding: EdgeInsets.all(10),
                  expandedAlignment: Alignment.centerLeft,
                  children: [
                    Text('Help info 1'),
                    Text('Help info 2'),
                    Text('Help info 3'),
                    Text('Help info 4'),
                  ],
                ),
                const ExpansionTile(
                  title: Text(
                    'Sales',
                    style: TextStyle(fontSize: 18),
                  ),
                  childrenPadding: EdgeInsets.all(10),
                  expandedAlignment: Alignment.centerLeft,
                  children: [
                    Text('Help info 1'),
                    Text('Help info 2'),
                    Text('Help info 3'),
                    Text('Help info 4'),
                  ],
                ),
                const ExpansionTile(
                  title: Text(
                    'Customers',
                    style: TextStyle(fontSize: 18),
                  ),
                  childrenPadding: EdgeInsets.all(10),
                  expandedAlignment: Alignment.centerLeft,
                  children: [
                    Text('Help info 1'),
                    Text('Help info 2'),
                    Text('Help info 3'),
                    Text('Help info 4'),
                  ],
                ),
                const ExpansionTile(
                  title: Text(
                    'Employees',
                    style: TextStyle(fontSize: 18),
                  ),
                  childrenPadding: EdgeInsets.all(10),
                  expandedAlignment: Alignment.centerLeft,
                  children: [
                    Text('Help info 1'),
                    Text('Help info 2'),
                    Text('Help info 3'),
                    Text('Help info 4'),
                  ],
                ),
                const ExpansionTile(
                  title: Text(
                    'Checkout',
                    style: TextStyle(fontSize: 18),
                  ),
                  childrenPadding: EdgeInsets.all(10),
                  expandedAlignment: Alignment.centerLeft,
                  children: [
                    Text('Help info 1'),
                    Text('Help info 2'),
                    Text('Help info 3'),
                    Text('Help info 4'),
                  ],
                ),
                const ExpansionTile(
                  title: Text(
                    'Others',
                    style: TextStyle(fontSize: 18),
                  ),
                  childrenPadding: EdgeInsets.all(10),
                  expandedAlignment: Alignment.centerLeft,
                  children: [
                    Text('Help info 1'),
                    Text('Help info 2'),
                    Text('Help info 3'),
                    Text('Help info 4'),
                  ],
                ),
                Container(
                  alignment: Alignment.bottomLeft,
                  padding: const EdgeInsets.only(left: 10),
                  child: TextButton(
                      onPressed: () {
                        _launchDLURLBrowser();
                      },
                      child: const Text('Get Windows App Version')),
                )
            ]),
          ),
        ],
      ),
    );
  }
}

_launchDLURLBrowser() async {
  const url = 'https://github.com/KizKizz/KizKizz.github.io/releases';
  if (!await launch(url)) throw 'Could not launch $url';
}
