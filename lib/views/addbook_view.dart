import 'package:firebase_cloud_kitaplar/services/calculator.dart';
import 'package:firebase_cloud_kitaplar/views/add_book_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddBookView extends StatefulWidget {
  const AddBookView({Key? key}) : super(key: key);


  @override
  State<AddBookView> createState() => _AddBookViewState();
}

class _AddBookViewState extends State<AddBookView> {
  TextEditingController bookctrl = TextEditingController();
  TextEditingController authorctrl = TextEditingController();
  TextEditingController publishctrl = TextEditingController();
  var selectedDate;
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddBookmodel>(
      create: (_)=> AddBookmodel(),
      builder:(context,_)=> Scaffold(
        appBar: AppBar(
          title: Text('Add Book'),
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
                      context.read<AddBookmodel>().addNewBook(bookName: bookctrl.text,
                         authorName: authorctrl.text,
                          publishDate: selectedDate);

                      Navigator.pop(context);
                    }
                  }, child: Text('kaydet'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
