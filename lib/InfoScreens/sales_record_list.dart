import 'dart:convert';

import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';

import '../Data/sales_record_data_handler.dart';
import '../main_appbar.dart';

final searchSalesRecordController = TextEditingController();
//String _searchDropDownVal = 'Title';

class SalesRecordList extends StatefulWidget {
  const SalesRecordList({Key? key}) : super(key: key);

  @override
  _SalesRecordListState createState() => _SalesRecordListState();
}

class _SalesRecordListState extends State<SalesRecordList> {
  bool _sortAscending = true;
  int? _sortColumnIndex;
  late SalesRecordDatabase _salesRecordDataSource;
  bool _initialized = false;
  final ScrollController _controller = ScrollController();
  List<SalesRecord> searchSalesRecord = [];
  final List<SalesRecord> preSearchList = mainSalesRecordListCopy;

  final List<String> _searchDropDownVal = [
    'All Fields',
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
  late String _curSearchChoice;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      setState(() {});
      _salesRecordDataSource = SalesRecordDatabase(context);
      _curSearchChoice = _searchDropDownVal[0];
      _initialized = true;
      _salesRecordDataSource.addListener(() {
        setState(() {});
      });
    }
  }

  void _sort<T>(
    Comparable<T> Function(SalesRecord d) getField,
    int columnIndex,
    bool ascending,
  ) {
    _salesRecordDataSource.sort<T>(getField, ascending);
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  @override
  void dispose() {
    _salesRecordDataSource.dispose();
    super.dispose();
  }

  @override
  Widget _searchField() {
    return TextField(
      controller: searchSalesRecordController,
      onChanged: (String text) {
        setState(() {
          searchSalesRecord = [];
          Iterable<SalesRecord> foundSalesRecord = [];
          if (_curSearchChoice == 'All Fields') {
            foundSalesRecord = mainSalesRecordListCopy.where((element) =>
                element.bookTitle.toLowerCase().contains(text.toLowerCase()) ||
                element.bookId.toLowerCase().contains(text.toLowerCase()) ||
                element.customerName.toLowerCase().contains(text.toLowerCase()) ||
                element.customerId.toLowerCase().contains(text.toLowerCase()) ||
                element.salesPersonName.toLowerCase().contains(text.toLowerCase()) ||
                element.salesPersonId.toLowerCase().contains(text.toLowerCase()) ||
                element.soldPrice.toLowerCase().contains(text.toLowerCase()) ||
                element.orderDate.toLowerCase().contains(text.toLowerCase()) ||
                element.deliveryDate.toLowerCase().contains(text.toLowerCase()));
          } else if (_curSearchChoice == 'Book Title') {
            foundSalesRecord = mainSalesRecordListCopy.where((element) =>
                element.bookTitle.toLowerCase().contains(text.toLowerCase()));
          } else if (_curSearchChoice == 'Book ID') {
            foundSalesRecord = mainSalesRecordListCopy.where((element) =>
                element.bookId.toLowerCase().contains(text.toLowerCase()));
          } else if (_curSearchChoice == 'Customer Name') {
            foundSalesRecord = mainSalesRecordListCopy.where((element) =>
                element.customerName
                    .toLowerCase()
                    .contains(text.toLowerCase()));
          } else if (_curSearchChoice == 'Customer ID') {
            foundSalesRecord = mainSalesRecordListCopy.where((element) =>
                element.customerId.toLowerCase().contains(text.toLowerCase()));
          } else if (_curSearchChoice == 'Salesperon Name') {
            foundSalesRecord = mainSalesRecordListCopy.where((element) =>
                element.salesPersonName
                    .toLowerCase()
                    .contains(text.toLowerCase()));
          } else if (_curSearchChoice == 'Salesperson ID') {
            foundSalesRecord = mainSalesRecordListCopy.where((element) =>
                element.salesPersonId
                    .toLowerCase()
                    .contains(text.toLowerCase()));
          } else if (_curSearchChoice == 'Sold Price') {
            foundSalesRecord = mainSalesRecordListCopy.where((element) =>
                element.soldPrice.toLowerCase().contains(text.toLowerCase()));
          } else if (_curSearchChoice == 'Order Date') {
            foundSalesRecord = mainSalesRecordListCopy.where((element) =>
                element.orderDate.toLowerCase().contains(text.toLowerCase()));
          } else if (_curSearchChoice == 'Delivery Date') {
            foundSalesRecord = mainSalesRecordListCopy.where((element) =>
                element.deliveryDate
                    .toLowerCase()
                    .contains(text.toLowerCase()));
          }

          if (foundSalesRecord.isNotEmpty) {
            for (var record in foundSalesRecord) {
              SalesRecord tempSalesRecord = SalesRecord(
                record.bookTitle,
                record.bookId,
                record.customerName,
                record.customerId,
                record.salesPersonName,
                record.salesPersonId,
                record.soldPrice,
                record.orderDate,
                record.deliveryDate,
              );
              searchSalesRecord.add(tempSalesRecord);
            }
            setState(() {
              salesRecordSearchHelper(context, searchSalesRecord).then((_) {
                setState(() {});
                //debugPrint('test ${mainBookList.toString()}');
              });
            });
          } else {
            setState(() {
              salesRecordSearchHelper(context, searchSalesRecord).then((_) {
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
          title: const Text('Sales Records'),
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
            if (searchSalesRecordController.text.isNotEmpty)
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
                        searchSalesRecordController.clear();
                        searchSalesRecord = preSearchList;
                        salesRecordSearchHelper(context, searchSalesRecord)
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
            const SizedBox(width: 128),

            //Add Data Button
            // isManager
            //     ? MaterialButton(
            //         onPressed: () => [
            //           setState(() {
            //             setState(() {
            //               customerDataAdder(context).then((_) {
            //                 setState(() {});
            //               });
            //             });
            //           })
            //         ],
            //         child: Column(
            //             mainAxisSize: MainAxisSize.min,
            //             children: const <Widget>[
            //               Padding(
            //                 padding: EdgeInsets.all(2.0),
            //                 child: Icon(
            //                   Icons.add_circle_outline_outlined,
            //                   color: Colors.white,
            //                 ),
            //               ),
            //               Padding(
            //                 padding: EdgeInsets.all(2.0),
            //                 child: Text(
            //                   "Add",
            //                   style: TextStyle(color: Colors.white),
            //                 ),
            //               )
            //             ]),
            //       )
            //     : const SizedBox(width: 80)
          ],
        ),
        body: FutureBuilder(
            future: DefaultAssetBundle.of(context)
                .loadString('assets/jsondatabase/sales_record_data.json'),
            builder: (context, snapshot) {
              if (snapshot.data.toString().isNotEmpty &&
                  snapshot.hasData &&
                  _salesRecordDataSource.salesRecords.isEmpty) {
                var jsonResponse = jsonDecode(snapshot.data.toString());
                convertSalesRecordData(jsonResponse);
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
                        onSelectAll: (val) => setState(
                            () => _salesRecordDataSource.selectAll(val)),
                        columns: [
                          DataColumn2(
                            label: const Text(
                              'Book Title',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            size: ColumnSize.L,
                            onSort: (columnIndex, ascending) => _sort<String>(
                                (d) => d.bookTitle, columnIndex, ascending),
                          ),
                          DataColumn2(
                            label: const Text(
                              'Book ID',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            size: ColumnSize.S,
                            onSort: (columnIndex, ascending) => _sort<String>(
                                (d) => d.bookId, columnIndex, ascending),
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
                              'Sold Price',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            size: ColumnSize.S,
                            onSort: (columnIndex, ascending) => _sort<String>(
                                (d) => d.soldPrice, columnIndex, ascending),
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
                        ],
                        rows: List<DataRow>.generate(
                            _salesRecordDataSource.rowCount,
                            (index) => _salesRecordDataSource.getRow(index))),
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
