

import 'dart:convert';

import 'package:bookstore_project/login_page.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';

import '../Data/order_data_handler.dart';
import '../main_appbar.dart';

final searchOrderController = TextEditingController();
//String _searchDropDownVal = 'Title';

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

  final List<String> _searchDropDownVal = [
    'Order Number',
    'Customer Name',
    'Customer ID',
    'Salesperson Name',
    'Salesperson ID',
    'Order Date',
    'Delivery Date',
    'Payment Method',
    'Order Status',
    'BookIDs'
  ];
  late String _curSearchChoice;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      setState(() {});
      _ordersDataSource = OrderDatabase(context);
      _curSearchChoice = _searchDropDownVal[0];
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

  @override
  Widget _searchField() {
    return TextField(
        controller: searchOrderController,
        onChanged: (String text) {
          setState(() {
            searchOrderList = [];
            Iterable<Order> foundOrder = [];
            if (_curSearchChoice == 'Order Number') {
              foundOrder = mainOrderListCopy.where((element) =>
                  element.orderNum.toLowerCase().contains(text.toLowerCase()));
            } else if (_curSearchChoice == 'Customer Name') {
              foundOrder = mainOrderListCopy.where((element) =>
                  element.customerName.toLowerCase().contains(text.toLowerCase()));
            } else if (_curSearchChoice == 'Customer ID') {
              foundOrder = mainOrderListCopy.where((element) =>
                  element.customerId.toLowerCase().contains(text.toLowerCase()));
            } else if (_curSearchChoice == 'Salesperon Name') {
              foundOrder = mainOrderListCopy.where((element) => element
                  .salesPersonName
                  .toLowerCase()
                  .contains(text.toLowerCase()));
            } else if (_curSearchChoice == 'Salesperon ID') {
              foundOrder = mainOrderListCopy.where((element) => element
                  .salesPersonId
                  .toLowerCase()
                  .contains(text.toLowerCase()));
            } else if (_curSearchChoice == 'Order Date') {
              foundOrder = mainOrderListCopy.where((element) => element
                  .orderDate
                  .toLowerCase()
                  .contains(text.toLowerCase()));
            } else if (_curSearchChoice == 'Delivery Date') {
              foundOrder = mainOrderListCopy.where((element) => element
                  .deliveryDate
                  .toLowerCase()
                  .contains(text.toLowerCase()));
            } else if (_curSearchChoice == 'Payment Medthod') {
              foundOrder = mainOrderListCopy.where((element) => element
                  .paymentMethod
                  .toLowerCase()
                  .contains(text.toLowerCase()));
            } else if (_curSearchChoice == 'Order Status') {
              foundOrder = mainOrderListCopy.where((element) => element
                  .orderStatus
                  .toLowerCase()
                  .contains(text.toLowerCase()));
            } else if (_curSearchChoice == 'Phone Number') {
              foundOrder = mainOrderListCopy.where((element) => element
                  .bookIds
                  .toLowerCase()
                  .contains(text.toLowerCase()));
            }

            if (foundOrder.isNotEmpty) {
              for (var customer in foundOrder) {
                Order tempOrder = Order(
                    customer.orderNum,
                    customer.customerName,
                    customer.customerId,
                    customer.salesPersonName,
                    customer.salesPersonId,
                    customer.orderDate,
                    customer.deliveryDate,
                    customer.paymentMethod,
                    customer.orderStatus,
                    customer.bookIds);
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
        cursorColor: Colors.white,
        style: const TextStyle(fontSize: 20, color: Colors.white),
        textInputAction: TextInputAction.search,
        decoration: const InputDecoration(
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.yellow)),
            hintText: 'Search',
            hintStyle: TextStyle(
                fontSize: 20, color: Color.fromARGB(255, 236, 236, 236))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //drawer: const MainDrawer(),
        appBar: MainAppbar(
          title: const Text('Order Data'),
          appBar: AppBar(),
          flexSpace: Container(
            padding: const EdgeInsets.only(top: 5, bottom: 12),
            margin: const EdgeInsets.only(left: 250, right: 368),
            // decoration: BoxDecoration(
            //   border: Border.all(color: Colors.white10)),
            child: _searchField(),
          ),
          widgets: <Widget>[
            // Clear
            if (searchOrderController.text.isNotEmpty)
              Container(
                width: 50,
                height: 50,
                padding: const EdgeInsets.only(
                    left: 2, right: 2, top: 10, bottom: 10),
                margin: const EdgeInsets.only(right: 0, top: 5, bottom: 4),
                child: MaterialButton(
                  onPressed: () => [
                    setState(() {
                      setState(() {
                        searchOrderController.clear();
                        searchOrderList = preSearchList;
                        orderSearchHelper(context, searchOrderList)
                            .then((_) {
                          setState(() {});
                        });
                      });
                    })
                  ],
                  child: const Icon(
                    Icons.clear_sharp,
                    color: Color.fromARGB(255, 240, 240, 240),
                  ),
                ),
              ),

            //Dropdown search
            Container(
                padding: const EdgeInsets.only(
                    left: 2, right: 2, top: 10, bottom: 0),
                margin: const EdgeInsets.only(right: 160, top: 5, bottom: 4),
                child: DropdownButton2(
                  buttonHeight: 25,
                  buttonWidth: 123,
                  offset: const Offset(0, 2),
                  // buttonDecoration: BoxDecoration(
                  //   borderRadius: BorderRadius.circular(5),
                  //   border: Border.all(
                  //     color: Colors.white54,
                  //   ),),
                  value: _curSearchChoice,
                  itemHeight: 35,
                  dropdownDecoration: const BoxDecoration(
                      color: Color.fromARGB(255, 54, 54, 54)),
                  itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                  items: _searchDropDownVal
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                        value: value,
                        child: SizedBox(
                            width: 98,
                            child: Text(
                              value,
                              style: const TextStyle(
                                  fontSize: 14.5, color: Colors.white),
                            )));
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _curSearchChoice = newValue!;
                    });
                  },
                )),

            //Add Data Button
            isManager
                ? MaterialButton(
                    onPressed: () => [
                      setState(() {
                        setState(() {
                          customerDataAdder(context).then((_) {
                            setState(() {});
                          });
                        });
                      })
                    ],
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const <Widget>[
                          Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Icon(
                              Icons.add_circle_outline_outlined,
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Text(
                              "Add",
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        ]),
                  )
                : const SizedBox(width: 80)
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
                        columnSpacing: 0,
                        horizontalMargin: 5,
                        bottomMargin: 5,
                        minWidth: 1000,
                        smRatio: 0.6,
                        lmRatio: 1.5,
                        sortColumnIndex: _sortColumnIndex,
                        sortAscending: _sortAscending,
                        onSelectAll: (val) =>
                            setState(() => _ordersDataSource.selectAll(val)),
                        columns: [
                          DataColumn2(
                            label: const Text(
                              'Order\nNumber',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            size: ColumnSize.S,
                            onSort: (columnIndex, ascending) => _sort<String>(
                                (d) => d.orderNum, columnIndex, ascending),
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
                          DataColumn2(
                            label: const Text(
                              'Customer\nID',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            size: ColumnSize.S,
                            numeric: false,
                            onSort: (columnIndex, ascending) => _sort<String>(
                                (d) => d.customerId, columnIndex, ascending),
                          ),
                          DataColumn2(
                            label: const Text(
                              'Salesperson\nName',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            size: ColumnSize.M,
                            numeric: false,
                            onSort: (columnIndex, ascending) => _sort<String>(
                                (d) => d.salesPersonName, columnIndex, ascending),
                          ),
                          DataColumn2(
                            label: const Text(
                              'Salesperson\nID',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            size: ColumnSize.S,
                            numeric: false,
                            onSort: (columnIndex, ascending) => _sort<String>(
                                (d) => d.salesPersonId, columnIndex, ascending),
                          ),
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
                          DataColumn2(
                            label: const Text(
                              'BookIDs',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            size: ColumnSize.L,
                            numeric: false,
                            onSort: (columnIndex, ascending) => _sort<String>(
                                (d) => d.bookIds, columnIndex, ascending),
                          ),
                      
                        ],
                        rows: List<DataRow>.generate(
                            _ordersDataSource.rowCount,
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

