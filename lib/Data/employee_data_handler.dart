// ignore_for_file: avoid_print, avoid_renaming_method_parameters

import 'dart:convert';
import 'dart:io';

import 'package:bookstore_project/login_page.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:data_table_2/data_table_2.dart';


final File employeeDataJson = File('assets/jsondatabase/employee_data.json');
List<Employee> mainEmployeeList = [];
List<Employee> mainEmployeeListCopy = [];
final List<String> _jobPosDropDownVal = [
  'Owner',
  'Assistant Manager',
  'Full Time Sales Clerk',
  'Part Time Sales Clerk',
];
late String _curJobPosChoice = _jobPosDropDownVal[0];

// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// The file was extracted from GitHub: https://github.com/flutter/gallery
// Changes and modifications by Maxim Saplin, 2021 - KizKizz 2022

/// Keeps track of selected rows, feed the data into DataSource
class RestorableEmployeeSelections extends RestorableProperty<Set<int>> {
  Set<int> _employeeSelections = {};

  // Returns whether or not a row is selected by index.
  bool isSelected(int index) => _employeeSelections.contains(index);

  // Takes a list of [Book]s and saves the row indices of selected rows
  // into a [Set].
  void setEmployeeSelections(List<Employee> employees) {
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
      this.numBookSold,
      this.description);

  String firstName;
  String lastName;
  String id;
  String address;
  String phoneNumber;
  String dateOfBirth;
  String hireDate;
  String position;
  String numBookSold;
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
      numBookSold,
      description,
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
      'Total Book Sales',
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
    else if (info == 'Total Book Sales' && editResults[8] != null)
      numBookSold = editResults[8];
    else if (info == 'Description' && editResults[9] != null)
      description = editResults[9];
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
    else if (header == 'Total Book Sales')
      return numBookSold;
    else if (header == 'Description')
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
    else if (info == 'Total Book Sales')
      editResults[8] = editedVal;
    else if (info == 'Description')
      editResults[9] = editedVal;
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
    numBookSold = json['numBookSold'];
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
    data['numBookSold'] = numBookSold;
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
  void updateSelectedEmployees(RestorableEmployeeSelections selectedRows) {
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
    if (index >= employees.length) throw 'index > .length';
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
          ? () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                duration: const Duration(seconds: 1),
                backgroundColor: Theme.of(context).errorColor,
                content: Text(
                    'Double Tapped on ${employee.firstName} ${employee.lastName}'),
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
        DataCell(Text(employee.numBookSold)),
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

  //Edit Popup
  _showDialog(context, Employee curEmployee) async {
    for (var pos in _jobPosDropDownVal) {
      if (pos == curEmployee.position) {
        _curJobPosChoice = pos;
      }
    }
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              contentPadding:
                  const EdgeInsets.only(top: 16, left: 16, bottom: 16),
              content: Container(
                //padding: const EdgeInsets.only(right: 20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Edit ${curEmployee.firstName} ${curEmployee.lastName}\'s Info',
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                      for (var item in curEmployee.allInfoHeaders)
                        if (item == 'Position')
                          Container(
                              padding: const EdgeInsets.only(top: 5),
                              child: Column(children: [
                                Container(
                                  alignment: const Alignment(-1, 0),
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    'Job Position:',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Theme.of(context).hintColor),
                                  ),
                                ),
                                DropdownButton2(
                                  buttonHeight: 40,
                                  buttonWidth: double.infinity,
                                  offset: const Offset(0, 2),
                                  // buttonDecoration: BoxDecoration(
                                  //   borderRadius: BorderRadius.circular(5),
                                  //   border: Border.all(
                                  //     color: Colors.white54,
                                  //   ),),
                                  value: _curJobPosChoice,
                                  itemHeight: 35,
                                  dropdownDecoration: const BoxDecoration(
                                      //color: Color.fromARGB(255, 54, 54, 54)
                                      ),
                                  itemPadding: const EdgeInsets.symmetric(
                                      horizontal: 2.0),
                                  items: _jobPosDropDownVal
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: const TextStyle(
                                            fontSize: 14.5,
                                            //color: Colors.white
                                          ),
                                        ));
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(
                                      () {
                                        _curJobPosChoice = newValue!;
                                        curEmployee.infoEdited(item, newValue);
                                      },
                                    );
                                  },
                                ),
                              ]))
                        else
                          TextField(
                              controller: TextEditingController()
                                ..text = curEmployee.headerToInfo(item),
                              onChanged: (text) =>
                                  {curEmployee.infoEdited(item, text)},
                              autofocus: true,
                              decoration: InputDecoration(
                                  labelText: item + ':', hintText: item)),
                    ],
                  ))
                ],
              )))),
              actions: <Widget>[
                TextButton(
                    child: const Text('CANCEL'),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                TextButton(
                    child: const Text('SAVE'),
                    onPressed: () {
                      int _employeeMatchIndex = mainEmployeeListCopy.indexWhere(
                          (element) => element.id == curEmployee.id);
                      //debugPrint('curafter: ${_employeeMatchIndex}');
                      for (var item in curEmployee.allInfoHeaders) {
                        curEmployee.setInfo(item);
                      }

                      if (_employeeMatchIndex >= 0) {
                        mainEmployeeListCopy[_employeeMatchIndex] = curEmployee;
                      }
                      notifyListeners();
                      Navigator.pop(context);
                      if (!kIsWeb) {
                        mainEmployeeListCopy
                            .map(
                              (employee) => employee.toJson(),
                            )
                            .toList();
                        employeeDataJson.writeAsStringSync(
                            json.encode(mainEmployeeListCopy));
                      }
                    })
              ],
           );
          });
        });
  }
}

