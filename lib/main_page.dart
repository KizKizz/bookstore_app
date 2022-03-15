import 'package:bookstore_project/InfoScreens/author_list.dart';
import 'package:bookstore_project/InfoScreens/customer_list.dart';
import 'package:bookstore_project/InfoScreens/order_list.dart';
import 'package:bookstore_project/InfoScreens/sale_record_list.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'main.dart';

//Screens
import 'login_page.dart';
import 'InfoScreens/book_list.dart';
import 'InfoScreens/employee_list.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  String appBarName = "Book Records";
  List<Widget> screen = [
    const BookList(),
    const AuthorList(),
    const OrderList(),
    const SaleRecordList(),
    CustomerList(),
    const EmployeeList()
  ];
  List<String> screenTitle = [
    "Book Records",
    "Author Records",
    "Order Records",
    'Sale Records',
    'Customer Records',
    'Employee Record'
  ];

  //AppBar + Navigation Rail
  @override
  Widget build(BuildContext context) {
    int darkModeOn = 0;
    if (MyApp.themeNotifier.value == ThemeMode.light) {
      darkModeOn = 0;
    } else {
      darkModeOn = 1;
    }
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
//Other buttons
                          leading: Column(
                            children: [
                              Container(
                                  padding: const EdgeInsets.only(bottom: 5),
                                child: Column(
                                  children: [
                                    isManager
                                    ? Column(
                                        children: [
                                          const Icon(Icons.account_box, size: 24),
                                          Text('Manager', 
                                            style: TextStyle(
                                              color: (Theme.of(context).toggleableActiveColor)
                                            ),)
                                        ],
                                      )
                                    : Column(
                                        children: [
                                          const Icon(Icons.account_circle,
                                              size: 24),
                                          Text('Employee',
                                          style: TextStyle(
                                            color: (Theme.of(context).toggleableActiveColor)))
                                        ],
                                      )
                                  ],
                                )
                              ),
                              SizedBox(
                                height: 2,
                                width: 60,
                                child: Container(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  color: Theme.of(context).hintColor)
                              ),

//Logout Button
                              MaterialButton(
                                onPressed: (() {
                                  _logoutDialog();
                                }),
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const <Widget>[
                                      Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: Icon(
                                          Icons.logout,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(2.0),
                                        child: Text(
                                          "Logout",
                                        ),
                                      )
                                    ]),
                              ),
//DarkMode Switch
                              Container(
                                padding: EdgeInsets.only(top: 20),
                                child: ToggleSwitch(
                                    minWidth: 35.0,
                                    minHeight: 28.0,
                                    initialLabelIndex: darkModeOn,
                                    cornerRadius: 90.0,
                                    borderColor: const [
                                      Color(0xff00aeff),
                                    ],
                                    borderWidth: 1.5,
                                    activeFgColor: Colors.white,
                                    inactiveBgColor:
                                        Color.fromARGB(255, 122, 122, 122),
                                    inactiveFgColor: Colors.white,
                                    totalSwitches: 2,
                                    icons: const [
                                      Icons.light_mode,
                                      Icons.dark_mode
                                    ],
                                    iconSize: 26.0,
                                    animate: true,
                                    curve: Curves.bounceInOut,
                                    onToggle: (darkModeOn) async {
                                      // obtain shared preferences
                                      final prefs =
                                          await SharedPreferences.getInstance();
                                      setState(() {
                                        if (MyApp.themeNotifier.value ==
                                            ThemeMode.light) {
                                          darkModeOn = 0;
                                          prefs.setBool('isDarkMode', true);
                                          MyApp.themeNotifier.value =
                                              ThemeMode.dark;
                                        } else {
                                          darkModeOn = 1;
                                          MyApp.themeNotifier.value =
                                              ThemeMode.light;
                                          prefs.setBool('isDarkMode', false);
                                        }
                                      });
                                    }),
                                //const Text('Dark Theme'),
                              ),
                            ],
                          ),

//Screens buttons
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

//Widgets on right of bar
  // Widget _editTableButton() {
  //   return MaterialButton(
  //     onPressed: () => [
  //       if (context.read<tableAdderSwitch>().isAddingMode == false)
  //         {context.read<tableAdderSwitch>().addingModeOn()}
  //       else
  //         {context.read<tableAdderSwitch>().addingModeOff()}
  //     ],
  //     child: Column(mainAxisSize: MainAxisSize.min, children: const <Widget>[
  //       Padding(
  //         padding: EdgeInsets.all(2.0),
  //         child: Icon(
  //           Icons.add_circle_outline_outlined,
  //         ),
  //       ),
  //       Padding(
  //         padding: EdgeInsets.all(2.0),
  //         child: Text(
  //           "Add",
  //           style: TextStyle(),
  //         ),
  //       )
  //     ]),
  //   );
  // }

  //Logout alert helpers
  _logoutDialog() async {
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return _SystemPadding(
            child: AlertDialog(
              contentPadding: const EdgeInsets.all(16.0),
              content: SizedBox(
                  width: 300,
                  height: 70,
                  child: Center(
                      child: Column(children: const <Widget>[
                    Text('Log out',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Padding(padding: EdgeInsets.only(bottom: 15)),
                    Text('You will be returned to the login screen.'),
                  ]))),
              actions: <Widget>[
                TextButton(
                    child: const Text('CANCEL'),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                TextButton(
                    child: const Text('CONFIRM'),
                    onPressed: (() async {
                      isManager = false;
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
                    }))
              ],
            ),
          );
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
