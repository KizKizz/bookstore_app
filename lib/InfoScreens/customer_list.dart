import 'dart:convert';

import 'package:bookstore_project/login_page.dart';
import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';

import '../Data/customer_data_handler.dart';
import '../Data/data_storage_helper.dart';
import '../main_appbar.dart';

final searchCustomerController = TextEditingController();
//String _searchDropDownVal = 'Title';
final List<String> _searchDropDownVal = [
    'All Fields',
    'First Name',
    'Last Name',
    'ID',
    'Address',
    'Phone Number',
    'Total Purchases',
  ];
  late String _curSearchChoice = _searchDropDownVal[0];

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

  

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      setState(() {});
      _customersDataSource = CustomerDatabase(context);
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

  Widget _searchField() {
    return TextField(
      controller: searchCustomerController,
      onChanged: (String text) {
        setState(() {
          searchCustomerList = [];
          Iterable<Customer> foundCustomer = [];
          if (_curSearchChoice == 'All Fields') {
            foundCustomer = mainCustomerListCopy.where((element) =>
                element.firstName.toLowerCase().contains(text.toLowerCase()) ||
                element.lastName.toLowerCase().contains(text.toLowerCase()) ||
                element.id.toLowerCase().contains(text.toLowerCase()) ||
                element.streetAddress
                    .toLowerCase()
                    .contains(text.toLowerCase()) ||
                element.suiteNum.toLowerCase().contains(text.toLowerCase()) ||
                element.city.toLowerCase().contains(text.toLowerCase()) ||
                element.state.toLowerCase().contains(text.toLowerCase()) ||
                element.zipCode.toLowerCase().contains(text.toLowerCase()) ||
                element.phoneNumber
                    .toLowerCase()
                    .contains(text.toLowerCase()) ||
                element.totalPurchases
                    .toLowerCase()
                    .contains(text.toLowerCase()));
          } else if (_curSearchChoice == 'First Name') {
            foundCustomer = mainCustomerListCopy.where((element) =>
                element.firstName.toLowerCase().contains(text.toLowerCase()));
          } else if (_curSearchChoice == 'Last Name') {
            foundCustomer = mainCustomerListCopy.where((element) =>
                element.lastName.toLowerCase().contains(text.toLowerCase()));
          } else if (_curSearchChoice == 'ID') {
            foundCustomer = mainCustomerListCopy.where((element) =>
                element.id.toLowerCase().contains(text.toLowerCase()));
          } else if (_curSearchChoice == 'Address') {
            foundCustomer = mainCustomerListCopy.where((element) => element
                .streetAddress
                .toLowerCase()
                .contains(text.toLowerCase()));
            foundCustomer = mainCustomerListCopy.where((element) =>
                element.suiteNum.toLowerCase().contains(text.toLowerCase()));
            foundCustomer = mainCustomerListCopy.where((element) =>
                element.city.toLowerCase().contains(text.toLowerCase()));
            foundCustomer = mainCustomerListCopy.where((element) =>
                element.state.toLowerCase().contains(text.toLowerCase()));
            foundCustomer = mainCustomerListCopy.where((element) =>
                element.zipCode.toLowerCase().contains(text.toLowerCase()));
          } else if (_curSearchChoice == 'Phone Number') {
            foundCustomer = mainCustomerListCopy.where((element) =>
                element.phoneNumber.toLowerCase().contains(text.toLowerCase()));
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
                  customer.streetAddress,
                  customer.suiteNum,
                  customer.city,
                  customer.state,
                  customer.zipCode,
                  customer.phoneNumber,
                  customer.email,
                  customer.totalPurchases,
                  customer.bookPurchased,
                  customer.purchasedDates);
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
          title: const Text('Customers', style: TextStyle(fontSize: 25)),
          appBar: AppBar(),
          flexSpace: Container(
            margin: const EdgeInsets.only(
              left: 200,
              right: 368,
            ),
            child: Container(
                padding: const EdgeInsets.only(left: 2, right: 0),
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                child: _searchField()),
          ),
          widgets: <Widget>[
            // Clear
            if (searchCustomerController.text.isNotEmpty)
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
                        searchCustomerController.clear();
                        searchCustomerList = preSearchList;
                        customerSearchHelper(context, searchCustomerList)
                            .then((_) {
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
                  value: _curSearchChoice,
                  dropdownItems: _searchDropDownVal,
                  onChanged: (String? newValue) {
                    setState(() {
                      _curSearchChoice = newValue!;
                    });
                  },
                )),

            //Add Data Button
            const SizedBox(width: 48),
            //isManager
                //?
                 MaterialButton(
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
                //Padding for nonmanager
                //: const SizedBox(width: 128),
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
                        columnSpacing: 3,
                        horizontalMargin: 5,
                        bottomMargin: 5,
                        minWidth: 1100,
                        smRatio: 0.6,
                        lmRatio: 1.5,
                        sortColumnIndex: _sortColumnIndex,
                        sortAscending: _sortAscending,
                        onSelectAll: (val) =>
                            setState(() => _customersDataSource.selectAll(val)),
                        columns: [
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
                              'Full Name',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            size: ColumnSize.M,
                            onSort: (columnIndex, ascending) => _sort<String>(
                                (d) => d.firstName + d.lastName, columnIndex, ascending),
                          ),  
                          DataColumn2(
                            label: const Text(
                              'Address',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            size: ColumnSize.L,
                            numeric: false,
                            onSort: (columnIndex, ascending) => _sort<String>(
                                (d) => d.streetAddress, columnIndex, ascending),
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
                              'Email',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            size: ColumnSize.L,
                            numeric: false,
                            onSort: (columnIndex, ascending) => _sort<String>(
                                (d) => d.email, columnIndex, ascending),
                          ),
                          DataColumn2(
                            label: const Text(
                              'Total Book\nPurchased',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            size: ColumnSize.S,
                            numeric: false,
                            onSort: (columnIndex, ascending) => _sort<num>(
                                (d) => int.parse(d.totalPurchases),
                                columnIndex,
                                ascending),
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
