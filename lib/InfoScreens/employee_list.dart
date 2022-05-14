import 'dart:convert';

import 'package:bookstore_project/login_page.dart';
import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../Data/data_storage_helper.dart';
import '../Data/employee_data_handler.dart';
import '../main_appbar.dart';

final searchEmployeeController = TextEditingController();
//String _searchDropDownVal = 'Title';
final List<String> _searchDropDownVal = [
  'All Fields',
  'First Name',
  'Last Name',
  'ID',
  'Address',
  'Phone Number',
  'Date of Birth',
  'Hire Date',
  'Position',
  'Books Sold',
  'Description',
];
late String curSearchChoice = _searchDropDownVal[0];

class EmployeeList extends StatefulWidget {
  const EmployeeList({Key? key}) : super(key: key);

  @override
  _EmployeeListState createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList> {
  bool _sortAscending = true;
  int? _sortColumnIndex;
  late EmployeeDatabase _employeesDataSource;
  bool _initialized = false;
  final ScrollController _controller = ScrollController();
  List<Employee> searchEmployeeList = [];
  final List<Employee> preSearchList = mainEmployeeListCopy;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      setState(() {});
      _employeesDataSource = EmployeeDatabase(context);
      _initialized = true;
      _employeesDataSource.addListener(() {
        setState(() {});
      });
    }
  }

  void _sort<T>(
    Comparable<T> Function(Employee d) getField,
    int columnIndex,
    bool ascending,
  ) {
    _employeesDataSource.sort<T>(getField, ascending);
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  @override
  void dispose() {
    _employeesDataSource.dispose();
    super.dispose();
  }

  Widget _searchField() {
    return TextField(
      controller: searchEmployeeController,
      onChanged: (String text) {
        setState(() {
          searchEmployeeList = [];
          Iterable<Employee> foundEmployee = [];
          if (curSearchChoice == 'All Fields') {
            foundEmployee = mainEmployeeListCopy.where((element) =>
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
                element.email.toLowerCase().contains(text.toLowerCase()) ||
                element.dateOfBirth
                    .toLowerCase()
                    .contains(text.toLowerCase()) ||
                element.hireDate.toLowerCase().contains(text.toLowerCase()) ||
                element.terminationDate
                    .toLowerCase()
                    .contains(text.toLowerCase()) ||
                element.position.toLowerCase().contains(text.toLowerCase()) ||
                element.numBookSold
                    .toLowerCase()
                    .contains(text.toLowerCase()) ||
                element.lastSoldBooks
                    .toLowerCase()
                    .contains(text.toLowerCase()) ||
                element.description.toLowerCase().contains(text.toLowerCase()));
          } else if (curSearchChoice == 'First Name') {
            foundEmployee = mainEmployeeListCopy.where((element) =>
                element.firstName.toLowerCase().contains(text.toLowerCase()));
          } else if (curSearchChoice == 'Last Name') {
            foundEmployee = mainEmployeeListCopy.where((element) =>
                element.lastName.toLowerCase().contains(text.toLowerCase()));
          } else if (curSearchChoice == 'ID') {
            foundEmployee = mainEmployeeListCopy.where((element) =>
                element.id.toLowerCase().contains(text.toLowerCase()));
          } else if (curSearchChoice == 'Address') {
            foundEmployee = mainEmployeeListCopy.where((element) =>
                element.streetAddress
                    .toLowerCase()
                    .contains(text.toLowerCase()) ||
                element.suiteNum.toLowerCase().contains(text.toLowerCase()) ||
                element.city.toLowerCase().contains(text.toLowerCase()) ||
                element.state.toLowerCase().contains(text.toLowerCase()) ||
                element.zipCode.toLowerCase().contains(text.toLowerCase()));
          } else if (curSearchChoice == 'Phone Number') {
            foundEmployee = mainEmployeeListCopy.where((element) =>
                element.phoneNumber.toLowerCase().contains(text.toLowerCase()));
          } else if (curSearchChoice == 'Email') {
            foundEmployee = mainEmployeeListCopy.where((element) =>
                element.email.toLowerCase().contains(text.toLowerCase()));
          } else if (curSearchChoice == 'Date of Birth') {
            foundEmployee = mainEmployeeListCopy.where((element) =>
                element.dateOfBirth.toLowerCase().contains(text.toLowerCase()));
          } else if (curSearchChoice == 'Hire Date') {
            foundEmployee = mainEmployeeListCopy.where((element) =>
                element.hireDate.toLowerCase().contains(text.toLowerCase()));
          } else if (curSearchChoice == 'Termination Date') {
            foundEmployee = mainEmployeeListCopy.where((element) => element
                .terminationDate
                .toLowerCase()
                .contains(text.toLowerCase()));
          } else if (curSearchChoice == 'Position') {
            foundEmployee = mainEmployeeListCopy.where((element) =>
                element.position.toLowerCase().contains(text.toLowerCase()));
          } else if (curSearchChoice == 'Books Sold') {
            foundEmployee = mainEmployeeListCopy.where((element) =>
                element.numBookSold.toLowerCase().contains(text.toLowerCase()));
          } else if (curSearchChoice == 'Last Sold Books') {
            foundEmployee = mainEmployeeListCopy.where((element) => element
                .lastSoldBooks
                .toLowerCase()
                .contains(text.toLowerCase()));
          } else if (curSearchChoice == 'Description') {
            foundEmployee = mainEmployeeListCopy.where((element) =>
                element.description.toLowerCase().contains(text.toLowerCase()));
          }

          if (foundEmployee.isNotEmpty) {
            for (var employee in foundEmployee) {
              Employee tempEmployee = Employee(
                  employee.firstName,
                  employee.lastName,
                  employee.id,
                  employee.streetAddress,
                  employee.suiteNum,
                  employee.city,
                  employee.state,
                  employee.zipCode,
                  employee.phoneNumber,
                  employee.email,
                  employee.dateOfBirth,
                  employee.hireDate,
                  employee.terminationDate,
                  employee.position,
                  employee.numBookSold,
                  employee.terminationDate,
                  employee.totalCostSold,
                  employee.description);
              searchEmployeeList.add(tempEmployee);
            }
            setState(() {
              employeeSearchHelper(context, searchEmployeeList).then((_) {
                setState(() {});
                //debugPrint('test ${mainBookList.toString()}');
              });
            });
          } else {
            setState(() {
              employeeSearchHelper(context, searchEmployeeList).then((_) {
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
          title: const Text('Employees', style: TextStyle(fontSize: 25)),
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
            if (searchEmployeeController.text.isNotEmpty)
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
                        searchEmployeeController.clear();
                        searchEmployeeList = preSearchList;
                        employeeSearchHelper(context, searchEmployeeList)
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
                  value: curSearchChoice,
                  dropdownItems: _searchDropDownVal,
                  onChanged: (String? newValue) {
                    setState(() {
                      curSearchChoice = newValue!;
                    });
                  },
                )),

            //Add Data Button
            //if (isManager) const SizedBox(width: 48),
            if (isManager)
              MaterialButton(
                onPressed: () => [
                  setState(() {
                    setState(() {
                      _jobPosDialog();
                      // employeeDataAdder(context).then((_) {
                      //   setState(() {});
                      // });
                    });
                  })
                ],
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const <Widget>[
                      Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Icon(
                          FontAwesomeIcons.peopleLine,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          "Job Position",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ]),
              ),
            isManager
                ? MaterialButton(
                    onPressed: () => [
                      setState(() {
                        setState(() {
                          employeeDataAdder(context).then((_) {
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
                : const SizedBox(width: 128)
          ],
        ),
        body: FutureBuilder(
            future: DefaultAssetBundle.of(context)
                .loadString('assets/jsondatabase/employee_data.json'),
            builder: (context, snapshot) {
              if (snapshot.data.toString().isNotEmpty &&
                  snapshot.hasData &&
                  _employeesDataSource.employees.isEmpty) {
                var jsonResponse = jsonDecode(snapshot.data.toString());
                convertEmployeeData(jsonResponse);
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
                            setState(() => _employeesDataSource.selectAll(val)),
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
                                (d) => d.firstName + d.lastName,
                                columnIndex,
                                ascending),
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
                              'Date of \nBirth',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            size: ColumnSize.S,
                            numeric: false,
                            onSort: (columnIndex, ascending) => _sort<String>(
                                (d) => d.dateOfBirth, columnIndex, ascending),
                          ),
                          DataColumn2(
                            label: const Text(
                              'Hire Date',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            size: ColumnSize.S,
                            numeric: false,
                            onSort: (columnIndex, ascending) => _sort<String>(
                                (d) => d.hireDate, columnIndex, ascending),
                          ),
                          DataColumn2(
                            label: const Text(
                              'End Date',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            size: ColumnSize.S,
                            numeric: false,
                            onSort: (columnIndex, ascending) => _sort<String>(
                                (d) => d.terminationDate,
                                columnIndex,
                                ascending),
                          ),
                          DataColumn2(
                            label: const Text(
                              'Job Position',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            size: ColumnSize.M,
                            numeric: false,
                            onSort: (columnIndex, ascending) => _sort<String>(
                                (d) => d.position, columnIndex, ascending),
                          ),
                          // DataColumn2(
                          //   label: const Text(
                          //     'Email',
                          //     style: TextStyle(fontWeight: FontWeight.bold),
                          //   ),
                          //   size: ColumnSize.M,
                          //   numeric: false,
                          //   onSort: (columnIndex, ascending) => _sort<String>(
                          //       (d) => d.email, columnIndex, ascending),
                          // ),
                          DataColumn2(
                            label: const Text(
                              'Books\nSold',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            size: ColumnSize.S,
                            numeric: false,
                            onSort: (columnIndex, ascending) => _sort<num>(
                                (d) => int.parse(d.numBookSold),
                                columnIndex,
                                ascending),
                          ),
                          // DataColumn2(
                          //   label: const Text(
                          //     'Description',
                          //     style: TextStyle(fontWeight: FontWeight.bold),
                          //   ),
                          //   size: ColumnSize.L,
                          //   numeric: false,
                          //   onSort: (columnIndex, ascending) => _sort<String>(
                          //       (d) => d.description, columnIndex, ascending),
                          // ),
                          DataColumn2(
                            label: const Text(
                              'Total Cost\nSold',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            size: ColumnSize.S,
                            numeric: false,
                            onSort: (columnIndex, ascending) => _sort<num>(
                                (d) => double.parse(d.totalCostSold),
                                columnIndex,
                                ascending),
                          ),
                        ],
                        rows: List<DataRow>.generate(
                            _employeesDataSource.rowCount,
                            (index) => _employeesDataSource.getRow(index))),
                    _ScrollUpButton(_controller)
                  ]));
            }));
  }

  _jobPosDialog() async {
    await showDialog<String>(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Theme.of(context).canvasColor,
              titlePadding: const EdgeInsets.only(top: 10),
              title: Center(
                child: Column(
                  children: const [
                    Text('Job Position Details',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    //Divider(thickness: 1, indent: 20, endIndent: 20,)
                  ],
                ),
              ),
              contentPadding:
                  const EdgeInsets.only(left: 16, right: 16, top: 20),
              content: SizedBox(
                  width: double.maxFinite,
                  height: double.maxFinite,
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var jobItem in jobPosDropDownVal)
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: DataTable2(
                              scrollController: _controller,
                              showCheckboxColumn: false,
                              columnSpacing: 3,
                              horizontalMargin: 5,
                              bottomMargin: 5,
                              showBottomBorder: true,
                              //minWidth: 1100,
                              smRatio: 0.6,
                              lmRatio: 1.5,
                              sortColumnIndex: _sortColumnIndex,
                              sortAscending: _sortAscending,
                              // onSelectAll: (val) =>
                              //     setState(() => _employeesDataSource.selectAll(val)),
                              columns: [
                                DataColumn2(
                                  label: Center(
                                    child: SizedBox(
                                      height: 40,
                                      child: Column(
                                        children: [
                                          Text(
                                            jobItem,
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            'Description',
                                            style: TextStyle(fontSize: 14, color: Theme.of(context).hintColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  size: ColumnSize.M,
                                  numeric: false,
                                  // onSort: (columnIndex, ascending) =>
                                  //     _sort<num>(
                                  //         (d) => double.parse(d.totalCostSold),
                                  //         columnIndex,
                                  //         ascending),
                                ),
                              ],
                              rows: [
                                for (var employee in mainEmployeeListCopy)
                                if (employee.position == jobItem)
                                DataRow(
                                  cells: [
                                  DataCell(Center(child: Text(employee.firstName + ' ' + employee.lastName))),
                                ]),
                              ],
                            ),),
                            
                            if (jobItem != jobPosDropDownVal.last)
                            const VerticalDivider(
                                thickness: 0, indent: 50,
                              )
                          ],
                        ),
                      ),
                      
                    ],
                  )
                ),
              actions: <Widget>[
                ElevatedButton(
                    child: const Text('CLOSE'),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ],
            );
          });
        });
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

