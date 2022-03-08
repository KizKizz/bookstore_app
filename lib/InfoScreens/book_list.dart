import 'dart:convert';

import 'package:bookstore_project/table_provider.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:bookstore_project/Data/book_data_handler.dart';
import 'package:provider/provider.dart';

import '../main_appbar.dart';
import '../main_drawer.dart';

class BookList extends StatefulWidget {
  const BookList({Key? key}) : super(key: key);

  @override
  _BookListState createState() => _BookListState();
}

class _BookListState extends State<BookList> {
  bool _sortAscending = true;
  int? _sortColumnIndex;
  late BookDatabase _booksDataSource;
  bool _initialized = false;
  final ScrollController _controller = ScrollController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      setState(() {});
      _booksDataSource = BookDatabase(context);
      _initialized = true;
      _booksDataSource.addListener(() {
        setState(() {});
      });
    }
  }

  void _sort<T>(
    Comparable<T> Function(Book d) getField,
    int columnIndex,
    bool ascending,
  ) {
    _booksDataSource.sort<T>(getField, ascending);
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  @override
  void dispose() {
    _booksDataSource.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppbar(
        title: Text('Book Data'),
        appBar: AppBar(),
        widgets: <Widget>[
                      MaterialButton(
                        onPressed: () => [
                          setState(() {
                            bookDataAdder(context).then((_) {
                              setState(() {});
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
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(2.0),
                                child: Text(
                                  "Add",
                                  style: TextStyle(),
                                ),
                              )
                            ]),
                      ),
        ],
      ),
      drawer: const MainDrawer(),
        body: FutureBuilder(
            future: DefaultAssetBundle.of(context)
                .loadString('assets/jsondatabase/book_data.json'),
            builder: (context, snapshot) {
              if (snapshot.hasData && _booksDataSource.books.isEmpty) {
                var jsonResponse = jsonDecode(snapshot.data.toString());
                convertBookData(jsonResponse);
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
                              setState(() => _booksDataSource.selectAll(val)),
                          columns: [
                            DataColumn2(
                              label: const Text(
                                'Title',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              size: ColumnSize.L,
                              onSort: (columnIndex, ascending) => _sort<String>(
                                  (d) => d.title, columnIndex, ascending),
                            ),
                            DataColumn2(
                              label: const Text(
                                'ID',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              size: ColumnSize.S,
                              onSort: (columnIndex, ascending) => _sort<String>(
                                  (d) => d.id, columnIndex, ascending),
                            ),
                            DataColumn2(
                              label: const Text(
                                'Author',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              size: ColumnSize.M,
                              numeric: false,
                              onSort: (columnIndex, ascending) => _sort<String>(
                                  (d) => d.author, columnIndex, ascending),
                            ),
                            DataColumn2(
                              label: const Text(
                                'Publisher',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              size: ColumnSize.S,
                              numeric: true,
                              onSort: (columnIndex, ascending) => _sort<String>(
                                  (d) => d.publisher, columnIndex, ascending),
                            ),
                            DataColumn2(
                              label: const Text(
                                'Publish\nDate',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              size: ColumnSize.S,
                              numeric: true,
                              onSort: (columnIndex, ascending) => _sort<num>(
                                  (d) => d.publishDate, columnIndex, ascending),
                            ),
                            DataColumn2(
                              label: const Text(
                                'Edition',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              size: ColumnSize.S,
                              numeric: true,
                              onSort: (columnIndex, ascending) => _sort<num>(
                                  (d) => d.edition, columnIndex, ascending),
                            ),
                            DataColumn2(
                              label: const Text(
                                'Cost',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              size: ColumnSize.S,
                              numeric: true,
                              onSort: (columnIndex, ascending) => _sort<num>(
                                  (d) => d.cost, columnIndex, ascending),
                            ),
                            DataColumn2(
                              label: const Text(
                                'Retail\nPrice',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              size: ColumnSize.S,
                              numeric: true,
                              onSort: (columnIndex, ascending) => _sort<num>(
                                  (d) => d.retailPrice, columnIndex, ascending),
                            ),
                            DataColumn2(
                              label: const Text(
                                'Condition',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              size: ColumnSize.S,
                              numeric: true,
                              onSort: (columnIndex, ascending) => _sort<String>(
                                  (d) => d.condition, columnIndex, ascending),
                            ),
                            DataColumn2(
                              label: const Text(
                                'Sold',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              size: ColumnSize.S,
                              numeric: true,
                              onSort: (columnIndex, ascending) => _sort<String>(
                                  (d) => d.sold, columnIndex, ascending),
                            ),
                          ],
                          rows: List<DataRow>.generate(
                              _booksDataSource.rowCount,
                              (index) => _booksDataSource.getRow(index))),
                      _ScrollUpButton(_controller)
                    ])
                  );
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
