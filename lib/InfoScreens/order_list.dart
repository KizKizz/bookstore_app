import 'dart:convert';

import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';

import '../Data/data_storage_helper.dart';
import '../Data/order_data_handler.dart';
import '../main_appbar.dart';

final searchOrderController = TextEditingController();
//String _searchDropDownVal = 'Title';
final List<String> _searchDropDownVal = [
    'All Fields',
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
    'BookIDs'
  ];
  late String _curOrderSearchChoice = _searchDropDownVal[0];

class OrderList extends StatefulWidget {
  const OrderList({Key? key}) : super(key: key);

  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  bool _sortAscending = true;
  int? _sortColumnIndex;
  late OrderDatabase _ordersDataSource;
  bool _initialized = false;
  final ScrollController _controller = ScrollController();
  List<Order> searchOrderList = [];
  final List<Order> preSearchList = mainOrderListCopy;

  

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      setState(() {});
      _ordersDataSource = OrderDatabase(context);
      _initialized = true;
      _ordersDataSource.addListener(() {
        setState(() {});
      });
    }
  }

  void _sort<T>(
    Comparable<T> Function(Order d) getField,
    int columnIndex,
    bool ascending,
  ) {
    _ordersDataSource.sort<T>(getField, ascending);
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  @override
  void dispose() {
    _ordersDataSource.dispose();
    super.dispose();
  }

  Widget _searchField() {
    return TextField(
      controller: searchOrderController,
      onChanged: (String text) {
        setState(() {
          searchOrderList = [];
          Iterable<Order> foundOrder = [];
          if (_curOrderSearchChoice == 'All Fields') {
            foundOrder = mainOrderListCopy.where((element) =>
                element.orderNum.toLowerCase().contains(text.toLowerCase()) ||
                element.customerName.toLowerCase().contains(text.toLowerCase()) ||
                element.customerId.toLowerCase().contains(text.toLowerCase()) ||
                element.salesPersonName.toLowerCase().contains(text.toLowerCase()) ||
                element.salesPersonId.toLowerCase().contains(text.toLowerCase()) ||
                element.orderDate.toLowerCase().contains(text.toLowerCase()) ||
                element.deliveryDate.toLowerCase().contains(text.toLowerCase()) ||
                element.totalOrderCost.toLowerCase().contains(text.toLowerCase()) ||
                element.paymentMethod.toLowerCase().contains(text.toLowerCase()) ||
                element.orderStatus.toLowerCase().contains(text.toLowerCase()) ||
                element.bookIds.toLowerCase().contains(text.toLowerCase()));
          } else if (_curOrderSearchChoice == 'Order Number') {
            foundOrder = mainOrderListCopy.where((element) =>
                element.orderNum.toLowerCase().contains(text.toLowerCase()));
          } else if (_curOrderSearchChoice == 'Customer Name') {
            foundOrder = mainOrderListCopy.where((element) => element
                .customerName
                .toLowerCase()
                .contains(text.toLowerCase()));
          } else if (_curOrderSearchChoice == 'Customer ID') {
            foundOrder = mainOrderListCopy.where((element) =>
                element.customerId.toLowerCase().contains(text.toLowerCase()));
          } else if (_curOrderSearchChoice == 'Salesperon Name') {
            foundOrder = mainOrderListCopy.where((element) => element
                .salesPersonName
                .toLowerCase()
                .contains(text.toLowerCase()));
          } else if (_curOrderSearchChoice == 'Salesperon ID') {
            foundOrder = mainOrderListCopy.where((element) => element
                .salesPersonId
                .toLowerCase()
                .contains(text.toLowerCase()));
          } else if (_curOrderSearchChoice == 'Order Date') {
            foundOrder = mainOrderListCopy.where((element) =>
                element.orderDate.toLowerCase().contains(text.toLowerCase()));
          } else if (_curOrderSearchChoice == 'Delivery Date') {
            foundOrder = mainOrderListCopy.where((element) => element
                .deliveryDate
                .toLowerCase()
                .contains(text.toLowerCase()));
          } else if (_curOrderSearchChoice == 'Total Cost') {
            foundOrder = mainOrderListCopy.where((element) => element
                .totalOrderCost
                .toLowerCase()
                .contains(text.toLowerCase()));
          } else if (_curOrderSearchChoice == 'Payment Medthod') {
            foundOrder = mainOrderListCopy.where((element) => element
                .paymentMethod
                .toLowerCase()
                .contains(text.toLowerCase()));
          } else if (_curOrderSearchChoice == 'Order Status') {
            foundOrder = mainOrderListCopy.where((element) =>
                element.orderStatus.toLowerCase().contains(text.toLowerCase()));
          } else if (_curOrderSearchChoice == 'Phone Number') {
            foundOrder = mainOrderListCopy.where((element) =>
                element.bookIds.toLowerCase().contains(text.toLowerCase()));
          }

          if (foundOrder.isNotEmpty) {
            for (var order in foundOrder) {
              Order tempOrder = Order(
                order.orderNum,
                order.customerName,
                order.customerId,
                order.salesPersonName,
                order.salesPersonId,
                order.orderDate,
                order.deliveryDate,
                order.totalOrderCost,
                order.paymentMethod,
                order.orderStatus,
                order.bookIds,
                order.bookSoldPrices,
                order.orderId,
              );
              searchOrderList.add(tempOrder);
            }
            setState(() {
              orderSearchHelper(context, searchOrderList).then((_) {
                setState(() {});
                //debugPrint('test ${mainBookList.toString()}');
              });
            });
          } else {
            setState(() {
              orderSearchHelper(context, searchOrderList).then((_) {
                setState(() {});
              });
            });
          }
        });
      },
      onSubmitted: (String text) {
        setState(() {});
      },
      autofocus: false,
      maxLines: 1,
      cursorColor: Theme.of(context).hintColor,
      style: const TextStyle(fontSize: 21),
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
          prefixIcon:
              Icon(Icons.search, size: 25, color: Theme.of(context).hintColor),
          filled: true,
          fillColor: Theme.of(context).canvasColor,
          enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(3)),
              borderSide: BorderSide(
                color: Theme.of(context).hintColor,
              )),
          focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(3)),
              borderSide: BorderSide(
                color: Theme.of(context).hintColor,
              )),
          isDense: true,
          contentPadding: const EdgeInsets.all(8),
          hintText: 'Search',
          hintStyle: const TextStyle(
            fontSize: 21,
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //drawer: const MainDrawer(),
        appBar: MainAppbar(
          title: const Text('Orders', style: TextStyle(fontSize: 25)),
          appBar: AppBar(),
          flexSpace: Container(
            margin: const EdgeInsets.only(
              left: 200,
              right: 368,
            ),
            // decoration: BoxDecoration(
            //   border: Border.all(color: Colors.white10)),
            child: Container(
                padding: const EdgeInsets.only(left: 2, right: 0),
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                child: _searchField()),
          ),
          widgets: <Widget>[
            // Clear
            if (searchOrderController.text.isNotEmpty)
              Container(
                width: 50,
                height: 50,
                padding: const EdgeInsets.only(
                    left: 0, right: 0, top: 10, bottom: 10),
                margin: const EdgeInsets.only(right: 0, top: 3, bottom: 3),
                child: MaterialButton(
                  onPressed: () => [
                    setState(() {
                      setState(() {
                        searchOrderController.clear();
                        searchOrderList = preSearchList;
                        orderSearchHelper(context, searchOrderList).then((_) {
                          setState(() {});
                        });
                      });
                    })
                  ],
                  child: Icon(
                    Icons.clear_sharp,
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ),

            //Dropdown search
            Container(
                padding: const EdgeInsets.only(left: 2, right: 2),
                margin: const EdgeInsets.only(right: 80, top: 10, bottom: 10),
                child: CustomDropdownButton2(
                  hint: 'Select one',
                  // buttonHeight: 25,
                  icon: const Icon(Icons.arrow_drop_down),
                  iconSize: 20,
                  buttonPadding: const EdgeInsets.symmetric(horizontal: 10),
                  buttonWidth: 160,
                  dropdownWidth: 160,
                  offset: const Offset(0, 0),
                  dropdownHeight: double.maxFinite,
                  dropdownDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(color: Theme.of(context).cardColor),
                    //color: Colors.redAccent,
                  ),
                  buttonDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(color: Theme.of(context).hintColor),
                    color: Theme.of(context).canvasColor,
                  ),
                  dropdownElevation: 2,
                  value: _curOrderSearchChoice,
                  dropdownItems: _searchDropDownVal,
                  onChanged: (String? newValue) {
                    setState(() {
                      _curOrderSearchChoice = newValue!;
                    });
                  },
                )),
            const SizedBox(width: 128),
          ],
        ),
        body: FutureBuilder(
            future: DefaultAssetBundle.of(context)
                .loadString('assets/jsondatabase/order_data.json'),
            builder: (context, snapshot) {
              if (snapshot.data.toString().isNotEmpty &&
                  snapshot.hasData &&
                  _ordersDataSource.orders.isEmpty) {
                var jsonResponse = jsonDecode(snapshot.data.toString());
                convertOrderData(jsonResponse);
                //getAuthorsFromBook();
                //debugPrint('test ${jsonResponse}');
              }
              //Build table
              return Padding(
                  padding: const EdgeInsets.all(5),
                  child: Stack(children: [
                    //Data table
                    DataTable2(
                        scrollController: _controller,
                        showCheckboxColumn: false,
                        columnSpacing: 3,
                        horizontalMargin: 5,
                        bottomMargin: 5,
                        minWidth: 1100,
                        smRatio: 0.6,
                        lmRatio: 1.5,
                        sortColumnIndex: _sortColumnIndex,
                        sortAscending: _sortAscending,
                        onSelectAll: (val) =>
                            setState(() => _ordersDataSource.selectAll(val)),
                        columns: [
                          DataColumn2(
                            label: const Text(
                              'ID',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            size: ColumnSize.S,
                            onSort: (columnIndex, ascending) => _sort<String>(
                                (d) => d.orderId, columnIndex, ascending),
                          ),
                          DataColumn2(
                            label: const Text(
                              'Customer\nName',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            size: ColumnSize.M,
                            onSort: (columnIndex, ascending) => _sort<String>(
                                (d) => d.customerName, columnIndex, ascending),
                          ),
                          // DataColumn2(
                          //   label: const Text(
                          //     'Customer\nID',
                          //     style: TextStyle(fontWeight: FontWeight.bold),
                          //   ),
                          //   size: ColumnSize.S,
                          //   numeric: false,
                          //   onSort: (columnIndex, ascending) => _sort<String>(
                          //       (d) => d.customerId, columnIndex, ascending),
                          // ),
                          DataColumn2(
                            label: const Text(
                              'Salesperson\nName',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            size: ColumnSize.M,
                            numeric: false,
                            onSort: (columnIndex, ascending) => _sort<String>(
                                (d) => d.salesPersonName,
                                columnIndex,
                                ascending),
                          ),
                          // DataColumn2(
                          //   label: const Text(
                          //     'Salesperson\nID',
                          //     style: TextStyle(fontWeight: FontWeight.bold),
                          //   ),
                          //   size: ColumnSize.S,
                          //   numeric: false,
                          //   onSort: (columnIndex, ascending) => _sort<String>(
                          //       (d) => d.salesPersonId, columnIndex, ascending),
                          // ),
                          DataColumn2(
                            label: const Text(
                              'Order Date',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            size: ColumnSize.M,
                            numeric: false,
                            onSort: (columnIndex, ascending) => _sort<String>(
                                (d) => d.orderDate, columnIndex, ascending),
                          ),
                          DataColumn2(
                            label: const Text(
                              'Delivery Date',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            size: ColumnSize.M,
                            numeric: false,
                            onSort: (columnIndex, ascending) => _sort<String>(
                                (d) => d.deliveryDate, columnIndex, ascending),
                          ),
                          DataColumn2(
                            label: const Text(
                              'Total Cost',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            size: ColumnSize.S,
                            numeric: false,
                            onSort: (columnIndex, ascending) => _sort<num>(
                                (d) => double.parse(d.totalOrderCost),
                                columnIndex,
                                ascending),
                          ),
                          DataColumn2(
                            label: const Text(
                              'Payment\nMethod',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            size: ColumnSize.S,
                            numeric: false,
                            onSort: (columnIndex, ascending) => _sort<String>(
                                (d) => d.paymentMethod, columnIndex, ascending),
                          ),
                          DataColumn2(
                            label: const Text(
                              'Order Status',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            size: ColumnSize.M,
                            numeric: false,
                            onSort: (columnIndex, ascending) => _sort<String>(
                                (d) => d.orderStatus, columnIndex, ascending),
                          ),
                          // DataColumn2(
                          //   label: const Text(
                          //     'BookIDs',
                          //     style: TextStyle(fontWeight: FontWeight.bold),
                          //   ),
                          //   size: ColumnSize.L,
                          //   numeric: false,
                          //   onSort: (columnIndex, ascending) => _sort<String>(
                          //       (d) => d.bookIds, columnIndex, ascending),
                          // ),
                          // DataColumn2(
                          //   label: const Text(
                          //     'Prices',
                          //     style: TextStyle(fontWeight: FontWeight.bold),
                          //   ),
                          //   size: ColumnSize.L,
                          //   numeric: false,
                          //   onSort: (columnIndex, ascending) => _sort<String>(
                          //       (d) => d.bookIds, columnIndex, ascending),
                          // ),
                        ],
                        rows: List<DataRow>.generate(_ordersDataSource.rowCount,
                            (index) => _ordersDataSource.getRow(index))),
                    _ScrollUpButton(_controller)
                  ]));
            }));
  }
}

class _ScrollUpButton extends StatefulWidget {
  const _ScrollUpButton(this.controller);

  final ScrollController controller;

  @override
  _ScrollUpButtonState createState() => _ScrollUpButtonState();
}

class _ScrollUpButtonState extends State<_ScrollUpButton> {
  bool _showScrollUp = false;

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(() {
      if (widget.controller.position.pixels > 20 && !_showScrollUp) {
        setState(() {
          _showScrollUp = true;
        });
      } else if (widget.controller.position.pixels < 20 && _showScrollUp) {
        setState(() {
          _showScrollUp = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _showScrollUp
        ? Positioned(
            right: 10,
            bottom: 10,
            child: OutlinedButton(
              child: const Text('↑ To Top ↑'),
              onPressed: () => widget.controller.animateTo(0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.grey[800]),
                  foregroundColor: MaterialStateProperty.all(Colors.white)),
            ))
        : const SizedBox();
  }
}
