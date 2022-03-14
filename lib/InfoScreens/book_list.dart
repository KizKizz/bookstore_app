import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:bookstore_project/Data/book_data_handler.dart';

import '../main_appbar.dart';

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
  final searchbookController = TextEditingController();
  final List<String> _searchDropDownVal = [
    'Title',
    'ID',
    'Author',
    'Publisher',
    'Publisher Date',
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

  @override
  Widget _searchField() {
    return TextField(
        controller: searchbookController,
        onChanged: (String text) {
          setState(() {
            searchBookList = [];
            Iterable<Book> foundBook = [];
            if (curSearchChoice == 'Title') {
              foundBook = mainBookListCopy.where((element) =>
                  element.title.toLowerCase().contains(text.toLowerCase()));
            } else if (curSearchChoice == 'ID') {
              foundBook = mainBookListCopy.where((element) =>
                  element.id.toLowerCase().contains(text.toLowerCase()));
            } else if (curSearchChoice == 'Author') {
              foundBook = mainBookListCopy.where((element) =>
                  element.author.toLowerCase().contains(text.toLowerCase()));
            } else if (curSearchChoice == 'Publisher') {
              foundBook = mainBookListCopy.where((element) =>
                  element.publisher.toLowerCase().contains(text.toLowerCase()));
            } else if (curSearchChoice == 'Publisher Date') {
              foundBook = mainBookListCopy.where((element) => element
                  .publishDate
                  .toLowerCase()
                  .contains(text.toLowerCase()));
            } else if (curSearchChoice == 'Edition') {
              foundBook = mainBookListCopy.where((element) =>
                  element.edition.toLowerCase().contains(text.toLowerCase()));
            } else if (curSearchChoice == 'Cost') {
              foundBook = mainBookListCopy.where((element) =>
                  element.cost.toLowerCase().contains(text.toLowerCase()));
            } else if (curSearchChoice == 'Retail Price') {
              foundBook = mainBookListCopy.where((element) => element
                  .retailPrice
                  .toLowerCase()
                  .contains(text.toLowerCase()));
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
                    book.author,
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
        cursorColor: Colors.white,
        style: const TextStyle(fontSize: 20, color: Colors.white),
        textInputAction: TextInputAction.search,
        decoration: const InputDecoration(
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.yellow)),
            hintText: 'Search',
            hintStyle: TextStyle(fontSize: 20, color: Color.fromARGB(255, 236, 236, 236))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //drawer: const MainDrawer(),
        appBar: MainAppbar(
          title: const Text('Book Data'),
          appBar: AppBar(),
          flexSpace: Container(
            padding: const EdgeInsets.only(top: 5, bottom: 12),
            margin: const EdgeInsets.only(left: 300, right: 350),
            // decoration: BoxDecoration(
            //   border: Border.all(color: Colors.white10)),
            child: _searchField(),
          ),
          widgets: <Widget>[
            // Clear
            if (searchbookController.text.isNotEmpty)
              Container(
                width: 50,
                height: 50,
                padding: const EdgeInsets.only(
                    left: 2, right: 2, top: 10, bottom: 10),
                margin: const EdgeInsets.only(right: 0, top: 5, bottom: 4),
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
                  child: const Icon(
                    Icons.clear_sharp,
                    color: Color.fromARGB(255, 240, 240, 240),
                  ),
                ),
              ),

            //Dropdown search
            Container(
                padding: const EdgeInsets.only(
                    left: 2, right: 2, top: 10, bottom: 0),
                margin: const EdgeInsets.only(right: 160, top: 5, bottom: 4),
                child: DropdownButton2(
                  buttonHeight: 25,
                  buttonWidth: 105,
                  offset: const Offset(0, 2),
                  // buttonDecoration: BoxDecoration(
                  //   borderRadius: BorderRadius.circular(5),
                  //   border: Border.all(
                  //     color: Colors.white54,
                  //   ),),
                  value: curSearchChoice,
                  itemHeight: 35,
                  dropdownDecoration: const BoxDecoration(
                      color: Color.fromARGB(255, 54, 54, 54)),
                  itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                  items: _searchDropDownVal
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                        value: value,
                        child: SizedBox(
                            width: 70,
                            child: Text(
                              value,
                              style: const TextStyle(
                                  fontSize: 14.5, color: Colors.white),
                            )));
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      curSearchChoice = newValue!;
                    });
                  },
                )),

            //Add Data Button
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
        body: FutureBuilder(
            future: DefaultAssetBundle.of(context)
                .loadString('assets/jsondatabase/book_data.json'),
            builder: (context, snapshot) {
              if (snapshot.hasData && _booksDataSource.books.isEmpty) {
                var jsonResponse = jsonDecode(snapshot.data.toString());
                convertBookData(jsonResponse);
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
                        columnSpacing: 0,
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
                              'Title',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            size: ColumnSize.L,
                            onSort: (columnIndex, ascending) => _sort<String>(
                                (d) => d.title, columnIndex, ascending),
                          ),
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
                              'Author',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            size: ColumnSize.M,
                            numeric: false,
                            onSort: (columnIndex, ascending) => _sort<String>(
                                (d) => d.author, columnIndex, ascending),
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
                            label: Text(
                              '',
                              style: TextStyle(fontWeight: FontWeight.bold),
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
