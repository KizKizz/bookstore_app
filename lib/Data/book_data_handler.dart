// ignore_for_file: avoid_print, avoid_renaming_method_parameters, curly_braces_in_flow_control_structures

import 'dart:convert';

import 'package:bookstore_app/Extra/id_generator.dart';
import 'package:bookstore_app/login_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../InfoScreens/book_list.dart';
import 'author_data_handler.dart';
import 'data_storage_helper.dart';

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
  Book(this.title, this.id, this.authorFirstName, this.authorLastName, this.authorID, this.publisher, this.publishDate, this.edition, this.cost, this.retailPrice, this.condition, this.sold);

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
  List editResults = List.filled(12, null);

  List get allInfo {
    return [title, id, authorFirstName, authorLastName, authorID, publisher, publishDate, edition, cost, retailPrice, condition, sold];
  }

  List get allInfoHeaders {
    return ['Title', 'ID', 'Author First Name', 'Author Last Name', 'Author ID', 'Publisher', 'Publish Date', 'Edition', 'Cost', 'Retail Price', 'Condition', 'Sold'];
  }

  void setInfo(var info) {
    if (info == 'Title' && editResults[0] != null)
      title = editResults[0];
    else if (info == 'ID' && editResults[1] != null)
      id = editResults[1];
    else if (info == 'Author First Name' && editResults[2] != null)
      authorFirstName = editResults[2];
    else if (info == 'Author Last Name' && editResults[3] != null)
      authorLastName = editResults[3];
    else if (info == 'Author ID' && editResults[4] != null)
      authorID = editResults[4];
    else if (info == 'Publisher' && editResults[5] != null)
      publisher = editResults[5];
    else if (info == 'Publish Date' && editResults[6] != null)
      publishDate = editResults[6];
    else if (info == 'Edition' && editResults[7] != null)
      edition = editResults[7];
    else if (info == 'Cost' && editResults[8] != null)
      cost = editResults[8];
    else if (info == 'Retail Price' && editResults[9] != null)
      retailPrice = editResults[9];
    else if (info == 'Condition' && editResults[10] != null)
      condition = editResults[10];
    else if (info == 'Sold' && editResults[11] != null) sold = editResults[11];
  }

  void infoEdited(var info, var editedVal) {
    if (info == 'Title')
      editResults[0] = editedVal;
    else if (info == 'ID')
      editResults[1] = editedVal;
    else if (info == 'Author First Name')
      editResults[2] = editedVal;
    else if (info == 'Author Last Name')
      editResults[3] = editedVal;
    else if (info == 'Author ID')
      editResults[4] = editedVal;
    else if (info == 'Publisher')
      editResults[5] = editedVal;
    else if (info == 'Publish Date')
      editResults[6] = editedVal;
    else if (info == 'Edition')
      editResults[7] = editedVal;
    else if (info == 'Cost')
      editResults[8] = editedVal;
    else if (info == 'Retail Price')
      editResults[9] = editedVal;
    else if (info == 'Condition')
      editResults[10] = editedVal;
    else if (info == 'Sold')
      editResults[11] = editedVal;
    else
      editResults[0] = editedVal;
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

  BookDatabase(this.context, [sortedByName = true, this.hasRowTaps = true, this.hasRowHeightOverrides = false]) {
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
      final aValue = getField(a);
      final bValue = getField(b);

      return ascending ? Comparable.compare(aValue, bValue) : Comparable.compare(bValue, aValue);
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
      onTap: hasRowTaps ? () => [_showDialog(context, book)] : null,
      specificRowHeight: hasRowHeightOverrides ? 100 : null,
      cells: [
        DataCell(Text(book.id)),
        DataCell(Text(book.title)),
        DataCell(Text('${book.authorFirstName} ${book.authorLastName}')),
        DataCell(Text(book.publisher)),
        DataCell(Text(book.publishDate)),
        DataCell(Text(book.edition)),
        DataCell(Text('\$${book.cost}')),
        DataCell(Text('\$${book.retailPrice}')),
        DataCell(Text(book.condition)),
        DataCell(Text(book.sold)),
        if (book.sold.toLowerCase() == 'Available'.toLowerCase())
          DataCell(
            Tooltip(
                message: 'Add to Cart',
                textStyle: const TextStyle(fontSize: 15),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Theme.of(context).primaryColorLight), color: Theme.of(context).cardColor),
                waitDuration: const Duration(seconds: 1),
                child: MaterialButton(
                  minWidth: double.infinity,
                  height: double.infinity,
                  onPressed: () {
                    book.sold = '*In Cart';
                    checkoutCartList.add(book);
                    MenuItems.getItems(checkoutCartList);
                    notifyListeners();
                  },
                  child: const Align(alignment: Alignment.centerRight, child: Icon(Icons.add_shopping_cart)),
                )),
          )
        else if (book.sold.toLowerCase() == '*In Cart'.toLowerCase())
          DataCell(
            Tooltip(
                message: 'Remove from Cart',
                textStyle: const TextStyle(fontSize: 15),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Theme.of(context).primaryColorLight), color: Theme.of(context).cardColor),
                waitDuration: const Duration(seconds: 1),
                child: MaterialButton(
                  minWidth: double.infinity,
                  height: double.infinity,
                  onPressed: () {
                    book.sold = 'Available';
                    checkoutCartList.remove(book);
                    MenuItems.getItems(checkoutCartList);
                    notifyListeners();
                  },
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.remove_shopping_cart, color: Theme.of(context).hintColor),
                  ),
                )),
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
    double conditionRating = 1.0;
    int statusRating = 0;
    if (curBook.condition == 'Poor') {
      conditionRating = 1.0;
    } else if (curBook.condition == 'Fair') {
      conditionRating = 2.0;
    } else if (curBook.condition == 'Good') {
      conditionRating = 3.0;
    } else if (curBook.condition == 'Exellent') {
      conditionRating = 4.0;
    } else if (curBook.condition == 'Superb') {
      conditionRating = 5.0;
    }
    if (curBook.sold == 'Available') {
      statusRating = 0;
    } else if (curBook.sold == 'Sold') {
      statusRating = 1;
    }

    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return _SystemPadding(
            child: AlertDialog(
              titlePadding: const EdgeInsets.only(top: 10),
              title: const Center(
                child: Center(
                  child: Text('Book Info', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
              contentPadding: const EdgeInsets.only(top: 10, left: 16, bottom: 10),
              content: Container(
                width: 400,
                constraints: const BoxConstraints(maxWidth: 400),
                child: SingleChildScrollView(
                    child: Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: AbsorbPointer(
                          absorbing: !isManager,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                  child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          child: Container(
                                        padding: const EdgeInsets.only(right: 10),
                                        child: TextFormField(
                                            controller: TextEditingController()..text = curBook.title,
                                            onChanged: (text) => {curBook.infoEdited('Title', text)},
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
                                            controller: TextEditingController()..text = curBook.edition,
                                            onChanged: (text) => {curBook.infoEdited('Edition', text)},
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
                                            enabled: false,
                                            controller: TextEditingController()..text = curBook.id,
                                            onChanged: (text) => {curBook.infoEdited('ID', text)},
                                            decoration: const InputDecoration(
                                              //icon: Icon(Icons.person),
                                              hintText: '',
                                              labelText: 'ID',
                                            )),
                                      )),
                                    ],
                                  ),
                                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                                    Expanded(
                                        child: Container(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: TextFormField(
                                          controller: TextEditingController()..text = curBook.authorFirstName,
                                          onChanged: (text) => {curBook.infoEdited('Author First Name', text)},
                                          decoration: const InputDecoration(
                                            //icon: Icon(Icons.person),
                                            hintText: '',
                                            labelText: 'Author\'s First Name',
                                          )),
                                    )),
                                    Expanded(
                                        child: Container(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: TextFormField(
                                          controller: TextEditingController()..text = curBook.authorLastName,
                                          onChanged: (text) => {curBook.infoEdited('Author Last Name', text)},
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
                                            controller: TextEditingController()..text = curBook.publisher,
                                            onChanged: (text) => {curBook.infoEdited('Publisher', text)},
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
                                            controller: TextEditingController()..text = curBook.publishDate,
                                            onChanged: (text) => {curBook.infoEdited('Publish Date', text)},
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
                                            controller: TextEditingController()..text = curBook.cost,
                                            onChanged: (text) => {curBook.infoEdited('Cost', text)},
                                            decoration: const InputDecoration(
                                              //icon: Icon(Icons.person),
                                              prefixText: '\$',
                                              hintText: '',
                                              labelText: 'Cost',
                                            )),
                                      )),
                                      Expanded(
                                          child: Container(
                                        padding: const EdgeInsets.only(left: 10),
                                        child: TextFormField(
                                            controller: TextEditingController()..text = curBook.retailPrice,
                                            onChanged: (text) => {curBook.infoEdited('Retail Price', text)},
                                            decoration: const InputDecoration(
                                              //icon: Icon(Icons.person),
                                              prefixText: '\$',
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
                                          style: TextStyle(fontSize: 14, color: Theme.of(context).hintColor),
                                        ),
                                        RatingBar.builder(
                                          itemSize: 40,
                                          initialRating: conditionRating,
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: false,
                                          itemCount: 5,
                                          itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                                          itemBuilder: (context, _) => const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          onRatingUpdate: (rating) {
                                            if (rating == 1.0) {
                                              curBook.infoEdited('Condition', 'Poor');
                                            } else if (rating == 2.0) {
                                              curBook.infoEdited('Condition', 'Fair');
                                            } else if (rating == 3.0) {
                                              curBook.infoEdited('Condition', 'Good');
                                            } else if (rating == 4.0) {
                                              curBook.infoEdited('Condition', 'Excellent');
                                            } else if (rating == 5.0) {
                                              curBook.infoEdited('Condition', 'Superb');
                                            }
                                          },
                                        )
                                      ])),
                                  Container(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Column(children: [
                                        Container(
                                          //alignment: const Alignment(-1, 0),
                                          padding: const EdgeInsets.only(bottom: 5),
                                          child: Text(
                                            'Status',
                                            style: TextStyle(fontSize: 14, color: Theme.of(context).hintColor),
                                          ),
                                        ),
                                        ToggleSwitch(
                                          minWidth: 110,
                                          minHeight: 30,
                                          // borderColor: [
                                          //   Theme.of(context).hintColor
                                          // ],
                                          // borderWidth: 1,
                                          initialLabelIndex: statusRating,
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
                                              curBook.infoEdited('Sold', 'Available');
                                            } else if (index == 1) {
                                              curBook.infoEdited('Sold', 'Sold');
                                            }
                                          },
                                        )
                                      ]))
                                ],
                              ))
                            ],
                          ),
                        ))),
              ),
              actions: <Widget>[
                if (!isManager)
                  ElevatedButton(
                      child: const Text('CLOSE'),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                if (isManager)
                  ElevatedButton(
                      child: const Text('CANCEL'),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                if (isManager)
                  ElevatedButton(
                      child: const Text('SAVE'),
                      onPressed: () async {
                        int bookMatchIndex = mainBookListCopy.indexWhere((element) => element.id == curBook.id);
                        //debugPrint('curafter: ${_bookMatchIndex}');
                        for (var item in curBook.allInfoHeaders) {
                          curBook.setInfo(item);
                        }

                        if (bookMatchIndex >= 0) {
                          mainBookListCopy[bookMatchIndex] = curBook;
                        }

                        //Fetch author data to update
                        Author matchAuthor = mainAuthorListCopy.firstWhere((element) => element.id == curBook.authorID);
                        matchAuthor.firstName = curBook.authorFirstName;
                        matchAuthor.lastName = curBook.authorLastName;

                        notifyListeners();

                        if (!kIsWeb) {
                          localDatabaseUpdate('authors');
                          localDatabaseUpdate('books');
                        }
                        Navigator.pop(context);
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
  Iterable<Author> authorsExistedInList = [];
  bool authorListVisible = false;
  TextEditingController authorNameController = TextEditingController();
  int statusIndex = 0;
  double ratingIndex = 3.0;
  newBook.id = idGenerator('B');
  newAuthor.id = idGenerator('A');

  await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return FutureBuilder(
              future: DefaultAssetBundle.of(context).loadString('assets/jsondatabase/author_data.json'),
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
                  titlePadding: const EdgeInsets.only(top: 10),
                  title: const Center(
                    child: Text('Add Book', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                  contentPadding: const EdgeInsets.only(top: 10, left: 16, bottom: 10),
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
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            child: Container(
                                          padding: const EdgeInsets.only(right: 10),
                                          child: TextFormField(
                                              onChanged: (text) => {newBook.title = text},
                                              autofocus: true,
                                              decoration: const InputDecoration(
                                                //icon: Icon(Icons.person),
                                                hintText: '',
                                                labelText: 'Title',
                                              )),
                                        )),
                                      ],
                                    ),
                                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                                      Expanded(
                                          child: Container(
                                        padding: const EdgeInsets.only(right: 10),
                                        child: TextFormField(
                                            onChanged: (text) => {newBook.edition = text},
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
                                            controller: TextEditingController()..text = newBook.id,
                                            enabled: false,
                                            onChanged: (text) => {newBook.id = text},
                                            decoration: const InputDecoration(
                                              //icon: Icon(Icons.person),
                                              hintText: '',
                                              labelText: 'ID',
                                            )),
                                      )),
                                    ]),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            child: Column(children: [
                                          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                                            Expanded(
                                                child: Container(
                                              padding: const EdgeInsets.only(right: 10),
                                              child: TextFormField(
                                                  controller: authorNameController,
                                                  onChanged: (text) => {
                                                        setState(
                                                          () {
                                                            authorsExistedInList = mainAuthorListCopy.where((element) => element.firstName.toLowerCase().contains(text.toLowerCase()));
                                                            if (authorsExistedInList.isEmpty) {
                                                              newBook.authorFirstName = text;
                                                              newAuthor.firstName = text;
                                                            }

                                                            if (authorsExistedInList.isNotEmpty && text.isNotEmpty) {
                                                              authorListVisible = true;
                                                            } else {
                                                              authorListVisible = false;
                                                            }
                                                          },
                                                        )
                                                      },
                                                  decoration: const InputDecoration(
                                                    //icon: Icon(Icons.person),
                                                    hintText: '',
                                                    labelText: 'Author\'s First Name',
                                                  )),
                                            )),
                                            Expanded(
                                                child: Container(
                                              padding: const EdgeInsets.only(left: 10),
                                              child: TextFormField(
                                                  controller: TextEditingController()..text = newAuthor.lastName,
                                                  onChanged: (text) => {newAuthor.lastName = text, newBook.authorLastName = text},
                                                  autofocus: false,
                                                  decoration: const InputDecoration(labelText: 'Author\'s Last Name', hintText: 'Author\'s Last Name')),
                                            )),
                                          ]),
                                          Stack(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(left: 15),
                                                child: Column(
                                                  children: [
                                                    TextFormField(
                                                        enabled: false,
                                                        controller: TextEditingController()..text = newAuthor.id,
                                                        onChanged: (text) => {newAuthor.id = text, newBook.authorID = text},
                                                        autofocus: false,
                                                        decoration: const InputDecoration(labelText: 'Author\'s ID:', hintText: 'Author ID')),
                                                    TextFormField(
                                                        controller: TextEditingController()..text = newAuthor.yearBirth,
                                                        onChanged: (text) => {newAuthor.yearBirth = text},
                                                        autofocus: false,
                                                        decoration: const InputDecoration(labelText: 'Author\'s Year of Birth:', hintText: 'YYYY')),
                                                    TextFormField(
                                                        controller: TextEditingController()..text = newAuthor.yearDead,
                                                        onChanged: (text) => {newAuthor.yearDead = text},
                                                        autofocus: false,
                                                        decoration: const InputDecoration(labelText: 'Author\'s Year of Dead:', hintText: 'YYYY')),
                                                    TextFormField(
                                                        controller: TextEditingController()..text = newAuthor.description,
                                                        onChanged: (text) => {newAuthor.description = text},
                                                        autofocus: false,
                                                        decoration: const InputDecoration(labelText: 'Author\'s Description:', hintText: 'Optional')),
                                                  ],
                                                ),
                                              ),
                                              if (authorListVisible)
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: Theme.of(context).canvasColor,
                                                      borderRadius: const BorderRadius.only(
                                                          topLeft: Radius.circular(0), topRight: Radius.circular(0), bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5)),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Theme.of(context).shadowColor.withOpacity(0.4),
                                                          spreadRadius: 2,
                                                          blurRadius: 2,
                                                          offset: const Offset(0, 1), // changes position of shadow
                                                        ),
                                                      ]),
                                                  width: 385,
                                                  height: (55 * double.parse(authorsExistedInList.length.toString())) + 5,
                                                  constraints: const BoxConstraints(maxHeight: 205, minWidth: 385, maxWidth: double.maxFinite),
                                                  child: ListView(padding: const EdgeInsets.only(left: 10, right: 11, top: 2.5, bottom: 5), controller: ScrollController(), children: [
                                                    for (var author in authorsExistedInList)
                                                      Card(
                                                        margin: const EdgeInsets.only(top: 5),
                                                        elevation: 3,
                                                        clipBehavior: Clip.antiAlias,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(5),
                                                            side: BorderSide(
                                                              color: Theme.of(context).cardColor.withOpacity(0.3),
                                                              width: 1,
                                                            )),
                                                        child: ListTile(
                                                          dense: true,
                                                          visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                                                          contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
                                                          onTap: () {
                                                            setState(
                                                              () {
                                                                newBook.authorFirstName = author.firstName;
                                                                newBook.authorLastName = author.lastName;
                                                                newBook.authorID = author.id;
                                                                newAuthor = author;
                                                                authorNameController.text = author.firstName;
                                                                newBook.authorFirstName = authorNameController.text;
                                                                authorListVisible = false;
                                                                authorsExistedInList = [];
                                                              },
                                                            );
                                                          },
                                                          // leading:
                                                          //     const Icon(Icons.person),
                                                          title: Text(
                                                            '${author.firstName} ${author.lastName}',
                                                            style: const TextStyle(fontSize: 15),
                                                          ),
                                                          subtitle: Text(
                                                            'ID: ${author.id}',
                                                            style: const TextStyle(fontSize: 14),
                                                          ),
                                                          trailing: const Icon(Icons.add),
                                                          isThreeLine: false,
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
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            child: Container(
                                          padding: const EdgeInsets.only(right: 10),
                                          child: TextFormField(
                                              onChanged: (text) => {newBook.publisher = text},
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
                                              onChanged: (text) => {newBook.publishDate = text},
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
                                              onChanged: (text) => {newBook.cost = text},
                                              decoration: const InputDecoration(
                                                //icon: Icon(Icons.person),
                                                prefixText: '\$',
                                                hintText: '',
                                                labelText: 'Cost',
                                              )),
                                        )),
                                        Expanded(
                                            child: Container(
                                          padding: const EdgeInsets.only(left: 10),
                                          child: TextFormField(
                                              onChanged: (text) => {newBook.retailPrice = text},
                                              decoration: const InputDecoration(
                                                //icon: Icon(Icons.person),
                                                prefixText: '\$',
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
                                            style: TextStyle(color: Theme.of(context).hintColor),
                                          ),
                                          RatingBar.builder(
                                            itemSize: 40,
                                            initialRating: ratingIndex,
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: false,
                                            itemCount: 5,
                                            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                                            itemBuilder: (context, _) => const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            onRatingUpdate: (rating) {
                                              if (rating == 1.0) {
                                                ratingIndex = 1.0;
                                              } else if (rating == 2.0) {
                                                ratingIndex = 2.0;
                                              } else if (rating == 3.0) {
                                                ratingIndex = 3.0;
                                              } else if (rating == 4.0) {
                                                ratingIndex = 4.0;
                                              } else if (rating == 5.0) {
                                                ratingIndex = 5.0;
                                              }
                                            },
                                          )
                                        ])),
                                    Container(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Column(children: [
                                          Container(
                                            //alignment: const Alignment(-1, 0),
                                            padding: const EdgeInsets.only(bottom: 5),
                                            child: Text(
                                              'Status',
                                              style: TextStyle(color: Theme.of(context).hintColor),
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
                                            initialLabelIndex: statusIndex,
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
                                                statusIndex = 0;
                                              } else if (index == 1) {
                                                statusIndex = 1;
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
                          if (statusIndex == 0) {
                            newBook.sold = 'Available';
                          } else if (statusIndex == 1) {
                            newBook.sold = 'Sold';
                          }

                          if (ratingIndex == 1.0) {
                            newBook.condition = 'Poor';
                          } else if (ratingIndex == 2.0) {
                            newBook.condition = 'Fair';
                          } else if (ratingIndex == 3.0) {
                            newBook.condition = 'Good';
                          } else if (ratingIndex == 4.0) {
                            newBook.condition = 'Excellent';
                          } else if (ratingIndex == 5.0) {
                            newBook.condition = 'Superb';
                          }
                          //Update Book List
                          // for (var item in newBook.allInfoHeaders) {
                          //   newBook.setInfo(item);
                          // }
                          mainBookList.add(newBook);
                          mainBookListCopy.add(newBook);

                          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          //   duration: const Duration(seconds: 1),
                          //   //backgroundColor: Theme.of(context).focusColor,
                          //   content: Text(
                          //       'File found at ${bookDataJson.existsSync().toString()}'),
                          // ));

                          //Update Author List
                          if ((mainAuthorListCopy.indexWhere((element) => element.id == newAuthor.id) == -1)) {
                            mainAuthorList.add(newAuthor);
                            mainAuthorListCopy.add(newAuthor);
                          }

                          //write to json
                          if (!kIsWeb) {
                            localDatabaseUpdate('books');
                            localDatabaseUpdate('authors');
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
    Book book =
        Book(b['title'], b['id'], b['authorFirstName'], b['authorLastName'], b['authorID'], b['publisher'], b['publishDate'], b['edition'], b['cost'], b['retailPrice'], b['condition'], b['sold']);
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
    return AnimatedContainer(padding: mediaQuery.viewInsets, duration: const Duration(milliseconds: 300), child: child);
  }
}
