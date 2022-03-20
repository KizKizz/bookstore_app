import 'dart:convert';

import 'package:bookstore_project/login_page.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';

import '../Data/customer_data_helper.dart';
import '../main_appbar.dart';

final searchCustomerController = TextEditingController();
//String _searchDropDownVal = 'Title';

class CustomerList extends StatefulWidget {
  const CustomerList({Key? key}) : super(key: key);

  @override
  _CustomerListState createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  bool _sortAscending = true;
  int? _sortColumnIndex;
  late CustomerDatabase _customersDataSource;
  bool _initialized = false;
  final ScrollController _controller = ScrollController();
  List<Customer> searchCustomerList = [];
  final List<Customer> preSearchList = mainCustomerListCopy;

  final List<String> _searchDropDownVal = [
    'First Name',
    'Last Name',
    'ID',
    'Address',
    'Phone Number',
    'Total Purchases',
  ];
  late String _curSearchChoice;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      setState(() {});
      _customersDataSource = CustomerDatabase(context);
      _curSearchChoice = _searchDropDownVal[0];
      _initialized = true;
      _customersDataSource.addListener(() {
        setState(() {});
      });
    }
  }

  void _sort<T>(
    Comparable<T> Function(Customer d) getField,
    int columnIndex,
    bool ascending,
  ) {
    _customersDataSource.sort<T>(getField, ascending);
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  @override
  void dispose() {
    _customersDataSource.dispose();
    super.dispose();
  }

  @override
  Widget _searchField() {
    return TextField(
        controller: searchCustomerController,
        onChanged: (String text) {
          setState(() {
            searchCustomerList = [];
            Iterable<Customer> foundCustomer = [];
            if (_curSearchChoice == 'First Name') {
              foundCustomer = mainCustomerListCopy.where((element) =>
                  element.firstName.toLowerCase().contains(text.toLowerCase()));
            } else if (_curSearchChoice == 'Last Name') {
              foundCustomer = mainCustomerListCopy.where((element) =>
                  element.lastName.toLowerCase().contains(text.toLowerCase()));
            } else if (_curSearchChoice == 'ID') {
              foundCustomer = mainCustomerListCopy.where((element) =>
                  element.id.toLowerCase().contains(text.toLowerCase()));
            } else if (_curSearchChoice == 'Address') {
              foundCustomer = mainCustomerListCopy.where((element) =>
                  element.address.toLowerCase().contains(text.toLowerCase()));
            } else if (_curSearchChoice == 'Phone Number') {
              foundCustomer = mainCustomerListCopy.where((element) => element
                  .phoneNumber
                  .toLowerCase()
                  .contains(text.toLowerCase()));
            } else if (_curSearchChoice == 'Date of Birth') {
              foundCustomer = mainCustomerListCopy.where((element) => element
                  .totalPurchases
                  .toLowerCase()
                  .contains(text.toLowerCase()));
            } 

            if (foundCustomer.isNotEmpty) {
              for (var customer in foundCustomer) {
                Customer tempCustomer = Customer(
                    customer.firstName,
                    customer.lastName,
                    customer.id,
                    customer.address,
                    customer.phoneNumber,
                    customer.totalPurchases);
                searchCustomerList.add(tempCustomer);
              }
              setState(() {
                customerSearchHelper(context, searchCustomerList).then((_) {
                  setState(() {});
                  //debugPrint('test ${mainBookList.toString()}');
                });
              });
            } else {
              setState(() {
                customerSearchHelper(context, searchCustomerList).then((_) {
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
          title: const Text('Customer Data'),
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
            if (searchCustomerController.text.isNotEmpty)
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
                        searchCustomerController.clear();
                        searchCustomerList = preSearchList;
                        customerSearchHelper(context, searchCustomerList)
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
                .loadString('assets/jsondatabase/customer_data.json'),
            builder: (context, snapshot) {
              if (snapshot.data.toString().isNotEmpty &&
                  snapshot.hasData &&
                  _customersDataSource.customers.isEmpty) {
                var jsonResponse = jsonDecode(snapshot.data.toString());
                convertCustomerData(jsonResponse);
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
                            setState(() => _customersDataSource.selectAll(val)),
                        columns: [
                          DataColumn2(
                            label: const Text(
                              'First\nName',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            size: ColumnSize.S,
                            onSort: (columnIndex, ascending) => _sort<String>(
                                (d) => d.firstName, columnIndex, ascending),
                          ),
                          DataColumn2(
                            label: const Text(
                              'Last\nName',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            size: ColumnSize.S,
                            onSort: (columnIndex, ascending) => _sort<String>(
                                (d) => d.lastName, columnIndex, ascending),
                          ),
                          DataColumn2(
                            label: const Text(
                              'ID',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            size: ColumnSize.S,
                            numeric: false,
                            onSort: (columnIndex, ascending) => _sort<String>(
                                (d) => d.id, columnIndex, ascending),
                          ),
                          DataColumn2(
                            label: const Text(
                              'Address',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            size: ColumnSize.L,
                            numeric: false,
                            onSort: (columnIndex, ascending) => _sort<String>(
                                (d) => d.address, columnIndex, ascending),
                          ),
                          DataColumn2(
                            label: const Text(
                              'Phone Number',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            size: ColumnSize.M,
                            numeric: false,
                            onSort: (columnIndex, ascending) => _sort<String>(
                                (d) => d.phoneNumber, columnIndex, ascending),
                          ),
                          DataColumn2(
                            label: const Text(
                              'Total Purchases',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            size: ColumnSize.S,
                            numeric: false,
                            onSort: (columnIndex, ascending) => _sort<num>(
                                (d) => int.parse(d.totalPurchases), columnIndex, ascending),
                          ),
                        ],
                        rows: List<DataRow>.generate(
                            _customersDataSource.rowCount,
                            (index) => _customersDataSource.getRow(index))),
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
