// ignore_for_file: avoid_print, avoid_renaming_method_parameters, curly_braces_in_flow_control_structures

import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:data_table_2/data_table_2.dart';

import 'book_data_handler.dart';
import 'data_storage_helper.dart';

final List<String> _orderStatusDropDownVal = [
  'Picked Up',
  'Customer Will Pickup',
  'To Be shipped',
  'Shipped'
];
late String _curOrderStatusChoice = _orderStatusDropDownVal[0];

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
      this.totalOrderCost,
      this.paymentMethod,
      this.orderStatus,
      this.bookIds,
      this.bookSoldPrices,
      this.orderId);

  String orderNum;
  String customerName;
  String customerId;
  String salesPersonName;
  String salesPersonId;
  String orderDate;
  String deliveryDate;
  String totalOrderCost;
  String paymentMethod;
  String orderStatus;
  String bookIds;
  String bookSoldPrices;
  String orderId;

  bool selected = false;
  bool isSearched = false;
  List editResults = List.filled(13, null);

  List get allInfo {
    return [
      orderNum,
      customerName,
      customerId,
      salesPersonName,
      salesPersonId,
      orderDate,
      deliveryDate,
      totalOrderCost,
      paymentMethod,
      orderStatus,
      bookIds,
      bookSoldPrices,
      orderId,
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
      'Total Cost',
      'Payment Method',
      'Order Status',
      'BookIDs',
      'BookSoldPrices',
      'OrderID'
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
    else if (info == 'Total Cost' && editResults[7] != null)
      totalOrderCost = editResults[7];
    else if (info == 'Payment Method' && editResults[8] != null)
      paymentMethod = editResults[8];
    else if (info == 'Order Status' && editResults[9] != null)
      orderStatus = editResults[9];
    else if (info == 'BookIDs' && editResults[10] != null)
      bookIds = editResults[10];
    else if (info == 'BookSoldPrices' && editResults[11] != null)
      bookIds = editResults[11];
    else if (info == 'OrderID' && editResults[12] != null)
      bookIds = editResults[12];
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
    else if (header == 'Total Cost')
      return totalOrderCost;
    else if (header == 'Payment Method')
      return paymentMethod;
    else if (header == 'Order Status')
      return orderStatus;
    else if (header == 'BookIDs')
      return bookIds;
    else if (header == 'BookSoldPrices')
      return bookSoldPrices;
    else if (header == 'OrderID')
      return orderId;
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
    else if (info == 'Total Cost')
      editResults[7] = editedVal;
    else if (info == 'Payment Method')
      editResults[8] = editedVal;
    else if (info == 'Order Status')
      editResults[9] = editedVal;
    else if (info == 'BookIDs')
      editResults[10] = editedVal;
    else if (info == 'BookSoldPrices')
      editResults[11] = editedVal;
    else if (info == 'OrderID')
      editResults[12] = editedVal;
    else
      editResults[0] = editedVal;
  }

  fromJson(Map<String, dynamic> json) {
    orderNum = json['orderNum'];
    customerName = json['customerName'];
    customerId = json['customerId'];
    salesPersonName = json['salesPersonName'];
    salesPersonId = json['salesPersonId'];
    orderDate = json['orderDate'];
    deliveryDate = json['deliveryDate'];
    totalOrderCost = json['totalCost'];
    paymentMethod = json['paymentMethod'];
    orderStatus = json['orderStatus'];
    bookIds = json['bookIds'];
    bookSoldPrices = json['BookSoldPrices'];
    orderId = json['orderId'];
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
    data['totalCost'] = totalOrderCost;
    data['paymentMethod'] = paymentMethod;
    data['orderStatus'] = orderStatus;
    data['bookIds'] = bookIds;
    data['bookSoldPrices'] = bookSoldPrices;
    data['orderId'] = orderId;

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
      sort((d) => d.orderNum, false);
    }
  }

  final BuildContext context;
  late List<Order> orders;
  late bool hasRowTaps;
  late bool hasRowHeightOverrides;

  void sort<T>(Comparable<T> Function(Order d) getField, bool ascending) {
    orders.sort((a, b) {
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
                //if (isManager) {
                _showDialog(context, customer)
                //}
              ]
          : null,
      // onDoubleTap: hasRowTaps
      //     ? () => [
      //           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //             duration: const Duration(seconds: 1),
      //             //backgroundColor: Theme.of(context).focusColor,
      //             content: Text(
      //                 'Double Tapped on ${customer.orderNum} ${customer.customerName}'),
      //           )),
      //         ]
      //     : null,
      // onSecondaryTap: hasRowTaps
      //     ? () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //           duration: const Duration(seconds: 1),
      //           backgroundColor: Theme.of(context).errorColor,
      //           content: Text(
      //               'Double Tapped on ${customer.orderNum} ${customer.customerName}'),
      //         ))
      //     : null,
      specificRowHeight: hasRowHeightOverrides ? 100 : null,
      cells: [
        DataCell(Text(customer.orderId)),
        DataCell(Text(customer.customerName)),
        //DataCell(Text(customer.customerId)),
        DataCell(Text(customer.salesPersonName)),
        //DataCell(Text(customer.salesPersonId)),
        DataCell(Text(customer.orderDate)),
        DataCell(Text(customer.deliveryDate)),
        DataCell(Text('\$' + customer.totalOrderCost)),
        DataCell(Text(customer.paymentMethod)),
        DataCell(Text(customer.orderStatus)),
        //DataCell(Text(customer.bookIds)),
        //DataCell(Text(customer.bookSoldPrices)),
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
    List<String> _tempBookIDList = curOrder.bookIds.split(' ');
    List<Book> _orderedBooks = [];
    for (var id in _tempBookIDList) {
      _orderedBooks
          .add(mainBookListCopy.firstWhere((element) => element.id == id));
    }

    List<String> _tempOrderPrices = curOrder.bookSoldPrices.split(' ');

    _curOrderStatusChoice = _orderStatusDropDownVal
        .firstWhere((element) => element == curOrder.orderStatus);

    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              titlePadding: const EdgeInsets.only(top: 10),
              title: Center(
                child: Column(
                  children: [
                    const Text('Order Info',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    Text('(ID: ${curOrder.orderId})',
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                  ],
                ),
              ),
              contentPadding:
                  const EdgeInsets.only(top: 10, left: 16, bottom: 10),
              content: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
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
                                  enabled: false,
                                    controller: TextEditingController()
                                      ..text = curOrder
                                          .headerToInfo('Customer Name'),
                                    onChanged: (text) => {
                                          curOrder.infoEdited(
                                              'Customer Name', text)
                                        },
                                    decoration: const InputDecoration(
                                      //icon: Icon(Icons.person),
                                      hintText: '',
                                      labelText: 'Customer Name',
                                    )),
                              )),
                              Expanded(
                                  child: Container(
                                padding: const EdgeInsets.only(left: 10),
                                child: TextFormField(
                                  enabled: false,
                                    controller: TextEditingController()
                                      ..text =
                                          curOrder.headerToInfo('Customer ID'),
                                    onChanged: (text) => {
                                          curOrder.infoEdited(
                                              'Customer ID', text)
                                        },
                                    decoration: const InputDecoration(
                                      //icon: Icon(Icons.person),
                                      hintText: '',
                                      labelText: 'Customer ID',
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
                                  enabled: false,
                                    controller: TextEditingController()
                                      ..text = curOrder
                                          .headerToInfo('Salesperson Name'),
                                    onChanged: (text) => {
                                          curOrder.infoEdited(
                                              'Salesperson Name', text)
                                        },
                                    decoration: const InputDecoration(
                                      //icon: Icon(Icons.person),
                                      hintText: '',
                                      labelText: 'Salesperson Name',
                                    )),
                              )),
                              Expanded(
                                  child: Container(
                                padding: const EdgeInsets.only(left: 10),
                                child: TextFormField(
                                  enabled: false,
                                    controller: TextEditingController()
                                      ..text = curOrder
                                          .headerToInfo('Salesperson ID'),
                                    onChanged: (text) => {
                                          curOrder.infoEdited(
                                              'Salesperson ID', text)
                                        },
                                    decoration: const InputDecoration(
                                      //icon: Icon(Icons.person),
                                      hintText: '',
                                      labelText: 'Salesperson ID',
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
                                      ..text =
                                          curOrder.headerToInfo('Order Date'),
                                    onChanged: (text) => {
                                          curOrder.infoEdited(
                                              'Order Date', text)
                                        },
                                    decoration: const InputDecoration(
                                      //icon: Icon(Icons.person),
                                      hintText: '',
                                      labelText: 'Order Date',
                                    )),
                              )),
                              Expanded(
                                  child: Container(
                                padding: const EdgeInsets.only(left: 10),
                                child: TextFormField(
                                    controller: TextEditingController()
                                      ..text = curOrder
                                          .headerToInfo('Delivery Date'),
                                    onChanged: (text) => {
                                          curOrder.infoEdited(
                                              'Delivery Date', text)
                                        },
                                    decoration: const InputDecoration(
                                      //icon: Icon(Icons.person),
                                      hintText: '',
                                      labelText: 'Delivery Date',
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
                                      ..text = curOrder
                                          .headerToInfo('Payment Method'),
                                    onChanged: (text) => {
                                          curOrder.infoEdited(
                                              'Payment Method', text)
                                        },
                                    decoration: const InputDecoration(
                                      //icon: Icon(Icons.person),
                                      hintText: '',
                                      labelText: 'Payment Method',
                                    )),
                              )),
                              Expanded(
                                  child: Container(
                                padding: const EdgeInsets.only(left: 10),
                                child: TextFormField(
                                    controller: TextEditingController()
                                      ..text =
                                          curOrder.headerToInfo('Total Cost'),
                                    onChanged: (text) => {
                                          curOrder.infoEdited(
                                              'Total Cost', text)
                                        },
                                    decoration: const InputDecoration(
                                      //icon: Icon(Icons.person),
                                      prefixText: '\$',
                                      hintText: '',
                                      labelText: 'Total Cost',
                                    )),
                              )),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: Column(
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.only(
                                        top: 11, bottom: 7),
                                    child: Text(
                                      'Order Status',
                                      style: TextStyle(
                                          color: Theme.of(context).hintColor,
                                          fontSize: 12),
                                    ),
                                  ),
                                  SizedBox(
                                      width: double.infinity,
                                      child: CustomDropdownButton2(
                                        buttonHeight: 25,
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
                                        dropdownItems: _orderStatusDropDownVal,
                                        value: _curOrderStatusChoice,
                                        onChanged: (value) {
                                          setState(() {
                                            _curOrderStatusChoice = value!;
                                          });
                                        },
                                      )),
                                ],
                              )),
                            ],
                          ),

                          //List of Books
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(top: 10),
                            child: Text('Ordered books',
                                style: TextStyle(
                                    color: Theme.of(context).hintColor,
                                    fontSize: 14)),
                          ),
                          Container(
                            height: 75 *
                                double.parse(_orderedBooks.length.toString()),
                            width: 400,
                            constraints: const BoxConstraints(maxHeight: 330),
                            child: ListView(
                              padding: const EdgeInsets.only(left: 7, right: 7),
                              clipBehavior: Clip.antiAlias,
                              shrinkWrap: true,
                              //controller: ScrollController(),
                              children: [
                                for (int i = 0; i < _orderedBooks.length; i++)
                                  SizedBox(
                                    height: 75,
                                    child: Card(
                                      elevation: 2,
                                      clipBehavior: Clip.antiAlias,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
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
                                        leading: const Icon(
                                            Icons.menu_book_outlined),
                                        title: Text(
                                          _orderedBooks[i].title,
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                        subtitle: Text(
                                          '${_orderedBooks[i].authorFirstName} ${_orderedBooks[i].authorLastName}\nID: ${_orderedBooks[i].id} | \$${_tempOrderPrices[i]}',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        // trailing: const Icon(Icons.clear),
                                        isThreeLine: true,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ))
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                    child: const Text('CANCEL'),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                ElevatedButton(
                    child: const Text('SAVE'),
                    onPressed: () {
                      int _orderMatchIndex = mainOrderListCopy.indexWhere(
                          (element) => element.orderNum == curOrder.orderNum);
                      //debugPrint('curafter: ${_customerMatchIndex}');
                      for (var item in curOrder.allInfoHeaders) {
                        curOrder.setInfo(item);
                      }

                      //Set status addon
                      curOrder.orderStatus = _curOrderStatusChoice;

                      if (_orderMatchIndex >= 0) {
                        mainOrderListCopy[_orderMatchIndex] = curOrder;
                      }
                      notifyListeners();
                      Navigator.pop(context);
                      if (!kIsWeb) {
                        localDatabaseUpdate('orders');
                      }
                    })
              ],
            );
          });
        });
  }
}

