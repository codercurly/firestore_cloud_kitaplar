import 'dart:io';
import 'package:firebase_cloud_kitaplar/model/book_model.dart';
import 'package:firebase_cloud_kitaplar/model/borrow_model.dart';
import 'package:firebase_cloud_kitaplar/views/borrow_view_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../services/calculator.dart';

class BorrowListView extends StatefulWidget {

  final Book? book;

  const BorrowListView({super.key,  this.book});


  @override

  State<BorrowListView> createState() => _BorrowListViewState();
}

class _BorrowListViewState extends State<BorrowListView> {
  @override
  Widget build(BuildContext context) {

    List<BorrowInfo>? borrowList = widget.book?.borrows;

    return ChangeNotifierProvider<BorrowListViewModel>(
      create: (context)=>BorrowListViewModel(),
      builder: (context, _) => Scaffold(
        appBar: AppBar(
          title: Text('ödünç alanlar'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             Expanded(
               child: ListView.builder(
                 itemCount: borrowList!.length,
                 itemBuilder:(context, index){ borrowList?.length;
                 return ListTile(
                   leading: CircleAvatar(
                //backgroundImage: NetworkImage(borrowList![index].photoUrl!),
                  ),
                   title: Text('${borrowList![index].name!} ${borrowList![index].surname!} '),

                 );}
               ),
             ),
             InkWell(
                 child: Container(
                     alignment: Alignment.center,
                     height: 80,
                     color: Colors.blueAccent,
                     child: Text(
                       'YENİ ÖDÜNÇ',
                       style: TextStyle(fontSize: 18, color: Colors.white),
                     )),
               onTap: () async{
                 BorrowInfo? newborrowInfo = await showModalBottomSheet<BorrowInfo>(
                     enableDrag: false,
                     isDismissible: false,
                     builder: (BuildContext context){
                   return WillPopScope(
                       onWillPop: null,
                       child: BorrowForm());
                 }, context: context);

      if (newborrowInfo != null) {
      setState(() {
      borrowList.add(newborrowInfo);
      });
      context.read<BorrowListViewModel>().updateBook(
          book: widget.book, borrowList: borrowList);

      }
                 }

      )
           ],
          ),
        ),
      ),
    );
  }
}


class BorrowForm extends StatefulWidget {
  const BorrowForm({Key? key}) : super(key: key);

  @override
  State<BorrowForm> createState() => _BorrowFormState();
}

class _BorrowFormState extends State<BorrowForm> {

