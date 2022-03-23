// ignore_for_file: avoid_print, avoid_renaming_method_parameters

import 'dart:convert';
import 'dart:io';

import 'package:bookstore_project/login_page.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:data_table_2/data_table_2.dart';

final File customerDataJson = File('assets/jsondatabase/order_data.json');
List<Order> mainOrderList = [];
List<Order> mainOrderListCopy = [];
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
class RestorableOrderSelections extends RestorableProperty<Set<int>> {
  Set<int> _orderSelections = {};

  // Returns whether or not a row is selected by index.
  bool isSelected(int index) => _orderSelections.contains(index);

  // Takes a list of [Book]s and saves the row indices of selected rows
  // into a [Set].
  void setOrderSelections(List<Order> orders) {
    final updatedSet = <int>{};
    for (var i = 0; i < orders.length; i += 1) {
      var order = orders[i];
      if (order.selected) {
        updatedSet.add(i);
      }
    }
    _orderSelections = updatedSet;
    notifyListeners();
  }

  @override
  Set<int> createDefaultValue() => _orderSelections;

  @override
  Set<int> fromPrimitives(Object? data) {
    final selectedItemIndices = data as List<dynamic>;
    _orderSelections = {
      ...selectedItemIndices.map<int>((dynamic id) => id as int),
    };
    return _orderSelections;
  }

  @override
  void initWithValue(Set<int> value) {
    _orderSelections = value;
  }

  @override
  Object toPrimitives() => _orderSelections.toList();
}

/// Domain model entity
class Order {
  Order(
      this.orderNum,
      this.customerName,
      this.customerId,
      this.salesPersonName,
      this.salesPersonId,
      this.orderDate,
      this.deliveryDate,
      this.paymentMethod,
      this.orderStatus,
      this.bookIds,
      );

  String orderNum;
  String customerName;
  String customerId;
  String salesPersonName;
  String salesPersonId;
  String orderDate;
  String deliveryDate;
  String paymentMethod;
  String orderStatus;
  String bookIds;

  bool selected = false;
  bool isSearched = false;
  List editResults = List.filled(11, null);

  List get allInfo {
    return [
      orderNum,
      customerName,
      customerId,
      salesPersonName,
      salesPersonId,
      orderDate,
      deliveryDate,
      paymentMethod,
      orderStatus,
      bookIds,
    ];
  }

  List get allInfoHeaders {
    return [
      'Order Number',
      'Customer Name',
      'Customer ID',
      'Salesperson Name',
      'Salesperson ID',
      'Order Date',
      'Delivery Date',
      'Payment Method',
      'Order Status',
      'BookIDs',
    ];
  }

  void setInfo(var info) {
    if (info == 'Order Number' && editResults[0] != null)
      orderNum = editResults[0];
    else if (info == 'Customer Name' && editResults[1] != null)
      customerName = editResults[1];
    else if (info == 'Customer ID' && editResults[2] != null)
      customerId = editResults[2];
    else if (info == 'Salesperson Name' && editResults[3] != null)
      salesPersonName = editResults[3];
    else if (info == 'Salesperson ID' && editResults[4] != null)
      salesPersonId = editResults[4];
    else if (info == 'Order Date' && editResults[5] != null)
      orderDate = editResults[5];
    else if (info == 'Delivery Date' && editResults[6] != null)
      deliveryDate = editResults[6];
    else if (info == 'Payment Method' && editResults[7] != null)
      paymentMethod = editResults[7];
    else if (info == 'Order Status' && editResults[8] != null)
      orderStatus = editResults[8];
    else if (info == 'BookIDs' && editResults[9] != null)
      bookIds = editResults[9];
  }

