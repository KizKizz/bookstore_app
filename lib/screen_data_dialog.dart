import 'dart:ui';

import 'package:flutter/material.dart';

class ScreenDataDialog extends StatelessWidget {
  String title;
  String content;
  VoidCallback continueCallBack;

  ScreenDataDialog(this.title, this.content, this.continueCallBack, {Key? key})
      : super(key: key);
  //TextStyle textStyle = TextStyle (color: Colors.black);

  @override
  Widget build(BuildContext context) {
    return _SystemPadding(
      child: AlertDialog(
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
      ),
    );
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
