// ignore_for_file: avoid_print, avoid_renaming_method_parameters

import 'dart:convert';
import 'dart:io';

import 'package:bookstore_project/login_page.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:data_table_2/data_table_2.dart';

final File customerDataJson = File('assets/jsondatabase/customer_data.json');
List<Customer> mainCustomerList = [];
List<Customer> mainCustomerListCopy = [];
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
class RestorableCustomerSelections extends RestorableProperty<Set<int>> {
  Set<int> _customerSelections = {};

  // Returns whether or not a row is selected by index.
  bool isSelected(int index) => _customerSelections.contains(index);

  // Takes a list of [Book]s and saves the row indices of selected rows
  // into a [Set].
  void setCustomerSelections(List<Customer> customers) {
    final updatedSet = <int>{};
    for (var i = 0; i < customers.length; i += 1) {
      var customer = customers[i];
      if (customer.selected) {
        updatedSet.add(i);
      }
    }
    _customerSelections = updatedSet;
    notifyListeners();
  }

  @override
  Set<int> createDefaultValue() => _customerSelections;

  @override
  Set<int> fromPrimitives(Object? data) {
    final selectedItemIndices = data as List<dynamic>;
    _customerSelections = {
      ...selectedItemIndices.map<int>((dynamic id) => id as int),
    };
    return _customerSelections;
  }

  @override
  void initWithValue(Set<int> value) {
    _customerSelections = value;
  }

  @override
  Object toPrimitives() => _customerSelections.toList();
}

/// Domain model entity
class Customer {
  Customer(this.firstName, this.lastName, this.id, this.address,
      this.phoneNumber, this.totalPurchases);

  String firstName;
  String lastName;
  String id;
  String address;
  String phoneNumber;
  String totalPurchases;

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
      totalPurchases,
    ];
  }

  List get allInfoHeaders {
    return [
      'First Name',
      'Last Name',
      'ID',
      'Address',
      'Phone Number',
      'Total Purchases',
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
    else if (info == 'Total Purchases' && editResults[5] != null)
      totalPurchases = editResults[5];
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
    else if (header == 'Total Purchases')
      return totalPurchases;
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
    else if (info == 'Total Purchases')
      editResults[5] = editedVal;
    else
      editResults[0] = editedVal;
  }

  fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    id = json['id'];
    address = json['address'];
    phoneNumber = json['phoneNumber'];
    totalPurchases = json['totalPurchases'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['id'] = id;
    data['address'] = address;
    data['phoneNumber'] = phoneNumber;
    data['totalPurchases'] = totalPurchases;

    return data;
  }
}

/// Data source implementing standard Flutter's DataTableSource abstract class
/// which is part of DataTable and PaginatedDataTable synchronous data fecthin API.
/// This class uses static collection of data as a data store, projects it into
/// DataRows, keeps track of selected items, provides sprting capability
class CustomerDatabase extends DataTableSource {
  CustomerDatabase.empty(this.context) {
    customers = [];
  }

  CustomerDatabase(this.context,
      [sortedByName = true,
      this.hasRowTaps = true,
      this.hasRowHeightOverrides = false]) {
    customers = mainCustomerList;
    if (sortedByName) {
      sort((d) => d.lastName, true);
    }
  }

  final BuildContext context;
  late List<Customer> customers;
  late bool hasRowTaps;
  late bool hasRowHeightOverrides;

