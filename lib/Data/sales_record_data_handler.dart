// ignore_for_file: avoid_print, avoid_renaming_method_parameters

import 'dart:convert';
import 'dart:io';

import 'package:bookstore_project/login_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:data_table_2/data_table_2.dart';


final File salesRecordDataJson =
    File('assets/jsondatabase/sales_record_data.json');
List<SalesRecord> mainSalesRecordList = [];
List<SalesRecord> mainSalesRecordListCopy = [];
final List<String> _salesRecordStatusDropDownVal = [
  'Picked Up',
  'Customer Will Pickup',
  'To Be shipped',
  'Shipped'
];
late String _curSalesRecordStatusChoice = _salesRecordStatusDropDownVal[0];

// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// The file was extracted from GitHub: https://github.com/flutter/gallery
// Changes and modifications by Maxim Saplin, 2021 - KizKizz 2022

/// Keeps track of selected rows, feed the data into DataSource
class RestorableSalesRecordSelections extends RestorableProperty<Set<int>> {
  Set<int> _salesRecordSelections = {};

  // Returns whether or not a row is selected by index.
  bool isSelected(int index) => _salesRecordSelections.contains(index);

  // Takes a list of [Book]s and saves the row indices of selected rows
  // into a [Set].
  void setSalesRecordSelections(List<SalesRecord> salesRecords) {
    final updatedSet = <int>{};
    for (var i = 0; i < salesRecords.length; i += 1) {
      var salesRecord = salesRecords[i];
      if (salesRecord.selected) {
        updatedSet.add(i);
      }
    }
    _salesRecordSelections = updatedSet;
    notifyListeners();
  }

  @override
  Set<int> createDefaultValue() => _salesRecordSelections;

  @override
  Set<int> fromPrimitives(Object? data) {
    final selectedItemIndices = data as List<dynamic>;
    _salesRecordSelections = {
      ...selectedItemIndices.map<int>((dynamic id) => id as int),
    };
    return _salesRecordSelections;
  }

  @override
  void initWithValue(Set<int> value) {
    _salesRecordSelections = value;
  }

  @override
  Object toPrimitives() => _salesRecordSelections.toList();
}

/// Domain model entity
class SalesRecord {
  SalesRecord(
    this.bookTitle,
    this.bookId,
    this.customerName,
    this.customerId,
    this.salesPersonName,
    this.salesPersonId,
    this.soldPrice,
    this.orderDate,
    this.deliveryDate,
  );

  String bookTitle;
  String bookId;
  String customerName;
  String customerId;
  String salesPersonName;
  String salesPersonId;
  String soldPrice;
  String orderDate;
  String deliveryDate;

  bool selected = false;
  bool isSearched = false;
  List editResults = List.filled(11, null);

  List get allInfo {
    return [
      bookTitle,
      bookId,
      customerName,
      customerId,
      salesPersonName,
      salesPersonId,
      soldPrice,
      orderDate,
      deliveryDate,
    ];
  }

  List get allInfoHeaders {
    return [
      'Book Title',
      'Book ID',
      'Customer Name',
      'Customer ID',
      'Salesperson Name',
      'Salesperson ID',
      'Sold Price',
      'Order Date',
      'Delivery Date',
    ];
  }

  void setInfo(var info) {
    if (info == 'Book Title' && editResults[0] != null)
      bookTitle = editResults[0];
    else if (info == 'Book ID' && editResults[1] != null)
      bookId = editResults[1];
    else if (info == 'Customer Name' && editResults[2] != null)
      customerName = editResults[2];
    else if (info == 'Customer ID' && editResults[3] != null)
      customerId = editResults[3];
    else if (info == 'Salesperson Name' && editResults[4] != null)
      salesPersonName = editResults[4];
    else if (info == 'Salesperson ID' && editResults[5] != null)
      salesPersonId = editResults[5];
    else if (info == 'Sold Price' && editResults[6] != null)
      soldPrice = editResults[6];
    else if (info == 'Order Date' && editResults[7] != null)
      orderDate = editResults[7];
    else if (info == 'Delivery Date' && editResults[8] != null)
      deliveryDate = editResults[8];
  }

  String headerToInfo(var header) {
    if (header == 'Book Title')
      return bookTitle;
    else if (header == 'Book ID')
      return bookId;
    else if (header == 'Customer Name')
      return customerName;
    else if (header == 'Customer ID')
      return customerId;
    else if (header == 'Salesperson Name')
      return salesPersonName;
    else if (header == 'Salesperson ID')
      return salesPersonId;
    else if (header == 'Sold Price')
      return soldPrice;
    else if (header == 'Order Date')
      return orderDate;
    else if (header == 'Delivery Date')
      return deliveryDate;
    else
      return 'error';
  }

