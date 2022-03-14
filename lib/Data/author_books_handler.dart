// ignore_for_file: avoid_print, avoid_renaming_method_parameters

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:bookstore_project/Data/book_data_handler.dart';

final File authorDataJson = File('assets/jsondatabase/author_data.json');

List<AuthorBooks> _authorBooks = [];

// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// The file was extracted from GitHub: https://github.com/flutter/gallery
// Changes and modifications by Maxim Saplin, 2021 - KizKizz 2022

/// Keeps track of selected rows, feed the data into DataSource
class RestorableauthorSelections extends RestorableProperty<Set<int>> {
  Set<int> _authorBooksSelections = {};

  // Returns whether or not a row is selected by index.
  bool isSelected(int index) => _authorBooksSelections.contains(index);

  // Takes a list of [author]s and saves the row indices of selected rows
  // into a [Set].
  void setAuthorBoooksSelections(List<AuthorBooks> authorBooks) {
    final updatedSet = <int>{};
    for (var i = 0; i < authorBooks.length; i += 1) {
      var authorbook = authorBooks[i];
      if (authorbook.selected) {
        updatedSet.add(i);
      }
    }
    _authorBooksSelections = updatedSet;
    notifyListeners();
  }

  @override
  Set<int> createDefaultValue() => _authorBooksSelections;

  @override
  Set<int> fromPrimitives(Object? data) {
    final selectedItemIndices = data as List<dynamic>;
    _authorBooksSelections = {
      ...selectedItemIndices.map<int>((dynamic id) => id as int),
    };
    return _authorBooksSelections;
  }

  @override
  void initWithValue(Set<int> value) {
    _authorBooksSelections = value;
  }

  @override
  Object toPrimitives() => _authorBooksSelections.toList();
}

/// Domain model entity
class AuthorBooks {
  AuthorBooks(
    this.title,
    this.id,
    this.sold,
  );

  String title;
  String id;
  String sold;

  bool selected = false;
  List editResults = List.filled(10, null);

  List get allInfo {
    return [
      title,
      id,
      sold,
    ];
  }

  List get allInfoHeaders {
    return [
      'Title',
      'ID',
      'SOLD',
    ];
  }

  void setInfo(var info) {
    if (info == 'Title' && editResults[0] != null)
      title = editResults[0];
    else if (info == 'ID' && editResults[1] != null)
      id = editResults[1];
    else if (info == 'SOLD' && editResults[2] != null) sold = editResults[2];
  }

  String headerToInfo(var header) {
    if (header == 'Full Name')
      return title;
    else if (header == 'ID')
      return id;
    else if (header == 'Year of Birth')
      return sold;
    else
      return 'error';
  }

  void infoEdited(var info, var editedVal) {
    if (info == 'Title')
      editResults[0] = editedVal;
    else if (info == 'ID')
      editResults[1] = editedVal;
    else if (info == 'ID')
      editResults[2] = editedVal;
    else
      editResults[0] = editedVal;
  }

  fromJson(Map<String, dynamic> json) {
    title = json['title'];
    id = json['id'];
    sold = json['sold'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['id'] = id;
    data['sold'] = sold;
    return data;
  }
}

/// Data source implementing standard Flutter's DataTableSource abstract class
/// which is part of DataTable and PaginatedDataTable synchronous data fecthin API.
/// This class uses static collection of data as a data store, projects it into
/// DataRows, keeps track of selected items, provides sprting capability
class AuthorBooksDatabase extends DataTableSource {
  AuthorBooksDatabase.empty(this.context) {
    authors = [];
  }

  AuthorBooksDatabase(this.context,
      [sortedByName = true,
      this.hasRowTaps = true,
      this.hasRowHeightOverrides = false]) {
    authors = _authorBooks;
    if (sortedByName) {
      sort((d) => d.title, true);
    }
  }

  final BuildContext context;
  late List<AuthorBooks> authors;
  late bool hasRowTaps;
  late bool hasRowHeightOverrides;

  void sort<T>(Comparable<T> Function(AuthorBooks d) getField, bool ascending) {
    authors.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
    notifyListeners();
  }

  int _selectedCount = 0;
  void updateSelectedauthors(RestorableauthorSelections selectedRows) {
    _selectedCount = 0;
    for (var i = 0; i < authors.length; i += 1) {
      var author = authors[i];
      if (selectedRows.isSelected(i)) {
        author.selected = true;
        _selectedCount += 1;
      } else {
        author.selected = false;
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
    if (index >= authors.length) throw 'index > _authors.length';
    final author = authors[index];
    return DataRow2.byIndex(
      index: index,
      selected: author.selected,
      onSelectChanged: hasRowTaps
          ? null
          : (value) {
              if (author.selected != value) {
                _selectedCount += value! ? 1 : -1;
                assert(_selectedCount >= 0);
                author.selected = value;
                notifyListeners();
              }
            },
      onTap: hasRowTaps
          ? () => [
                //_showDialog(context, author),
              ]
          : null,
      onDoubleTap: hasRowTaps
          ? () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                duration: const Duration(seconds: 1),
                //backgroundColor: Theme.of(context).focusColor,
                content: Text('Double Tapped on ${author.title}'),
              ))
          : null,
      onSecondaryTap: hasRowTaps
          ? () => //_authorDataAdder()
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                duration: const Duration(seconds: 1),
                backgroundColor: Theme.of(context).errorColor,
                content: Text('Right clicked on ${author.title}'),
              ))
          : null,
      specificRowHeight: hasRowHeightOverrides ? 100 : null,
      cells: [
        DataCell(
          Text(author.title),
        ),
        DataCell(Text(author.id)),
        DataCell(Text(author.sold)),
        DataCell(
            Container(
                //padding: const EdgeInsets.only(left: 5),
                child: const Icon(
              Icons.arrow_forward,
              color: Colors.grey,
            )),
            onTap: () => []),
      ],
    );
  }

  @override
  int get rowCount => authors.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;

  void selectAll(bool? checked) {
    for (final dessert in authors) {
      dessert.selected = checked ?? false;
    }
    _selectedCount = (checked ?? false) ? authors.length : 0;
    notifyListeners();
  }

  //Custom dialog handles

}


//get books
Future<void> getBooksFromAuthor(context, String author) async {
  if (mainBookListCopy.isNotEmpty) {
    _authorBooks = [];
    final foundBooks = mainBookListCopy.where(
        (element) => element.author.toLowerCase() == author.toLowerCase());
    if (foundBooks.isNotEmpty) {
      AuthorBooks _temp = AuthorBooks('', '', '');
      for (var book in foundBooks) {
        _temp.title = book.title;
        _temp.id = book.id;
        _temp.sold = book.sold;
        _authorBooks.add(_temp);
        
      }
    } else {
      AuthorBooks _temp = AuthorBooks('', '', '');
      _authorBooks.add(_temp);
    }
  }
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
