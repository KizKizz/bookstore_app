import 'package:bookstore_project/Data/book_data_handler.dart';
import 'package:bookstore_project/InfoScreens/author_list.dart';
import 'package:bookstore_project/InfoScreens/customer_list.dart';
import 'package:bookstore_project/InfoScreens/order_list.dart';
import 'package:bookstore_project/InfoScreens/sale_record_list.dart';
import 'package:bookstore_project/table_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main_appbar.dart';
import 'main_drawer.dart';

//Screens
import 'login_page.dart';
import 'InfoScreens/book_list.dart';
import 'InfoScreens/employee_list.dart';


class MainPage extends StatefulWidget {
  const MainPage({ Key? key }) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  String appBarName = "Book Records";
  List<Widget> screen = [const BookList(), const AuthorList(), const OrderList(), const SaleRecordList(), CustomerList(), const EmployeeList()];
  List<String> screenTitle = ["Book Records", "Author Records", "Order Records", 'Sale Records', 'Customer Records', 'Employee Record'];
   
  //AppBar + Navigation Rail
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: MainAppbar(
      //   title: Text(appBarName),
      //   appBar: AppBar(),
      //   widgets: <Widget>[_editTableButton()],
      // ),
      //drawer: const MainDrawer(),
      body: Row(
        children: <Widget>[
          LayoutBuilder(
            builder: (context, constraint) {
              return SingleChildScrollView(
                  child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: constraint.maxHeight),
                      child: IntrinsicHeight(
                        child: NavigationRail(
                          selectedIndex: _selectedIndex,
                          onDestinationSelected: (int index) {
                            setState(() {
                              _selectedIndex = index;
                              appBarName = screenTitle[_selectedIndex];
                            });
                          },
//Logout Button
                          leading: MaterialButton(                            
                            onPressed: (() async {
                              final prefs = await SharedPreferences.getInstance();
                              // set value
                              prefs.setBool('isLoggedin', false);
                              Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation1, animation2) =>
                                      const LoginPage(),
                                  transitionDuration: Duration.zero,
                                  reverseTransitionDuration: Duration.zero,
                                ),
                              );
                            }), 
//Screens                          
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: Icon(Icons.logout,
                                  //color: Colors.white,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(2.0),
                                  child: Text("Logout",
                                    style: TextStyle(
                                      // color: Colors.yellow,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )]),
                            
                          ),

                          groupAlignment: 1.0,
                          labelType: NavigationRailLabelType.all,
                          destinations: const <NavigationRailDestination>[
                            NavigationRailDestination(
                              icon: Icon(Icons.menu_book_outlined),
                              selectedIcon: Icon(Icons.menu_book),
                              label: Text('Books'),
                            ),
                            NavigationRailDestination(
                              icon: Icon(Icons.library_books_outlined),
                              selectedIcon: Icon(Icons.library_books),
                              label: Text('Authors'),
                            ),
                            NavigationRailDestination(
                              icon: Icon(Icons.receipt_outlined),
                              selectedIcon: Icon(Icons.receipt),
                              label: Text('Orders'),
                            ),
                            NavigationRailDestination(
                              icon: Icon(Icons.receipt_long_outlined),
                              selectedIcon: Icon(Icons.receipt_long),
                              label: Text('Sales'),
                            ),
                            NavigationRailDestination(
                              icon: Icon(Icons.people_alt_outlined),
                              selectedIcon: Icon(Icons.people_alt),
                              label: Text('Customers'),
                            ),
                            NavigationRailDestination(
                              icon: Icon(Icons.emoji_people_outlined),
                              selectedIcon: Icon(Icons.emoji_people),
                              label: Text('Employees'),
                            ),
                          ],
                        ),
                      )));
            },
          ),
          const VerticalDivider(thickness: 1, width: 1),
          //This is the main content.
          Expanded(
            child: screen[_selectedIndex],
          ),
        ],
      ),
    );
  }

  Widget _editTableButton() {
    return MaterialButton(                            
      onPressed: () => [ 
        if (context.read<tableAdderSwitch>().isAddingMode == false) {
          context.read<tableAdderSwitch>().addingModeOn()
        }
        else {
          context.read<tableAdderSwitch>().addingModeOff()
        }
      ],                           
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const <Widget>[
          Padding(
            padding: EdgeInsets.all(2.0),
            child: Icon(Icons.add_circle_outline_outlined,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(2.0),
            child: Text("Add",
              style: TextStyle(
              ),
            ),
          )]),
    );
  }
}