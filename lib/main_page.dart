import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:bookstore_project/InfoScreens/author_list.dart';
import 'package:bookstore_project/InfoScreens/checkout_page.dart';
import 'package:bookstore_project/InfoScreens/customer_list.dart';
import 'package:bookstore_project/InfoScreens/order_list.dart';
import 'package:bookstore_project/InfoScreens/sales_record_list.dart';
import 'package:bookstore_project/main_drawer.dart';
import 'package:bookstore_project/state_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Extra/app_window.dart';
import 'main.dart';

//Screens
import 'login_page.dart';
import 'InfoScreens/book_list.dart';
import 'InfoScreens/employee_list.dart';

int selectedIndex = 0;
bool verticalBar = false;

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String appBarName = "Book Records";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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

    return Scaffold(
      key: _scaffoldKey,
      // appBar: MainAppbar(
      //   title: Text(appBarName),
      //   appBar: AppBar(),
      //   widgets: <Widget>[_editTableButton()],
      // ),
      drawer: const MainDrawer(),
      body: WindowBorder(
          color: borderColor,
          width: 1,
          child: Column(children: [
            WindowTitleBarBox(
                child: Container(
              color: Theme.of(context).primaryColor,
              child: Stack(
                  children: [
                    Positioned(right:0,child: WindowButtons()),
                    Expanded(
                      child: MoveWindow(
                        child:
                        const Center(child: Text('Antique Publications Bookstore',
                          //style: TextStyle(color: Colors.white)
                          ))
                  )), 
                  ]),
            )),
            if (verticalBar)
              Expanded(
                child: Row(
                  children: [
                    LayoutBuilder(
                      builder: (context, constraint) {
                        return SingleChildScrollView(
                          child: ConstrainedBox(
                              constraints: BoxConstraints(
                                  minHeight: constraint.maxHeight),
                              child: IntrinsicHeight(
                                child: FocusTraversalGroup(
                                  policy: OrderedTraversalPolicy(),
                                  child: NavigationRail(
                                    selectedIndex: selectedIndex,
                                    onDestinationSelected: (int index) {
                                      setState(() {
                                        selectedIndex = index;
                                        //appBarName = screenTitle[selectedIndex];
                                      });
                                    },
                                    //Other buttons
                                    leading: Column(
                                      children: [
                                        Container(
                                            padding: const EdgeInsets.only(
                                                bottom: 20),
                                            child: Column(
                                              children: [
                                                isManager
                                                    ? Column(
                                                        children: const [
                                                          Icon(
                                                              Icons.account_box,
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
                                                          Icon(
                                                              Icons
                                                                  .account_circle,
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
                                        const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10)),
                                        if (MyApp.themeNotifier.value ==
                                            ThemeMode.dark)
                                          MaterialButton(
                                            onPressed: (() async {
                                              final prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              MyApp.themeNotifier.value =
                                                  ThemeMode.light;
                                              prefs.setBool(
                                                  'isDarkMode', false);
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
                                                    padding:
                                                        EdgeInsets.all(2.0),
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
                                              final prefs =
                                                  await SharedPreferences
                                                      .getInstance();
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
                                                    padding:
                                                        EdgeInsets.all(2.0),
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
                                      if (context
                                          .watch<checkoutNotif>()
                                          .isCheckout)
                                        const NavigationRailDestination(
                                          icon: Icon(
                                              Icons.shopping_basket_outlined),
                                          selectedIcon:
                                              Icon(Icons.shopping_basket),
                                          label: Text('Checkout'),
                                        ),
                                      const NavigationRailDestination(
                                        icon: Icon(Icons.menu_book_outlined),
                                        selectedIcon: Icon(Icons.menu_book),
                                        label: Text('Books'),
                                      ),
                                      const NavigationRailDestination(
                                        icon:
                                            Icon(Icons.library_books_outlined),
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
                                          icon:
                                              Icon(Icons.emoji_people_outlined),
                                          selectedIcon:
                                              Icon(Icons.emoji_people),
                                          label: Text('Employees'),
                                        ),
                                    ],
                                  ),
                                ),
                              )),
                        );
                      },
                    ),
                    const VerticalDivider(thickness: 1, width: 1),
                    //This is the main content.
                    Expanded(
                      child: screen[selectedIndex],
                    ),
                  ],
                ),
              ),
            if (!verticalBar)
              Expanded(
                  child: Row(
                children: [
                  Column(
                    children: [
                      Container(
                        color: Theme.of(context).primaryColor,
                        width: 90,
                        height: 56,
                        child: Container(
                            padding: const EdgeInsets.only(top: 3.5),
                            child: Column(
                              children: [
                                isManager
                                    ? Column(
                                        children: const [
                                          Icon(Icons.account_box, size: 30),
                                          Text(
                                            'Manager',
                                            // style: TextStyle(
                                            //   color: (Theme.of(context).toggleableActiveColor))
                                          )
                                        ],
                                      )
                                    : Column(
                                        children: const [
                                          Icon(Icons.account_circle, size: 30),
                                          Text(
                                            'Employee',
                                            // style: TextStyle(
                                            //   color: (Theme.of(context).toggleableActiveColor))
                                          )
                                        ],
                                      )
                              ],
                            )),
                      ),
                      Expanded(
                          child: Row(
                        children: [
                          LayoutBuilder(
                            builder: (context, constraint) {
                              return SingleChildScrollView(
                                child: Container(
                                    width: 90,
                                    constraints: BoxConstraints(
                                        minHeight: constraint.maxHeight),
                                    child: IntrinsicHeight(
                                      child: FocusTraversalGroup(
                                        policy: OrderedTraversalPolicy(),
                                        child: NavigationRail(
                                          selectedIndex: selectedIndex,
                                          onDestinationSelected: (int index) {
                                            setState(() {
                                              selectedIndex = index;
                                              //appBarName = screenTitle[selectedIndex];
                                            });
                                          },
                                          //Other buttons
                                          leading: Column(
                                            children: [
                                              //Logout Button
                                              MaterialButton(
                                                onPressed: (() {
                                                  _logoutDialog();
                                                }),
                                                child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 4,
                                                                bottom: 2),
                                                        child: Icon(
                                                          Icons.logout,
                                                          color: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .button!
                                                              .color!
                                                              .withOpacity(0.7),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(2.0),
                                                        child: Text(
                                                          "Logout",
                                                          style: TextStyle(
                                                              color: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .button!
                                                                  .color!
                                                                  .withOpacity(
                                                                      0.7)),
                                                        ),
                                                      )
                                                    ]),
                                              ),
                                              const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10)),

                                              //Help Button
                                              MaterialButton(
                                                onPressed: (() {
                                                  _scaffoldKey.currentState!
                                                      .openDrawer();
                                                }),
                                                child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 4,
                                                                bottom: 2),
                                                        child: Icon(
                                                          Icons
                                                              .help_outline_outlined,
                                                          color: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .button!
                                                              .color!
                                                              .withOpacity(0.7),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(2.0),
                                                        child: Text(
                                                          "Help",
                                                          style: TextStyle(
                                                              color: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .button!
                                                                  .color!
                                                                  .withOpacity(
                                                                      0.7)),
                                                        ),
                                                      )
                                                    ]),
                                              ),
                                              const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10)),

                                              //Darkmode
                                              if (MyApp.themeNotifier.value ==
                                                  ThemeMode.dark)
                                                MaterialButton(
                                                  onPressed: (() async {
                                                    final prefs =
                                                        await SharedPreferences
                                                            .getInstance();
                                                    MyApp.themeNotifier.value =
                                                        ThemeMode.light;
                                                    prefs.setBool(
                                                        'isDarkMode', false);
                                                    setState(() {});
                                                  }),
                                                  child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 4,
                                                                  bottom: 2),
                                                          child: Icon(
                                                            Icons.light_mode,
                                                            color: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .button!
                                                                .color!
                                                                .withOpacity(
                                                                    0.7),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(2.0),
                                                          child: Text(
                                                            "Light",
                                                            style: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .button!
                                                                    .color!
                                                                    .withOpacity(
                                                                        0.7)),
                                                          ),
                                                        )
                                                      ]),
                                                ),

                                              if (MyApp.themeNotifier.value ==
                                                  ThemeMode.light)
                                                MaterialButton(
                                                  onPressed: (() async {
                                                    final prefs =
                                                        await SharedPreferences
                                                            .getInstance();
                                                    prefs.setBool(
                                                        'isDarkMode', true);
                                                    MyApp.themeNotifier.value =
                                                        ThemeMode.dark;
                                                    setState(() {});
                                                  }),
                                                  child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 4,
                                                                  bottom: 2),
                                                          child: Icon(
                                                            Icons.dark_mode,
                                                            color: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .button!
                                                                .color!
                                                                .withOpacity(
                                                                    0.7),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(2.0),
                                                          child: Text(
                                                            "Dark",
                                                            style: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .button!
                                                                    .color!
                                                                    .withOpacity(
                                                                        0.7)),
                                                          ),
                                                        )
                                                      ]),
                                                ),
                                            ],
                                          ),
                                          //Screens buttons
                                          groupAlignment: 1.0,
                                          labelType:
                                              NavigationRailLabelType.all,
                                          destinations: <
                                              NavigationRailDestination>[
                                            if (context
                                                .watch<checkoutNotif>()
                                                .isCheckout)
                                              const NavigationRailDestination(
                                                icon: Icon(Icons
                                                    .shopping_basket_outlined),
                                                selectedIcon:
                                                    Icon(Icons.shopping_basket),
                                                label: Text('Checkout'),
                                              ),
                                            const NavigationRailDestination(
                                              icon: Icon(
                                                  Icons.menu_book_outlined),
                                              selectedIcon:
                                                  Icon(Icons.menu_book),
                                              label: Text('Books'),
                                            ),
                                            const NavigationRailDestination(
                                              icon: Icon(
                                                  Icons.library_books_outlined),
                                              selectedIcon:
                                                  Icon(Icons.library_books),
                                              label: Text('Authors'),
                                            ),
                                            const NavigationRailDestination(
                                              icon:
                                                  Icon(Icons.receipt_outlined),
                                              selectedIcon: Icon(Icons.receipt),
                                              label: Text('Orders'),
                                            ),
                                            const NavigationRailDestination(
                                              icon: Icon(
                                                  Icons.receipt_long_outlined),
                                              selectedIcon:
                                                  Icon(Icons.receipt_long),
                                              label: Text('Sales'),
                                            ),
                                            const NavigationRailDestination(
                                              icon: Icon(
                                                  Icons.people_alt_outlined),
                                              selectedIcon:
                                                  Icon(Icons.people_alt),
                                              label: Text('Customers'),
                                            ),
                                            if (isManager)
                                              const NavigationRailDestination(
                                                icon: Icon(Icons
                                                    .emoji_people_outlined),
                                                selectedIcon:
                                                    Icon(Icons.emoji_people),
                                                label: Text('Employees'),
                                              ),
                                          ],
                                        ),
                                      ),
                                    )),
                              );
                            },
                          ),
                        ],
                      )),
                    ],
                  ),
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 0),
                        height: 56,
                        child: VerticalDivider(
                            color: Theme.of(context).primaryColor,
                            thickness: 1,
                            width: 1),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 56),
                        child: const VerticalDivider(thickness: 1, width: 1),
                      ),
                    ],
                  ),
                  Expanded(
                    child: screen[selectedIndex],
                  ),
                ],
              )),
          ])),
    );
  }

  //Logout alert helpers
  _logoutDialog() async {
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return _SystemPadding(
            child: AlertDialog(
              titlePadding: const EdgeInsets.only(top: 10),
              title: const Center(
                child: Text('Log out',
                    style: TextStyle(fontWeight: FontWeight.w700)),
              ),
              contentPadding: const EdgeInsets.only(left: 16, right: 16),
              content: const SizedBox(
                  width: 300,
                  height: 70,
                  child: Center(
                      child:
                          Text('You will be returned to the login screen.'))),
              actions: <Widget>[
                ElevatedButton(
                    child: const Text('CANCEL'),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                ElevatedButton(
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
                              const MyApp(),
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
