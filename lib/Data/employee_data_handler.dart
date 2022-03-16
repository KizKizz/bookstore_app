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

import 'author_data_handler.dart';

final File employeeDataJson = File('assets/jsondatabase/book_data.json');
List<Employee> mainEmployeeList = [];
List<Employee> mainEmployeeListCopy = [];

// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// The file was extracted from GitHub: https://github.com/flutter/gallery
// Changes and modifications by Maxim Saplin, 2021 - KizKizz 2022

/// Keeps track of selected rows, feed the data into DataSource
class RestorableBookSelections extends RestorableProperty<Set<int>> {
  Set<int> _employeeSelections = {};

  // Returns whether or not a row is selected by index.
  bool isSelected(int index) => _employeeSelections.contains(index);

  // Takes a list of [Book]s and saves the row indices of selected rows
  // into a [Set].
  void setBookSelections(List<Employee> employees) {
    final updatedSet = <int>{};
    for (var i = 0; i < employees.length; i += 1) {
      var employee = employees[i];
      if (employee.selected) {
        updatedSet.add(i);
      }
    }
    _employeeSelections = updatedSet;
    notifyListeners();
  }

  @override
  Set<int> createDefaultValue() => _employeeSelections;

  @override
  Set<int> fromPrimitives(Object? data) {
    final selectedItemIndices = data as List<dynamic>;
    _employeeSelections = {
      ...selectedItemIndices.map<int>((dynamic id) => id as int),
    };
    return _employeeSelections;
  }

  @override
  void initWithValue(Set<int> value) {
    _employeeSelections = value;
  }

  @override
  Object toPrimitives() => _employeeSelections.toList();
}

/// Domain model entity
class Employee {
  Employee(
      this.firstName,
      this.lastName,
      this.id,
      this.address,
      this.phoneNumber,
      this.dateOfBirth,
      this.hireDate,
      this.position,
      this.description);

  String firstName;
  String lastName;
  String id;
  String address;
  String phoneNumber;
  String dateOfBirth;
  String hireDate;
  String position;
  String description;

  bool selected = false;
  bool isSearched = false;
  List editResults = List.filled(10, null);

  List get allInfo {
    return [
      firstName,
      lastName,
      id,
      address,
      phoneNumber,
      dateOfBirth,
      hireDate,
      position,
      description
    ];
  }

  List get allInfoHeaders {
    return [
      'First Name',
      'Last Name',
      'ID',
      'Address',
      'Phone Number',
      'Date Of Birth',
      'Hire Date',
      'Position',
      'Description'
    ];
  }

  void setInfo(var info) {
    if (info == 'First Name' && editResults[0] != null)
      firstName = editResults[0];
    else if (info == 'Last Name' && editResults[1] != null)
      lastName = editResults[1];
    else if (info == 'ID' && editResults[2] != null)
      id = editResults[2];
    else if (info == 'Address' && editResults[3] != null)
      address = editResults[3];
    else if (info == 'Phone Number' && editResults[4] != null)
      phoneNumber = editResults[4];
    else if (info == 'Date Of Birth' && editResults[5] != null)
      dateOfBirth = editResults[5];
    else if (info == 'Hire Date' && editResults[6] != null)
      hireDate = editResults[6];
    else if (info == 'Position' && editResults[7] != null)
      position = editResults[7];
    else if (info == 'Description' && editResults[8] != null)
      description = editResults[8];
  }

  String headerToInfo(var header) {
    if (header == 'First Name')
      return firstName;
    else if (header == 'Last Name')
      return lastName;
    else if (header == 'ID')
      return id;
    else if (header == 'Address')
      return address;
    else if (header == 'Phone Number')
      return phoneNumber;
    else if (header == 'Date Of Birth')
      return dateOfBirth;
    else if (header == 'Hire Date')
      return hireDate;
    else if (header == 'Position')
      return position;
    else if (header == 'Decsription')
      return description;
    else
      return 'error';
  }

  void infoEdited(var info, var editedVal) {
    if (info == 'First Name')
      editResults[0] = editedVal;
    else if (info == 'Last Name')
      editResults[1] = editedVal;
    else if (info == 'ID')
      editResults[2] = editedVal;
    else if (info == 'Address')
      editResults[3] = editedVal;
    else if (info == 'Phone Number')
      editResults[4] = editedVal;
    else if (info == 'Date Of Birth')
      editResults[5] = editedVal;
    else if (info == 'Hire Date')
      editResults[6] = editedVal;
    else if (info == 'Position')
      editResults[7] = editedVal;
    else if (info == 'Description')
      editResults[8] = editedVal;
    else
      editResults[0] = editedVal;
  }

  fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    id = json['id'];
    address = json['address'];
    phoneNumber = json['phoneNumber'];
    dateOfBirth = json['dateOfBirth'];
    hireDate = json['hireDate'];
    position = json['position'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['id'] = id;
    data['address'] = address;
    data['phoneNumber'] = phoneNumber;
    data['dateOfBirth'] = dateOfBirth;
    data['hireDate'] = hireDate;
    data['position'] = position;
    data['description'] = description;

    return data;
  }
}

/// Data source implementing standard Flutter's DataTableSource abstract class
/// which is part of DataTable and PaginatedDataTable synchronous data fecthin API.
/// This class uses static collection of data as a data store, projects it into
/// DataRows, keeps track of selected items, provides sprting capability
class EmployeeDatabase extends DataTableSource {
  EmployeeDatabase.empty(this.context) {
    employees = [];
  }

  EmployeeDatabase(this.context,
      [sortedByName = true,
      this.hasRowTaps = true,
      this.hasRowHeightOverrides = false]) {
    employees = mainEmployeeList;
    if (sortedByName) {
      sort((d) => d.lastName, true);
    }
  }

  final BuildContext context;
  late List<Employee> employees;
  late bool hasRowTaps;
  late bool hasRowHeightOverrides;

  void sort<T>(Comparable<T> Function(Employee d) getField, bool ascending) {
    employees.sort((a, b) {
      // if (a.cost == '') {
      //   a.cost = 0.toString();
      // } else if (a.edition == '') {
      //   a.edition = 0.toString();
      // } else if (a.retailPrice == '') {
      //   a.retailPrice = 0.toString();
      // } else if (a.publishDate == '') {
      //   a.publishDate = 0.toString();
      // }
      // if (b.cost == '') {
      //   b.cost = 0.toString();
      // } else if (b.edition == '') {
      //   b.edition = 0.toString();
      // } else if (b.retailPrice == '') {
      //   b.retailPrice = 0.toString();
      // } else if (b.publishDate == '') {
      //   b.publishDate = 0.toString();
      // }
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
    for (var i = 0; i < employees.length; i += 1) {
      var employee = employees[i];
      if (selectedRows.isSelected(i)) {
        employee.selected = true;
        _selectedCount += 1;
      } else {
        employee.selected = false;
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
    if (index >= employees.length) throw 'index > _books.length';
    final employee = employees[index];
    return DataRow2.byIndex(
      index: index,
      selected: employee.selected,
      onSelectChanged: hasRowTaps
          ? null
          : (value) {
              if (employee.selected != value) {
                _selectedCount += value! ? 1 : -1;
                assert(_selectedCount >= 0);
                employee.selected = value;
                notifyListeners();
              }
            },
      onTap: hasRowTaps
          ? () => [
                if (isManager) {_showDialog(context, employee)}
              ]
          : null,
      onDoubleTap: hasRowTaps
          ? () => [
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  duration: const Duration(seconds: 1),
                  //backgroundColor: Theme.of(context).focusColor,
                  content: Text(
                      'Double Tapped on ${employee.firstName} ${employee.lastName}'),
                )),
              ]
          : null,
      onSecondaryTap: hasRowTaps
          ? () => //_bookDataAdder()
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                duration: const Duration(seconds: 1),
                backgroundColor: Theme.of(context).errorColor,
                content: Text('Double Tapped on ${employee.firstName} ${employee.lastName}'),
              ))
          : null,
      specificRowHeight: hasRowHeightOverrides ? 100 : null,
      cells: [
        DataCell(Text(employee.firstName)),
        DataCell(Text(employee.lastName)),
        DataCell(Text(employee.id)),
        DataCell(Text(employee.address)),
        DataCell(Text(employee.phoneNumber)),
        DataCell(Text(employee.dateOfBirth)),
        DataCell(Text(employee.hireDate)),
        DataCell(Text(employee.position)),
        DataCell(Text(employee.description)),

      ],
    );
  }

  @override
  int get rowCount => employees.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;

  void selectAll(bool? checked) {
    for (final dessert in employees) {
      dessert.selected = checked ?? false;
    }
    _selectedCount = (checked ?? false) ? employees.length : 0;
    notifyListeners();
  }

