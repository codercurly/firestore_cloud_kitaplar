import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_cloud_kitaplar/model/book_model.dart';
import 'package:firebase_cloud_kitaplar/services/database.dart';
import 'package:flutter/material.dart';
class BooksViewModel extends ChangeNotifier{

  Database _database = Database();
   String?   _booksref ='books';
  Stream<List<Book>> getBookList() {
   
    Stream<List<DocumentSnapshot>> streamlistdoc = _database
        .getBookFromApi(_booksref!)
        .map((querysnapshot) => querysnapshot.docs );

    Stream<List<Book>> streamListBook = streamlistdoc.map(
            (listOfDocSnap) => listOfDocSnap
            .map((docSnap) => Book.fromMap(docSnap.data() as Map<String, dynamic>) )
            .toList());

    return streamListBook;

  }

  Future<void> deleteBook(Book book) async {
    await _database.getdeleteBook(path: _booksref, id: book.id);
  }

  }

