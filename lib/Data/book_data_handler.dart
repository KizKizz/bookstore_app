// ignore_for_file: avoid_print, avoid_renaming_method_parameters

import 'dart:convert';
import 'dart:io';

import 'package:bookstore_project/login_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../InfoScreens/book_list.dart';
import 'author_data_handler.dart';

final File bookDataJson = File('assets/jsondatabase/book_data.json');
List<Book> mainBookList = [];
List<Book> mainBookListCopy = [];
List<Book> checkoutCartList = [];

// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// The file was extracted from GitHub: https://github.com/flutter/gallery
// Changes and modifications by Maxim Saplin, 2021 - KizKizz 2022

/// Keeps track of selected rows, feed the data into DataSource
class RestorableBookSelections extends RestorableProperty<Set<int>> {
  Set<int> _bookSelections = {};

  // Returns whether or not a row is selected by index.
  bool isSelected(int index) => _bookSelections.contains(index);

  // Takes a list of [Book]s and saves the row indices of selected rows
  // into a [Set].
  void setBookSelections(List<Book> books) {
    final updatedSet = <int>{};
    for (var i = 0; i < books.length; i += 1) {
      var book = books[i];
      if (book.selected) {
        updatedSet.add(i);
      }
    }
    _bookSelections = updatedSet;
    notifyListeners();
  }

  @override
  Set<int> createDefaultValue() => _bookSelections;

  @override
  Set<int> fromPrimitives(Object? data) {
    final selectedItemIndices = data as List<dynamic>;
    _bookSelections = {
      ...selectedItemIndices.map<int>((dynamic id) => id as int),
    };
    return _bookSelections;
  }

  @override
  void initWithValue(Set<int> value) {
    _bookSelections = value;
  }

  @override
  Object toPrimitives() => _bookSelections.toList();
}

/// Domain model entity
class Book {
  Book(this.title, this.id, this.author, this.publisher, this.publishDate,
      this.edition, this.cost, this.retailPrice, this.condition, this.sold);

  String title;
  String id;
  String author;
  String publisher;
  String publishDate;
  String edition;
  String cost;
  String retailPrice;
  String condition;
  String sold;

  bool selected = false;
  bool isSearched = false;
  List editResults = List.filled(10, null);

  List get allInfo {
    return [
      title,
      id,
      author,
      publisher,
      publishDate,
      edition,
      cost,
      retailPrice,
      condition,
      sold
    ];
  }

  List get allInfoHeaders {
    return [
      'Title',
      'ID',
      'Author',
      'Publisher',
      'Publish Date',
      'Edition',
      'Cost',
      'Retail Price',
      'Condition',
      'Sold'
    ];
  }

  void setInfo(var info) {
    if (info == 'Title' && editResults[0] != null)
      title = editResults[0];
    else if (info == 'ID' && editResults[1] != null)
      id = editResults[1];
    else if (info == 'Author' && editResults[2] != null)
      author = editResults[2];
    else if (info == 'Publisher' && editResults[3] != null)
      publisher = editResults[3];
    else if (info == 'Publish Date' && editResults[4] != null)
      publishDate = editResults[4];
    else if (info == 'Edition' && editResults[5] != null)
      edition = editResults[5];
    else if (info == 'Cost' && editResults[6] != null)
      cost = editResults[6];
    else if (info == 'Retail Price' && editResults[7] != null)
      retailPrice = editResults[7];
    else if (info == 'Condition' && editResults[8] != null)
      condition = editResults[8];
    else if (info == 'Sold' && editResults[9] != null) sold = editResults[9];
  }

  String headerToInfo(var header) {
    if (header == 'Title')
      return title;
    else if (header == 'ID')
      return id;
    else if (header == 'Author')
      return author;
    else if (header == 'Publisher')
      return publisher;
    else if (header == 'Publish Date')
      return publishDate;
    else if (header == 'Edition')
      return edition;
    else if (header == 'Cost')
      return cost;
    else if (header == 'Retail Price')
      return retailPrice;
    else if (header == 'Condition')
      return condition;
    else if (header == 'Sold')
      return sold;
    else
      return 'error';
  }

