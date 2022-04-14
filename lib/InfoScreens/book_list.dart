import 'dart:convert';

import 'package:bookstore_project/InfoScreens/checkout_page.dart';
import 'package:bookstore_project/login_page.dart';
import 'package:bookstore_project/state_provider.dart';
import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:bookstore_project/Data/book_data_handler.dart';
import 'package:provider/provider.dart';

import '../main_appbar.dart';
import '../main_page.dart';

final searchbookController = TextEditingController();
int checkoutDropDownRemoveIndex = -1;

//String _searchDropDownVal = 'Title';

class BookList extends StatefulWidget {
  const BookList({Key? key}) : super(key: key);

  @override
  _BookListState createState() => _BookListState();
}

class _BookListState extends State<BookList> {
  bool _sortAscending = true;
  int? _sortColumnIndex;
  late BookDatabase _booksDataSource;
  bool _initialized = false;
  final ScrollController _controller = ScrollController();
  List<Book> searchBookList = [];
  final List<Book> preSearchList = mainBookListCopy;

  final List<String> _searchDropDownVal = [
    'All Fields',
    'Title',
    'ID',
    'Author',
    'Publisher',
    'Publish Date',
    'Edition',
    'Cost',
    'Retail Price',
    'Condition',
    'Sold Status'
  ];
  late String curSearchChoice;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      setState(() {});
      _booksDataSource = BookDatabase(context);
      curSearchChoice = _searchDropDownVal[0];
      _initialized = true;
      _booksDataSource.addListener(() {
        setState(() {});
      });
    }
  }

  void _sort<T>(
    Comparable<T> Function(Book d) getField,
    int columnIndex,
    bool ascending,
  ) {
    _booksDataSource.sort<T>(getField, ascending);
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  @override
  void dispose() {
    _booksDataSource.dispose();
    super.dispose();
  }

  Widget _searchField() {
    return TextField(
      controller: searchbookController,
      onChanged: (String text) {
        setState(() {
          searchBookList = [];
          Iterable<Book> foundBook = [];
          if (curSearchChoice == 'All Fields') {
            foundBook = mainBookListCopy.where((element) =>
                element.title.toLowerCase().contains(text.toLowerCase()) ||
                element.id.toLowerCase().contains(text.toLowerCase()) ||
                element.authorFirstName
                    .toLowerCase()
                    .contains(text.toLowerCase()) ||
                element.authorLastName
                    .toLowerCase()
                    .contains(text.toLowerCase()) ||
                element.publisher.toLowerCase().contains(text.toLowerCase()) ||
                element.publishDate
                    .toLowerCase()
                    .contains(text.toLowerCase()) ||
                element.edition.toLowerCase().contains(text.toLowerCase()) ||
                element.cost.toLowerCase().contains(text.toLowerCase()) ||
                element.retailPrice
                    .toLowerCase()
                    .contains(text.toLowerCase()) ||
                element.condition.toLowerCase().contains(text.toLowerCase()) ||
                element.sold.toLowerCase().contains(text.toLowerCase()));
          } else if (curSearchChoice == 'Title') {
            foundBook = mainBookListCopy.where((element) =>
                element.title.toLowerCase().contains(text.toLowerCase()));
          } else if (curSearchChoice == 'ID') {
            foundBook = mainBookListCopy.where((element) =>
                element.id.toLowerCase().contains(text.toLowerCase()));
          } else if (curSearchChoice == 'Author') {
            foundBook = mainBookListCopy.where((element) => element
                .authorFirstName
                .toLowerCase()
                .contains(text.toLowerCase()) ||
                element.authorLastName
                    .toLowerCase()
                    .contains(text.toLowerCase()));
          } else if (curSearchChoice == 'Publisher') {
            foundBook = mainBookListCopy.where((element) =>
                element.publisher.toLowerCase().contains(text.toLowerCase()));
          } else if (curSearchChoice == 'Publish Date') {
            foundBook = mainBookListCopy.where((element) =>
                element.publishDate.toLowerCase().contains(text.toLowerCase()));
          } else if (curSearchChoice == 'Edition') {
            foundBook = mainBookListCopy.where((element) =>
                element.edition.toLowerCase().contains(text.toLowerCase()));
          } else if (curSearchChoice == 'Cost') {
            foundBook = mainBookListCopy.where((element) =>
                element.cost.toLowerCase().contains(text.toLowerCase()));
          } else if (curSearchChoice == 'Retail Price') {
            foundBook = mainBookListCopy.where((element) =>
                element.retailPrice.toLowerCase().contains(text.toLowerCase()));
          } else if (curSearchChoice == 'Condition') {
            foundBook = mainBookListCopy.where((element) =>
                element.condition.toLowerCase().contains(text.toLowerCase()));
          } else if (curSearchChoice == 'Sold Status') {
            foundBook = mainBookListCopy.where((element) =>
                element.sold.toLowerCase().contains(text.toLowerCase()));
          }

          if (foundBook.isNotEmpty) {
            for (var book in foundBook) {
              Book tempBook = Book(
                  book.title,
                  book.id,
                  book.authorFirstName,
                  book.authorLastName,
                  book.authorID,
                  book.publisher,
                  book.publishDate,
                  book.edition,
                  book.cost,
                  book.retailPrice,
                  book.condition,
                  book.sold);
              searchBookList.add(tempBook);
            }
            setState(() {
              searchHelper(context, searchBookList).then((_) {
                setState(() {});
                //debugPrint('test ${mainBookList.toString()}');
              });
            });
          } else {
            setState(() {
              searchHelper(context, searchBookList).then((_) {
                setState(() {});
              });
            });
          }
        });
      },
      onSubmitted: (String text) {
        setState(() {});
      },
      autofocus: false,
      maxLines: 1,
      cursorColor: Theme.of(context).hintColor,
      style: const TextStyle(fontSize: 21),
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
          prefixIcon:
              Icon(Icons.search, size: 25, color: Theme.of(context).hintColor),
          filled: true,
          fillColor: Theme.of(context).canvasColor,
          enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(3)),
              borderSide: BorderSide(
                color: Theme.of(context).hintColor,
              )),
          focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(3)),
              borderSide: BorderSide(
                color: Theme.of(context).hintColor,
              )),
          isDense: true,
          contentPadding: const EdgeInsets.all(8),
          hintText: 'Search',
          hintStyle: const TextStyle(
            fontSize: 21,
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //drawer: const MainDrawer(),
        appBar: MainAppbar(
          title: const Text('Book Data'),
          appBar: AppBar(),
          flexSpace: Container(
            margin: const EdgeInsets.only(
              left: 200,
              right: 368,
            ),
            child: Container(
                padding: const EdgeInsets.only(left: 2, right: 0),
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                child: _searchField()),
          ),
          widgets: <Widget>[
            // Clear
            if (searchbookController.text.isNotEmpty)
              Container(
                width: 50,
                height: 50,
                padding: const EdgeInsets.only(
                    left: 0, right: 0, top: 10, bottom: 10),
                margin: const EdgeInsets.only(right: 0, top: 3, bottom: 3),
                child: MaterialButton(
                  onPressed: () => [
                    setState(() {
                      setState(() {
                        searchbookController.clear();
                        searchBookList = preSearchList;
                        searchHelper(context, searchBookList).then((_) {
                          setState(() {});
                        });
                      });
                    })
                  ],
                  child: Icon(
                    Icons.clear_sharp,
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ),

            //Dropdown search
            Container(
                padding: const EdgeInsets.only(left: 2, right: 2),
                margin: const EdgeInsets.only(right: 80, top: 10, bottom: 10),
                child: CustomDropdownButton2(
                  hint: 'Select one',
                  // buttonHeight: 25,
                  buttonWidth: 128,
                  dropdownWidth: 128,
                  offset: const Offset(0, 0),
                  icon: const Icon(Icons.arrow_drop_down),
                  iconSize: 20,
                  buttonPadding: const EdgeInsets.symmetric(horizontal: 10),
                  dropdownHeight: double.maxFinite,
                  dropdownDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(color: Theme.of(context).cardColor),
                    //color: Colors.redAccent,
                  ),
                  buttonDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(color: Theme.of(context).hintColor),
                    color: Theme.of(context).canvasColor,
                  ),
                  dropdownElevation: 2,
                  value: curSearchChoice,
                  dropdownItems: _searchDropDownVal,
                  onChanged: (String? newValue) {
                    setState(() {
                      curSearchChoice = newValue!;
                    });
                  },
                )),

            //Padding for nonmanager
            if (!isManager) const SizedBox(width: 80),

            //Checkout cart list
            DropdownButtonHideUnderline(
              child: DropdownButton2(
                customButton: SizedBox(
                    width: 80,
                    child: Center(
                        child: Stack(children: [
                      Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 6, bottom: 2, left: 2, right: 2),
                              child: Icon(
                                Icons.shopping_cart_checkout,
                                color: Colors.white,
                                size: 25,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 2, right: 2),
                              child: Text(
                                "Book Cart",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            )
                          ]),
                      if (checkoutCartList.isNotEmpty)
                        Positioned(
                            right: 2,
                            top: 4,
                            child: Container(
                                padding: const EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 18,
                                  minHeight: 18,
                                ),
                                child: Text('${checkoutCartList.length}',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    )))),
                    ]))),
                customItemsIndexes: [checkoutCartList.length],
                customItemsHeight: 8,
                items: [
                  ...MenuItems.booksMenu.map(
                    (item) => DropdownMenuItem<MenuItem>(
                      value: item,
                      child: MenuItems.buildItem(context, item),
                    ),
                  ),
                  if (checkoutCartList.isNotEmpty)
                    const DropdownMenuItem<Divider>(
                        enabled: false, child: Divider()),
                  if (checkoutCartList.isNotEmpty)
                    ...MenuItems.clearMenu.map(
                      (item) => DropdownMenuItem<MenuItem>(
                        value: item,
                        child: MenuItems.buildItem(context, item),
                      ),
                    ),
                  // const DropdownMenuItem<Divider>(
                  //     enabled: false, child: Divider()),
                  if (checkoutCartList.isNotEmpty)
                    ...MenuItems.toCheckoutMenu.map(
                      (item) => DropdownMenuItem<MenuItem>(
                        value: item,
                        child: MenuItems.buildItem(context, item),
                      ),
                    ),
                ],
                onChanged: (value) {
                  setState(() {
                    FocusScope.of(context).requestFocus(FocusNode());
                    MenuItems.onChanged(context, value as MenuItem);
                  });
                },
                itemHeight: 48,
                itemPadding: const EdgeInsets.only(left: 16, right: 16),
                dropdownWidth: 270,
                dropdownPadding: const EdgeInsets.symmetric(vertical: 6),
                dropdownDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  //color: Colors.redAccent,
                ),
                dropdownElevation: 8,
                offset: const Offset(-140, 8),
              ),
            ),

            //Add Data Button
            if (isManager)
              MaterialButton(
                onPressed: () => [
                  setState(() {
                    setState(() {
                      bookDataAdder(context).then((_) {
                        setState(() {});
                      });
                    });
                  })
                ],
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const <Widget>[
                      Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Icon(
                          Icons.add_circle_outline_outlined,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          "Add",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ]),
              ),
          ],
        ),

        //Body List
        body: FutureBuilder(
            future: DefaultAssetBundle.of(context)
                .loadString('assets/jsondatabase/book_data.json'),
            builder: (context, snapshot) {
              if (snapshot.data.toString().isNotEmpty &&
                  snapshot.hasData &&
                  _booksDataSource.books.isEmpty) {
                var jsonResponse = jsonDecode(snapshot.data.toString());
                convertBookData(jsonResponse);
                //getAuthorsFromBook();
                //debugPrint('test ${jsonResponse}');
              }
              //Build table
              return Padding(
                  padding: const EdgeInsets.all(5),
                  child: Stack(children: [
                    //Data table
                    DataTable2(
                        scrollController: _controller,
                        showCheckboxColumn: false,
                        columnSpacing: 3,
                        horizontalMargin: 5,
                        bottomMargin: 5,
                        minWidth: 1000,
                        smRatio: 0.6,
                        lmRatio: 1.5,
                        sortColumnIndex: _sortColumnIndex,
                        sortAscending: _sortAscending,
                        onSelectAll: (val) =>
                            setState(() => _booksDataSource.selectAll(val)),
                        columns: [
                          DataColumn2(
                            label: const Text(
                              'ID',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            size: ColumnSize.S,
                            onSort: (columnIndex, ascending) => _sort<String>(
                                (d) => d.id, columnIndex, ascending),
                          ),
                          DataColumn2(
                            label: const Text(
                              'Title',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            size: ColumnSize.L,
                            onSort: (columnIndex, ascending) => _sort<String>(
                                (d) => d.title, columnIndex, ascending),
                          ),
                          DataColumn2(
                            label: const Text(
                              'Author',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            size: ColumnSize.M,
                            numeric: false,
                            onSort: (columnIndex, ascending) => _sort<String>(
                                (d) => d.authorFirstName + d.authorLastName, columnIndex, ascending),
                          ),
                          DataColumn2(
                            label: const Text(
                              'Publisher',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            size: ColumnSize.S,
                            numeric: true,
                            onSort: (columnIndex, ascending) => _sort<String>(
                                (d) => d.publisher, columnIndex, ascending),
                          ),
                          DataColumn2(
                            label: const Text(
                              'Publish\nDate',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            size: ColumnSize.S,
                            numeric: true,
                            onSort: (columnIndex, ascending) => _sort<num>(
                                (d) => int.parse(d.publishDate),
                                columnIndex,
                                ascending),
                          ),
                          DataColumn2(
                            label: const Text(
                              'Edition',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            size: ColumnSize.S,
                            numeric: true,
                            onSort: (columnIndex, ascending) => _sort<num>(
                                (d) => double.parse(d.edition),
                                columnIndex,
                                ascending),
                          ),
                          DataColumn2(
                            label: const Text(
                              'Cost',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            size: ColumnSize.S,
                            numeric: true,
                            onSort: (columnIndex, ascending) => _sort<num>(
                                (d) => double.parse(d.cost),
                                columnIndex,
                                ascending),
                          ),
                          DataColumn2(
                            label: const Text(
                              'Retail\nPrice',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            size: ColumnSize.S,
                            numeric: true,
                            onSort: (columnIndex, ascending) => _sort<num>(
                                (d) => double.parse(d.retailPrice),
                                columnIndex,
                                ascending),
                          ),
                          DataColumn2(
                            label: const Text(
                              'Condition',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            size: ColumnSize.S,
                            numeric: true,
                            onSort: (columnIndex, ascending) => _sort<String>(
                                (d) => d.condition, columnIndex, ascending),
                          ),
                          DataColumn2(
                            label: const Text(
                              'Status',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            size: ColumnSize.S,
                            numeric: true,
                            onSort: (columnIndex, ascending) => _sort<String>(
                                (d) => d.sold, columnIndex, ascending),
                          ),
                          const DataColumn2(
                            label: Padding(
                              padding: EdgeInsets.only(right: 15),
                              child: Text(
                                'Cart', 
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            size: ColumnSize.S,
                            numeric: true,
                          ),
                        ],
                        rows: List<DataRow>.generate(_booksDataSource.rowCount,
                            (index) => _booksDataSource.getRow(index))),
                    _ScrollUpButton(_controller)
                  ]));
            }));
  }
}

class _ScrollUpButton extends StatefulWidget {
  const _ScrollUpButton(this.controller);

  final ScrollController controller;

  @override
  _ScrollUpButtonState createState() => _ScrollUpButtonState();
}

class _ScrollUpButtonState extends State<_ScrollUpButton> {
  bool _showScrollUp = false;

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(() {
      if (widget.controller.position.pixels > 20 && !_showScrollUp) {
        setState(() {
          _showScrollUp = true;
        });
      } else if (widget.controller.position.pixels < 20 && _showScrollUp) {
        setState(() {
          _showScrollUp = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _showScrollUp
        ? Positioned(
            right: 10,
            bottom: 10,
            child: OutlinedButton(
              child: const Text('↑ To Top ↑'),
              onPressed: () => widget.controller.animateTo(0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.grey[800]),
                  foregroundColor: MaterialStateProperty.all(Colors.white)),
            ))
        : const SizedBox();
  }
}

class MenuItem {
  final String text;
  final IconData icon;

  const MenuItem({
    required this.text,
    required this.icon,
  });
}

class MenuItems {
  static List<MenuItem> booksMenu = [];
  static const List<MenuItem> clearMenu = [clear];
  static const List<MenuItem> toCheckoutMenu = [checkout];

  static const clear = MenuItem(text: 'Clear All', icon: Icons.clear_all);
  static const checkout =
      MenuItem(text: 'Checkout', icon: Icons.shopping_basket);

  static void getItems(List<Book> booksInCart) {
    List<MenuItem> tempList = [];
    if (booksInCart.isNotEmpty) {
      for (var book in booksInCart) {
        tempList.add(
            MenuItem(text: book.title + ' - ' + book.id, icon: Icons.clear));
      }
    }
    booksMenu = tempList;
  }

  static Widget buildItem(context, MenuItem item) {
    return Row(
      children: [
        Icon(item.icon,
            color: Theme.of(context).textTheme.overline!.color, size: 22),
        const SizedBox(
          width: 10,
        ),
        Flexible(
            child: Text(
          item.text,
          textAlign: TextAlign.left,
          maxLines: 2,
          // style: const TextStyle(
          //   color: Colors.white,
          // ),
        )),
      ],
    );
  }

  static onChanged(BuildContext context, MenuItem item) {
    switch (item) {
      case MenuItems.clear:
        for (var book in checkoutCartList) {
          book.sold = 'Available';
        }
        checkoutCartList.clear();
        booksMenu.clear();
        checkoutPrices.clear();
        priceControllers.clear();
        subTotal = 0.00;
        break;
      case MenuItems.checkout:
        context.read<checkoutNotif>().checkoutOn();
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => const MainPage(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
        break;
      default:
        final getBookID = item.text.split(' - ');
        var bookFound = mainBookListCopy
            .singleWhere((element) => element.id == getBookID.last);
        if (bookFound.id.isNotEmpty) {
          bookFound.sold = 'Available';
        }

        int _index = checkoutCartList
            .indexWhere((element) => element.id == getBookID.last);
        checkoutDropDownRemoveIndex = _index;

        checkoutCartList.remove(checkoutCartList
            .singleWhere((element) => element.id == getBookID.last));
        booksMenu.remove(
            booksMenu.singleWhere((element) => element.text == item.text));

        break;
    }
  }
}