  void sort<T>(Comparable<T> Function(Customer d) getField, bool ascending) {
    customers.sort((a, b) {
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
  void updateSelectedCustomers(RestorableCustomerSelections selectedRows) {
    _selectedCount = 0;
    for (var i = 0; i < customers.length; i += 1) {
      var customer = customers[i];
      if (selectedRows.isSelected(i)) {
        customer.selected = true;
        _selectedCount += 1;
      } else {
        customer.selected = false;
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
    if (index >= customers.length) throw 'index > .length';
    final customer = customers[index];
    return DataRow2.byIndex(
      index: index,
      selected: customer.selected,
      onSelectChanged: hasRowTaps
          ? null
          : (value) {
              if (customer.selected != value) {
                _selectedCount += value! ? 1 : -1;
                assert(_selectedCount >= 0);
                customer.selected = value;
                notifyListeners();
              }
            },
      onTap: hasRowTaps
          ? () => [
                if (isManager) {_showDialog(context, customer)}
              ]
          : null,
      onDoubleTap: hasRowTaps
          ? () => [
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  duration: const Duration(seconds: 1),
                  //backgroundColor: Theme.of(context).focusColor,
                  content: Text(
                      'Double Tapped on ${customer.firstName} ${customer.lastName}'),
                )),
              ]
          : null,
      onSecondaryTap: hasRowTaps
          ? () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                duration: const Duration(seconds: 1),
                backgroundColor: Theme.of(context).errorColor,
                content: Text(
                    'Double Tapped on ${customer.firstName} ${customer.lastName}'),
              ))
          : null,
      specificRowHeight: hasRowHeightOverrides ? 100 : null,
      cells: [
        DataCell(Text(customer.firstName)),
        DataCell(Text(customer.lastName)),
        DataCell(Text(customer.id)),
        DataCell(Text(customer.address)),
        DataCell(Text(customer.phoneNumber)),
        DataCell(Text(customer.totalPurchases)),
      ],
    );
  }

  @override
  int get rowCount => customers.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;

  void selectAll(bool? checked) {
    for (final dessert in customers) {
      dessert.selected = checked ?? false;
    }
    _selectedCount = (checked ?? false) ? customers.length : 0;
    notifyListeners();
  }

  //Edit Popup
  _showDialog(context, Customer curCustomer) async {
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              contentPadding: const EdgeInsets.all(16.0),
              content: Row(
                children: <Widget>[
                  Expanded(
                      child: SingleChildScrollView(
                          child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Edit Customer Info'),
                      for (var item in curCustomer.allInfoHeaders)
                        TextField(
                            controller: TextEditingController()
                              ..text = curCustomer.headerToInfo(item),
                            onChanged: (text) =>
                                {curCustomer.infoEdited(item, text)},
                            autofocus: true,
                            decoration: InputDecoration(
                                labelText: item + ':', hintText: item)),
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
                      int _customerMatchIndex = mainCustomerListCopy.indexWhere(
                          (element) => element.id == curCustomer.id);
                      //debugPrint('curafter: ${_customerMatchIndex}');
                      for (var item in curCustomer.allInfoHeaders) {
                        curCustomer.setInfo(item);
                      }

                      if (_customerMatchIndex >= 0) {
                        mainCustomerListCopy[_customerMatchIndex] = curCustomer;
                      }
                      notifyListeners();
                      Navigator.pop(context);
                      if (!kIsWeb) {
                        mainCustomerListCopy
                            .map(
                              (customer) => customer.toJson(),
                            )
                            .toList();
                        customerDataJson.writeAsStringSync(
                            json.encode(mainCustomerListCopy));
                      }
                    })
              ],
            );
          });
        });
  }
}

//Add
Future<void> customerDataAdder(context) async {
  _curJobPosChoice = _jobPosDropDownVal[2];
  Customer newCustomer = Customer(
    '',
    '',
    '',
    '',
    '',
    '',
  );
  await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(16.0),
            content: Row(
              children: <Widget>[
                Expanded(
                    child: SingleChildScrollView(
                        child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Add Customer'),
                    for (var item in newCustomer.allInfoHeaders)
                        TextField(
                            // controller: TextEditingController()
                            //   ..text = item.toString(),
                            onChanged: (text) =>
                                {newCustomer.infoEdited(item, text)},
                            autofocus: true,
                            decoration: InputDecoration(
                                labelText: item + ':', hintText: item)),
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
                    for (var item in newCustomer.allInfoHeaders) {
                      newCustomer.setInfo(item);
                    }
                    mainCustomerList.add(newCustomer);
                    mainCustomerListCopy.add(newCustomer);
                    Navigator.pop(context);
                    if (!kIsWeb) {
                      mainCustomerListCopy
                          .map(
                            (customer) => customer.toJson(),
                          )
                          .toList();
                      customerDataJson
                          .writeAsStringSync(json.encode(mainCustomerListCopy));
                    }

                    //debugPrint(newBook.allInfo.toString());
                  })
            ],
          );
        });
      });
}

//JSON Helper
void convertCustomerData(var jsonResponse) {
  for (var b in jsonResponse) {
    Customer customer = Customer(
      b['firstName'],
      b['lastName'],
      b['id'],
      b['address'],
      b['phoneNumber'],
      b['totalPurchases'],
    );
    mainCustomerList.add(customer);
    mainCustomerListCopy.add(customer);
  }
  //debugPrint('test ${mainBookList.length}');
}

//Search Helper
Future<void> customerSearchHelper(context, List<Customer> foundList) async {
  if (foundList.isEmpty) {
    mainCustomerList.removeRange(1, mainCustomerList.length);
    mainCustomerList.first = Customer('', '', '', '', '', '');
  } else {
    if (mainCustomerList.length > 1) {
      mainCustomerList.removeRange(1, mainCustomerList.length);
    }

    for (var customer in foundList) {
      if (customer == foundList.first) {
        mainCustomerList.first = customer;
      } else if (foundList.length > 1) {
        mainCustomerList.add(customer);
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
