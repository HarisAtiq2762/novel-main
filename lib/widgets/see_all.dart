import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:novel/models/book.dart';
import 'package:novel/widgets/bookCard.dart';
import 'package:novel/widgets/myappbar.dart';
import '../screens/chapters_screen.dart';
import 'package:novel/globals.dart' as globals;
class SeeAllScreen extends StatefulWidget {
String Noveltype;
List booksList;
SeeAllScreen({this.Noveltype,this.booksList});
  @override
  _SeeAllScreenState createState() => _SeeAllScreenState();
}

class _SeeAllScreenState extends State<SeeAllScreen> {
  final styleOfTexts = GoogleFonts.roboto(color: globals.primaryTextColor,fontSize: 25);
  int _bottomNavIndex;
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(360, 690),
        orientation: Orientation.portrait);
    return Scaffold(
      // backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: globals.primary,// HexColor('#ffebe7'),
        title: Text(widget.Noveltype,style: styleOfTexts,),
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios,color: globals.primaryTextColor,size: 30,)
        ),
      ),
      body:
      widget.booksList.length==0?
      Center(
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
              Text('No Books Found',style: TextStyle(color: Color(0xffdfb2a9),fontSize: 17.sp),),
            ],
          ),
        ),
      ) :
      SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height-100,
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: widget.booksList.length,
                  itemBuilder: (context,index){
                    Book myBook = widget.booksList[index];
                    return Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 0.0.sh, 0.0, 0.01.sh),
                          child: Container(
                            width: MediaQuery.of(context).size.width*0.9,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                BookCard(book: myBook,),
                                Column(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width/3,
                                      child: GFButton(
                                          color: globals.primary,
                                          fullWidthButton: false,
                                          text: 'Read Now',
                                          textStyle: GoogleFonts.roboto(color: globals.primaryTextColor),
                                          onPressed: (){
                                            Navigator.push(context, MaterialPageRoute(builder: (context)=>ChaptersScreen(book: myBook,)));
                                          }),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width*0.4,
                                      height: 0.15.sh,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: Text(myBook.description,
                                          style: GoogleFonts.lato(
                                            textStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15.0,
                                                letterSpacing: 1
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0.12.sw, 0.0, 0.0, 0.0),
                          child: Container(
                              width: 0.09.sw,
                              height: 0.04.sh,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: globals.primary.withOpacity(0.9),
                              ),
                              child: Center(child: Text('# '+(index+1).toString(),style: GoogleFonts.montserrat(color: Colors.white,fontSize: 12.sp,fontWeight: FontWeight.w500),))),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),

    );

  }
}