  final _formkey = GlobalKey<FormState>();
  TextEditingController namefieldctr =TextEditingController();
  TextEditingController surnamefieldctr =TextEditingController();
  TextEditingController borrowdatefieldctr =TextEditingController();
  TextEditingController returnDatefieldctr =TextEditingController();
  DateTime? _selectedBorrowDate;
  DateTime? _selectedReturnDate;
  String? photoUrl;
  File? _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile =
    await picker.getImage(source: ImageSource.camera, maxHeight: 200);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);

      } else {
        print('No image selected.');
      }
    });

    if(pickedFile != null){
  photoUrl = await  uploadImageStorage(_image!);}

  }

  Future<String> uploadImageStorage (File uploadedImage)async{
    String path= '${DateTime.now().microsecondsSinceEpoch}.jpg';

    TaskSnapshot uploadTask = await FirebaseStorage.instance.ref().child('photos').child(path).putFile(_image!);
    String uploadImageUrl = await uploadTask.ref.getDownloadURL();
    return uploadImageUrl;
  }



  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context)=> BorrowListViewModel(),
      builder: (context,_) =>
       SingleChildScrollView(
        child: Container(
            padding:  EdgeInsets.only(bottom:MediaQuery.of(context).viewInsets.bottom),
            child: Form(
            key: _formkey,
            child: Column(
           children: [
             Row(
               mainAxisSize: MainAxisSize.max,
               mainAxisAlignment: MainAxisAlignment.spaceAround,
               children: [
                 Flexible(child: Stack(
               children: [
                     Container(
                      width: 90,
                    height: 90,

                    child: ClipOval(

                      child: (_image == null)
                              ? Image(
                                  image: NetworkImage(
                                      'https://gunceloku.com/uploads/cin-nedir-60dedf327cd73.jpg')
                    )
                              : Image.file(_image!),
                 ),),
                     Positioned(
                         bottom: -5,
                         right: -10,
                         child: IconButton(
                       onPressed: getImage,
                       icon: Icon(Icons.camera_alt,
                         color: Colors.grey.shade800,
                         size: 35),

                     ))
                   ],
                 )),

                 Flexible(child: Column(
                   children: [
                     TextFormField(
                       controller: namefieldctr,
                       decoration: InputDecoration(
                         hintText: 'adınız'
                       ),
                       validator: (val){
                         if(val==null || val.isEmpty){
                           return 'adınızı girin';
                         }
                         else{
                           return null;
                         }

                       },
                     ),
                     TextFormField(
                       controller: surnamefieldctr,
                       decoration: InputDecoration(
                           hintText: 'Soyadınız'
                       ),
                       validator: (val){
                         if(val==null || val.isEmpty){
                           return 'Soyadınızı girin';
                         }
                         else{
                           return null;
                         }

                       },
                     )
                   ],
                 ))
               ],
             ),
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceAround,
               mainAxisSize: MainAxisSize.min,
               children: [
                 Flexible(
                   child: TextFormField(
                       controller: borrowdatefieldctr,
                       onTap: () async {
                         _selectedBorrowDate = await showDatePicker(
                             context: context,
                             initialDate: DateTime.now(),
                             firstDate: DateTime.now(),
                             lastDate: DateTime.now().add(Duration(days: 365)));

                         borrowdatefieldctr.text =
                             Calculator.parseDateFormat(_selectedBorrowDate);
                       },

                       decoration: InputDecoration(
                         prefixIcon: Icon(Icons.date_range),
                         hintText: 'Alım Tarihi',
                       ),
                       validator: (value) {
                         if (value == null || value.isEmpty) {
                           return 'Lütfen Tarih Seçiniz';
                         } else {
                           return null;
                         }
                       }),
                 ),
                 SizedBox(width: 10),
                 Flexible(
                   child: TextFormField(
                       controller: returnDatefieldctr,
                       onTap: () async {
                         _selectedReturnDate = await showDatePicker(
                             context: context,
                             initialDate: DateTime.now(),
                             firstDate: DateTime.now(),
                             lastDate: DateTime.now().add(Duration(days: 365)));

                         returnDatefieldctr.text =
                             Calculator.parseDateFormat(_selectedReturnDate);
                       },

                       decoration: InputDecoration(
                           hintText: 'İade Tarihi',
                           prefixIcon: Icon(Icons.date_range)),
                       validator: (value) {
                         if (value == null || value.isEmpty) {
                           return 'Lütfen Tarih Seçiniz';
                         } else {
                           return null;
                         }
                       }),
                 ),
               ],
             ),

             SizedBox(height: 40),
             ElevatedButton(onPressed: (){
               if(_formkey.currentState!.validate()){
                 BorrowInfo newborrowInfo = BorrowInfo(
                     name: namefieldctr.text,
                     surname: surnamefieldctr.text,
                     borrowdate: Calculator.datetimeTotimestap(_selectedBorrowDate),
                     returndate: Calculator.datetimeTotimestap(_selectedReturnDate),
                     photoUrl: photoUrl ?? 'https://icdn.tgrthaber.com.tr/resize/850x467/static/albumler/2020_05/24126/buyuk/cin-filmleri-en-guzel-cin-filmleri-en-korkunc-cin-filmleri-turk-cin-filmleri_01589388482.jpg'
                 );
                 Navigator.pop(context, newborrowInfo);
               }
             }, child: Text('ekle')),
             ElevatedButton(onPressed: (){

               if (photoUrl != null) {
                 context.read<BorrowListViewModel>()
                     .deletePhoto(photoUrl: photoUrl);
               }

               Navigator.pop(context);
             }, child: Text('iptal'))
           ]
            ),

        )),
      ),
    );
  }
}
