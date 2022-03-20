import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:bookstore_project/Data/author_data_handler.dart';

import '../main_appbar.dart';

bool showBooks = false;
final searchAuthorController = TextEditingController();

class AuthorList extends StatefulWidget {
  const AuthorList({Key? key}) : super(key: key);

  @override
  _AuthorListState createState() => _AuthorListState();
}

class _AuthorListState extends State<AuthorList> {
  bool _sortAscending = true;
  int? _sortColumnIndex;
  late AuthorDatabase _authorsDataSource;
  bool _initialized = false;
  final ScrollController _controller = ScrollController();
  List<Author> searchAuthorList = [];
  final List<Author> preSearchList = mainAuthorListCopy;

  final List<String> _searchDropDownVal = [
    'Full Name',
    'ID',
    'Year of Birth',
    'Year of Dead',
    'Description',
  ];
  late String _curSearchChoice;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      setState(() {});
      _authorsDataSource = AuthorDatabase(context);
      _curSearchChoice = _searchDropDownVal[0];
      _initialized = true;
      _authorsDataSource.addListener(() {
        setState(() {});
      });
    }
  }

  void _sort<T>(
    Comparable<T> Function(Author d) getField,
    int columnIndex,
    bool ascending,
  ) {
    _authorsDataSource.sort<T>(getField, ascending);
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  @override
  Widget _searchField() {
    return TextField(
        controller: searchAuthorController,
        onChanged: (String text) {
          setState(() {
            searchAuthorList = [];
            Iterable<Author> foundAuthor = [];
            if (_curSearchChoice == 'Full Name') {
              foundAuthor = mainAuthorListCopy.where((element) =>
                  element.fullName.toLowerCase().contains(text.toLowerCase()));
            } else if (_curSearchChoice == 'ID') {
              foundAuthor = mainAuthorListCopy.where((element) =>
                  element.id.toLowerCase().contains(text.toLowerCase()));
            } else if (_curSearchChoice == 'Year of Birth') {
              foundAuthor = mainAuthorListCopy.where((element) =>
                  element.yearBirth.toLowerCase().contains(text.toLowerCase()));
            } else if (_curSearchChoice == 'Year of Dead') {
              foundAuthor = mainAuthorListCopy.where((element) =>
                  element.yearDead.toLowerCase().contains(text.toLowerCase()));
            } else if (_curSearchChoice == 'Description') {
              foundAuthor = mainAuthorListCopy.where((element) => element
                  .description
                  .toLowerCase()
                  .contains(text.toLowerCase()));
            }

            if (foundAuthor.isNotEmpty) {
              for (var author in foundAuthor) {
                Author tempAuthor = Author(author.fullName, author.id,
                    author.yearBirth, author.yearDead, author.description);
                searchAuthorList.add(tempAuthor);
              }
              setState(() {
                authorSearchHelper(context, searchAuthorList).then((_) {
                  setState(() {});
                  //debugPrint('test ${mainBookList.toString()}');
                });
              });
            } else {
              setState(() {
                authorSearchHelper(context, searchAuthorList).then((_) {
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
  void dispose() {
    _authorsDataSource.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //drawer: const MainDrawer(),
        appBar: MainAppbar(
          title: const Text('Author Data'),
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
            if (searchAuthorController.text.isNotEmpty)
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
                        searchAuthorController.clear();
                        searchAuthorList = preSearchList;
                        authorSearchHelper(context, searchAuthorList).then((_) {
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
            const SizedBox(width: 80)
            // MaterialButton(
            //   onPressed: () => [
            //     setState(() {
            //       authorDataAdder(context).then((_) {
            //         setState(() {});
            //       });
            //     })
            //   ],
            //   child: Column(
            //       mainAxisSize: MainAxisSize.min,
            //       children: const <Widget>[
            //         Padding(
            //           padding: EdgeInsets.all(2.0),
            //           child: Icon(
            //             Icons.add_circle_outline_outlined,
            //           ),
            //         ),
            //         Padding(
            //           padding: EdgeInsets.all(2.0),
            //           child: Text(
            //             "Add",
            //             style: TextStyle(),
            //           ),
            //         )
            //       ]),
            // ),
          ],
        ),
        body: FutureBuilder(
            future: DefaultAssetBundle.of(context)
                .loadString('assets/jsondatabase/author_data.json'),
            builder: (context, snapshot) {
              if (snapshot.data.toString().isEmpty) {
                getAuthorsFromBook();
              } else if (snapshot.hasData &&
                  _authorsDataSource.authors.isEmpty) {
                var jsonResponse = jsonDecode(snapshot.data.toString());
                convertauthorData(jsonResponse);
                //debugPrint('test ${jsonResponse}');
              }
              //Build table
              return Padding(
                  padding: const EdgeInsets.all(5),
                  child: Stack(children: [
                    //Data table
                    Container(
                        child: DataTable2(
                            scrollController: _controller,
                            showCheckboxColumn: false,
                            columnSpacing: 0,
                            horizontalMargin: 5,
                            bottomMargin: 5,
                            minWidth: 600,
                            smRatio: 0.5,
                            lmRatio: 2.0,
                            sortColumnIndex: _sortColumnIndex,
                            sortAscending: _sortAscending,
                            onSelectAll: (val) => setState(
                                () => _authorsDataSource.selectAll(val)),
                            columns: [
                              DataColumn2(
                                label: const Text(
                                  'Full Name',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                size: ColumnSize.L,
                                onSort: (columnIndex, ascending) =>
                                    _sort<String>((d) => d.fullName,
                                        columnIndex, ascending),
                              ),
                              DataColumn2(
                                label: const Text(
                                  'ID',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                size: ColumnSize.S,
                                numeric: false,
                                onSort: (columnIndex, ascending) =>
                                    _sort<String>(
                                        (d) => d.id, columnIndex, ascending),
                              ),
                              DataColumn2(
                                label: const Text(
                                  'Year of \nBirth',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                size: ColumnSize.M,
                                numeric: false,
                                onSort: (columnIndex, ascending) => _sort<num>(
                                    (d) => int.parse(d.yearBirth),
                                    columnIndex,
                                    ascending),
                              ),
                              DataColumn2(
                                label: const Text(
                                  'Year of \nDead',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                size: ColumnSize.M,
                                numeric: false,
                                onSort: (columnIndex, ascending) => _sort<num>(
                                    (d) => int.parse(d.yearDead),
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
                                onSort: (columnIndex, ascending) =>
                                    _sort<String>((d) => d.description,
                                        columnIndex, ascending),
                              ),
                            ],
                            rows: List<DataRow>.generate(
                                _authorsDataSource.rowCount,
                                (index) => _authorsDataSource.getRow(index)))),
                    _ScrollUpButton(_controller),
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
