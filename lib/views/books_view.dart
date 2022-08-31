import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_cloud_kitaplar/model/book_model.dart';
import 'package:firebase_cloud_kitaplar/views/addbook_view.dart';
import 'package:firebase_cloud_kitaplar/views/books_view_model.dart';
import 'package:firebase_cloud_kitaplar/views/borrow_list_view.dart';
import 'package:firebase_cloud_kitaplar/views/updateBook_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';


class BooksView extends StatefulWidget {

  @override
  State<BooksView> createState() => _BooksViewState();
}


class _BooksViewState extends State<BooksView> {


  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (_)=> BooksViewModel(),
      builder:(context, child)=>
       Scaffold(
         backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          title: Text('kitaplar'),
        ),
      body: Center(
        child: Column(
          children: [
            StreamBuilder<List<Book>>(
                stream: Provider.of<BooksViewModel>(context, listen: false).getBookList(),
                builder: (context, asyncSnapshot ){
                  if(asyncSnapshot.hasError){
                     print(asyncSnapshot.error);
                    return

                      Center(child: Text('hata'),

                   );
                  }
                  else{
                    if(!asyncSnapshot.hasData){
                       return CircularProgressIndicator();
                    }
                    else{
                      List  KitapList = asyncSnapshot.data! as List<Book>;
                      return BuildListBuilde(KitapList: KitapList);

                    }
                  }
                }),
FloatingActionButton(onPressed:(){
  Navigator.push(context, MaterialPageRoute(builder: (context) => AddBookView()));
})
          ],
        ),
      ),
      ),
    );
  }
}

class BuildListBuilde extends StatefulWidget {
  const BuildListBuilde({
    super.key,
    required this.KitapList,
  });

  final List KitapList;

  @override
  State<BuildListBuilde> createState() => _BuildListBuildeState();
}

class _BuildListBuildeState extends State<BuildListBuilde> {
  bool? isFiltering=false;
  List<Book>? filteredList;

  @override
  Widget build(BuildContext context) {


    var fulList =widget.KitapList;
    print(fulList.first.borrows.first.name);
    return Flexible(
      child: Column(

        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
          onChanged: (val){
             if(val.isNotEmpty){
              isFiltering=true;
              setState(() {
                filteredList = fulList.where((Book) => Book.bookName.toLowerCase().contains(val.toLowerCase())).cast<Book>().toList();
              });
           }else{
               setState(() {
                 WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
                 isFiltering=false;
               });
             }
          },
              decoration: InputDecoration(
                hintText: 'kitap arayın',
              prefixIcon: Icon(Icons.search_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15)
                )
              ),

            ),
          ),
          Flexible(child: ListView.builder(
              itemCount: isFiltering!? filteredList?.length:fulList.length,
              itemBuilder: (context,index){
                var list=isFiltering!? filteredList:fulList;
                return
                  Slidable(




                    startActionPane: ActionPane(
                    // A motion is a widget used to control how the pane animates.
                    motion: const ScrollMotion(), children: [
                      SlidableAction(
                        onPressed: (_) async{
                  await Provider.of<BooksViewModel>(context,
                       listen: false)
                        .deleteBook(list![index]);
                        },
                        backgroundColor: Color(0xFFFE4A49),
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                      SlidableAction(
                        onPressed: (_){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>UpdateBookView(

                              book:list![index])));
                        },
                        backgroundColor: Color(0xFF21B7CA),
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                        label: 'edit',


                      ),


                    ],),

                    endActionPane:  ActionPane(
                      motion: ScrollMotion(),
                      children: [
                        SlidableAction(

                          onPressed: (_){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>BorrowListView(

                                book:list![index])));
                          },

                          backgroundColor: Colors.greenAccent,
                          foregroundColor: Colors.white,
                          icon: Icons.person,
                          label: 'kayıtlar',


                        ),

                      ],
                    ),

                    child: Card(
                      child: ListTile(
                      title: Text(list![index].bookName),
                        subtitle: Text(list![index].authorName),

                      ),
                    ),
                  );
              })),
        ],
      ),
    );
  }
}
