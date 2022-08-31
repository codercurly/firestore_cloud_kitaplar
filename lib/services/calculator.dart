import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Calculator{
  static String parseDateFormat(DateTime? dateTime){
String dateFormat = DateFormat('dd / MM / yyyy').format(dateTime!);
return dateFormat;
  }

  static Timestamp datetimeTotimestap(DateTime? dateTime){
    return Timestamp.fromDate(dateTime!);}

  static DateTime datetimeFromTimestamp(Timestamp timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);
  }
}