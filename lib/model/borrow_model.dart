import 'package:cloud_firestore/cloud_firestore.dart';

class BorrowInfo{

  final String? name;
  final String? surname;
  final String? photoUrl;
  final Timestamp? borrowdate;
  final Timestamp? returndate;

  BorrowInfo({this.name, this.surname, this.photoUrl, this.borrowdate, this.returndate});



  Map<String, dynamic> toMAp() => {
    'name' : name,
    'surname': surname,

    'borrowdate': borrowdate,
    'returndate' : returndate
  };
  factory BorrowInfo.fromMap(Map map)=> BorrowInfo(
          name:map['name'],
          surname:map['surname'],
          photoUrl:map['photoUrl'],
           borrowdate: map['borrowdate'],
          returndate:map['returndate']);

}