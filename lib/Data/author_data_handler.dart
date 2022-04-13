// ignore_for_file: avoid_print, avoid_renaming_method_parameters, curly_braces_in_flow_control_structures

import 'dart:convert';
import 'dart:io';

import 'package:bookstore_project/login_page.dart';
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
    this.firstName,
    this.lastName,
    this.id,
    this.yearBirth,
    this.yearDead,
    this.description,
  );

  String firstName;
  String lastName;
  String id;
  String yearBirth;
  String yearDead;
  String description;

  bool selected = false;
  List editResults = List.filled(10, null);

  List get allInfo {
    return [
      firstName,
      lastName,
      id,
      yearBirth,
      yearDead,
      description,
    ];
  }

  fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    id = json['id'];
    yearBirth = json['yearBirth'];
    yearDead = json['yearDead'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firstName'] = firstName;
    data['lastName'] = lastName;
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
      sort((d) => d.firstName, true);
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
                if (isManager) _showDialog(context, author),
              ]
          : null,
      onDoubleTap: hasRowTaps
          ? () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                duration: const Duration(seconds: 1),
                //backgroundColor: Theme.of(context).focusColor,
                content: Text('Double Tapped on ${author.firstName}'),
              ))
          : null,
      onSecondaryTap: hasRowTaps
          ? () => //_authorDataAdder()
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                duration: const Duration(seconds: 1),
                backgroundColor: Theme.of(context).errorColor,
                content: Text('Right clicked on ${author.firstName}'),
              ))
          : null,
      specificRowHeight: hasRowHeightOverrides ? 100 : null,
      cells: [
        DataCell(Text(author.id)),
        DataCell(
          Text(author.firstName + ' ' + author.lastName),
        ),
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
              contentPadding:
                  const EdgeInsets.only(top: 16, left: 16, bottom: 16),
              content: SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Container(
                        width: 400,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('${curAuthor.firstName} ${curAuthor.lastName}\'s Info',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        child: Container(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: TextFormField(
                                          controller: TextEditingController()
                                            ..text = curAuthor.firstName,
                                          onChanged: (text) => {
                                               curAuthor.firstName = text
                                              },
                                          decoration: const InputDecoration(
                                            //icon: Icon(Icons.person),
                                            hintText: '',
                                            labelText: 'First Name',
                                          )),
                                    )),
                                    Expanded(
                                        child: Container(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: TextFormField(
                                          controller: TextEditingController()
                                            ..text = curAuthor.lastName,
                                          onChanged: (text) => {
                                                curAuthor.lastName = text
                                              },
                                          decoration: const InputDecoration(
                                            //icon: Icon(Icons.person),
                                            hintText: '',
                                            labelText: 'Last Name',
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
                                            ..text = curAuthor.id,
                                          onChanged: (text) =>
                                              {curAuthor.id = text},
                                          decoration: const InputDecoration(
                                            //icon: Icon(Icons.person),
                                            hintText: 'ABCD1234',
                                            labelText: 'ID',
                                          )),
                                    )),
                                    Expanded(
                                        child: Container(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: TextFormField(
                                          controller: TextEditingController()
                                            ..text = curAuthor.yearBirth,
                                          onChanged: (text) =>
                                              {curAuthor.yearBirth = text},
                                          decoration: const InputDecoration(
                                            //icon: Icon(Icons.person),
                                            hintText: 'YYYY',
                                            labelText: 'Year of Birth',
                                          )),
                                    )),
                                    Expanded(
                                        child: Container(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: TextFormField(
                                          controller: TextEditingController()
                                            ..text = curAuthor.yearDead,
                                          onChanged: (text) =>
                                              {curAuthor.yearDead = text},
                                          decoration: const InputDecoration(
                                            //icon: Icon(Icons.person),
                                            hintText: 'YYYY',
                                            labelText: 'Year of Dead',
                                          )),
                                    )),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        child: Container(
                                      padding: const EdgeInsets.only(right: 0),
                                      child: TextFormField(
                                          controller: TextEditingController()
                                            ..text = curAuthor.description,
                                          onChanged: (text) =>
                                              {curAuthor.description = text},
                                          decoration: const InputDecoration(
                                            //icon: Icon(Icons.person),
                                            hintText: '',
                                            labelText: 'Description',
                                          )),
                                    )),
                                  ],
                                ),
                              ],
                            ))
                          ],
                        ),
                      ))),
              actions: <Widget>[
                ElevatedButton(
                    child: const Text('CANCEL'),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                ElevatedButton(
                    child: const Text('SAVE'),
                    onPressed: () {
                      // for (var item in curAuthor.allInfoHeaders) {
                      //   curAuthor.setInfo(item);
                      // }

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
    Author author = Author(b['firstName'], b['lastName'], b['id'], b['yearBirth'],
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
    List<String> _authorIDs = [];
    for (var book in mainBookListCopy) {
      _authorIDs.add(book.authorID);
    }
    _authorIDs = _authorIDs.toSet().toList();
    //print(_authorNames);
    for (var id in _authorIDs) {
      mainAuthorList.add(Author('', '', id, '', '', ''));
    }
  } else if (mainBookListCopy.isNotEmpty && mainAuthorList.isNotEmpty) {
    List<String> _authorIDs = [];
    for (var book in mainBookListCopy) {
      _authorIDs.add(book.authorID);
    }
    _authorIDs = _authorIDs.toSet().toList();
    for (var author in mainAuthorList) {
      final index =
          _authorIDs.indexWhere((element) => element == author.id);
      if (index >= 0) {
        _authorIDs.removeAt(index);
      }
    }
    if (_authorIDs.isNotEmpty) {
      for (var id in _authorIDs) {
        mainAuthorList.add(Author('', '', id, '', '', ''));
        mainAuthorListCopy.add(Author('', '', id, '', '', ''));
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
    mainAuthorList.first = Author('', '', '', '', '', '');
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
