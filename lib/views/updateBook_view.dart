import 'package:firebase_cloud_kitaplar/model/book_model.dart';
import 'package:firebase_cloud_kitaplar/services/calculator.dart';
import 'package:firebase_cloud_kitaplar/views/add_book_model.dart';
import 'package:firebase_cloud_kitaplar/views/update_book_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateBookView extends StatefulWidget {
 final Book? book ;

  const UpdateBookView({super.key,  this.book});




  @override
  State<UpdateBookView> createState() => _UpdateBookViewState();
}

class _UpdateBookViewState extends State<UpdateBookView> {
  TextEditingController bookctrl = TextEditingController();
  TextEditingController authorctrl = TextEditingController();
  TextEditingController publishctrl = TextEditingController();
  var selectedDate;
  final _formkey = GlobalKey<FormState>();

  void dispose(){
    bookctrl.dispose();
    authorctrl.dispose();
    publishctrl.dispose();
}

  @override
  Widget build(BuildContext context) {
    bookctrl.text=widget.book!.bookName!;
    authorctrl.text=widget.book!.authorName!;
    publishctrl.text=Calculator.parseDateFormat(
        Calculator.datetimeFromTimestamp(widget.book!.publishDate!));



    return ChangeNotifierProvider<UpdateBookmodel>(
      create: (_)=> UpdateBookmodel(),
      builder:(context,_)=> Scaffold(
        appBar: AppBar(
          title: Text('update book'),
        ),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  TextFormField(
controller: bookctrl,
                    decoration: InputDecoration(
                      hintText: 'kitap adı',
                      icon: Icon(Icons.book)
                    ),
                    validator: (val){
  if(val==null || val.isEmpty){
return 'kitap adı boş olamaz';
  } else{return null;}
                    },
                  ),
                  TextFormField(
                    controller: authorctrl,
                    decoration: InputDecoration(
                        hintText: 'yazar adı',
                        icon: Icon(Icons.edit)
                    ),
                    validator: (val){
                      if(val==null || val.isEmpty){
                        return 'yazar adı boş olamaz';
                      } else{return null;}
                    },
                  ),
                  TextFormField(
                    onTap: ()async{
                        selectedDate= await showDatePicker(context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(-1000),
                          lastDate: DateTime.now());

                       publishctrl.text = Calculator.parseDateFormat(selectedDate!);
                    },


                    controller: publishctrl,

                    decoration: InputDecoration(
                        hintText: 'basım tarihi',
                        icon: Icon(Icons.date_range)
                    ),
                    validator: (val){
                      if(val==null || val.isEmpty){
                        return 'basım tarihi boş olamaz';
                      } else{return null;}
                    },
                  ),
                  ElevatedButton(onPressed: ()async{
                    if(_formkey.currentState!.validate()){
                      context.read<UpdateBookmodel>().UpdateNewBook(bookName: bookctrl.text,
                         authorName: authorctrl.text,
                          publishDate: selectedDate?? Calculator.datetimeFromTimestamp(widget.book!.publishDate!),
                      book: widget.book
                      );

                      Navigator.pop(context);
                    }
                  }, child: Text('güncelle'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
