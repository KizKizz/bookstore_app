import 'package:flutter/material.dart';

String _skillOne = "You have";
  String _skillTwo = "not Added";
  String _skillThree = "any skills yet";


class CustomerList extends StatefulWidget {
  CustomerList({ Key? key }) : super(key: key);
  
String _skillOne = "You have";
  String _skillTwo = "not Added";
  String _skillThree = "any skills yet";
  @override
  _CustomerListState createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  TextEditingController _skillOneController = TextEditingController();
  TextEditingController _skillTwoController = TextEditingController();

  TextEditingController _skillThreeController = TextEditingController();


  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(child: ListView(
          children: <Widget>[
            TextField(controller: _skillOneController,),
            TextField(controller: _skillTwoController,),
            TextField(controller: _skillThreeController,),
            Row(
              children: <Widget>[
                Expanded(child: RaisedButton(onPressed: () {
                  widget._skillThree = _skillThreeController.text;
                  widget._skillTwo = _skillTwoController.text;
                  widget._skillOne = _skillOneController.text;
                  Navigator.pop(context);
                }, child: Text("Save"),))
              ],
            )
          ],
        ), padding: EdgeInsets.symmetric(horizontal: 20.0),)
    );
  }
}