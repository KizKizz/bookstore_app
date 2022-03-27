// import 'package:flutter/material.dart';

// import '../main_appbar.dart';

// class EmployeeList extends StatefulWidget {
//   const EmployeeList({ Key? key }) : super(key: key);

//   @override
//   _EmployeeListState createState() => _EmployeeListState();
// }

// class _EmployeeListState extends State<EmployeeList> {

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         //drawer: const MainDrawer(),
//         appBar: MainAppbar(
//             title: const Text('Employee Data'),
//             appBar: AppBar(),
//             flexSpace: Text('PlaceHolder'),
//             widgets: <Widget>[]),
//         body: Center(
//             child: Column(children: const [
//           Text('UNDER CONSTRUCTION',
//               textAlign: TextAlign.center, style: TextStyle(fontSize: 100))
//         ])));
//   }
// }

import 'dart:convert';

import 'package:bookstore_project/login_page.dart';
import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:bookstore_project/Data/book_data_handler.dart';

import '../Data/employee_data_handler.dart';
import '../main_appbar.dart';

final searchEmployeeController = TextEditingController();
//String _searchDropDownVal = 'Title';

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

  final List<String> _searchDropDownVal = [
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
  late String curSearchChoice;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      setState(() {});
      _employeesDataSource = EmployeeDatabase(context);
      curSearchChoice = _searchDropDownVal[0];
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

  @override
  Widget _searchField() {
    return TextField(
        controller: searchEmployeeController,
        onChanged: (String text) {
          setState(() {
            searchEmployeeList = [];
            Iterable<Employee> foundEmployee = [];
            if (curSearchChoice == 'First Name') {
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
                  element.address.toLowerCase().contains(text.toLowerCase()));
            } else if (curSearchChoice == 'Phone Number') {
              foundEmployee = mainEmployeeListCopy.where((element) => element
                  .phoneNumber
                  .toLowerCase()
                  .contains(text.toLowerCase()));
            } else if (curSearchChoice == 'Date of Birth') {
              foundEmployee = mainEmployeeListCopy.where((element) => element
                  .dateOfBirth
                  .toLowerCase()
                  .contains(text.toLowerCase()));
            } else if (curSearchChoice == 'Hire Date') {
              foundEmployee = mainEmployeeListCopy.where((element) =>
                  element.hireDate.toLowerCase().contains(text.toLowerCase()));
            } else if (curSearchChoice == 'Position') {
              foundEmployee = mainEmployeeListCopy.where((element) =>
                  element.position.toLowerCase().contains(text.toLowerCase()));
            } else if (curSearchChoice == 'Books Sold') {
              foundEmployee = mainEmployeeListCopy.where((element) => element
                  .numBookSold
                  .toLowerCase()
                  .contains(text.toLowerCase()));
            } else if (curSearchChoice == 'Description') {
              foundEmployee = mainEmployeeListCopy.where((element) => element
                  .description
                  .toLowerCase()
                  .contains(text.toLowerCase()));
            }

            if (foundEmployee.isNotEmpty) {
              for (var employee in foundEmployee) {
                Employee tempEmployee = Employee(
                    employee.firstName,
                    employee.lastName,
                    employee.id,
                    employee.address,
                    employee.phoneNumber,
                    employee.dateOfBirth,
                    employee.hireDate,
                    employee.position,
                    employee.numBookSold,
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
          title: const Text('Employee Data'),
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
                  buttonWidth: 128,
                  dropdownWidth: 128,
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
            if (isManager) const SizedBox(width: 80),
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
                : const SizedBox(width: 160)
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
                        columnSpacing: 0,
                        horizontalMargin: 5,
                        bottomMargin: 5,
                        minWidth: 1000,
                        smRatio: 0.6,
                        lmRatio: 1.5,
                        sortColumnIndex: _sortColumnIndex,
                        sortAscending: _sortAscending,
                        onSelectAll: (val) =>
                            setState(() => _employeesDataSource.selectAll(val)),
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
                              'Job Position',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            size: ColumnSize.M,
                            numeric: false,
                            onSort: (columnIndex, ascending) => _sort<String>(
                                (d) => d.position, columnIndex, ascending),
                          ),
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
                          DataColumn2(
                            label: const Text(
                              'Description',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            size: ColumnSize.L,
                            numeric: false,
                            onSort: (columnIndex, ascending) => _sort<String>(
                                (d) => d.description, columnIndex, ascending),
                          ),
                        ],
                        rows: List<DataRow>.generate(
                            _employeesDataSource.rowCount,
                            (index) => _employeesDataSource.getRow(index))),
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