  String headerToInfo(var header) {
    if (header == 'Order Number')
      return orderNum;
    else if (header == 'Customer Name')
      return customerName;
    else if (header == 'Customer ID')
      return customerId;
    else if (header == 'Salesperson Name')
      return salesPersonName;
    else if (header == 'Salesperson ID')
      return salesPersonId;
    else if (header == 'Order Date')
      return orderDate;
    else if (header == 'Delivery Date')
      return deliveryDate;
    else if (header == 'Payment Method')
      return paymentMethod;
    else if (header == 'Order Status')
      return orderStatus;
    else if (header == 'BookIDs')
      return bookIds;
    else
      return 'error';
  }

  void infoEdited(var info, var editedVal) {
    if (info == 'Order Number')
      editResults[0] = editedVal;
    else if (info == 'Customer Name')
      editResults[1] = editedVal;
    else if (info == 'Customer ID')
      editResults[2] = editedVal;
    else if (info == 'Salesperson Name')
      editResults[3] = editedVal;
    else if (info == 'Salesperson ID')
      editResults[4] = editedVal;
    else if (info == 'Order Date')
      editResults[5] = editedVal;
    else if (info == 'Delivery Date')
      editResults[6] = editedVal;
    else if (info == 'Payment Method')
      editResults[7] = editedVal;
    else if (info == 'Order Status')
      editResults[8] = editedVal;
    else if (info == 'BookIDs')
      editResults[9] = editedVal;
    else if (info == 'Total Purchases')
      editResults[10] = editedVal;
    else
      editResults[0] = editedVal;
  }

  fromJson(Map<String, dynamic> json) {
    orderNum = json['orderNum'];
    customerName = json['customerName'];
    customerId = json['customerId'];
    salesPersonName = json['salesPersonName'];
    salesPersonId = json['salesPersonId'];
    orderDate = json['suite'];
    deliveryDate = json['deliveryDate'];
    paymentMethod = json['paymentMethod'];
    orderStatus = json['orderStatus'];
    bookIds = json['bookIds'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['orderNum'] = orderNum;
    data['customerName'] = customerName;
    data['customerId'] = customerId;
    data['salesPersonName'] = salesPersonName;
    data['salesPersonId'] = salesPersonId;
    data['orderDate'] = orderDate;
    data['deliveryDate'] = deliveryDate;
    data['paymentMethod'] = paymentMethod;
    data['orderStatus'] = orderStatus;
    data['bookIds'] = bookIds;

    return data;
  }
}

/// Data source implementing standard Flutter's DataTableSource abstract class
/// which is part of DataTable and PaginatedDataTable synchronous data fecthin API.
/// This class uses static collection of data as a data store, projects it into
/// DataRows, keeps track of selected items, provides sprting capability
class OrderDatabase extends DataTableSource {
  OrderDatabase.empty(this.context) {
    orders = [];
  }

  OrderDatabase(this.context,
      [sortedByName = true,
      this.hasRowTaps = true,
      this.hasRowHeightOverrides = false]) {
    orders = mainOrderList;
    if (sortedByName) {
      sort((d) => d.customerName, true);
    }
  }

  final BuildContext context;
  late List<Order> orders;
  late bool hasRowTaps;
  late bool hasRowHeightOverrides;

