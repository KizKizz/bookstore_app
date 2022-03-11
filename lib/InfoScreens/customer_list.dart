import 'package:flutter/material.dart';

import '../main_appbar.dart';

class CustomerList extends StatefulWidget {
  const CustomerList({Key? key}) : super(key: key);

  @override
  _CustomerListState createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //drawer: const MainDrawer(),
        appBar: MainAppbar(
            title: const Text('Customer Data'),
            appBar: AppBar(),
            flexSpace: Text('PlaceHolder'),
            widgets: <Widget>[]),
        body: Center(
            child: Column(children: const [
          Text('UNDER CONSTRUCTION',
              textAlign: TextAlign.center, style: TextStyle(fontSize: 100))
        ])));
  }
}