//Add
Future<void> orderDataAdder(context) async {
  Order newOrder = Order(
    '',
    '',
    '',
    '',
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
                      localDatabaseUpdate('orders');
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
    Order order = Order(
      b['orderNum'],
      b['customerName'],
      b['customerId'],
      b['salesPersonName'],
      b['salesPersonId'],
      b['orderDate'],
      b['deliveryDate'],
      b['totalCost'],
      b['paymentMethod'],
      b['orderStatus'],
      b['bookIds'],
      b['bookSoldPrices'],
      b['orderId']
    );
    mainOrderList.add(order);
    mainOrderListCopy.add(order);
  }
  //debugPrint('test ${mainBookList.length}');
}

//Search Helper
Future<void> orderSearchHelper(context, List<Order> foundList) async {
  if (foundList.isEmpty) {
    mainOrderList.removeRange(1, mainOrderList.length);
    mainOrderList.first = Order(
      '',
      '',
      '',
      '',
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
    if (mainOrderList.length > 1) {
      mainOrderList.removeRange(1, mainOrderList.length);
    }

    for (var order in foundList) {
      if (order == foundList.first) {
        mainOrderList.first = order;
      } else if (foundList.length > 1) {
        mainOrderList.add(order);
      }
    }
  }
  //debugPrint('main ${mainBookList.toString()}');
  //debugPrint('copy ${mainBookListCopy.toString()}');
}
