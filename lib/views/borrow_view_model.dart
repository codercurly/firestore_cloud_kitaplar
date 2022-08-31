import 'package:firebase_cloud_kitaplar/model/book_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../model/borrow_model.dart';
import '../services/database.dart';

class BorrowListViewModel extends ChangeNotifier{

  Database _database = Database();
  String collectionPath = 'books';
  Future<void> updateBook({List<BorrowInfo>? borrowList, Book? book}) async {
    Book newBook = Book(
        id: book?.id,
        bookName: book?.bookName,
        authorName: book?.authorName,
        publishDate: book?.publishDate,
        borrows: borrowList);

    await _database.setBookData(
        cllctionPath: collectionPath, bookasmap: newBook.toMAp());
  }

   Future<void> deletePhoto({String? photoUrl})async{
    Reference photoRef = await FirebaseStorage.instance.refFromURL(photoUrl!);
     photoRef.delete();
  }

}