  //Edit Book Popup
  _showDialog(context, Employee curEmployee) async {
    double _conditionRating = 1.0;
    int _statusRating = 0;
    //String _curBookAuthor = curBook.author;
    // if (curBook.condition == 'Poor') {
    //   _conditionRating = 1.0;
    // } else if (curBook.condition == 'Fair') {
    //   _conditionRating = 2.0;
    // } else if (curBook.condition == 'Good') {
    //   _conditionRating = 3.0;
    // } else if (curBook.condition == 'Exellent') {
    //   _conditionRating = 4.0;
    // } else if (curBook.condition == 'Superb') {
    //   _conditionRating = 5.0;
    // }
    // if (curBook.sold == 'Available') {
    //   _statusRating = 0;
    // } else if (curBook.sold == 'Sold') {
    //   _statusRating = 1;
    // }

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
                      const Text('Edit Employee Info'),
                      for (var item in curEmployee.allInfoHeaders)
                        // if (item == 'Condition')
                        //   Container(
                        //       padding: EdgeInsets.only(top: 10),
                        //       child: Column(children: [
                        //         Container(
                        //           alignment: Alignment(-1, 0),
                        //           padding: EdgeInsets.only(bottom: 5),
                        //           child: Text(
                        //             'Condition:',
                        //             style: TextStyle(
                        //                 fontSize: 14,
                        //                 color: Theme.of(context).hintColor),
                        //           ),
                        //         ),
                        //         RatingBar.builder(
                        //           itemSize: 40,
                        //           initialRating: _conditionRating,
                        //           minRating: 1,
                        //           direction: Axis.horizontal,
                        //           allowHalfRating: false,
                        //           itemCount: 5,
                        //           itemPadding: const EdgeInsets.symmetric(
                        //               horizontal: 4.0),
                        //           itemBuilder: (context, _) => const Icon(
                        //             Icons.star,
                        //             color: Colors.amber,
                        //           ),
                        //           onRatingUpdate: (rating) {
                        //             if (rating == 1.0) {
                        //               curBook.infoEdited(item, 'Poor');
                        //             } else if (rating == 2.0) {
                        //               curBook.infoEdited(item, 'Fair');
                        //             } else if (rating == 3.0) {
                        //               curBook.infoEdited(item, 'Good');
                        //             } else if (rating == 4.0) {
                        //               curBook.infoEdited(item, 'Excellent');
                        //             } else if (rating == 5.0) {
                        //               curBook.infoEdited(item, 'Superb');
                        //             }
                        //           },
                        //         )
                        //       ]))
                        // else if (item == 'Sold')
                        //   Container(
                        //       padding: const EdgeInsets.only(top: 5),
                        //       child: Column(children: [
                        //         Container(
                        //           alignment: const Alignment(-1, 0),
                        //           padding: const EdgeInsets.only(bottom: 5),
                        //           child: Text(
                        //             'Status:',
                        //             style: TextStyle(
                        //                 fontSize: 14,
                        //                 color: Theme.of(context).hintColor),
                        //           ),
                        //         ),
                        //         ToggleSwitch(
                        //           minWidth: 80.0,
                        //           minHeight: 30,
                        //           borderColor: [
                        //             Theme.of(context).primaryColorLight
                        //           ],
                        //           borderWidth: 1.5,
                        //           initialLabelIndex: _statusRating,
                        //           cornerRadius: 50.0,
                        //           activeFgColor: Colors.white,
                        //           inactiveBgColor: Colors.grey,
                        //           inactiveFgColor: Colors.white,
                        //           totalSwitches: 2,
                        //           labels: const ['Available', 'Sold'],
                        //           activeBgColors: const [
                        //             [Colors.blue],
                        //             [Colors.pink]
                        //           ],
                        //           onToggle: (index) {
                        //             if (index == 0) {
                        //               curBook.infoEdited(item, 'Available');
                        //             } else if (index == 1) {
                        //               curBook.infoEdited(item, 'Sold');
                        //             }
                        //           },
                        //         )
                        //       ]))
                        // else
                          TextField(
                              controller: TextEditingController()
                                ..text = curEmployee.headerToInfo(item),
                              onChanged: (text) =>
                                  {curEmployee.infoEdited(item, text)},
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
                      int _EmployeeMatchIndex = mainEmployeeListCopy
                          .indexWhere((element) => element.id == curEmployee.id);
                      //debugPrint('curafter: ${_bookMatchIndex}');
                      for (var item in curEmployee.allInfoHeaders) {
                        curEmployee.setInfo(item);
                      }

                      if (_EmployeeMatchIndex >= 0) {
                        mainEmployeeListCopy[_EmployeeMatchIndex] = curEmployee;
                      }

                      //Fetch author data again?
                      // final foundAuthor = authorDataList.singleWhere(
                      //     (element) => element.fullName
                      //         .toLowerCase()
                      //         .contains(_curBookAuthor.toLowerCase()));
                      // foundAuthor.fullName = curBook.author;

                      // if (!kIsWeb) {
                      //   mainBookListCopy
                      //       .map(
                      //         (book) => book.toJson(),
                      //       )
                      //       .toList();
                      //   bookDataJson
                      //       .writeAsStringSync(json.encode(mainBookListCopy));
                      // }
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
Future<void> employeeDataAdder(context) async {
  Employee newBook = Employee('', '', '', '', '', '', '', '', '');
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
                    const Text('Add Employee'),
                    for (var item in newBook.allInfoHeaders)
                      // if (item == 'Condition')
                      //   Container(
                      //       padding: EdgeInsets.only(top: 10),
                      //       child: Column(children: [
                      //         Container(
                      //           alignment: Alignment(-1, 0),
                      //           padding: EdgeInsets.only(bottom: 5),
                      //           child: Text(
                      //             'Condition:',
                      //             style: TextStyle(
                      //                 color: Theme.of(context).hintColor),
                      //           ),
                      //         ),
                      //         RatingBar.builder(
                      //           itemSize: 40,
                      //           initialRating: 3,
                      //           minRating: 1,
                      //           direction: Axis.horizontal,
                      //           allowHalfRating: false,
                      //           itemCount: 5,
                      //           itemPadding:
                      //               const EdgeInsets.symmetric(horizontal: 4.0),
                      //           itemBuilder: (context, _) => const Icon(
                      //             Icons.star,
                      //             color: Colors.amber,
                      //           ),
                      //           onRatingUpdate: (rating) {
                      //             if (rating == 1.0) {
                      //               newBook.infoEdited(item, 'Poor');
                      //             } else if (rating == 2.0) {
                      //               newBook.infoEdited(item, 'Fair');
                      //             } else if (rating == 3.0) {
                      //               newBook.infoEdited(item, 'Good');
                      //             } else if (rating == 4.0) {
                      //               newBook.infoEdited(item, 'Excellent');
                      //             } else if (rating == 5.0) {
                      //               newBook.infoEdited(item, 'Superb');
                      //             }
                      //           },
                      //         )
                      //       ]))
                      // else if (item == 'Sold')
                      //   Container(
                      //       padding: const EdgeInsets.only(top: 5),
                      //       child: Column(children: [
                      //         Container(
                      //           alignment: const Alignment(-1, 0),
                      //           padding: const EdgeInsets.only(bottom: 5),
                      //           child: Text(
                      //             'Status:',
                      //             style: TextStyle(
                      //                 color: Theme.of(context).hintColor),
                      //           ),
                      //         ),
                      //         ToggleSwitch(
                      //           minWidth: 80.0,
                      //           minHeight: 30,
                      //           borderColor: [
                      //             Theme.of(context).primaryColorLight
                      //           ],
                      //           borderWidth: 1.5,
                      //           initialLabelIndex: 0,
                      //           cornerRadius: 50.0,
                      //           activeFgColor: Colors.white,
                      //           inactiveBgColor: Colors.grey,
                      //           inactiveFgColor: Colors.white,
                      //           totalSwitches: 2,
                      //           labels: const ['Available', 'Sold'],
                      //           activeBgColors: const [
                      //             [Colors.blue],
                      //             [Colors.pink]
                      //           ],
                      //           onToggle: (index) {
                      //             if (index == 0) {
                      //               newBook.infoEdited(item, 'Available');
                      //             } else if (index == 1) {
                      //               newBook.infoEdited(item, 'Sold');
                      //             }
                      //           },
                      //         )
                      //       ]))
                      // else
                        TextField(
                            // controller: TextEditingController()
                            //   ..text = item.toString(),
                            onChanged: (text) =>
                                {newBook.infoEdited(item, text)},
                            autofocus: true,
                            decoration: InputDecoration(
                                labelText: item + ':',
                                hintText: item)),
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
                    mainEmployeeList.add(newBook);
                    mainEmployeeListCopy.add(newBook);

                    if (!kIsWeb) {
                      mainEmployeeListCopy
                          .map(
                            (book) => book.toJson(),
                          )
                          .toList();
                      employeeDataJson
                          .writeAsStringSync(json.encode(mainEmployeeListCopy));
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
    Employee employee = Employee(
        b['firstName'],
        b['lastName'],
        b['id'],
        b['address'],
        b['phoneNumber'],
        b['dateOfBirth'],
        b['hireDate'],
        b['position'],
        b['description']);
    mainEmployeeList.add(employee);
    mainEmployeeListCopy.add(employee);
  }
  //debugPrint('test ${mainBookList.length}');
}

//Search Helper
Future<void> searchHelper(context, List<Employee> foundList) async {
  if (foundList.isEmpty) {
    mainEmployeeList.removeRange(1, mainEmployeeList.length);
    mainEmployeeList.first = Employee('', '', '', '', '', '', '', '', '');
  } else {
    if (mainEmployeeList.length > 1) {
      mainEmployeeList.removeRange(1, mainEmployeeList.length);
    }

    for (var employee in foundList) {
      if (employee == foundList.first) {
        mainEmployeeList.first = employee;
      } else if (foundList.length > 1) {
        mainEmployeeList.add(employee);
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
