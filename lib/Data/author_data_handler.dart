// ignore_for_file: avoid_print, avoid_renaming_method_parameters, curly_braces_in_flow_control_structures, unused_import

import 'dart:convert';

import 'package:bookstore_project/Data/data_storage_helper.dart';
import 'package:bookstore_project/InfoScreens/book_list.dart';
import 'package:bookstore_project/login_page.dart';
import 'package:bookstore_project/main_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:bookstore_project/Data/book_data_handler.dart';
import 'package:provider/provider.dart';

import '../state_provider.dart';

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
  List editResults = List.filled(6, null);

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

  List get allInfoHeaders {
    return [
      'First Name',
      'Last Name',
      'ID',
      'Year of Birth',
      'Year of Dead',
      'Description',
    ];
  }

  void setInfo(var info) {
    if (info == 'First Name' && editResults[0] != null)
      firstName = editResults[0];
    else if (info == 'Last Name' && editResults[1] != null)
      lastName = editResults[1];
    else if (info == 'ID' && editResults[2] != null)
      id = editResults[2];
    else if (info == 'Year of Birth' && editResults[3] != null)
      yearBirth = editResults[3];
    else if (info == 'Year of Dead' && editResults[4] != null)
      yearDead = editResults[4];
    else if (info == 'Description' && editResults[5] != null)
      description = editResults[5];
  }

  void infoEdited(var info, var editedVal) {
    if (info == 'First Name')
      editResults[0] = editedVal;
    else if (info == 'Last Name')
      editResults[1] = editedVal;
    else if (info == 'ID')
      editResults[2] = editedVal;
    else if (info == 'Year of Birth')
      editResults[3] = editedVal;
    else if (info == 'Year of Dead')
      editResults[4] = editedVal;
    else if (info == 'Description')
      editResults[5] = editedVal;
    else
      editResults[0] = editedVal;
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
                _showDialog(context, author),
              ]
          : null,
      // onDoubleTap: hasRowTaps
      //     ? () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //           duration: const Duration(seconds: 1),
      //           //backgroundColor: Theme.of(context).focusColor,
      //           content: Text('Double Tapped on ${author.firstName}'),
      //         ))
      //     : null,
      // onSecondaryTap: hasRowTaps
      //     ? () => //_authorDataAdder()
      //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //           duration: const Duration(seconds: 1),
      //           backgroundColor: Theme.of(context).errorColor,
      //           content: Text('Right clicked on ${author.firstName}'),
      //         ))
      //     : null,
      specificRowHeight: hasRowHeightOverrides ? 100 : null,
      cells: [
        DataCell(Text(author.id)),
        DataCell(
          Text('${author.firstName} ${author.lastName}'),
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
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              titlePadding: const EdgeInsets.only(top: 10),
              title: Center(
                child: Text(
                    '${curAuthor.firstName} ${curAuthor.lastName}\'s Info',
                    style: const TextStyle(fontWeight: FontWeight.w700)),
              ),
              contentPadding:
                  const EdgeInsets.only(top: 10, left: 16, bottom: 10),
              content: SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: SizedBox(
                        width: 400,
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
                                          enabled: isManager,
                                          controller: TextEditingController()
                                            ..text = curAuthor.firstName,
                                          onChanged: (text) =>
                                              {curAuthor.infoEdited('First Name', text)},
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
                                          enabled: isManager,
                                          controller: TextEditingController()
                                            ..text = curAuthor.lastName,
                                          onChanged: (text) =>
                                              {curAuthor.infoEdited('Last Name', text)},
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
                                          enabled: isManager,
                                          controller: TextEditingController()
                                            ..text = curAuthor.id,
                                          onChanged: (text) =>
                                              {curAuthor.infoEdited('ID', text)},
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
                                          enabled: isManager,
                                          controller: TextEditingController()
                                            ..text = curAuthor.yearBirth,
                                          onChanged: (text) =>
                                              {curAuthor.infoEdited('Year of Birth', text)},
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
                                          enabled: isManager,
                                          controller: TextEditingController()
                                            ..text = curAuthor.yearDead,
                                          onChanged: (text) =>
                                              {curAuthor.infoEdited('Year of Dead', text)},
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
                                          enabled: isManager,
                                          controller: TextEditingController()
                                            ..text = curAuthor.description,
                                          onChanged: (text) =>
                                              {curAuthor.infoEdited('Description', text)},
                                          decoration: const InputDecoration(
                                            //icon: Icon(Icons.person),
                                            hintText: '',
                                            labelText: 'Description',
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
                                                const EdgeInsets.only(top: 15),
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor: Theme.of(context)
                                                        .buttonTheme
                                                        .colorScheme!
                                                        .background,
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 9)),
                                                child: Text(
                                                  'Books From This Author',
                                                  textAlign: TextAlign.justify,
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Theme.of(context)
                                                          .textTheme
                                                          .labelLarge!
                                                          .color),
                                                ),
                                                onPressed: () {
                                                  setState(
                                                    () {
                                                      if (Provider.of<
                                                                  checkoutNotif>(
                                                              context,
                                                              listen: false)
                                                          .isCheckout) {
                                                        selectedIndex = 1;
                                                      } else {
                                                        selectedIndex = 0;
                                                      }

                                                      Navigator.pushReplacement(
                                                        context,
                                                        PageRouteBuilder(
                                                          pageBuilder: (context,
                                                                  animation1,
                                                                  animation2) =>
                                                              const MainPage(),
                                                          // transitionDuration: Duration.zero,
                                                          // reverseTransitionDuration:
                                                          //     Duration.zero,
                                                        ),
                                                      );

                                                      //Search and list books from curAuthor
                                                      curBookSearchChoice =
                                                          'All Fields';
                                                      searchbookController
                                                          .text = '${curAuthor
                                                              .firstName} ${curAuthor.lastName} ${curAuthor.id}';
                                                      searchBookList = [];
                                                      Iterable<Book> foundBook =
                                                          [];
                                                      foundBook = mainBookListCopy.where((element) =>
                                                          element
                                                              .authorFirstName
                                                              .toLowerCase()
                                                              .contains(curAuthor
                                                                  .firstName
                                                                  .toLowerCase()) ||
                                                          element.authorLastName
                                                              .toLowerCase()
                                                              .contains(curAuthor
                                                                  .lastName
                                                                  .toLowerCase()) ||
                                                          element.authorID
                                                              .toLowerCase()
                                                              .contains(curAuthor
                                                                  .id
                                                                  .toLowerCase()));
                                                      if (foundBook
                                                          .isNotEmpty) {
                                                        for (var book
                                                            in foundBook) {
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
                                                          searchBookList
                                                              .add(tempBook);
                                                        }
                                                        searchHelper(context,
                                                                searchBookList)
                                                            .then((_) {
                                                          setState(() {});
                                                          //debugPrint('test ${mainBookList.toString()}');
                                                        });
                                                      } else {
                                                        searchHelper(context,
                                                                searchBookList)
                                                            .then((_) {
                                                          setState(() {});
                                                        });
                                                      }
                                                    },
                                                  );
                                                }))),
                                  ],
                                ),
                              ],
                            ))
                          ],
                        ),
                      ))),
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
                      onPressed: () {
                        for (var item in curAuthor.allInfoHeaders) {
                          curAuthor.setInfo(item);
                        }

                        //write to json
                        if (!kIsWeb) {
                          localDatabaseUpdate('authors');
                        }
                        notifyListeners();
                        Navigator.pop(context);
                      })
              ],
            );
          });
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
    Author author = Author(b['firstName'], b['lastName'], b['id'],
        b['yearBirth'], b['yearDead'], b['description']);
    mainAuthorList.add(author);
    mainAuthorListCopy.add(author);
  }
  //debugPrint('test ${_authors.length}');
  //getAuthorsFromBook();
}

