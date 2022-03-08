import 'package:bookstore_project/Data/book_data_list.dart';
import 'package:bookstore_project/table_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class BookList extends StatefulWidget {
  const BookList({Key? key}) : super(key: key);

  @override
  State createState() => _BookListState();
}

class _BookListState extends State<BookList> {
  int _currentSortColumn = 0;
  bool _isSortAsc = true;
  final List<String> headers = ['ID', 'Title', 'Author', 'Publisher', 
    'Publish Date', 'Edition', 'Cost', 'Retail Price', 'Condition', 'Sold'];
  //bool editMode = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: ListView(controller: ScrollController(),
            //scrollDirection: Axis.horizontal,
            children: [
              _createDataTable(),
            ]));
  }

  DataTable _createDataTable() {
    return DataTable(
      columns: _createColumns(headers),
      rows: _createRows(),
      dividerThickness: 2,
      columnSpacing: 0,
      horizontalMargin: 0,
      dataRowHeight: 55,
      showBottomBorder: true,
      
      headingTextStyle: const TextStyle(fontWeight: FontWeight.bold
          //   color: Colors.black
          ),
      // headingRowColor: MaterialStateProperty.resolveWith(
      //                   (states) => Colors.black
      //                 ),
      sortColumnIndex: _currentSortColumn,
      sortAscending: _isSortAsc,
    );
  }

  List<DataColumn> _createColumns(List<String> headerList) {
    List<DataColumn> tempList = [];
    for (var element in headerList) {
      tempList.add(
        DataColumn( 
          label: Stack(
                  children: [Container(
                    padding: const EdgeInsets.only(left: 10, bottom: 5),
                    //color: Colors.amber,
                    child: Text(element))]),
          onSort: (columnIndex, _) {
            setState(() {
              _currentSortColumn = columnIndex;
              if (_isSortAsc) {
                booksData.sort((a, b) => b.edition.compareTo(a.edition));
              } else {
                booksData.sort((a, b) => a.edition.compareTo(b.edition));
              }
              _isSortAsc = !_isSortAsc;
            });
          },
        ),
      );
    }
    return tempList;
  }

  List<DataRow> _createRows() {
    List<DataRow> tempList = [];
    for (var element in booksData) {
      tempList.add(
        DataRow(
          cells: [ 
            _createTitleCell(element.id.toString()),
            _createTitleCell(element.title.toString()),
            _createTitleCell(element.author.toString()),
            _createTitleCell(element.publisher.toString()),
            _createTitleCell(element.publishDate.toString()),
            _createTitleCell(element.edition.toString()),
            _createTitleCell(element.cost.toString()),
            _createTitleCell(element.sugRetailPrice.toString()),
            _createTitleCell(element.condition.toString()),
            DataCell(Text(element.sold.toString())),
          ]
        )
    );}
    
    return tempList;
  }

  DataCell _createTitleCell(var editField) {
    return DataCell(context.watch<tableAdderSwitch>().isAddingMode
        ? Stack(
                  children: [Container(
                    padding: const EdgeInsets.only(left: 10, bottom: 5),
                    //color: Colors.amber,
                    child: TextFormField(   
            initialValue: editField,
            onChanged: (var value) {
              for (var element in booksData) {
                if (element.title == editField) {
                  booksData[booksData
                          .indexWhere((element) => element.title == editField)]
                      .title = value;
                  //element.title = value;
                  debugPrint('Value for field "${element.title}"');
                  editField = value;
                }
              }
              //debugPrint('Value for field "$value"');
            },
            style: const TextStyle(fontSize: 14)))])
        : Stack(
                  children: [Container(
                    padding: const EdgeInsets.only(left: 10, bottom: 5),
                    //color: Colors.amber,
                    child: Text(editField)
                  )]));
  }
}
