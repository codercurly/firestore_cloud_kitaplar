import 'package:firebase_cloud_kitaplar/model/book_model.dart';
import 'package:firebase_cloud_kitaplar/services/calculator.dart';
import 'package:firebase_cloud_kitaplar/services/database.dart';
import 'package:flutter/foundation.dart';

class UpdateBookmodel extends ChangeNotifier{
  Database _database = Database();
  String? collectionpath ='books';

  Future<void> UpdateNewBook({String? bookName, String? authorName, DateTime? publishDate, Book? book})async{
Book newbook= Book(id: book!.id,
  bookName: bookName,
  authorName: authorName,
  publishDate: Calculator.datetimeTotimestap(publishDate!),
    borrows: book.borrows
);
await _database.setBookData(cllctionPath: collectionpath, bookasmap: newbook.toMAp());

  }
}