  void infoEdited(var info, var editedVal) {
    if (info == 'Title')
      editResults[0] = editedVal;
    else if (info == 'ID')
      editResults[1] = editedVal;
    else if (info == 'Author')
      editResults[2] = editedVal;
    else if (info == 'Publisher')
      editResults[3] = editedVal;
    else if (info == 'Publish Date')
      editResults[4] = editedVal;
    else if (info == 'Edition')
      editResults[5] = editedVal;
    else if (info == 'Cost')
      editResults[6] = editedVal;
    else if (info == 'RetailPrice')
      editResults[7] = editedVal;
    else if (info == 'Condition')
      editResults[8] = editedVal;
    else if (info == 'Sold')
      editResults[9] = editedVal;
    else
      editResults[0] = editedVal;
  }

  fromJson(Map<String, dynamic> json) {
    title = json['title'];
    id = json['id'];
    author = json['author'];
    publisher = json['publisher'];
    publishDate = json['publishDate'];
    edition = json['edition'];
    cost = json['cost'];
    retailPrice = json['retailPrice'];
    condition = json['condition'];
    sold = json['sold'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['id'] = id;
    data['author'] = author;
    data['publisher'] = publisher;
    data['publishDate'] = publishDate;
    data['edition'] = edition;
    data['cost'] = cost;
    data['retailPrice'] = retailPrice;
    data['condition'] = condition;
    data['sold'] = sold;

    return data;
  }
}

/// Data source implementing standard Flutter's DataTableSource abstract class
/// which is part of DataTable and PaginatedDataTable synchronous data fecthin API.
/// This class uses static collection of data as a data store, projects it into
/// DataRows, keeps track of selected items, provides sprting capability
class BookDatabase extends DataTableSource {
  BookDatabase.empty(this.context) {
    books = [];
  }

  BookDatabase(this.context,
      [sortedByName = true,
      this.hasRowTaps = true,
      this.hasRowHeightOverrides = false]) {
    books = mainBookList;
    if (sortedByName) {
      sort((d) => d.title, true);
    }
  }

  final BuildContext context;
  late List<Book> books;
  late bool hasRowTaps;
  late bool hasRowHeightOverrides;