//Add
Future<void> employeeDataAdder(context) async {
  _curJobPosChoice = _jobPosDropDownVal[2];
  Employee newEmployee = Employee('', '', '', '', '', '', '', '', '', '');
  await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            contentPadding:
                  const EdgeInsets.only(top: 16, left: 16, bottom: 16),
              content: Container(
                //padding: const EdgeInsets.only(right: 20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Add New Employee',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    for (var item in newEmployee.allInfoHeaders)
                      if (item == 'Position')
                        Container(
                            padding: const EdgeInsets.only(top: 15),
                            child: Column(children: [
                              Container(
                                alignment: const Alignment(-1, 0),
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Text(
                                  'Job Position:',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(context).hintColor),
                                ),
                              ),
                              DropdownButton2(
                                buttonHeight: 40,
                                buttonWidth: double.infinity,
                                offset: const Offset(0, 2),
                                // buttonDecoration: BoxDecoration(
                                //   borderRadius: BorderRadius.circular(5),
                                //   border: Border.all(
                                //     color: Colors.white54,
                                //   ),),
                                value: _curJobPosChoice,
                                itemHeight: 35,
                                dropdownDecoration: const BoxDecoration(
                                    //color: Color.fromARGB(255, 54, 54, 54)
                                    ),
                                itemPadding:
                                    const EdgeInsets.symmetric(horizontal: 2.0),
                                items: _jobPosDropDownVal
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: const TextStyle(
                                          fontSize: 14.5,
                                          //color: Colors.white
                                        ),
                                      ));
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(
                                    () {
                                      _curJobPosChoice = newValue!;
                                      newEmployee.infoEdited(item, newValue);
                                    },
                                  );
                                },
                              ),
                            ]))
                      else
                        TextField(
                            // controller: TextEditingController()
                            //   ..text = item.toString(),
                            onChanged: (text) =>
                                {newEmployee.infoEdited(item, text)},
                            autofocus: true,
                            decoration: InputDecoration(
                                labelText: item + ':', hintText: item)),
                  ],
                ))
              ],
            )))),
            actions: <Widget>[
              TextButton(
                  child: const Text('CANCEL'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              TextButton(
                  child: const Text('ADD'),
                  onPressed: () {
                    for (var item in newEmployee.allInfoHeaders) {
                      newEmployee.setInfo(item);
                    }
                    mainEmployeeList.add(newEmployee);
                    mainEmployeeListCopy.add(newEmployee);
                    Navigator.pop(context);
                    if (!kIsWeb) {
                      mainEmployeeListCopy
                          .map(
                            (employee) => employee.toJson(),
                          )
                          .toList();
                      employeeDataJson
                          .writeAsStringSync(json.encode(mainEmployeeListCopy));
                    }

                    //debugPrint(newBook.allInfo.toString());
                  })
            ],
          );
        });
      });
}

//JSON Helper
void convertEmployeeData(var jsonResponse) {
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
        b['numBookSold'],
        b['description']);
    mainEmployeeList.add(employee);
    mainEmployeeListCopy.add(employee);
  }
  //debugPrint('test ${mainBookList.length}');
}

//Search Helper
Future<void> employeeSearchHelper(context, List<Employee> foundList) async {
  if (foundList.isEmpty) {
    mainEmployeeList.removeRange(1, mainEmployeeList.length);
    mainEmployeeList.first = Employee('', '', '', '', '', '', '', '', '', '');
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
