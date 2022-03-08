// ignore_for_file: avoid_print, avoid_renaming_method_parameters

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:provider/provider.dart';

import '../table_provider.dart';

final File bookDataJson = File('assets/jsondatabase/book_data.json');
List<Book> _books = [];

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
  int publishDate;
  double edition;
  double cost;
  double retailPrice;
  String condition;
  String sold;

  bool selected = false;
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
      publishDate = int.parse(editResults[4]);
    else if (info == 'Edition' && editResults[5] != null)
      edition = double.parse(editResults[5]);
    else if (info == 'Cost' && editResults[6] != null)
      cost = double.parse(editResults[6]);
    else if (info == 'Retail Price' && editResults[7] != null)
      retailPrice = double.parse(editResults[7]);
    else if (info == 'Condition' && editResults[8] != null)
      condition = editResults[8];
    else if (info == 'Sold' && editResults[9] != null)
      sold = editResults[9];
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
      return publishDate.toString();
    else if (header == 'Edition')
      return edition.toString();
    else if (header == 'Cost')
      return cost.toString();
    else if (header == 'Retail Price')
      return retailPrice.toString();
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
    books = _books;
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
      decimalDigits: 00,
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
          ? () => //_bookDataAdder()
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
//Edit Popup
                      for (var item in curBook.allInfoHeaders)
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
                      for (var item in curBook.allInfoHeaders) {
                        curBook.setInfo(item);
                      }                    
                      notifyListeners();
                      Navigator.pop(context);
                    })
              ],
            ),
          );
        });
  }
}

//Add book
Future<void> bookDataAdder(context) async {
  Book newBook = Book('', '', '', '', 0000, 00, 00, 00, '', '');
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
                      TextField(
                          // controller: TextEditingController()
                          //   ..text = item.toString(),
                          onChanged: (text) => {newBook.infoEdited(item, text)},
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
                    for (var item in newBook.allInfo) { 
                      newBook.setInfo(item);
                    }
                    _books.add(newBook);
                    debugPrint(newBook.allInfo.toString());
                    Navigator.pop(context);
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
