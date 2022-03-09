import 'package:flutter/material.dart';

import '../main_appbar.dart';


class EmployeeList extends StatefulWidget {
  const EmployeeList({ Key? key }) : super(key: key);

  @override
  _EmployeeListState createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //drawer: const MainDrawer(),
        appBar: MainAppbar(
            title: const Text('Employee Data'),
            appBar: AppBar(),
            widgets: <Widget>[]),
        body: Center(
            child: Column(children: const [
          Text('UNDER CONSTRUCTION',
              textAlign: TextAlign.center, style: TextStyle(fontSize: 100))
        ])));
  }
}
