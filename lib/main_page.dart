import 'package:bookstore_project/InfoScreens/author_list.dart';
import 'package:bookstore_project/InfoScreens/checkout_page.dart';
import 'package:bookstore_project/InfoScreens/customer_list.dart';
import 'package:bookstore_project/InfoScreens/order_list.dart';
import 'package:bookstore_project/InfoScreens/sales_record_list.dart';
import 'package:bookstore_project/state_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    //NavigationRail Indexes
    List<Widget> screen = [
      if (context.watch<checkoutNotif>().isCheckout) const CheckoutPage(),
      const BookList(),
      const AuthorList(),
      const OrderList(),
      const SalesRecordList(),
      const CustomerList(),
      const EmployeeList()
    ];
    // if (context.watch<checkoutNotif>().isCheckout) {
    //   _selectedIndex = 0;
    // }

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
                        child: FocusTraversalGroup(
                          policy: OrderedTraversalPolicy(),
                          child: NavigationRail(
                            selectedIndex: _selectedIndex,
                            onDestinationSelected: (int index) {
                              setState(() {
                                _selectedIndex = index;
                                //appBarName = screenTitle[_selectedIndex];
                              });
                            },
//Other buttons
                            leading: Column(
                              children: [
                                Container(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: Column(
                                      children: [
                                        isManager
                                            ? Column(
                                                children: const [
                                                  Icon(Icons.account_box,
                                                      size: 30),
                                                  Text(
                                                    'Manager',
                                                    // style: TextStyle(
                                                    //   color: (Theme.of(context).toggleableActiveColor))
                                                  )
                                                ],
                                              )
                                            : Column(
                                                children: const [
                                                  Icon(Icons.account_circle,
                                                      size: 30),
                                                  Text(
                                                    'Employee',
                                                    // style: TextStyle(
                                                    //   color: (Theme.of(context).toggleableActiveColor))
                                                  )
                                                ],
                                              )
                                      ],
                                    )),
                                //Spacer
                                // SizedBox(
                                //   height: 2,
                                //   width: 60,
                                //   child: Container(
                                //     padding: const EdgeInsets.only(bottom: 5),
                                //     color: Theme.of(context).hintColor)
                                // ),

//Logout Button
                                MaterialButton(
                                  onPressed: (() {
                                    _logoutDialog();
                                  }),
                                  child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 4, bottom: 2),
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
                                // Container(
                                //   padding: const EdgeInsets.only(top: 20),
                                //   child: ToggleSwitch(
                                //       minWidth: 35.0,
                                //       minHeight: 28.0,
                                //       initialLabelIndex: darkModeOn,
                                //       cornerRadius: 90.0,
                                //       borderColor: [
                                //         Theme.of(context).hintColor,
                                //       ],
                                //       borderWidth: 1.5,
                                //       activeFgColor: Colors.white,
                                //       inactiveBgColor:
                                //           const Color.fromARGB(255, 122, 122, 122),
                                //       inactiveFgColor: Colors.white,
                                //       totalSwitches: 2,
                                //       icons: const [
                                //         Icons.light_mode,
                                //         Icons.dark_mode
                                //       ],
                                //       iconSize: 26.0,
                                //       animate: true,
                                //       curve: Curves.bounceInOut,
                                //       onToggle: (darkModeOn) async {
                                //         // obtain shared preferences
                                //         final prefs =
                                //             await SharedPreferences.getInstance();
                                //         setState(() {
                                //           if (MyApp.themeNotifier.value ==
                                //               ThemeMode.light) {
                                //             darkModeOn = 0;
                                //             prefs.setBool('isDarkMode', true);
                                //             MyApp.themeNotifier.value =
                                //                 ThemeMode.dark;
                                //           } else {
                                //             darkModeOn = 1;
                                //             MyApp.themeNotifier.value =
                                //                 ThemeMode.light;
                                //             prefs.setBool('isDarkMode', false);
                                //           }
                                //         });
                                //       }),
                                //   //const Text('Dark Theme'),
                                // ),
                                const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                                if (MyApp.themeNotifier.value ==
                                    ThemeMode.dark)
                                  MaterialButton(
                                    onPressed: (() async {
                                      final prefs =
                                          await SharedPreferences.getInstance();
                                      darkModeOn = 1;
                                      MyApp.themeNotifier.value =
                                          ThemeMode.light;
                                      prefs.setBool('isDarkMode', false);
                                      setState(() {});
                                    }),
                                    child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: const <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 4, bottom: 2),
                                            child: Icon(
                                              Icons.light_mode,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(2.0),
                                            child: Text(
                                              "Light",
                                            ),
                                          )
                                        ]),
                                  ),

                                  if (MyApp.themeNotifier.value ==
                                    ThemeMode.light)
                                  MaterialButton(
                                    onPressed: (() async {
                                      darkModeOn = 0;
                                      final prefs =
                                          await SharedPreferences.getInstance();
                                      prefs.setBool('isDarkMode', true);
                                      MyApp.themeNotifier.value =
                                          ThemeMode.dark;
                                      setState(() {});
                                    }),
                                    child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: const <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 4, bottom: 2),
                                            child: Icon(
                                              Icons.dark_mode,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(2.0),
                                            child: Text(
                                              "Dark",
                                            ),
                                          )
                                        ]),
                                  ),
                              ],
                            ),

//Screens buttons
                            groupAlignment: 1.0,
                            labelType: NavigationRailLabelType.all,
                            destinations: <NavigationRailDestination>[
                              if (context.watch<checkoutNotif>().isCheckout)
                                const NavigationRailDestination(
                                  icon: Icon(Icons.shopping_basket_outlined),
                                  selectedIcon: Icon(Icons.shopping_basket),
                                  label: Text('Checkout'),
                                ),
                              const NavigationRailDestination(
                                icon: Icon(Icons.menu_book_outlined),
                                selectedIcon: Icon(Icons.menu_book),
                                label: Text('Books'),
                              ),
                              const NavigationRailDestination(
                                icon: Icon(Icons.library_books_outlined),
                                selectedIcon: Icon(Icons.library_books),
                                label: Text('Authors'),
                              ),
                              const NavigationRailDestination(
                                icon: Icon(Icons.receipt_outlined),
                                selectedIcon: Icon(Icons.receipt),
                                label: Text('Orders'),
                              ),
                              const NavigationRailDestination(
                                icon: Icon(Icons.receipt_long_outlined),
                                selectedIcon: Icon(Icons.receipt_long),
                                label: Text('Sales'),
                              ),
                              const NavigationRailDestination(
                                icon: Icon(Icons.people_alt_outlined),
                                selectedIcon: Icon(Icons.people_alt),
                                label: Text('Customers'),
                              ),
                              if (isManager)
                                const NavigationRailDestination(
                                  icon: Icon(Icons.emoji_people_outlined),
                                  selectedIcon: Icon(Icons.emoji_people),
                                  label: Text('Employees'),
                                ),
                            ],
                          ),
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
                      prefs.setBool('isLoggedinManager', false);
                      prefs.setBool('isLoggedinEmployee', false);
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