  void infoEdited(var info, var editedVal) {
    if (info == 'Book Title')
      editResults[0] = editedVal;
    else if (info == 'Book ID')
      editResults[1] = editedVal;
    else if (info == 'Customer Name')
      editResults[2] = editedVal;
    else if (info == 'Customer ID')
      editResults[3] = editedVal;
    else if (info == 'Salesperson Name')
      editResults[4] = editedVal;
    else if (info == 'Salesperson ID')
      editResults[5] = editedVal;
    else if (info == 'Sold Price')
      editResults[6] = editedVal;
    else if (info == 'Order Date')
      editResults[7] = editedVal;
    else if (info == 'Delivery Date')
      editResults[8] = editedVal;
    else
      editResults[0] = editedVal;
  }

  fromJson(Map<String, dynamic> json) {
    bookTitle = json['bookTitle'];
    bookId = json['bookId'];
    customerName = json['customerName'];
    customerId = json['customerId'];
    salesPersonName = json['salesPersonName'];
    salesPersonId = json['salesPersonId'];
    soldPrice = json['soldPrice'];
    orderDate = json['orderDate'];
    deliveryDate = json['deliveryDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bookTitle'] = bookTitle;
    data['bookId'] = bookId;
    data['customerName'] = customerName;
    data['customerId'] = customerId;
    data['salesPersonName'] = salesPersonName;
    data['salesPersonId'] = salesPersonId;
    data['soldPrice'] = soldPrice;
    data['orderDate'] = orderDate;
    data['deliveryDate'] = deliveryDate;

    return data;
  }
}

/// Data source implementing standard Flutter's DataTableSource abstract class
/// which is part of DataTable and PaginatedDataTable synchronous data fecthin API.
/// This class uses static collection of data as a data store, projects it into
/// DataRows, keeps track of selected items, provides sprting capability
class SalesRecordDatabase extends DataTableSource {
  SalesRecordDatabase.empty(this.context) {
    salesRecords = [];
  }

  SalesRecordDatabase(this.context,
      [sortedByName = true,
      this.hasRowTaps = true,
      this.hasRowHeightOverrides = false]) {
      salesRecords = mainSalesRecordList;
    if (sortedByName) {
      sort((d) => d.customerName, true);
    }
  }

  final BuildContext context;
  late List<SalesRecord> salesRecords;
  late bool hasRowTaps;
  late bool hasRowHeightOverrides;

  void sort<T>(Comparable<T> Function(SalesRecord d) getField, bool ascending) {
    salesRecords.sort((a, b) {
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
  void updateSelectedSalesRecords(
      RestorableSalesRecordSelections selectedRows) {
    _selectedCount = 0;
    for (var i = 0; i < salesRecords.length; i += 1) {
      var customer = salesRecords[i];
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
    if (index >= salesRecords.length) throw 'index > .length';
    final salesRecord = salesRecords[index];
    return DataRow2.byIndex(
      index: index,
      selected: salesRecord.selected,
      onSelectChanged: hasRowTaps
          ? null
          : (value) {
              if (salesRecord.selected != value) {
                _selectedCount += value! ? 1 : -1;
                assert(_selectedCount >= 0);
                salesRecord.selected = value;
                notifyListeners();
              }
            },
      onTap: hasRowTaps
          ? () => [
                if (isManager) {_showDialog(context, salesRecord)}
              ]
          : null,
      onDoubleTap: hasRowTaps
          ? () => [
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  duration: const Duration(seconds: 1),
                  //backgroundColor: Theme.of(context).focusColor,
                  content: Text(
                      'Double Tapped on ${salesRecord.bookTitle} ${salesRecord.customerName}'),
                )),
              ]
          : null,
      onSecondaryTap: hasRowTaps
          ? () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                duration: const Duration(seconds: 1),
                backgroundColor: Theme.of(context).errorColor,
                content: Text(
                    'Double Tapped on ${salesRecord.bookTitle} ${salesRecord.customerName}'),
              ))
          : null,
      specificRowHeight: hasRowHeightOverrides ? 100 : null,
      cells: [
        DataCell(Text(salesRecord.bookTitle)),
        DataCell(Text(salesRecord.bookId)),
        DataCell(Text(salesRecord.customerName)),
        //DataCell(Text(salesRecord.customerId)),
        DataCell(Text(salesRecord.salesPersonName)),
        //DataCell(Text(salesRecord.salesPersonId)),
        DataCell(Text(salesRecord.soldPrice)),
        DataCell(Text(salesRecord.orderDate)),
        DataCell(Text(salesRecord.deliveryDate)),
      ],
    );
  }