  void sort<T>(Comparable<T> Function(Book d) getField, bool ascending) {
    books.sort((a, b) {
      if (a.cost == '') {
        a.cost = 0.toString();
      } else if (a.edition == '') {
        a.edition = 0.toString();
      } else if (a.retailPrice == '') {
        a.retailPrice = 0.toString();
      } else if (a.publishDate == '') {
        a.publishDate = 0.toString();
      }
      if (b.cost == '') {
        b.cost = 0.toString();
      } else if (b.edition == '') {
        b.edition = 0.toString();
      } else if (b.retailPrice == '') {
        b.retailPrice = 0.toString();
      } else if (b.publishDate == '') {
        b.publishDate = 0.toString();
      }
      final aValue = getField(a);
      final bValue = getField(b);

      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
    notifyListeners();
  }

  int _selectedCount = 0;
  void updateSelectedBooks(RestorableBookSelections selectedRows) {
    _selectedCount = 0;
    for (var i = 0; i < books.length; i += 1) {
      var book = books[i];
      if (selectedRows.isSelected(i)) {
        book.selected = true;
        _selectedCount += 1;
      } else {
        book.selected = false;
      }
    }
    notifyListeners();
  }

  @override
  DataRow getRow(int index) {
    // ignore: unused_local_variable
    final format = NumberFormat.decimalPercentPattern(
      locale: 'en',
      decimalDigits: 0,
    );
    assert(index >= 0);
    if (index >= books.length) throw 'index > _books.length';
    final book = books[index];
    return DataRow2.byIndex(
      index: index,
      selected: book.selected,
      onSelectChanged: hasRowTaps
          ? null
          : (value) {
              if (book.selected != value) {
                _selectedCount += value! ? 1 : -1;
                assert(_selectedCount >= 0);
                book.selected = value;
                notifyListeners();
              }
            },
      onTap: hasRowTaps
          ? () => [
                if (isManager) {_showDialog(context, book)}
              ]
          : null,
      onDoubleTap: hasRowTaps
          ? () => [
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  duration: const Duration(seconds: 1),
                  //backgroundColor: Theme.of(context).focusColor,
                  content: Text('Double Tapped on ${book.title}'),
                )),
              ]
          : null,
      onSecondaryTap: hasRowTaps
          ? () => //_bookDataAdder()
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                duration: const Duration(seconds: 1),
                backgroundColor: Theme.of(context).errorColor,
                content: Text('Right clicked on ${book.title}'),
              ))
          : null,
      specificRowHeight: hasRowHeightOverrides ? 100 : null,
      cells: [
        DataCell(Text(book.title)),
        DataCell(Text(book.id)),
        DataCell(Text(book.author)),
        DataCell(Text(book.publisher)),
        DataCell(Text(book.publishDate)),
        DataCell(Text(book.edition)),
        DataCell(Text(book.cost)),
        DataCell(Text(book.retailPrice)),
        DataCell(Text(book.condition)),
        DataCell(Text(book.sold)),
        if (book.sold.toLowerCase() == 'Available'.toLowerCase())
          DataCell(
            Container(
                padding: const EdgeInsets.only(right: 15),
                child: const Icon(Icons.add_shopping_cart)),
            onTap: () {
              book.sold = 'Sold';
              checkoutCartList.add(book);
              MenuItems.getItems(checkoutCartList);
              notifyListeners();
            },
          )
        else
          const DataCell(SizedBox())
      ],
    );
  }

  @override
  int get rowCount => books.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;

  void selectAll(bool? checked) {
    for (final dessert in books) {
      dessert.selected = checked ?? false;
    }
    _selectedCount = (checked ?? false) ? books.length : 0;
    notifyListeners();
  }

  //Edit Book Popup
  _showDialog(context, Book curBook) async {
    double _conditionRating = 1.0;
    int _statusRating = 0;
    String _curBookAuthor = curBook.author;
    if (curBook.condition == 'Poor') {
      _conditionRating = 1.0;
    } else if (curBook.condition == 'Fair') {
      _conditionRating = 2.0;
    } else if (curBook.condition == 'Good') {
      _conditionRating = 3.0;
    } else if (curBook.condition == 'Exellent') {
      _conditionRating = 4.0;
    } else if (curBook.condition == 'Superb') {
      _conditionRating = 5.0;
    }
    if (curBook.sold == 'Available') {
      _statusRating = 0;
    } else if (curBook.sold == 'Sold') {
      _statusRating = 1;
    }

    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return _SystemPadding(
            child: AlertDialog(
              contentPadding: const EdgeInsets.all(16.0),
              content: Row(
                children: <Widget>[
                  Expanded(
                      child: SingleChildScrollView(
                          child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Edit Book Info'),
                      for (var item in curBook.allInfoHeaders)
                        if (item == 'Condition')
                          Container(
                              padding: EdgeInsets.only(top: 10),
                              child: Column(children: [
                                Container(
                                  alignment: Alignment(-1, 0),
                                  padding: EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    'Condition:',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Theme.of(context).hintColor),
                                  ),
                                ),
                                RatingBar.builder(
                                  itemSize: 40,
                                  initialRating: _conditionRating,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: false,
                                  itemCount: 5,
                                  itemPadding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {
                                    if (rating == 1.0) {
                                      curBook.infoEdited(item, 'Poor');
                                    } else if (rating == 2.0) {
                                      curBook.infoEdited(item, 'Fair');
                                    } else if (rating == 3.0) {
                                      curBook.infoEdited(item, 'Good');
                                    } else if (rating == 4.0) {
                                      curBook.infoEdited(item, 'Excellent');
                                    } else if (rating == 5.0) {
                                      curBook.infoEdited(item, 'Superb');
                                    }
                                  },
                                )
                              ]))
                        else if (item == 'Sold')
                          Container(
                              padding: const EdgeInsets.only(top: 5),
                              child: Column(children: [
                                Container(
                                  alignment: const Alignment(-1, 0),
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    'Status:',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Theme.of(context).hintColor),
                                  ),
                                ),
                                ToggleSwitch(
                                  minWidth: 80.0,
                                  minHeight: 30,
                                  borderColor: [
                                    Theme.of(context).primaryColorLight
                                  ],
                                  borderWidth: 1.5,
                                  initialLabelIndex: _statusRating,
                                  cornerRadius: 50.0,
                                  activeFgColor: Colors.white,
                                  inactiveBgColor: Colors.grey,
                                  inactiveFgColor: Colors.white,
                                  totalSwitches: 2,
                                  labels: const ['Available', 'Sold'],
                                  activeBgColors: const [
                                    [Colors.blue],
                                    [Colors.pink]
                                  ],
                                  onToggle: (index) {
                                    if (index == 0) {
                                      curBook.infoEdited(item, 'Available');
                                    } else if (index == 1) {
                                      curBook.infoEdited(item, 'Sold');
                                    }
                                  },
                                )
                              ]))
                        else
                          TextField(
                              controller: TextEditingController()
                                ..text = curBook.headerToInfo(item),
                              onChanged: (text) =>
                                  {curBook.infoEdited(item, text)},
                              autofocus: true,
                              decoration: InputDecoration(
                                  labelText: item + ':',
                                  hintText: item + ' of the book')),
                    ],
                  )))
                ],
              ),
              actions: <Widget>[
                TextButton(
                    child: const Text('CANCEL'),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                TextButton(
                    child: const Text('SAVE'),
                    onPressed: () {
                      int _bookMatchIndex = mainBookListCopy
                          .indexWhere((element) => element.id == curBook.id);
                      //debugPrint('curafter: ${_bookMatchIndex}');
                      for (var item in curBook.allInfoHeaders) {
                        curBook.setInfo(item);
                      }

                      if (_bookMatchIndex >= 0) {
                        mainBookListCopy[_bookMatchIndex] = curBook;
                      }

                      //Fetch author data again?
                      final foundAuthor = mainAuthorList.singleWhere(
                          (element) => element.fullName
                              .toLowerCase()
                              .contains(_curBookAuthor.toLowerCase()));
                      foundAuthor.fullName = curBook.author;

                      notifyListeners();
                      Navigator.pop(context);

                      if (!kIsWeb) {
                        mainBookListCopy
                            .map(
                              (book) => book.toJson(),
                            )
                            .toList();
                        bookDataJson
                            .writeAsStringSync(json.encode(mainBookListCopy));
                      }
                      // notifyListeners();
                      // Navigator.pop(context);
                    })
              ],
            ),
          );
        });
  }
}

