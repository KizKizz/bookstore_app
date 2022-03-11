import 'package:flutter/material.dart';

import '../main_appbar.dart';

class SaleRecordList extends StatefulWidget {
  const SaleRecordList({ Key? key }) : super(key: key);

  @override
  _SaleRecordListState createState() => _SaleRecordListState();
}

class _SaleRecordListState extends State<SaleRecordList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //drawer: const MainDrawer(),
        appBar: MainAppbar(
            title: const Text('Sales Records'),
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