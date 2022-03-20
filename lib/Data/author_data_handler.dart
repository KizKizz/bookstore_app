// ignore_for_file: avoid_print, avoid_renaming_method_parameters

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:bookstore_project/Data/book_data_handler.dart';

final File authorDataJson = File('assets/jsondatabase/author_data.json');

List<Author> mainAuthorList = [];
List<Author> mainAuthorListCopy = [];

// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// The file was extracted from GitHub: https://github.com/flutter/gallery
// Changes and modifications by Maxim Saplin, 2021 - KizKizz 2022

/// Keeps track of selected rows, feed the data into DataSource
class RestorableauthorSelections extends RestorableProperty<Set<int>> {
  Set<int> _authorSelections = {};

  // Returns whether or not a row is selected by index.
  bool isSelected(int index) => _authorSelections.contains(index);

  // Takes a list of [author]s and saves the row indices of selected rows
  // into a [Set].
  void setAuthorSelections(List<Author> authors) {
    final updatedSet = <int>{};
    for (var i = 0; i < authors.length; i += 1) {
      var author = authors[i];
      if (author.selected) {
        updatedSet.add(i);
      }
    }
    _authorSelections = updatedSet;
    notifyListeners();
  }

  @override
  Set<int> createDefaultValue() => _authorSelections;

  @override
  Set<int> fromPrimitives(Object? data) {
    final selectedItemIndices = data as List<dynamic>;
    _authorSelections = {
      ...selectedItemIndices.map<int>((dynamic id) => id as int),
    };
    return _authorSelections;
  }

  @override
  void initWithValue(Set<int> value) {
    _authorSelections = value;
  }

  @override
  Object toPrimitives() => _authorSelections.toList();
}

/// Domain model entity
class Author {
  Author(
    this.fullName,
    this.id,
    this.yearBirth,
    this.yearDead,
    this.description,
  );

  String fullName;
  String id;
  String yearBirth;
  String yearDead;
  String description;

  bool selected = false;
  List editResults = List.filled(10, null);

  List get allInfo {
    return [
      fullName,
      id,
      yearBirth,
      yearDead,
      description,
    ];
  }

  List get allInfoHeaders {
    return [
      'Full Name',
      'ID',
      'Year of Birth',
      'Year of Dead',
      'Description',
    ];
  }

  void setInfo(var info) {
    if (info == 'Full Name' && editResults[0] != null)
      fullName = editResults[0];
    else if (info == 'ID' && editResults[1] != null)
      id = editResults[1];
    else if (info == 'Year of Birth' && editResults[2] != null)
      yearBirth = editResults[2];
    else if (info == 'Year of Dead' && editResults[3] != null)
      yearDead = editResults[3];
    else if (info == 'Description' && editResults[4] != null)
      description = editResults[4];
  }

  String headerToInfo(var header) {
    if (header == 'Full Name')
      return fullName;
    else if (header == 'ID')
      return id;
    else if (header == 'Year of Birth')
      return yearBirth.toString();
    else if (header == 'Year of Dead')
      return yearDead.toString();
    else if (header == 'Description')
      return description;
    else
      return 'error';
  }

  void infoEdited(var info, var editedVal) {
    if (info == 'Full Name')
      editResults[0] = editedVal;
    else if (info == 'ID')
      editResults[1] = editedVal;
    else if (info == 'Year of Birth')
      editResults[2] = editedVal;
    else if (info == 'Year of Dead')
      editResults[3] = editedVal;
    else if (info == 'Description')
      editResults[4] = editedVal;
    else
      editResults[0] = editedVal;
  }

  fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    id = json['id'];
    yearBirth = json['yearBirth'];
    yearDead = json['yearDead'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fullName'] = fullName;
    data['id'] = id;
    data['yearBirth'] = yearBirth;
    data['yearDead'] = yearDead;
    data['description'] = description;

    return data;
  }
}

/// Data source implementing standard Flutter's DataTableSource abstract class
/// which is part of DataTable and PaginatedDataTable synchronous data fecthin API.
/// This class uses static collection of data as a data store, projects it into
/// DataRows, keeps track of selected items, provides sprting capability
class AuthorDatabase extends DataTableSource {
  AuthorDatabase.empty(this.context) {
    authors = [];
  }

  AuthorDatabase(this.context,
      [sortedByName = true,
      this.hasRowTaps = true,
      this.hasRowHeightOverrides = false]) {
    authors = mainAuthorList;
    if (sortedByName) {
      sort((d) => d.fullName, true);
    }
  }

  final BuildContext context;
  late List<Author> authors;
  late bool hasRowTaps;
  late bool hasRowHeightOverrides;