//Add book
Future<void> bookDataAdder(context) async {
  Book newBook = Book('', '', '', '', '', '', '', '', '', '');
  await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return _SystemPadding(
          child: AlertDialog(
            contentPadding: const EdgeInsets.all(16.0),
            content: Row(
              children: <Widget>[
                Expanded(
                    child: SingleChildScrollView(
                        child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Add Book'),
                    for (var item in newBook.allInfoHeaders)
                      if (item == 'Condition')
                        Container(
                            padding: EdgeInsets.only(top: 10),
                            child: Column(children: [
                              Container(
                                alignment: Alignment(-1, 0),
                                padding: EdgeInsets.only(bottom: 5),
                                child: Text(
                                  'Condition:',
                                  style: TextStyle(
                                      color: Theme.of(context).hintColor),
                                ),
                              ),
                              RatingBar.builder(
                                itemSize: 40,
                                initialRating: 3,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: false,
                                itemCount: 5,
                                itemPadding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {
                                  if (rating == 1.0) {
                                    newBook.infoEdited(item, 'Poor');
                                  } else if (rating == 2.0) {
                                    newBook.infoEdited(item, 'Fair');
                                  } else if (rating == 3.0) {
                                    newBook.infoEdited(item, 'Good');
                                  } else if (rating == 4.0) {
                                    newBook.infoEdited(item, 'Excellent');
                                  } else if (rating == 5.0) {
                                    newBook.infoEdited(item, 'Superb');
                                  }
                                },
                              )
                            ]))
                      else if (item == 'Sold')
                        Container(
                            padding: const EdgeInsets.only(top: 5),
                            child: Column(children: [
                              Container(
                                alignment: const Alignment(-1, 0),
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Text(
                                  'Status:',
                                  style: TextStyle(
                                      color: Theme.of(context).hintColor),
                                ),
                              ),
                              ToggleSwitch(
                                minWidth: 80.0,
                                minHeight: 30,
                                borderColor: [
                                  Theme.of(context).primaryColorLight
                                ],
                                borderWidth: 1.5,
                                initialLabelIndex: 0,
                                cornerRadius: 50.0,
                                activeFgColor: Colors.white,
                                inactiveBgColor: Colors.grey,
                                inactiveFgColor: Colors.white,
                                totalSwitches: 2,
                                labels: const ['Available', 'Sold'],
                                activeBgColors: const [
                                  [Colors.blue],
                                  [Colors.pink]
                                ],
                                onToggle: (index) {
                                  if (index == 0) {
                                    newBook.infoEdited(item, 'Available');
                                  } else if (index == 1) {
                                    newBook.infoEdited(item, 'Sold');
                                  }
                                },
                              )
                            ]))
                      else
                        TextField(
                            // controller: TextEditingController()
                            //   ..text = item.toString(),
                            onChanged: (text) =>
                                {newBook.infoEdited(item, text)},
                            autofocus: true,
                            decoration: InputDecoration(
                                labelText: item + ':',
                                hintText: item + ' of the book')),
                  ],
                )))
              ],
            ),
            actions: <Widget>[
              TextButton(
                  child: const Text('CANCEL'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              TextButton(
                  child: const Text('ADD'),
                  onPressed: () {
                    for (var item in newBook.allInfoHeaders) {
                      newBook.setInfo(item);
                    }
                    mainBookList.add(newBook);
                    mainBookListCopy.add(newBook);

                    if (!kIsWeb) {
                      mainBookListCopy
                          .map(
                            (book) => book.toJson(),
                          )
                          .toList();
                      bookDataJson
                          .writeAsStringSync(json.encode(mainBookListCopy));
                    }
                    Navigator.pop(context);
                    //debugPrint(newBook.allInfo.toString());
                  })
            ],
          ),
        );
      });
}

//JSON Helper
void convertBookData(var jsonResponse) {
  for (var b in jsonResponse) {
    Book book = Book(
        b['title'],
        b['id'],
        b['author'],
        b['publisher'],
        b['publishDate'],
        b['edition'],
        b['cost'],
        b['retailPrice'],
        b['condition'],
        b['sold']);
    mainBookList.add(book);
    mainBookListCopy.add(book);
  }
  //debugPrint('test ${mainBookList.length}');
}

//Search Helper
Future<void> searchHelper(context, List<Book> foundList) async {
  if (foundList.isEmpty) {
    mainBookList.removeRange(1, mainBookList.length);
    mainBookList.first = Book('', '', '', '', '', '', '', '', '', '');
  } else {
    if (mainBookList.length > 1) {
      mainBookList.removeRange(1, mainBookList.length);
    }

    for (var book in foundList) {
      if (book == foundList.first) {
        mainBookList.first = book;
      } else if (foundList.length > 1) {
        mainBookList.add(book);
      }
    }
  }
  //debugPrint('main ${mainBookList.toString()}');
  //debugPrint('copy ${mainBookListCopy.toString()}');
}

// Dialog Helper
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
