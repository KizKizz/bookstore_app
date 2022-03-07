import 'package:bookstore_project/screen_data_dialog.dart';
import 'package:flutter/material.dart';


class EmployeeList extends StatefulWidget {
  const EmployeeList({ Key? key }) : super(key: key);

  @override
  _EmployeeListState createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList> {

  @override
  Widget build(BuildContext context) {
    return Center(
        // child: RaisedButton(
        //   onPressed: 
        //   _showDialog(context),
        //   child: const Text("Push Me"),
        // ),
    );
  }
}

// _showDialog(BuildContext context)
// {

//   VoidCallback continueCallBack = ()=> {
//  Navigator.of(context).pop(),
//     // code on continue comes here

//   };
//   ScreenDataDialog  alert = ScreenDataDialog("Abort","Are you sure you want to abort this operation?",continueCallBack);


//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return alert;
//     },
//   );
// }