  void sort<T>(Comparable<T> Function(Author d) getField, bool ascending) {
    authors.sort((a, b) {
      if (a.yearBirth == '') {
        a.yearBirth = 0.toString();
      } else if (a.yearDead == '') {
        a.yearDead = 0.toString();
      }
      if (b.yearBirth == '') {
        b.yearBirth = 0.toString();
      } else if (b.yearDead == '') {
        b.yearDead = 0.toString();
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
                _showDialog(context, author),
              ]
          : null,
      onDoubleTap: hasRowTaps
          ? () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                duration: const Duration(seconds: 1),
                //backgroundColor: Theme.of(context).focusColor,
                content: Text('Double Tapped on ${author.fullName}'),
              ))
          : null,
      onSecondaryTap: hasRowTaps
          ? () => //_authorDataAdder()
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                duration: const Duration(seconds: 1),
                backgroundColor: Theme.of(context).errorColor,
                content: Text('Right clicked on ${author.fullName}'),
              ))
          : null,
      specificRowHeight: hasRowHeightOverrides ? 100 : null,
      cells: [
        DataCell(
          Text(author.fullName),
        ),
        DataCell(Text(author.id)),
        DataCell(Text(author.yearBirth.toString())),
        DataCell(Text(author.yearDead.toString())),
        DataCell(Text(author.description)),
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
  //Edit author Popup
  _showDialog(context, Author curAuthor) async {
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
                      const Text('Edit author Info'),
                      for (var item in curAuthor.allInfoHeaders)
                        TextField(
                            controller: TextEditingController()
                              ..text = curAuthor.headerToInfo(item),
                            onChanged: (text) =>
                                {curAuthor.infoEdited(item, text)},
                            autofocus: true,
                            decoration: InputDecoration(
                                labelText: item + ':',
                                hintText: item + ' of the author')),
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
                      for (var item in curAuthor.allInfoHeaders) {
                        curAuthor.setInfo(item);
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
                      notifyListeners();
                      Navigator.pop(context);
                    })
              ],
            ),
          );
        });
  }
}

//Add author
// Future<void> authorDataAdder(context) async {
//   Author newauthor = Author('', '', '', '', '');
//   await showDialog<String>(
//       context: context,
//       builder: (BuildContext context) {
//         return _SystemPadding(
//           child: AlertDialog(
//             contentPadding: const EdgeInsets.all(16.0),
//             content: Row(
//               children: <Widget>[
//                 Expanded(
//                     child: SingleChildScrollView(
//                         child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const Text('Add author'),
//                     for (var item in newauthor.allInfoHeaders)
//                       TextField(
//                           // controller: TextEditingController()
//                           //   ..text = item.toString(),
//                           onChanged: (text) =>
//                               {newauthor.infoEdited(item, text)},
//                           autofocus: true,
//                           decoration: InputDecoration(
//                               labelText: item + ':',
//                               hintText: item + ' of the author')),
//                   ],
//                 )))
//               ],
//             ),
//             actions: <Widget>[
//               TextButton(
//                   child: const Text('CANCEL'),
//                   onPressed: () {
//                     Navigator.pop(context);
//                   }),
//               TextButton(
//                   child: const Text('ADD'),
//                   onPressed: () {
//                     for (var item in newauthor.allInfoHeaders) {
//                       newauthor.setInfo(item);
//                     }
//                     mainAuthorList.add(newauthor);

//                     if (!kIsWeb) {
//                       mainAuthorList
//                           .map(
//                             (author) => author.toJson(),
//                           )
//                           .toList();
//                       authorDataJson
//                           .writeAsStringSync(json.encode(mainAuthorList));
//                       debugPrint(newauthor.allInfo.toString());
//                     }
//                     Navigator.pop(context);
//                   })
//             ],
//           ),
//         );
//       });
// }

//JSON Helper
void convertauthorData(var jsonResponse) {
  for (var b in jsonResponse) {
    Author author = Author(b['fullName'], b['id'], b['yearBirth'],
        b['yearDead'], b['description']);
    mainAuthorList.add(author);
    mainAuthorListCopy.add(author);
  }
  //debugPrint('test ${_authors.length}');
  getAuthorsFromBook();
}

//Get Authors from Book data
Future<void> getAuthorsFromBook() async {
  if (mainBookListCopy.isNotEmpty && mainAuthorList.isEmpty) {
    List<String> _authorNames = [];
    for (var book in mainBookListCopy) {
      _authorNames.add(book.author);
    }
    _authorNames = _authorNames.toSet().toList();
    //print(_authorNames);
    for (var name in _authorNames) {
      mainAuthorList.add(Author(name, '', '', '', ''));
    }
  } else if (mainBookListCopy.isNotEmpty && mainAuthorList.isNotEmpty) {
    List<String> _authorNames = [];
    for (var book in mainBookListCopy) {
      _authorNames.add(book.author);
    }
    _authorNames = _authorNames.toSet().toList();
    for (var author in mainAuthorList) {
      final index =
          _authorNames.indexWhere((element) => element == author.fullName);
      if (index >= 0) {
        _authorNames.removeAt(index);
      }
    }
    if (_authorNames.isNotEmpty) {
      for (var name in _authorNames) {
        mainAuthorList.add(Author(name, '', '', '', ''));
        mainAuthorListCopy.add(Author(name, '', '', '', ''));
      }
    }
  }

  //Save to database
  if (!kIsWeb) {
    mainAuthorList
        .map(
          (author) => author.toJson(),
        )
        .toList();
    authorDataJson.writeAsStringSync(json.encode(mainAuthorList));
  }
}

//Search Helper
Future<void> authorSearchHelper(context, List<Author> foundList) async {
  if (foundList.isEmpty) {
    mainAuthorList.removeRange(1, mainAuthorList.length);
    mainAuthorList.first = Author('', '', '', '', '');
  } else {
    if (mainAuthorList.length > 1) {
      mainAuthorList.removeRange(1, mainAuthorList.length);
    }

    for (var customer in foundList) {
      if (customer == foundList.first) {
        mainAuthorList.first = customer;
      } else if (foundList.length > 1) {
        mainAuthorList.add(customer);
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
