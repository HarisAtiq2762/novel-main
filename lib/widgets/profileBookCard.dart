import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:novel/models/book.dart';
import 'package:http/http.dart' as http;
import 'package:novel/screens/edit_book.dart';
import 'package:novel/globals.dart' as globals;
class ProfileBookCard extends StatelessWidget {
  Book book;
  ProfileBookCard({@required this.book});

  Future getBookViewsVotesTotalChapters()async{
    var headers = {
      'Content-Transfer-Encoding': 'multipart/form-data',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(globals.baseUrl+'book_views_votes_total_chapters'));
    request.body = json.encode({
      "book_id": book.bookId
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      dynamic data = await response.stream.bytesToString();
      data = jsonDecode(data);
      if(data['success']==true){
        return data;
      }
    }
    else {
      print(response.reasonPhrase);
    }
  }
  @override
  Widget build(BuildContext context) {
    int views=0;
    int votes=0;
    int totalChapters=0;
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            // decoration: BoxDecoration(
            //   // border: Border.all(color: globals.primary),
            //   //   borderRadius: BorderRadius.circular(20.0)
            // ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 0.25.sw,
                  height: 0.15.sh,
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20.0),bottom: Radius.circular(20.0)),
                    child: Image.network(
                      book.image!=null?book.image:'',
                      // height: MediaQuery.of(context).size.height * 0.23,
                      // alignment: Alignment(-offset.abs(), 0),
                      fit: BoxFit.cover,
                      // width: 240,
                    ),
                  ),
                ),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                            height: 0.1.sh,
                            width: 0.7.sw,
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(0.01.sw, 0.005.sh, 0.01.sw, 0.001.sh),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        book.bookTitle+'\n',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14.sp),
                                    ),
                                    Text(
                                        book.description
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      SizedBox(height: 10,),
                      Text(
                          "Status: "+book.bookStatusPublish
                      ),
                      SizedBox(height: 10,),
                      FutureBuilder(
                          future: getBookViewsVotesTotalChapters(),
                          builder: (context,snapshot){
                            if(snapshot.connectionState==ConnectionState.done) {
                              views = snapshot.data['total_views'][0]['views'];
                              votes = snapshot.data['total_votes'][0]['votes'];
                              totalChapters = snapshot
                                  .data['total_chapters'][0]['chapters'];
                              return Row(
                                children: [
                                  Container(
                                    child: Column(
                                      children: [
                                        Icon(FontAwesomeIcons.eye),
                                        Text(snapshot
                                            .data['total_views'][0]['views']
                                            .toString()),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 0.025.sw,),
                                  Container(
                                    child: Column(
                                      children: [
                                        Icon(FontAwesomeIcons.star),
                                        Text(snapshot
                                            .data['total_votes'][0]['votes']
                                            .toString()),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 0.025.sw,),
                                  Container(
                                    child: Column(
                                      children: [
                                        Icon(Icons.menu),
                                        Text(snapshot
                                            .data['total_chapters'][0]['chapters']
                                            .toString()),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }
                            else return GFLoader();
                          }
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        book.authorId==globals.logedInUser.userId?
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
              icon: Icon(FontAwesomeIcons.edit),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>EditBook(book: book,)));
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: ()async{
                showDialog(context: context, builder: (context){
                  return Dialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                    child: Container(
                      width: 1.0.sw,
                      height: 0.25.sh,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.delete_outline_outlined,color: Colors.red,size: 0.1.sh,),
                            Text('Are you sure you want to delete this book?',style: GoogleFonts.montserrat(fontWeight: FontWeight.w500,fontSize: 16.sp),),
                            GFButton(
                              color: globals.primary,
                                text: 'Delete',
                                onPressed: ()async{
                              await Book().deleteBook(book.bookId);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Book deleted successfully. Please refresh'),
                                duration: Duration(milliseconds: 3000),
                              ));
                              Navigator.pop(context);
                            })
                          ],
                        ),
                      ),
                    ),
                  );
                });
              },
            )
          ],
        ):Container(),
        book.bookStatusActive!='active'?
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.5),
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(20.0),
            ),
            width: 1.0.sw,height: 0.157.sh,
            child: Center(
              child: Text('Your book has been inactivated',style: TextStyle(color: Colors.black,fontSize: 15.sp),),
            ),
          ),
        ):Container(),
      ],
    );
  }
}
