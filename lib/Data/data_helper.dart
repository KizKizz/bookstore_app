import 'dart:io';
import 'dart:convert';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';

final File bookDataJson = File('assets/jsondatabase/book_data.json');

class Book {
  Book(this.title, this.id, this.author, this.publisher, this.publishDate,
      this.edition, this.cost, this.retailPrice, this.condition, this.sold);

  String title;
  String id;
  String author;
  String publisher;
  int publishDate;
  double edition;
  double cost;
  double retailPrice;
  String condition;
  String sold;

  bool selected = false;

  fromJson(Map<String, dynamic> json) {
    title = json['title'];
    id = json['id'];
    author = json['author'];
    publisher = json['publisher'];
    publishDate = json['publishDate'];
    edition = json['edition'];
    cost = json['cost'];
    retailPrice = json['retailPrice'];
    condition = json['condition'];
    sold = json['sold'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['id'] = this.id;
    data['author'] = this.author;
    data['publisher'] = this.publisher;
    data['publishDate'] = this.publishDate;
    data['edition'] = this.edition;
    data['cost'] = this.cost;
    data['retailPrice'] = this.retailPrice;
    data['condition'] = this.condition;
    data['sold'] = this.sold;

    return data;
  }
}

class bookDataHelper with ChangeNotifier {
  List<Book> books = [];

  List<Book> get _books => books;

  void bookDataGet() async {
    books = await readBookData(bookDataJson);
    debugPrint('test ${_books.length}');
    notifyListeners();
  }

  Future<List<Book>> bookDataGet2() async {
    List<Book> temp;
    temp = await readBookData(bookDataJson);
    notifyListeners();
    return temp;
  }
}

Future<List<Book>> readBookData(File file) async {
  String contents = await file.readAsString();
  var jsonResponse = jsonDecode(contents);
  List<Book> temp = [];

  for (var b in jsonResponse) {
    Book book = Book(
        b['title'],
        b['id'],
        b['author'],
        b['publisher'],
        b['publishDate'],
        b['edition'],
        b['cost'],
        b['retailPrice'],
        b['condition'],
        b['sold']);
    temp.add(book);
  }
  //debugPrint('test ${_books.length}');
  return temp;
}


//List<Book> _books = [];

//void DataHelper() async {
  //print("hello world");
//  final File file =
 //     File('assets/jsondatabase/book_data.json'); //load the json file
 // await readData(file); //read data from json file
  //debugPrint('test ${_books.length}');

  // _books //convert list data  to json
  //     .map(
  //       (book) => book.toJson(),
  //     )
  //     .toList();

  // file.writeAsStringSync(
  //     json.encode(_books)); //write (the whole list) to json file
//}
