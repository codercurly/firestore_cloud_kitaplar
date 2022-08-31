import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_cloud_kitaplar/model/book_model.dart';
import 'package:firebase_core/firebase_core.dart';

class Database{
  FirebaseFirestore firestore = FirebaseFirestore.instance;


  Stream<QuerySnapshot> getBookFromApi(String referencePath){
    return firestore.collection(referencePath).snapshots();
  }

  Future<void> getdeleteBook({String? path, String? id}) async{
    await firestore.collection(path!).doc(id).delete();

  }

  Future<void> setBookData({String? cllctionPath, Map<String, dynamic>? bookasmap }) async{
    await firestore.collection(cllctionPath!).doc(Book.fromMap(bookasmap!).id).set(bookasmap);
  }

}