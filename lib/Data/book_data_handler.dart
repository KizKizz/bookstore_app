// ignore_for_file: avoid_print, avoid_renaming_method_parameters

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:data_table_2/data_table_2.dart';

final File bookDataJson = File('assets/jsondatabase/book_data.json');
List<Book> _books = [];

// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// The file was extracted from GitHub: https://github.com/flutter/gallery
// Changes and modifications by Maxim Saplin, 2021

/// Keeps track of selected rows, feed the data into DesertsDataSource
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
  int publishDate;
  double edition;
  double cost;
  double retailPrice;
  String condition;
  String sold;

  bool selected = false;

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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['id'] = this.id;
    data['author'] = this.author;
    data['publisher'] = this.publisher;
    data['publishDate'] = this.publishDate;
    data['edition'] = this.edition;
    data['cost'] = this.cost;
    data['retailPrice'] = this.retailPrice;
    data['condition'] = this.condition;
    data['sold'] = this.sold;

    return data;
  }
}

/// Data source implementing standard Flutter's DataTableSource abstract class
/// which is part of DataTable and PaginatedDataTable synchronous data fecthin API.
/// This class uses static collection of deserts as a data store, projects it into
/// DataRows, keeps track of selected items, provides sprting capability
class BookDatabase extends DataTableSource {
  BookDatabase.empty(this.context) {
    books = [];
  }

  BookDatabase(this.context,
      [sortedByName = true,
      this.hasRowTaps = true,
      this.hasRowHeightOverrides = false]) {
    ///readBookData(bookDataJson);
    books = _books;
    if (sortedByName) {
      sort((d) => d.title, true);
    }
    //notifyListeners();
  }

  final BuildContext context;
  late List<Book> books;
  late bool hasRowTaps;
  late bool hasRowHeightOverrides;

  void sort<T>(Comparable<T> Function(Book d) getField, bool ascending) {
    books.sort((a, b) {
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
                _showDialog(context, book),
                notifyListeners()
                // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                //   duration: const Duration(seconds: 1),
                //   content: Text('Tapped on ${book.title}'),
                // )),

                // _books[_books.indexOf(book)].author = 'Pending',
                // notifyListeners(),
                // _books.forEach((element) {
                // if (element.id == book.id) {
                //   debugPrint('Value for field "${element.author}"');
                //   element.author = 'TestChange';

                // }
                // notifyListeners();
                // }),
              ]
          : null,
      onDoubleTap: hasRowTaps
          ? () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                duration: const Duration(seconds: 1),
                //backgroundColor: Theme.of(context).focusColor,
                content: Text('Double Tapped on ${book.title}'),
              ))
          : null,
      onSecondaryTap: hasRowTaps
          ? () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                duration: const Duration(seconds: 1),
                backgroundColor: Theme.of(context).errorColor,
                content: Text('Right clicked on ${book.title}'),
              ))
          : null,
      specificRowHeight: hasRowHeightOverrides && book.cost >= 25 ? 100 : null,
      cells: [
        DataCell(Text(book.title)),
        DataCell(Text(book.id)),
        DataCell(Text(book.author)),
        DataCell(Text(book.publisher)),
        DataCell(Text(book.publishDate.toString())),
        DataCell(Text(book.edition.toString())),
        DataCell(Text(book.cost.toString())),
        DataCell(Text(book.retailPrice.toString())),
        DataCell(Text(book.condition)),
        DataCell(Text(book.sold.toString())),
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

  //Custom dialog handles
  _showDialog(context, Book curBook) async {
    TextEditingController _titleTextcontroller =
        TextEditingController(text: curBook.title);
    TextEditingController _idTextcontroller =
        TextEditingController(text: curBook.id);
    TextEditingController _authorTextcontroller =
        TextEditingController(text: curBook.author);
    TextEditingController _publisherTextcontroller =
        TextEditingController(text: curBook.publisher);
    TextEditingController _publishDateTextcontroller =
        TextEditingController(text: curBook.publishDate.toString());
    TextEditingController _editionTextcontroller =
        TextEditingController(text: curBook.edition.toString());
    TextEditingController _costTextcontroller =
        TextEditingController(text: curBook.cost.toString());
    TextEditingController _retailPriceTextcontroller =
        TextEditingController(text: curBook.retailPrice.toString());
    TextEditingController _conditionTextcontroller =
        TextEditingController(text: curBook.condition);
    TextEditingController _soldTextcontroller =
        TextEditingController(text: curBook.sold);

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
                      Text('Edit Book Info'),
                      TextField(
                          controller: _titleTextcontroller,
                          autofocus: true,
                          decoration: const InputDecoration(
                              labelText: 'Title',
                              hintText: 'Title of the book')),
                      TextField(
                        controller: _idTextcontroller,
                        autofocus: true,
                        decoration: const InputDecoration(
                            labelText: 'ID', hintText: 'ID of the book'),
                      ),
                      TextField(
                        controller: _authorTextcontroller,
                        autofocus: true,
                        decoration: const InputDecoration(
                            labelText: 'Author',
                            hintText: 'Author of the book'),
                      ),
                      TextField(
                        controller: _publisherTextcontroller,
                        autofocus: true,
                        decoration: const InputDecoration(
                            labelText: 'Publisher',
                            hintText: 'Publisher of the book'),
                      ),
                      TextField(
                        controller: _publishDateTextcontroller,
                        autofocus: true,
                        decoration: const InputDecoration(
                            labelText: 'Publish Date',
                            hintText: 'Publish date of the book'),
                      ),
                      TextField(
                        controller: _editionTextcontroller,
                        decoration: const InputDecoration(
                            labelText: 'Edition',
                            hintText: 'Edition of the book'),
                      ),
                      TextField(
                        controller: _costTextcontroller,
                        autofocus: true,
                        decoration: const InputDecoration(
                            labelText: 'Cost', hintText: 'Cost of the book'),
                      ),
                      TextField(
                        controller: _retailPriceTextcontroller,
                        autofocus: true,
                        decoration: const InputDecoration(
                            labelText: 'Retail Price',
                            hintText: 'Retail Price of the book'),
                      ),
                      TextField(
                        controller: _conditionTextcontroller,
                        autofocus: true,
                        decoration: const InputDecoration(
                            labelText: 'Condition',
                            hintText: 'Condition of the book'),
                      ),
                      TextField(
                        controller: _soldTextcontroller,
                        autofocus: true,
                        decoration: const InputDecoration(
                            labelText: 'Sold status',
                            hintText: 'Sale status of the book'),
                      ),
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
                      curBook.title = _titleTextcontroller.text;
                      curBook.id = _idTextcontroller.text;
                      curBook.author = _authorTextcontroller.text;
                      curBook.publisher = _publisherTextcontroller.text;
                      var pubDate = int.parse(_publishDateTextcontroller.text);
                      assert(pubDate is int);
                      curBook.publishDate = pubDate;
                      var editionConvert =
                          double.parse(_editionTextcontroller.text);
                      assert(editionConvert is double);
                      curBook.edition = editionConvert;
                      var costConvert =
                          double.parse(_costTextcontroller.text);
                      assert(costConvert is double);
                      curBook.cost = costConvert;
                      var retailConvert =
                          double.parse(_retailPriceTextcontroller.text);
                      assert(retailConvert is double);
                      curBook.retailPrice = retailConvert;
                      curBook.condition = _conditionTextcontroller.text;
                      curBook.sold = _soldTextcontroller.text;

                      notifyListeners();
                      Navigator.pop(context);
                    })
              ],
            ),
          );
        });
  }
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
    _books.add(book);
  }
  //debugPrint('test ${_books.length}');
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
