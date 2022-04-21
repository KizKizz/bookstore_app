// ignore_for_file: avoid_print, avoid_renaming_method_parameters, curly_braces_in_flow_control_structures


import 'package:bookstore_project/login_page.dart';
import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:data_table_2/data_table_2.dart';

import 'data_storage_helper.dart';


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
      this.streetAddress,
      this.suiteNum,
      this.city,
      this.state,
      this.zipCode,
      this.phoneNumber,
      this.email,
      this.dateOfBirth,
      this.hireDate,
      this.terminationDate,
      this.position,
      this.numBookSold,
      this.lastSoldBooks,
      this.description);

  String firstName;
  String lastName;
  String id;
  String streetAddress;
  String suiteNum;
  String city;
  String state;
  String zipCode;
  String phoneNumber;
  String email;
  String dateOfBirth;
  String hireDate;
  String terminationDate;
  String position;
  String numBookSold;
  String lastSoldBooks;
  String description;

  bool selected = false;
  bool isSearched = false;
  List editResults = List.filled(17, null);

  List get allInfoHeaders {
    return [
      'First Name',
      'Last Name',
      'ID',
      'Street Address',
      'Suite Number',
      'City',
      'State',
      'Postal Code',
      'Phone Number',
      'Email',
      'Date of Birth',
      'Hire Date',
      'Termination Date',
      'Position',
      'Books Sold',
      'Last Sold Books',
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
    else if (info == 'Street Address' && editResults[3] != null)
      streetAddress = editResults[3];
    else if (info == 'Suite Number' && editResults[4] != null)
      suiteNum = editResults[4];
    else if (info == 'City' && editResults[5] != null)
      city = editResults[5];
    else if (info == 'State' && editResults[6] != null)
      state = editResults[6];
    else if (info == 'Postal Code' && editResults[7] != null)
      zipCode = editResults[7];
    else if (info == 'Phone Number' && editResults[8] != null)
      phoneNumber = editResults[8];
    else if (info == 'Email' && editResults[9] != null)
      email = editResults[9];
    else if (info == 'Date of Birth' && editResults[10] != null)
      dateOfBirth = editResults[10];
    else if (info == 'Hire Date' && editResults[11] != null) 
      hireDate = editResults[11];
    else if (info == 'Termination Date' && editResults[12] != null) 
      terminationDate = editResults[12];
    else if (info == 'Position' && editResults[13] != null) 
      position = editResults[13];
    else if (info == 'Books Sold' && editResults[14] != null) 
      numBookSold = editResults[14];
    else if (info == 'Last Sold Books' && editResults[15] != null) 
      lastSoldBooks = editResults[15];
    else if (info == 'Description' && editResults[16] != null) 
      description = editResults[16]; 
  }

  void infoEdited(var info, var editedVal) {
    if (info == 'First Name')
      editResults[0] = editedVal;
    else if (info == 'Last Name')
      editResults[1] = editedVal;
    else if (info == 'ID')
      editResults[2] = editedVal;
    else if (info == 'Street Address')
      editResults[3] = editedVal;
    else if (info == 'Suite Number')
      editResults[4] = editedVal;
    else if (info == 'City')
      editResults[5] = editedVal;
    else if (info == 'State')
      editResults[6] = editedVal;
    else if (info == 'Postal Code')
      editResults[7] = editedVal;
    else if (info == 'Phone Number')
      editResults[8] = editedVal;
    else if (info == 'Email')
      editResults[9] = editedVal;
    else if (info == 'Date of Birth')
      editResults[10] = editedVal;
    else if (info == 'Hire Date')
      editResults[11] = editedVal;
    else if (info == 'Termination Date')
      editResults[12] = editedVal;
    else if (info == 'Position')
      editResults[13] = editedVal;
    else if (info == 'Books Sold')
      editResults[14] = editedVal;
    else if (info == 'Last Sold Books')
      editResults[15] = editedVal;
    else if (info == 'Description')
      editResults[16] = editedVal;
    else
      editResults[0] = editedVal;
  }


  fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    id = json['id'];
    streetAddress = json['streetAddress'];
    suiteNum = json['suiteNum'];
    city = json['city'];
    state = json['state'];
    zipCode = json['zipCode'];
    phoneNumber = json['phoneNumber'];
    email = json['email'];
    dateOfBirth = json['dateOfBirth'];
    hireDate = json['hireDate'];
    terminationDate = json['terminationDate'];
    position = json['position'];
    numBookSold = json['numBookSold'];
    lastSoldBooks = json['lastSoldBooks'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['id'] = id;
    data['streetAddress'] = streetAddress;
    data['suiteNum'] = suiteNum;
    data['city'] = city;
    data['state'] = state;
    data['zipCode'] = zipCode;
    data['phoneNumber'] = phoneNumber;
    data['email'] = email;
    data['dateOfBirth'] = dateOfBirth;
    data['hireDate'] = hireDate;
    data['terminationDate'] = terminationDate;
    data['position'] = position;
    data['numBookSold'] = numBookSold;
    data['lastSoldBooks'] = lastSoldBooks;
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
      sort((d) => d.firstName + d.lastName, true);
    }
  }

  final BuildContext context;
  late List<Employee> employees;
  late bool hasRowTaps;
  late bool hasRowHeightOverrides;

  void sort<T>(Comparable<T> Function(Employee d) getField, bool ascending) {
    employees.sort((a, b) {
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
                _showDialog(context, employee)
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
        DataCell(Text(employee.id)),
        DataCell(Text('${employee.firstName} ${employee.lastName}')),
        if (employee.suiteNum.isNotEmpty)
          DataCell(Text(
              '${employee.streetAddress} ${employee.suiteNum} ${employee.city} ${employee.state}, ${employee.zipCode}')),
        if (employee.suiteNum.isEmpty)
          DataCell(Text(
              '${employee.streetAddress} ${employee.city} ${employee.state}, ${employee.zipCode}')),
        DataCell(Text(employee.phoneNumber)),
        DataCell(Text(employee.dateOfBirth)),
        DataCell(Text(employee.hireDate)),
        DataCell(Text(employee.terminationDate)),
        DataCell(Text(employee.position)),
        //DataCell(Text(employee.email)),
        DataCell(Text(employee.numBookSold)),
        //DataCell(Text(employee.description)),
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
              titlePadding: const EdgeInsets.only(top: 10),
              title: Center(
                child: Text(
                    '${curEmployee.firstName} ${curEmployee.lastName}\'s Info',
                    style: const TextStyle(fontWeight: FontWeight.w700)),
              ),
              contentPadding:
                  const EdgeInsets.only(top: 10, left: 16, bottom: 10),
              content: SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: SizedBox(
                        width: 400,
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
                                            controller: TextEditingController()
                                              ..text = curEmployee.firstName,
                                            onChanged: (text) =>
                                                {curEmployee.infoEdited('First Name', text)},
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
                                              ..text = curEmployee.lastName,
                                            onChanged: (text) =>
                                                {curEmployee.infoEdited('Last Name', text)},
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
                                              ..text = curEmployee.id,
                                            onChanged: (text) =>
                                                {curEmployee.infoEdited('ID', text)},
                                            decoration: const InputDecoration(
                                              //icon: Icon(Icons.person),
                                              hintText: '',
                                              labelText: 'ID',
                                            )),
                                      )),
                                      Expanded(
                                          child: Container(
                                        padding: const EdgeInsets.only(left: 10),
                                        child: TextFormField(
                                            controller: TextEditingController()
                                              ..text = curEmployee.dateOfBirth,
                                            onChanged: (text) =>
                                                {curEmployee.infoEdited('Date of Birth', text)},
                                            decoration: const InputDecoration(
                                              //icon: Icon(Icons.person),
                                              hintText: '',
                                              labelText: 'Date of Birth',
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
                                              ..text = curEmployee.streetAddress,
                                            onChanged: (text) => {
                                                  curEmployee.infoEdited('Street Address', text)
                                                },
                                            decoration: const InputDecoration(
                                              //icon: Icon(Icons.person),
                                              hintText: '',
                                              labelText: 'Street Address',
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
                                              ..text = curEmployee.suiteNum,
                                            onChanged: (text) =>
                                                {curEmployee.infoEdited('Suite Number', text)},
                                            decoration: const InputDecoration(
                                              //icon: Icon(Icons.person),
                                              hintText: '',
                                              labelText: 'Suite / Apt#',
                                            )),
                                      )),
                                      Expanded(
                                          child: Container(
                                        padding: const EdgeInsets.only(left: 10),
                                        child: TextFormField(
                                            controller: TextEditingController()
                                              ..text = curEmployee.city,
                                            onChanged: (text) =>
                                                {curEmployee.infoEdited('City', text)},
                                            decoration: const InputDecoration(
                                              //icon: Icon(Icons.person),
                                              hintText: '',
                                              labelText: 'City',
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
                                              ..text = curEmployee.state,
                                            onChanged: (text) =>
                                                {curEmployee.infoEdited('State', text)},
                                            decoration: const InputDecoration(
                                              //icon: Icon(Icons.person),
                                              hintText: '',
                                              labelText: 'State',
                                            )),
                                      )),
                                      Expanded(
                                          child: Container(
                                        padding: const EdgeInsets.only(left: 10),
                                        child: TextFormField(
                                            controller: TextEditingController()
                                              ..text = curEmployee.zipCode,
                                            onChanged: (text) =>
                                                {curEmployee.infoEdited('Postal Code', text)},
                                            decoration: const InputDecoration(
                                              //icon: Icon(Icons.person),
                                              hintText: '',
                                              labelText: 'Postal Code',
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
                                              ..text = curEmployee.hireDate,
                                            onChanged: (text) =>
                                                {curEmployee.infoEdited('Hire Date', text)},
                                            decoration: const InputDecoration(
                                              //icon: Icon(Icons.person),
                                              hintText: '',
                                              labelText: 'Hire Date',
                                            )),
                                      )),
                                      Expanded(
                                          child: Container(
                                        padding: const EdgeInsets.only(left: 10),
                                        child: TextFormField(
                                            controller: TextEditingController()
                                              ..text =
                                                  curEmployee.terminationDate,
                                            onChanged: (text) => {
                                                  curEmployee.infoEdited('Termination Date', text)
                                                },
                                            decoration: const InputDecoration(
                                              //icon: Icon(Icons.person),
                                              hintText: '',
                                              labelText: 'Termination Date',
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
                                              ..text = curEmployee.email,
                                            onChanged: (text) =>
                                                {curEmployee.infoEdited('Email', text)},
                                            decoration: const InputDecoration(
                                              //icon: Icon(Icons.person),
                                              hintText: 'example@domain.com',
                                              labelText: 'Email Address',
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
                                              ..text = curEmployee.description,
                                            onChanged: (text) =>
                                                {curEmployee.infoEdited('Description', text)},
                                            decoration: const InputDecoration(
                                              //icon: Icon(Icons.person),
                                              hintText: '',
                                              labelText: 'Description',
                                            )),
                                      )),
                                    ],
                                  ),
                                  Container(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Column(children: [
                                        Container(
                                          alignment: const Alignment(-1, 0),
                                          padding:
                                              const EdgeInsets.only(bottom: 5),
                                          child: Text(
                                            'Job Position:',
                                            style: TextStyle(
                                                fontSize: 13,
                                                color:
                                                    Theme.of(context).hintColor),
                                          ),
                                        ),
                                        CustomDropdownButton2(
                                          buttonHeight: 25,
                                          buttonWidth: 400,
                                          buttonPadding:
                                              const EdgeInsets.only(bottom: 3),
                                          hint: 'Select Status',
                                          dropdownDecoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(3),
                                            border: Border.all(
                                                color:
                                                    Theme.of(context).cardColor),
                                            //color: Colors.redAccent,
                                          ),
                                          buttonDecoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(3),
                                            border: Border.all(
                                                color:
                                                    Theme.of(context).hintColor),
                                            //color: Colors.redAccent,
                                          ),
                                          dropdownElevation: 2,
                                          offset: const Offset(0, 0),
                                          valueAlignment: Alignment.center,
                                          icon: const Icon(Icons.arrow_drop_down),
                                          iconSize: 20,
                                          dropdownWidth: 400,
                                          dropdownItems: _jobPosDropDownVal,
                                          value: _curJobPosChoice,
                                          onChanged: (String? newValue) {
                                            setState(
                                              () {
                                                _curJobPosChoice = newValue!;
                                                curEmployee.infoEdited('Position', newValue);
                                              },
                                            );
                                          },
                                        ),
                                      ])),
                                ],
                              ))
                            ],
                          ),
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
                        localDatabaseUpdate('employees');
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
  Employee newEmployee = Employee(
      '', '', '', '', '', '', '', '', '', '', '', '', '', '', '0', '', '');
  await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            titlePadding: const EdgeInsets.only(top: 10),
            title: const Center(
              child: Text('Add Employee',
                  style: TextStyle(fontWeight: FontWeight.w700)),
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
                                        onChanged: (text) =>
                                            {newEmployee.firstName = text},
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
                                        onChanged: (text) =>
                                            {newEmployee.lastName = text},
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
                                        onChanged: (text) =>
                                            {newEmployee.id = text},
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
                                        onChanged: (text) =>
                                            {newEmployee.dateOfBirth = text},
                                        decoration: const InputDecoration(
                                          //icon: Icon(Icons.person),
                                          hintText: '',
                                          labelText: 'Date of Birth',
                                        )),
                                  )),
                                  Expanded(
                                      child: Container(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: TextFormField(
                                        onChanged: (text) =>
                                            {newEmployee.phoneNumber = text},
                                        decoration: const InputDecoration(
                                          //icon: Icon(Icons.person),
                                          hintText: '',
                                          labelText: 'Phone Number',
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
                                        onChanged: (text) =>
                                            {newEmployee.streetAddress = text},
                                        decoration: const InputDecoration(
                                          //icon: Icon(Icons.person),
                                          hintText: '',
                                          labelText: 'Street Address',
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
                                        onChanged: (text) =>
                                            {newEmployee.suiteNum = text},
                                        decoration: const InputDecoration(
                                          //icon: Icon(Icons.person),
                                          hintText: '',
                                          labelText: 'Suite / Apt#',
                                        )),
                                  )),
                                  Expanded(
                                      child: Container(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: TextFormField(
                                        onChanged: (text) =>
                                            {newEmployee.city = text},
                                        decoration: const InputDecoration(
                                          //icon: Icon(Icons.person),
                                          hintText: '',
                                          labelText: 'City',
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
                                        onChanged: (text) =>
                                            {newEmployee.state = text},
                                        decoration: const InputDecoration(
                                          //icon: Icon(Icons.person),
                                          hintText: '',
                                          labelText: 'State',
                                        )),
                                  )),
                                  Expanded(
                                      child: Container(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: TextFormField(
                                        onChanged: (text) =>
                                            {newEmployee.zipCode = text},
                                        decoration: const InputDecoration(
                                          //icon: Icon(Icons.person),
                                          hintText: '',
                                          labelText: 'Postal Code',
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
                                        onChanged: (text) =>
                                            {newEmployee.hireDate = text},
                                        decoration: const InputDecoration(
                                          //icon: Icon(Icons.person),
                                          hintText: '',
                                          labelText: 'Hire Date',
                                        )),
                                  )),
                                  Expanded(
                                      child: Container(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: TextFormField(
                                        onChanged: (text) => {
                                              newEmployee.terminationDate = text
                                            },
                                        decoration: const InputDecoration(
                                          //icon: Icon(Icons.person),
                                          hintText: '',
                                          labelText: 'Termination Date',
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
                                        onChanged: (text) =>
                                            {newEmployee.email = text},
                                        decoration: const InputDecoration(
                                          //icon: Icon(Icons.person),
                                          hintText: 'example@domain.com',
                                          labelText: 'Email Address',
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
                                        onChanged: (text) =>
                                            {newEmployee.description = text},
                                        decoration: const InputDecoration(
                                          //icon: Icon(Icons.person),
                                          hintText: '',
                                          labelText: 'Description',
                                        )),
                                  )),
                                ],
                              ),
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
                                    CustomDropdownButton2(
                                      buttonHeight: 25,
                                      buttonWidth: 400,
                                      buttonPadding:
                                          const EdgeInsets.only(bottom: 3),
                                      hint: 'Select Status',
                                      dropdownDecoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(3),
                                        border: Border.all(
                                            color: Theme.of(context).cardColor),
                                        //color: Colors.redAccent,
                                      ),
                                      buttonDecoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(3),
                                        border: Border.all(
                                            color: Theme.of(context).hintColor),
                                        //color: Colors.redAccent,
                                      ),
                                      dropdownElevation: 2,
                                      offset: const Offset(0, 0),
                                      valueAlignment: Alignment.center,
                                      icon: const Icon(Icons.arrow_drop_down),
                                      iconSize: 20,
                                      dropdownWidth: 400,
                                      dropdownItems: _jobPosDropDownVal,
                                      value: _curJobPosChoice,
                                      onChanged: (String? newValue) {
                                        setState(
                                          () {
                                            _curJobPosChoice = newValue!;
                                            newEmployee.position = newValue;
                                          },
                                        );
                                      },
                                    ),
                                  ]))
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
                  child: const Text('ADD'),
                  onPressed: () {
                    newEmployee.position = _curJobPosChoice;
                    mainEmployeeList.add(newEmployee);
                    mainEmployeeListCopy.add(newEmployee);
                    Navigator.pop(context);
                    if (!kIsWeb) {
                      localDatabaseUpdate('employees');
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
        b['streetAddress'],
        b['suiteNum'],
        b['city'],
        b['state'],
        b['zipCode'],
        b['phoneNumber'],
        b['email'],
        b['dateOfBirth'],
        b['hireDate'],
        b['terminationDate'],
        b['position'],
        b['numBookSold'],
        b['lastSoldBooks'],
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
    mainEmployeeList.first = Employee(
        '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
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
