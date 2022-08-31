import 'package:firebase_cloud_kitaplar/model/book_model.dart';
import 'package:firebase_cloud_kitaplar/services/calculator.dart';
import 'package:firebase_cloud_kitaplar/services/database.dart';
import 'package:flutter/foundation.dart';

class AddBookmodel extends ChangeNotifier{
  Database _database = Database();
  String? collectionpath ='books';

  Future<void> addNewBook({String? bookName, String? authorName, DateTime? publishDate})async{
Book newbook= Book(id: DateTime.now().toIso8601String(),
  bookName: bookName,
  authorName: authorName,
  publishDate: Calculator.datetimeTotimestap(publishDate!),
  borrows: []
);
await _database.setBookData(cllctionPath: collectionpath, bookasmap: newbook.toMAp());

  }
}