//Get Authors from Book data
Future<void> getAuthorsFromBook() async {
  if (mainBookListCopy.isNotEmpty && mainAuthorList.isEmpty) {
    List<String> authorIDs = [];
    for (var book in mainBookListCopy) {
      authorIDs.add(book.authorID);
    }
    authorIDs = authorIDs.toSet().toList();
    //print(_authorNames);
    for (var id in authorIDs) {
      mainAuthorList.add(Author('', '', id, '', '', ''));
    }
  } else if (mainBookListCopy.isNotEmpty && mainAuthorList.isNotEmpty) {
    List<String> authorIDs0 = [];
    for (var book in mainBookListCopy) {
      authorIDs0.add(book.authorID);
    }
    authorIDs0 = authorIDs0.toSet().toList();
    for (var author in mainAuthorList) {
      final index = authorIDs0.indexWhere((element) => element == author.id);
      if (index >= 0) {
        authorIDs0.removeAt(index);
      }
    }
    if (authorIDs0.isNotEmpty) {
      for (var id in authorIDs0) {
        mainAuthorList.add(Author('', '', id, '', '', ''));
        mainAuthorListCopy.add(Author('', '', id, '', '', ''));
      }
    }
  }

  //Save to database
  if (!kIsWeb) {
    localDatabaseUpdate('authors');
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

    for (var author in foundList) {
      if (author == foundList.first) {
        mainAuthorList.first = author;
      } else if (foundList.length > 1) {
        mainAuthorList.add(author);
      }
    }
  }
  //debugPrint('main ${mainBookList.toString()}');
  //debugPrint('copy ${mainBookListCopy.toString()}');
}

// Dialog Helper
// ignore: unused_element
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
