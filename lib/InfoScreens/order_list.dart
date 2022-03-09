import 'package:flutter/material.dart';

import '../main_appbar.dart';

class OrderList extends StatefulWidget {
  const OrderList({ Key? key }) : super(key: key);

  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //drawer: const MainDrawer(),
        appBar: MainAppbar(
            title: const Text('Order Data'),
            appBar: AppBar(),
            widgets: <Widget>[]),
        body: Center(
            child: Column(children: const [
          Text('UNDER CONSTRUCTION',
              textAlign: TextAlign.center, style: TextStyle(fontSize: 100))
        ])));
  }
}