  void sort<T>(Comparable<T> Function(Order d) getField, bool ascending) {
    orders.sort((a, b) {
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
  void updateSelectedOrders(RestorableOrderSelections selectedRows) {
    _selectedCount = 0;
    for (var i = 0; i < orders.length; i += 1) {
      var customer = orders[i];
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
    if (index >= orders.length) throw 'index > .length';
    final customer = orders[index];
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
                      'Double Tapped on ${customer.orderNum} ${customer.customerName}'),
                )),
              ]
          : null,
      onSecondaryTap: hasRowTaps
          ? () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                duration: const Duration(seconds: 1),
                backgroundColor: Theme.of(context).errorColor,
                content: Text(
                    'Double Tapped on ${customer.orderNum} ${customer.customerName}'),
              ))
          : null,
      specificRowHeight: hasRowHeightOverrides ? 100 : null,
      cells: [
        DataCell(Text(customer.orderNum)),
        DataCell(Text(customer.customerName)),
        DataCell(Text(customer.customerId)),
        DataCell(Text(customer.salesPersonName)),
        DataCell(Text(customer.salesPersonId)),
        DataCell(Text(customer.orderDate)),
        DataCell(Text(customer.deliveryDate)),
        DataCell(Text(customer.paymentMethod)),
        DataCell(Text(customer.orderStatus)),
        DataCell(Text(customer.bookIds)),
      ],
    );
  }

  @override
  int get rowCount => orders.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;

  void selectAll(bool? checked) {
    for (final dessert in orders) {
      dessert.selected = checked ?? false;
    }
    _selectedCount = (checked ?? false) ? orders.length : 0;
    notifyListeners();
  }

  //Edit Popup
  _showDialog(context, Order curOrder) async {
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
                      const Text('Edit Order Info'),
                      for (var item in curOrder.allInfoHeaders)
                        TextField(
                            controller: TextEditingController()
                              ..text = curOrder.headerToInfo(item),
                            onChanged: (text) =>
                                {curOrder.infoEdited(item, text)},
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
                      int _orderMatchIndex = mainOrderListCopy.indexWhere(
                          (element) => element.orderNum == curOrder.orderNum);
                      //debugPrint('curafter: ${_customerMatchIndex}');
                      for (var item in curOrder.allInfoHeaders) {
                        curOrder.setInfo(item);
                      }

                      if (_orderMatchIndex >= 0) {
                        mainOrderListCopy[_orderMatchIndex] = curOrder;
                      }
                      notifyListeners();
                      Navigator.pop(context);
                      if (!kIsWeb) {
                        mainOrderListCopy
                            .map(
                              (customer) => customer.toJson(),
                            )
                            .toList();
                        customerDataJson.writeAsStringSync(
                            json.encode(mainOrderListCopy));
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
  Order newOrder = Order('', '', '', '', '', '', '', '', '', '',);
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
                    const Text('Add Order'),
                    for (var item in newOrder.allInfoHeaders)
                      TextField(
                          // controller: TextEditingController()
                          //   ..text = item.toString(),
                          onChanged: (text) =>
                              {newOrder.infoEdited(item, text)},
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
                    for (var item in newOrder.allInfoHeaders) {
                      newOrder.setInfo(item);
                    }
                    mainOrderList.add(newOrder);
                    mainOrderListCopy.add(newOrder);
                    Navigator.pop(context);
                    if (!kIsWeb) {
                      mainOrderListCopy
                          .map(
                            (customer) => customer.toJson(),
                          )
                          .toList();
                      customerDataJson
                          .writeAsStringSync(json.encode(mainOrderListCopy));
                    }

                    //debugPrint(newBook.allInfo.toString());
                  })
            ],
          );
        });
      });
}

//JSON Helper
void convertOrderData(var jsonResponse) {
  for (var b in jsonResponse) {
    Order customer = Order(
      b['orderNum'],
      b['customerName'],
      b['customerId'],
      b['salesPersonName'],
      b['salesPersonId'],
      b['orderDate'],
      b['deliveryDate'],
      b['paymentMethod'],
      b['orderStatus'],
      b['bookIds'],
    );
    mainOrderList.add(customer);
    mainOrderListCopy.add(customer);
  }
  //debugPrint('test ${mainBookList.length}');
}

//Search Helper
Future<void> orderSearchHelper(context, List<Order> foundList) async {
  if (foundList.isEmpty) {
    mainOrderList.removeRange(1, mainOrderList.length);
    mainOrderList.first =
        Order('', '', '', '', '', '', '', '', '', '',);
  } else {
    if (mainOrderList.length > 1) {
      mainOrderList.removeRange(1, mainOrderList.length);
    }

    for (var customer in foundList) {
      if (customer == foundList.first) {
        mainOrderList.first = customer;
      } else if (foundList.length > 1) {
        mainOrderList.add(customer);
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