  @override
  int get rowCount => salesRecords.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;

  void selectAll(bool? checked) {
    for (final dessert in salesRecords) {
      dessert.selected = checked ?? false;
    }
    _selectedCount = (checked ?? false) ? salesRecords.length : 0;
    notifyListeners();
  }

  //Edit Popup
  _showDialog(context, SalesRecord curSalesRecord) async {
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
                            const Text(
                                'Sale Info',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700)),
                            for (var item in curSalesRecord.allInfoHeaders)
                              TextField(
                                  controller: TextEditingController()
                                    ..text = curSalesRecord.headerToInfo(item),
                                  onChanged: (text) =>
                                      {curSalesRecord.infoEdited(item, text)},
                                  autofocus: false,
                                  decoration: InputDecoration(
                                      labelText: item + ':', hintText: item)
                              ),
                          ],
                        ))
                      ],
                    ),
                  ),
                ),
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
                      int _salesRecordMatchIndex =
                          mainSalesRecordListCopy.indexWhere((element) =>
                              element.bookId ==
                              curSalesRecord.bookId);
                      //debugPrint('curafter: ${_customerMatchIndex}');
                      for (var item in curSalesRecord.allInfoHeaders) {
                        curSalesRecord.setInfo(item);
                      }


                      if (_salesRecordMatchIndex >= 0) {
                        mainSalesRecordListCopy[_salesRecordMatchIndex] =
                            curSalesRecord;
                      }
                      notifyListeners();
                      Navigator.pop(context);
                      if (!kIsWeb) {
                        mainSalesRecordListCopy
                            .map(
                              (salesRecord) => salesRecord.toJson(),
                            )
                            .toList();
                        salesRecordDataJson.writeAsStringSync(
                            json.encode(mainSalesRecordListCopy));
                      }
                    })
              ],
            );
          });
        });
  }
}

//Add
Future<void> salesRecordDataAdder(context) async {
  SalesRecord newSalesRecord = SalesRecord(
    '',
    '',
    '',
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
                    const Text('Add SalesRecord'),
                    for (var item in newSalesRecord.allInfoHeaders)
                      TextField(
                          // controller: TextEditingController()
                          //   ..text = item.toString(),
                          onChanged: (text) =>
                              {newSalesRecord.infoEdited(item, text)},
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
                    for (var item in newSalesRecord.allInfoHeaders) {
                      newSalesRecord.setInfo(item);
                    }
                    mainSalesRecordList.add(newSalesRecord);
                    mainSalesRecordListCopy.add(newSalesRecord);
                    Navigator.pop(context);
                    if (!kIsWeb) {
                      mainSalesRecordListCopy
                          .map(
                            (customer) => customer.toJson(),
                          )
                          .toList();
                      salesRecordDataJson.writeAsStringSync(
                          json.encode(mainSalesRecordListCopy));
                    }

                    //debugPrint(newBook.allInfo.toString());
                  })
            ],
          );
        });
      });
}

//JSON Helper
void convertSalesRecordData(var jsonResponse) {
  for (var b in jsonResponse) {
    SalesRecord record = SalesRecord(
      b['bookTitle'],
      b['bookId'],
      b['customerName'],
      b['customerId'],
      b['salesPersonName'],
      b['salesPersonId'],
      b['soldPrice'],
      b['orderDate'],
      b['deliveryDate'],
    );
    mainSalesRecordList.add(record);
    mainSalesRecordListCopy.add(record);
  }
  //debugPrint('test ${mainBookList.length}');
}

//Search Helper
Future<void> salesRecordSearchHelper(
    context, List<SalesRecord> foundList) async {
  if (foundList.isEmpty) {
    mainSalesRecordList.removeRange(1, mainSalesRecordList.length);
    mainSalesRecordList.first = SalesRecord(
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
    );
  } else {
    if (mainSalesRecordList.length > 1) {
      mainSalesRecordList.removeRange(1, mainSalesRecordList.length);
    }

    for (var salesRecord in foundList) {
      if (salesRecord == foundList.first) {
        mainSalesRecordList.first = salesRecord;
      } else if (foundList.length > 1) {
        mainSalesRecordList.add(salesRecord);
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
