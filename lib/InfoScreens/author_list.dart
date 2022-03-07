import 'package:flutter/material.dart';

class AuthorList extends StatefulWidget {
  const AuthorList({ Key? key }) : super(key: key);

  @override
  _AuthorListState createState() => _AuthorListState();
}

class _AuthorListState extends State<AuthorList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
        child: RaisedButton(
          onPressed: _showDialog,
          child: const Text("Push Me"),
        ),
      ),
    );
  }

  _showDialog() async {
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
          return _SystemPadding(child: AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: Row(
          children: const <Widget>[
            Expanded(
              child: TextField(
                autofocus: true,
                decoration: InputDecoration(
                    labelText: 'Full Name', hintText: 'eg. John Smith'),
              ),
            )
          ],
        ),
        actions: <Widget>[
          FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              }),
          FlatButton(
              child: const Text('OPEN'),
              onPressed: () {
                Navigator.pop(context);
              })
        ],
      ),);
      });
  
  }
}
class _SystemPadding extends StatelessWidget {
  final Widget child;

  const _SystemPadding({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return AnimatedContainer(
        padding: mediaQuery.viewInsets,
        duration: const Duration(milliseconds: 300),
        child: child);
  }
}