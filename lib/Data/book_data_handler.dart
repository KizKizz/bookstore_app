// ignore_for_file: avoid_print, avoid_renaming_method_parameters, curly_braces_in_flow_control_structures

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
  Book(
      this.title,
      this.id,
      this.authorFirstName,
      this.authorLastName,
      this.authorID,
      this.publisher,
      this.publishDate,
      this.edition,
      this.cost,
      this.retailPrice,
      this.condition,
      this.sold);

  String title;
  String id;
  String authorFirstName;
  String authorLastName;
  String authorID;
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
      authorFirstName,
      authorLastName,
      authorID,
      publisher,
      publishDate,
      edition,
      cost,
      retailPrice,
      condition,
      sold
    ];
  }

  fromJson(Map<String, dynamic> json) {
    title = json['title'];
    id = json['id'];
    authorFirstName = json['authorFirstName'];
    authorLastName = json['authorLastName'];
    authorID = json['authorID'];
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
    data['authorFirstName'] = authorFirstName;
    data['authorLastName'] = authorLastName;
    data['authorID'] = authorID;
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
        DataCell(Text(book.id)),
        DataCell(Text(book.title)),
        DataCell(Text(book.authorFirstName + ' ' + book.authorLastName)),
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
    String _curBookAuthor = curBook.authorID;
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
              contentPadding:
                  const EdgeInsets.only(top: 16, left: 16, bottom: 16),
              content: Container(
                width: 400,
                constraints: const BoxConstraints(maxWidth: 400),
                child: SingleChildScrollView(
                    child: Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('Book Info',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        child: Container(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: TextFormField(
                                          controller: TextEditingController()
                                            ..text = curBook.title,
                                          onChanged: (text) => {curBook.title = text},
                                          decoration: const InputDecoration(
                                            //icon: Icon(Icons.person),
                                            hintText: '',
                                            labelText: 'Title',
                                          )),
                                    )),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        child: Container(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: TextFormField(
                                          controller: TextEditingController()
                                            ..text = curBook.edition,
                                          onChanged: (text) =>
                                              {curBook.edition = text},
                                          decoration: const InputDecoration(
                                            //icon: Icon(Icons.person),
                                            hintText: '',
                                            labelText: 'Edition',
                                          )),
                                    )),
                                    Expanded(
                                        child: Container(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: TextFormField(
                                          controller: TextEditingController()
                                            ..text = curBook.id,
                                          onChanged: (text) => {curBook.id = text},
                                          decoration: const InputDecoration(
                                            //icon: Icon(Icons.person),
                                            hintText: '',
                                            labelText: 'ID',
                                          )),
                                    )),
                                  ],
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          child: Container(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: TextFormField(
                                            controller: TextEditingController()
                                              ..text = curBook.authorFirstName,
                                            onChanged: (text) =>
                                                {curBook.authorFirstName = text},
                                            decoration: const InputDecoration(
                                              //icon: Icon(Icons.person),
                                              hintText: '',
                                              labelText: 'Author\'s First Name',
                                            )),
                                      )),
                                      Expanded(
                                          child: Container(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: TextFormField(
                                            controller: TextEditingController()
                                              ..text = curBook.authorLastName,
                                            onChanged: (text) =>
                                                {curBook.authorLastName = text},
                                            decoration: const InputDecoration(
                                              //icon: Icon(Icons.person),
                                              hintText: '',
                                              labelText: 'Author\'s Last Name',
                                            )),
                                      )),
                                    ]),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        child: Container(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: TextFormField(
                                          controller: TextEditingController()
                                            ..text = curBook.publisher,
                                          onChanged: (text) =>
                                              {curBook.publisher = text},
                                          decoration: const InputDecoration(
                                            //icon: Icon(Icons.person),
                                            hintText: '',
                                            labelText: 'Publisher',
                                          )),
                                    )),
                                    Expanded(
                                        child: Container(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: TextFormField(
                                          controller: TextEditingController()
                                            ..text = curBook.publishDate,
                                          onChanged: (text) =>
                                              {curBook.publishDate = text},
                                          decoration: const InputDecoration(
                                            //icon: Icon(Icons.person),
                                            hintText: '',
                                            labelText: 'Publish Date',
                                          )),
                                    )),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        child: Container(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: TextFormField(
                                          controller: TextEditingController()
                                            ..text = curBook.cost,
                                          onChanged: (text) => {curBook.cost = text},
                                          decoration: const InputDecoration(
                                            //icon: Icon(Icons.person),
                                            hintText: '',
                                            labelText: 'Cost',
                                          )),
                                    )),
                                    Expanded(
                                        child: Container(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: TextFormField(
                                          controller: TextEditingController()
                                            ..text = curBook.retailPrice,
                                          onChanged: (text) =>
                                              {curBook.retailPrice = text},
                                          decoration: const InputDecoration(
                                            //icon: Icon(Icons.person),
                                            hintText: '',
                                            labelText: 'Retail Price',
                                          )),
                                    )),
                                  ],
                                ),
                                Container(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Column(children: [
                                      Text(
                                        'Condition',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Theme.of(context).hintColor),
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
                                            curBook.condition = 'Poor';
                                          } else if (rating == 2.0) {
                                            curBook.condition = 'Fair';
                                          } else if (rating == 3.0) {
                                            curBook.condition = 'Good';
                                          } else if (rating == 4.0) {
                                            curBook.condition = 'Excellent';
                                          } else if (rating == 5.0) {
                                            curBook.condition = 'Superb';
                                          }
                                        },
                                      )
                                    ])),
                                Container(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Column(children: [
                                      Container(
                                        //alignment: const Alignment(-1, 0),
                                        padding:
                                            const EdgeInsets.only(bottom: 5),
                                        child: Text(
                                          'Status',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color:
                                                  Theme.of(context).hintColor),
                                        ),
                                      ),
                                      ToggleSwitch(
                                        minWidth: 110,
                                        minHeight: 30,
                                        // borderColor: [
                                        //   Theme.of(context).hintColor
                                        // ],
                                        // borderWidth: 1,
                                        initialLabelIndex: _statusRating,
                                        cornerRadius: 5,
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
                                            curBook.sold = 'Available';
                                          } else if (index == 1) {
                                            curBook.sold = 'Sold';
                                          }
                                        },
                                      )
                                    ]))
                              ],
                            ))
                          ],
                        ))),
              ),
              actions: <Widget>[
                ElevatedButton(
                    child: const Text('CANCEL'),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                ElevatedButton(
                    child: const Text('SAVE'),
                    onPressed: () async {
                      int _bookMatchIndex = mainBookListCopy
                          .indexWhere((element) => element.id == curBook.id);
                      //debugPrint('curafter: ${_bookMatchIndex}');
                      // for (var item in curBook.allInfoHeaders) {
                      //   curBook.setInfo(item);
                      // }

                      String _authorDataGet =
                          await authorDataJson.readAsString();
                      if (_authorDataGet.isEmpty) {
                        getAuthorsFromBook();
                      } else if (_authorDataGet.isNotEmpty &&
                          mainAuthorListCopy.isEmpty) {
                        var _jsonResponse = await jsonDecode(_authorDataGet);
                        convertauthorData(_jsonResponse);
                      }

                      if (_bookMatchIndex >= 0) {
                        mainBookListCopy[_bookMatchIndex] = curBook;
                      }

                      //Fetch author data again?
                      final foundAuthor = mainAuthorListCopy.singleWhere(
                          (element) => element.id
                              .toLowerCase()
                              .contains(_curBookAuthor.toLowerCase()));
                      foundAuthor.firstName = curBook.authorFirstName;
                      foundAuthor.lastName = curBook.authorLastName;

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
  Book newBook = Book('', '', '', '', '', '', '', '', '', '', '', '');
  Author newAuthor = Author('', '', '', '', '', '');
  Iterable<Author> _authorsExistedInList = [];
  bool _authorListVisible = false;
  TextEditingController _authorNameController = TextEditingController();
  int _statusIndex = 0;
  double _ratingIndex = 3.0;

  await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return FutureBuilder(
              future: DefaultAssetBundle.of(context)
                  .loadString('assets/jsondatabase/author_data.json'),
              builder: (context, snapshot) {
                if (snapshot.data.toString().isEmpty) {
                  getAuthorsFromBook();
                } else if (snapshot.hasData && mainAuthorListCopy.isEmpty) {
                  var jsonResponse = jsonDecode(snapshot.data.toString());
                  convertauthorData(jsonResponse);
                  //debugPrint('test ${jsonResponse}');
                }
                //Build table
                return AlertDialog(
                  contentPadding:
                      const EdgeInsets.only(top: 16, left: 16, bottom: 16),
                  content: Container(
                      constraints: const BoxConstraints(minWidth: 400),
                      //padding: const EdgeInsets.only(right: 20),
                      child: SingleChildScrollView(
                          child: Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: Row(children: <Widget>[
                                Expanded(
                                    child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    const Text('Add Book',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700)),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            child: Container(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: TextFormField(
                                              onChanged: (text) =>
                                                  {newBook.title = text},
                                              autofocus: true,
                                              decoration: const InputDecoration(
                                                //icon: Icon(Icons.person),
                                                hintText: '',
                                                labelText: 'Title',
                                              )),
                                        )),
                                      ],
                                    ),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                              child: Container(
                                            padding: const EdgeInsets.only(
                                                right: 10),
                                            child: TextFormField(
                                                onChanged: (text) =>
                                                    {newBook.edition = text},
                                                decoration:
                                                    const InputDecoration(
                                                  //icon: Icon(Icons.person),
                                                  hintText: '',
                                                  labelText: 'Edition',
                                                )),
                                          )),
                                          Expanded(
                                              child: Container(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: TextFormField(
                                                onChanged: (text) =>
                                                    {newBook.id = text},
                                                decoration:
                                                    const InputDecoration(
                                                  //icon: Icon(Icons.person),
                                                  hintText: '',
                                                  labelText: 'ID',
                                                )),
                                          )),
                                        ]),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            child: Column(children: [
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                    child: Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 10),
                                                  child: TextFormField(
                                                      controller:
                                                          _authorNameController,
                                                      onChanged: (text) => {
                                                            setState(
                                                              () {
                                                                _authorsExistedInList = mainAuthorListCopy.where((element) => element
                                                                    .firstName
                                                                    .toLowerCase()
                                                                    .contains(text
                                                                        .toLowerCase()));
                                                                if (_authorsExistedInList
                                                                    .isEmpty) {
                                                                  newBook.authorFirstName =
                                                                      text;
                                                                  newAuthor
                                                                          .firstName =
                                                                      text;
                                                                }

                                                                if (_authorsExistedInList
                                                                        .isNotEmpty &&
                                                                    text.isNotEmpty) {
                                                                  _authorListVisible =
                                                                      true;
                                                                } else {
                                                                  _authorListVisible =
                                                                      false;
                                                                }
                                                              },
                                                            )
                                                          },
                                                      decoration:
                                                          const InputDecoration(
                                                        //icon: Icon(Icons.person),
                                                        hintText: '',
                                                        labelText:
                                                            'Author\'s First Name',
                                                      )),
                                                )),
                                                Expanded(
                                                    child: Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child: TextFormField(
                                                      controller:
                                                          TextEditingController()
                                                            ..text = newAuthor
                                                                .lastName,
                                                      onChanged: (text) => {
                                                            newAuthor.lastName =
                                                                text,
                                                            newBook.authorLastName =
                                                                text
                                                          },
                                                      autofocus: false,
                                                      decoration: const InputDecoration(
                                                          labelText:
                                                              'Author\'s Last Name',
                                                          hintText:
                                                              'Author\'s Last Name')),
                                                )),
                                              ]),
                                          Stack(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 15),
                                                child: Column(
                                                  children: [
                                                    TextField(
                                                        controller:
                                                            TextEditingController()
                                                              ..text =
                                                                  newAuthor.id,
                                                        onChanged: (text) => {
                                                              newAuthor.id =
                                                                  text,
                                                              newBook.authorID =
                                                                  text
                                                            },
                                                        autofocus: false,
                                                        decoration:
                                                            const InputDecoration(
                                                                labelText:
                                                                    'Author\'s ID:',
                                                                hintText:
                                                                    'Author ID')),
                                                    TextField(
                                                        controller:
                                                            TextEditingController()
                                                              ..text = newAuthor
                                                                  .yearBirth,
                                                        onChanged: (text) => {
                                                              newAuthor
                                                                      .yearBirth =
                                                                  text
                                                            },
                                                        autofocus: false,
                                                        decoration:
                                                            const InputDecoration(
                                                                labelText:
                                                                    'Author\'s Year of Birth:',
                                                                hintText:
                                                                    'YYYY')),
                                                    TextField(
                                                        controller:
                                                            TextEditingController()
                                                              ..text = newAuthor
                                                                  .yearDead,
                                                        onChanged: (text) => {
                                                              newAuthor
                                                                      .yearDead =
                                                                  text
                                                            },
                                                        autofocus: false,
                                                        decoration:
                                                            const InputDecoration(
                                                                labelText:
                                                                    'Author\'s Year of Dead:',
                                                                hintText:
                                                                    'YYYY')),
                                                    TextField(
                                                        controller:
                                                            TextEditingController()
                                                              ..text = newAuthor
                                                                  .description,
                                                        onChanged: (text) => {
                                                              newAuthor
                                                                      .description =
                                                                  text
                                                            },
                                                        autofocus: false,
                                                        decoration:
                                                            const InputDecoration(
                                                                labelText:
                                                                    'Author\'s Description:',
                                                                hintText:
                                                                    'Optional')),
                                                  ],
                                                ),
                                              ),
                                              if (_authorListVisible)
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .canvasColor,
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .only(
                                                              topLeft: Radius
                                                                  .circular(0),
                                                              topRight: Radius
                                                                  .circular(0),
                                                              bottomLeft: Radius
                                                                  .circular(5),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          5)),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Theme.of(
                                                                  context)
                                                              .shadowColor
                                                              .withOpacity(0.4),
                                                          spreadRadius: 2,
                                                          blurRadius: 2,
                                                          offset: const Offset(
                                                              0,
                                                              1), // changes position of shadow
                                                        ),
                                                      ]),
                                                  width: 385,
                                                  height: (55 *
                                                          double.parse(
                                                              _authorsExistedInList
                                                                  .length
                                                                  .toString())) +
                                                      5,
                                                  constraints:
                                                      const BoxConstraints(
                                                          maxHeight: 205,
                                                          minWidth: 385,
                                                          maxWidth:
                                                              double.maxFinite),
                                                  child: ListView(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10,
                                                              right: 11,
                                                              top: 2.5,
                                                              bottom: 5),
                                                      controller:
                                                          ScrollController(),
                                                      children: [
                                                        for (var author
                                                            in _authorsExistedInList)
                                                          Card(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 5),
                                                            elevation: 3,
                                                            clipBehavior:
                                                                Clip.antiAlias,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                5),
                                                                    side:
                                                                        BorderSide(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .cardColor
                                                                          .withOpacity(
                                                                              0.3),
                                                                      width: 1,
                                                                    )),
                                                            child: ListTile(
                                                              dense: true,
                                                              visualDensity:
                                                                  const VisualDensity(
                                                                      horizontal:
                                                                          0,
                                                                      vertical:
                                                                          -4),
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          10.0,
                                                                      vertical:
                                                                          0.0),
                                                              onTap: () {
                                                                setState(
                                                                  () {
                                                                    newBook.authorFirstName =
                                                                        author
                                                                            .firstName;
                                                                    newBook.authorLastName =
                                                                        author
                                                                            .lastName;
                                                                    newBook.authorID =
                                                                        author
                                                                            .id;
                                                                    newAuthor =
                                                                        author;
                                                                    _authorNameController
                                                                            .text =
                                                                        author
                                                                            .firstName;
                                                                    newBook.authorFirstName =
                                                                        _authorNameController
                                                                            .text;
                                                                    _authorListVisible =
                                                                        false;
                                                                    _authorsExistedInList =
                                                                        [];
                                                                  },
                                                                );
                                                              },
                                                              // leading:
                                                              //     const Icon(Icons.person),
                                                              title: Text(
                                                                author.firstName +
                                                                    ' ' +
                                                                    author
                                                                        .lastName,
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            15),
                                                              ),
                                                              subtitle: Text(
                                                                'ID: ${author.id}',
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            14),
                                                              ),
                                                              trailing:
                                                                  const Icon(
                                                                      Icons
                                                                          .add),
                                                              isThreeLine:
                                                                  false,
                                                            ),
                                                          ),
                                                      ]),
                                                ),
                                            ],
                                          ),
                                        ])),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            child: Container(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: TextFormField(
                                              onChanged: (text) =>
                                                  {newBook.publisher = text},
                                              decoration: const InputDecoration(
                                                //icon: Icon(Icons.person),
                                                hintText: '',
                                                labelText: 'Publisher',
                                              )),
                                        )),
                                        Expanded(
                                            child: Container(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: TextFormField(
                                              onChanged: (text) =>
                                                  {newBook.publishDate = text},
                                              decoration: const InputDecoration(
                                                //icon: Icon(Icons.person),
                                                hintText: '',
                                                labelText: 'Publish Date',
                                              )),
                                        )),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            child: Container(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: TextFormField(
                                              onChanged: (text) =>
                                                  {newBook.cost = text},
                                              decoration: const InputDecoration(
                                                //icon: Icon(Icons.person),
                                                hintText: '',
                                                labelText: 'Cost',
                                              )),
                                        )),
                                        Expanded(
                                            child: Container(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: TextFormField(
                                              onChanged: (text) =>
                                                  {newBook.retailPrice = text},
                                              decoration: const InputDecoration(
                                                //icon: Icon(Icons.person),
                                                hintText: '',
                                                labelText: 'Retail Price',
                                              )),
                                        )),
                                      ],
                                    ),
                                    Container(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Column(children: [
                                          Text(
                                            'Condition',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .hintColor),
                                          ),
                                          RatingBar.builder(
                                            itemSize: 40,
                                            initialRating: _ratingIndex,
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: false,
                                            itemCount: 5,
                                            itemPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 4.0),
                                            itemBuilder: (context, _) =>
                                                const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            onRatingUpdate: (rating) {
                                              if (rating == 1.0) {
                                                _ratingIndex = 1.0;
                                              } else if (rating == 2.0) {
                                                _ratingIndex = 2.0;
                                              } else if (rating == 3.0) {
                                                _ratingIndex = 3.0;
                                              } else if (rating == 4.0) {
                                                _ratingIndex = 4.0;
                                              } else if (rating == 5.0) {
                                                _ratingIndex = 5.0;
                                              }
                                            },
                                          )
                                        ])),
                                    Container(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Column(children: [
                                          Container(
                                            //alignment: const Alignment(-1, 0),
                                            padding: const EdgeInsets.only(
                                                bottom: 5),
                                            child: Text(
                                              'Status',
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .hintColor),
                                            ),
                                          ),
                                          ToggleSwitch(
                                            minWidth: 110.0,
                                            minHeight: 30,
                                            // borderColor: [
                                            //   Theme.of(context)
                                            //       .hintColor
                                            // ],
                                            // borderWidth: 1.5,
                                            initialLabelIndex: _statusIndex,
                                            cornerRadius: 5,
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
                                                _statusIndex = 0;
                                              } else if (index == 1) {
                                                _statusIndex = 1;
                                              }
                                            },
                                          )
                                        ]))
                                  ],
                                ))
                              ])))),
                  actions: <Widget>[
                    ElevatedButton(
                        child: const Text('CANCEL'),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                    ElevatedButton(
                        child: const Text('ADD'),
                        onPressed: () {
                          if (_statusIndex == 0) {
                            newBook.sold = 'Available';
                          } else if (_statusIndex == 1) {
                            newBook.sold = 'Sold';
                          }

                          if (_ratingIndex == 1.0) {
                            newBook.condition = 'Poor';
                          } else if (_ratingIndex == 2.0) {
                            newBook.condition = 'Fair';
                          } else if (_ratingIndex == 3.0) {
                            newBook.condition = 'Good';
                          } else if (_ratingIndex == 4.0) {
                            newBook.condition = 'Excellent';
                          } else if (_ratingIndex == 5.0) {
                            newBook.condition = 'Superb';
                          }
                          //Update Book List
                          // for (var item in newBook.allInfoHeaders) {
                          //   newBook.setInfo(item);
                          // }
                          mainBookList.add(newBook);
                          mainBookListCopy.add(newBook);

                          //Update Author List
                          if ((mainAuthorListCopy.indexWhere(
                                  (element) => element.id == newAuthor.id) ==
                              -1)) {
                            mainAuthorList.add(newAuthor);
                            mainAuthorListCopy.add(newAuthor);
                          }

                          //write to json
                          if (!kIsWeb) {
                            mainAuthorList
                                .map(
                                  (author) => author.toJson(),
                                )
                                .toList();
                            authorDataJson
                                .writeAsStringSync(json.encode(mainAuthorList));
                          }

                          if (!kIsWeb) {
                            mainBookListCopy
                                .map(
                                  (book) => book.toJson(),
                                )
                                .toList();
                            bookDataJson.writeAsStringSync(
                                json.encode(mainBookListCopy));
                          }
                          Navigator.pop(context);
                          //debugPrint(newBook.allInfo.toString());
                        })
                  ],
                );
              });
        });
      });
}

//JSON Helper
void convertBookData(var jsonResponse) {
  for (var b in jsonResponse) {
    Book book = Book(
        b['title'],
        b['id'],
        b['authorFirstName'],
        b['authorLastName'],
        b['authorID'],
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
    mainBookList.first = Book('', '', '', '', '', '', '', '', '', '', '', '');
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
