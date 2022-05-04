// ignore_for_file: avoid_print, avoid_renaming_method_parameters, curly_braces_in_flow_control_structures, unused_import

import 'dart:convert';

import 'package:bookstore_project/Data/book_data_handler.dart';
import 'package:bookstore_project/Extra/id_generator.dart';
import 'package:bookstore_project/login_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:data_table_2/data_table_2.dart';

import 'data_storage_helper.dart';

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
  Customer(
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
    this.totalPurchases,
    this.bookPurchased,
    this.purchasedDates,
  );

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
  String totalPurchases;
  String bookPurchased;
  String purchasedDates;

  bool selected = false;
  bool isSearched = false;
  List editResults = List.filled(13, null);

  List get allInfo {
    return [
      firstName,
      lastName,
      id,
      streetAddress,
      suiteNum,
      city,
      state,
      zipCode,
      phoneNumber,
      email,
      totalPurchases,
      bookPurchased,
      purchasedDates,
    ];
  }

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
      'Total Purchases',
      'Book Purchased',
      'Purchased Dates'
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
    else if (info == 'Total Purchases' && editResults[10] != null)
      totalPurchases = editResults[10];
    else if (info == 'Book Purchased' && editResults[11] != null)
      totalPurchases = editResults[11];
    else if (info == 'Purchased Dates' && editResults[12] != null)
      totalPurchases = editResults[12];
  }

  String headerToInfo(var header) {
    if (header == 'First Name')
      return firstName;
    else if (header == 'Last Name')
      return lastName;
    else if (header == 'ID')
      return id;
    else if (header == 'Street Address')
      return streetAddress;
    else if (header == 'Suite Number')
      return suiteNum;
    else if (header == 'City')
      return city;
    else if (header == 'State')
      return state;
    else if (header == 'Postal Code')
      return zipCode;
    else if (header == 'Phone Number')
      return phoneNumber;
    else if (header == 'Email')
      return email;
    else if (header == 'Total Purchases')
      return totalPurchases;
    else if (header == 'Book Purchased')
      return bookPurchased;
    else if (header == 'Purchased Dates')
      return purchasedDates;
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
    else if (info == 'Total Purchases')
      editResults[10] = editedVal;
    else if (info == 'Book Purchased')
      editResults[11] = editedVal;
    else if (info == 'Purchased Dates')
      editResults[12] = editedVal;
    else
      editResults[0] = editedVal;
  }

  fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    id = json['id'];
    streetAddress = json['streetAddress'];
    suiteNum = json['suiteNum'];
    city = json['suite'];
    state = json['state'];
    zipCode = json['zipCode'];
    phoneNumber = json['phoneNumber'];
    email = json['email'];
    totalPurchases = json['totalPurchases'];
    bookPurchased = json['bookPurchased'];
    purchasedDates = json['purchasedDates'];
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
    data['totalPurchases'] = totalPurchases;
    data['bookPurchased'] = bookPurchased;
    data['purchasedDates'] = purchasedDates;

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
      sort((d) => d.firstName + d.lastName, true);
    }
  }

  final BuildContext context;
  late List<Customer> customers;
  late bool hasRowTaps;
  late bool hasRowHeightOverrides;

  void sort<T>(Comparable<T> Function(Customer d) getField, bool ascending) {
    customers.sort((a, b) {
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
      onTap: hasRowTaps ? () => [_showDialog(context, customer)] : null,
      // onDoubleTap: hasRowTaps
      //     ? () => [
      //           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //             duration: const Duration(seconds: 1),
      //             //backgroundColor: Theme.of(context).focusColor,
      //             content: Text(
      //                 'Double Tapped on ${customer.firstName} ${customer.lastName}'),
      //           )),
      //         ]
      //     : null,
      // onSecondaryTap: hasRowTaps
      //     ? () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //           duration: const Duration(seconds: 1),
      //           backgroundColor: Theme.of(context).errorColor,
      //           content: Text(
      //               'Double Tapped on ${customer.firstName} ${customer.lastName}'),
      //         ))
      //     : null,
      specificRowHeight: hasRowHeightOverrides ? 100 : null,
      cells: [
        DataCell(Text(customer.id)),
        DataCell(Text('${customer.firstName} ${customer.lastName}')),
        if (customer.suiteNum.isNotEmpty)
          DataCell(Text(
              '${customer.streetAddress} ${customer.suiteNum} ${customer.city} ${customer.state}, ${customer.zipCode}')),
        if (customer.suiteNum.isEmpty)
          DataCell(Text(
              '${customer.streetAddress} ${customer.city} ${customer.state}, ${customer.zipCode}')),
        // DataCell(Text(customer.streetAddress)),
        // DataCell(Text(customer.suiteNum)),
        // DataCell(Text(customer.city)),
        // DataCell(Text(customer.state)),
        // DataCell(Text(customer.zipCode)),
        DataCell(Text(customer.phoneNumber)),
        DataCell(Text(customer.email)),
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
    //final _purchasedBookList = curCustomer.bookPurchased.split('||');
    final _purchasedDateList = curCustomer.purchasedDates.split('||');
    //print(_purchasedBookList.first);

    List<Book> _purchasedBooksList = [];
    List<Book> _recomBooksList = [];
    if (curCustomer.bookPurchased.isNotEmpty) {
      List<String> _purchasedBooksIDList = curCustomer.bookPurchased.split(' ');
      for (var id in _purchasedBooksIDList) {
        _purchasedBooksList
            .add(mainBookListCopy.singleWhere((element) => element.id == id));
      }
      for (var book in _purchasedBooksList) {
        final _tempRecList = mainBookListCopy.where((element) =>
            element.authorID == book.authorID && element.sold != 'Sold');
        if (_tempRecList.isNotEmpty) {
          for (var item in _tempRecList) {
            _recomBooksList.add(item);
          }
        }
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
                    '${curCustomer.firstName} ${curCustomer.lastName}\'s Info',
                    style: const TextStyle(fontWeight: FontWeight.w700)),
              ),
              contentPadding:
                  const EdgeInsets.only(top: 10, left: 16, bottom: 10),
              content: SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: SizedBox(
                        width: 800,
                        child: AbsorbPointer(
                          absorbing: !isManager,
                          child: IntrinsicHeight(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                    child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            child: Container(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: TextFormField(
                                              controller:
                                                  TextEditingController()
                                                    ..text = curCustomer
                                                        .headerToInfo(
                                                            'First Name'),
                                              onChanged: (text) => {
                                                    curCustomer.infoEdited(
                                                        'First Name', text)
                                                  },
                                              decoration: const InputDecoration(
                                                //icon: Icon(Icons.person),
                                                hintText: '',
                                                labelText: 'First Name',
                                              )),
                                        )),
                                        Expanded(
                                            child: Container(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: TextFormField(
                                              controller:
                                                  TextEditingController()
                                                    ..text = curCustomer
                                                        .headerToInfo(
                                                            'Last Name'),
                                              onChanged: (text) => {
                                                    curCustomer.infoEdited(
                                                        'Last Name', text)
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            child: Container(
                                          padding:
                                              const EdgeInsets.only(right: 0),
                                          child: TextFormField(
                                              controller:
                                                  TextEditingController()
                                                    ..text = curCustomer
                                                        .headerToInfo(
                                                            'Street Address'),
                                              onChanged: (text) => {
                                                    curCustomer.infoEdited(
                                                        'Street Address', text)
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            child: Container(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: TextFormField(
                                              controller:
                                                  TextEditingController()
                                                    ..text = curCustomer
                                                        .headerToInfo(
                                                            'Suite Number'),
                                              onChanged: (text) => {
                                                    curCustomer.infoEdited(
                                                        'Suite Number', text)
                                                  },
                                              decoration: const InputDecoration(
                                                //icon: Icon(Icons.person),
                                                hintText: '',
                                                labelText: 'Suite / Apt#',
                                              )),
                                        )),
                                        Expanded(
                                            child: Container(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: TextFormField(
                                              controller:
                                                  TextEditingController()
                                                    ..text = curCustomer
                                                        .headerToInfo('City'),
                                              onChanged: (text) => {
                                                    curCustomer.infoEdited(
                                                        'City', text)
                                                  },
                                              decoration: const InputDecoration(
                                                //icon: Icon(Icons.person),
                                                hintText: '',
                                                labelText: 'City',
                                              )),
                                        )),
                                      ],
                                    ),

                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            child: Container(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: TextFormField(
                                              controller:
                                                  TextEditingController()
                                                    ..text = curCustomer
                                                        .headerToInfo('State'),
                                              onChanged: (text) => {
                                                    curCustomer.infoEdited(
                                                        'State', text)
                                                  },
                                              decoration: const InputDecoration(
                                                //icon: Icon(Icons.person),
                                                hintText: '',
                                                labelText: 'State',
                                              )),
                                        )),
                                        Expanded(
                                            child: Container(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: TextFormField(
                                              controller:
                                                  TextEditingController()
                                                    ..text = curCustomer
                                                        .headerToInfo(
                                                            'Postal Code'),
                                              onChanged: (text) => {
                                                    curCustomer.infoEdited(
                                                        'Postal Code', text)
                                                  },
                                              decoration: const InputDecoration(
                                                //icon: Icon(Icons.person),
                                                hintText: '',
                                                labelText: 'Postal Code',
                                              )),
                                        )),
                                      ],
                                    ),

                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            child: Container(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: TextFormField(
                                              controller:
                                                  TextEditingController()
                                                    ..text = curCustomer
                                                        .headerToInfo(
                                                            'Phone Number'),
                                              onChanged: (text) => {
                                                    curCustomer.infoEdited(
                                                        'Phone Number', text)
                                                  },
                                              decoration: const InputDecoration(
                                                //icon: Icon(Icons.person),
                                                hintText: '',
                                                labelText: 'Phone Number',
                                              )),
                                        )),
                                        Expanded(
                                            child: Container(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: TextFormField(
                                              enabled: false,
                                              controller:
                                                  TextEditingController()
                                                    ..text = curCustomer
                                                        .headerToInfo('ID'),
                                              onChanged: (text) => {
                                                    curCustomer.infoEdited(
                                                        'ID', text)
                                                  },
                                              decoration: const InputDecoration(
                                                //icon: Icon(Icons.person),
                                                hintText: '',
                                                labelText: 'ID',
                                              )),
                                        )),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            child: Container(
                                          padding:
                                              const EdgeInsets.only(right: 0),
                                          child: TextFormField(
                                              controller:
                                                  TextEditingController()
                                                    ..text = curCustomer
                                                        .headerToInfo('Email'),
                                              onChanged: (text) => {
                                                    curCustomer.infoEdited(
                                                        'Email', text)
                                                  },
                                              decoration: const InputDecoration(
                                                //icon: Icon(Icons.person),
                                                hintText: '',
                                                labelText: 'Email',
                                              )),
                                        )),
                                      ],
                                    ),
                                    //List of Books
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text('Last Purchased Books',
                                          style: TextStyle(
                                              color:
                                                  Theme.of(context).hintColor,
                                              fontSize: 14)),
                                    ),
                                    Container(
                                      height: 75 *
                                          double.parse(_purchasedBooksList
                                              .length
                                              .toString()),
                                      width: 400,
                                      constraints:
                                          const BoxConstraints(maxHeight: 250),
                                      child: Column(
                                        children: [
                                          if (_purchasedBooksList.isNotEmpty)
                                            ListView(
                                              padding: const EdgeInsets.only(
                                                  left: 7, right: 7),
                                              clipBehavior: Clip.antiAlias,
                                              shrinkWrap: true,
                                              controller: ScrollController(),
                                              children: [
                                                for (int i = _purchasedBooksList
                                                            .length -
                                                        1;
                                                    i >= 0;
                                                    i--)
                                                  SizedBox(
                                                    height: 75,
                                                    child: Card(
                                                      elevation: 3,
                                                      clipBehavior:
                                                          Clip.antiAlias,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              side: BorderSide(
                                                                color: Theme.of(
                                                                        context)
                                                                    .hintColor
                                                                    .withOpacity(
                                                                        0.3),
                                                                //color: Colors.grey.withOpacity(0.2),
                                                                width: 1,
                                                              )),
                                                      child: ListTile(
                                                        dense: true,
                                                        //contentPadding: EdgeInsets.symmetric(vertical: 0),
                                                        onTap: () {
                                                          setState(() {});
                                                        },
                                                        leading: const Icon(Icons
                                                            .menu_book_outlined),
                                                        title: Text(
                                                          _purchasedBooksList[i]
                                                              .title,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 15),
                                                        ),
                                                        subtitle: Text(
                                                          '${_purchasedBooksList[i].authorFirstName} ${_purchasedBooksList[i].authorLastName} | ID: ${_purchasedBooksList[i].id}\nPurchased Date: ${_purchasedDateList[i]}',
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 14),
                                                        ),
                                                        // trailing:
                                                        //     const Icon(Icons.clear),
                                                        isThreeLine: false,
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          if (_purchasedBooksList.isEmpty)
                                            const Text(
                                              'No Data Found',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                                const Padding(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: VerticalDivider(
                                    thickness: 1,
                                    width: 1,
                                    indent: 20,
                                  ),
                                ),
                                Expanded(
                                    child: Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.only(
                                          top: 10, bottom: 10),
                                      child: Text('Recommended Books',
                                          style: TextStyle(
                                              color:
                                                  Theme.of(context).hintColor,
                                              fontSize: 14)),
                                    ),
                                    if (_recomBooksList.isNotEmpty)
                                    Expanded(
                                      child: Container(
                                        height: 75 *
                                            double.parse(_recomBooksList.length
                                                .toString()),
                                        width: 400,
                                        constraints: const BoxConstraints(
                                            maxHeight: 330),
                                        child: ListView(
                                          padding: const EdgeInsets.only(
                                              left: 7, right: 7),
                                          clipBehavior: Clip.antiAlias,
                                          shrinkWrap: true,
                                          //controller: ScrollController(),
                                          children: [
                                            for (int i =
                                                    _recomBooksList.length - 1;
                                                i >= 0;
                                                i--)
                                              SizedBox(
                                                height: 75,
                                                child: Card(
                                                  elevation: 2,
                                                  clipBehavior: Clip.antiAlias,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      side: BorderSide(
                                                        color: Theme.of(context)
                                                            .hintColor
                                                            .withOpacity(0.3),
                                                        //color: Colors.grey.withOpacity(0.2),
                                                        width: 1,
                                                      )),
                                                  child: ListTile(
                                                    dense: true,
                                                    //contentPadding: EdgeInsets.symmetric(vertical: 0),
                                                    onTap: () {
                                                      setState(() {});
                                                    },
                                                    leading: const Icon(Icons
                                                        .menu_book_outlined),
                                                    title: Text(
                                                      _recomBooksList[i].title,
                                                      style: const TextStyle(
                                                          fontSize: 15),
                                                    ),
                                                    subtitle: Text(
                                                      '${_recomBooksList[i].authorFirstName} ${_recomBooksList[i].authorLastName}\nID: ${_recomBooksList[i].id}',
                                                      style: const TextStyle(
                                                          fontSize: 14),
                                                    ),
                                                    // trailing: const Icon(Icons.clear),
                                                    isThreeLine: true,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (_recomBooksList.isEmpty)
                                      const Text(
                                        'No Recommended Books Found',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                  ],
                                )),
                              ],
                            ),
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
                        int _customerMatchIndex =
                            mainCustomerListCopy.indexWhere(
                                (element) => element.id == curCustomer.id);
                        //debugPrint('curafter: ${_customerMatchIndex}');
                        for (var item in curCustomer.allInfoHeaders) {
                          curCustomer.setInfo(item);
                        }

                        if (_customerMatchIndex >= 0) {
                          mainCustomerListCopy[_customerMatchIndex] =
                              curCustomer;
                        }
                        notifyListeners();
                        Navigator.pop(context);
                        if (!kIsWeb) {
                          localDatabaseUpdate('customers');
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
  Customer newCustomer =
      Customer('', '', '', '', '', '', '', '', '', '', '0', '', '');
  newCustomer.id = idGenerator('C');
  await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            titlePadding: const EdgeInsets.only(top: 10),
            title: const Center(
              child: Text('Add Customer',
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
                                            {newCustomer.firstName = text},
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
                                            {newCustomer.lastName = text},
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
                                    padding: const EdgeInsets.only(right: 0),
                                    child: TextFormField(
                                        onChanged: (text) =>
                                            {newCustomer.streetAddress = text},
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
                                            {newCustomer.suiteNum = text},
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
                                            {newCustomer.city = text},
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
                                            {newCustomer.state = text},
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
                                            {newCustomer.zipCode = text},
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
                                            {newCustomer.phoneNumber = text},
                                        decoration: const InputDecoration(
                                          //icon: Icon(Icons.person),
                                          hintText: '',
                                          labelText: 'Phone Number',
                                        )),
                                  )),
                                  Expanded(
                                      child: Container(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: TextFormField(
                                        enabled: false,
                                        controller: TextEditingController()
                                          ..text = newCustomer.id,
                                        onChanged: (text) =>
                                            {newCustomer.id = text},
                                        decoration: const InputDecoration(
                                          //icon: Icon(Icons.person),
                                          hintText: '',
                                          labelText: 'ID',
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
                                            {newCustomer.email = text},
                                        decoration: const InputDecoration(
                                          //icon: Icon(Icons.person),
                                          hintText: '',
                                          labelText: 'Email',
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
                  child: const Text('ADD'),
                  onPressed: () {
                    // for (var item in newCustomer.allInfoHeaders) {
                    //   newCustomer.setInfo(item);
                    // }
                    mainCustomerList.add(newCustomer);
                    mainCustomerListCopy.add(newCustomer);
                    Navigator.pop(context);
                    if (!kIsWeb) {
                      localDatabaseUpdate('customers');
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
        b['streetAddress'],
        b['suiteNum'],
        b['city'],
        b['state'],
        b['zipCode'],
        b['phoneNumber'],
        b['email'],
        b['totalPurchases'],
        b['bookPurchased'],
        b['purchasedDates']);
    mainCustomerList.add(customer);
    mainCustomerListCopy.add(customer);
  }
  //debugPrint('test ${mainBookList.length}');
}

//Search Helper
Future<void> customerSearchHelper(context, List<Customer> foundList) async {
  if (foundList.isEmpty) {
    mainCustomerList.removeRange(1, mainCustomerList.length);
    mainCustomerList.first =
        Customer('', '', '', '', '', '', '', '', '', '', '', '', '');
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
