import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';
import 'package:novel/models/book.dart';
import 'package:novel/widgets/bookCard.dart';
import 'package:novel/widgets/libraryBookCard.dart';
import 'package:novel/widgets/myDrawer.dart';
import 'package:novel/widgets/myappbar.dart';
import 'package:novel/widgets/profileBookCard.dart';
import 'package:novel/globals.dart' as globals;
import '../screens/chapters_screen.dart';
import 'book_details.dart';
class UserBookLibrary extends StatefulWidget {
  @override
  _UserBookLibraryState createState() => _UserBookLibraryState();
}

class _UserBookLibraryState extends State<UserBookLibrary> {
  final styleOfTexts = GoogleFonts.roboto(color: Colors.black,fontSize: 18.sp);
  int _bottomNavIndex;

  Widget myButton(int id){
    return GFButton(
        color: globals.primary,
        fullWidthButton: false,
        text: 'Remove From Library',
        textStyle: GoogleFonts.roboto(color: globals.primaryTextColor),
        onPressed: ()async{
          await Book().removeBookFromLibrary(id);
          setState(() {});
        });
  }
  Widget myButtonToAddToLibrary(){
    return GFButton(
      onPressed: ()async{
        var temp = await Book().addBookToLibrary(globals.bookId);
        print(jsonDecode(temp));
        if(jsonDecode(temp)['success']==true){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Book Added To Library"),
            backgroundColor: globals.primary,
            duration: Duration(seconds: 2),
          ));
          setState(() {});
        }else{
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Book already present in Library"),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ));
        }
      },
      shape: GFButtonShape.pills,
      icon: Icon(CupertinoIcons.add_circled_solid,color: globals.primary,),
      type: GFButtonType.outline2x,
      color: globals.primary,
      text: 'Add To Library',
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(360, 690),
        orientation: Orientation.portrait);
    globals.addToLibrary = myButtonToAddToLibrary();
    return Scaffold(
      // backgroundColor: Colors.black,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: MyAppBar(title: 'My Library',)
      ),
      body: FutureBuilder(
        future: Book().getLibraryBooks(),
        builder: (context,snapshot){
          if(snapshot.data!=null) {
            return ListView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  Book tempBook = snapshot.data[index];
                  // print(tempBook.chapterList);
                  return Column(
                    children: [
                      GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 2.0,
                                      spreadRadius: 0.0,
                                      offset: Offset(2.0, 2.0), // shadow direction: bottom right
                                    )
                                  ],
                                  color: Colors.white),
                              child: LibraryBookCard(
                                book: snapshot.data[index],
                                button: myButton(tempBook.bookId),
                              )),
                        ),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => BookDetails(book: snapshot.data[index],)));
                        },
                      ),
                      SizedBox(
                        height: 0.02.sh,
                      ),
                    ],
                  );
                });
          } else {
            return Center(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      'asset/emptyLib.json',
                        width: 0.7.sw,
                        height: 0.3.sh,
                        fit: BoxFit.fill,
                      repeat: true
                    ),
                    Text('Empty Library',style: TextStyle(color: globals.primary,fontSize: 17.sp),),
                  ],
                ),
              ),
            );
          }
        },
      ),

    );

  }
}
