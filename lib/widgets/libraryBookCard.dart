import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/components/progress_bar/gf_progress_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:novel/models/book.dart';
import 'package:novel/screens/chapters_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bookCard.dart';
import 'package:novel/globals.dart' as globals;
class LibraryBookCard extends StatefulWidget {
  Book book;
  Widget button;
  final chapterId;
  LibraryBookCard({Key key,this.book,this.button,this.chapterId}) : super(key: key);

  @override
  _LibraryBookCardState createState() => _LibraryBookCardState();
}

class _LibraryBookCardState extends State<LibraryBookCard> {
  SharedPreferences prefs;
  double percent=0.0;
  Future intiSharedPrefs()async{
    prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey('memoryOf'+widget.book.bookId.toString())){
      List memory = prefs.get('memoryOf' + widget.book.bookId.toString());
      percent = double.parse(memory[1])+1/widget.book.chapterList.length;
      return percent;
    }
    return 0.0;
  }
  @override
  Widget build(BuildContext context) {
    intiSharedPrefs();
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(360, 690),
        orientation: Orientation.portrait);
    return Container(
      width: 1.0.sw,
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BookCard(book: widget.book,),
          SizedBox(width: 0.1.sw,),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 0.35.sw,
                child: GFButton(
                    color: globals.primary,
                    fullWidthButton: false,
                    text: 'Read Now',
                    textStyle: GoogleFonts.roboto(color: globals.primaryTextColor),
                    onPressed: (){
                      int chapIndex;
                      if(prefs.containsKey('memoryOf'+widget.book.bookId.toString())){
                        List memory = prefs.get('memoryOf' + widget.book.bookId.toString());
                        chapIndex=int.parse(memory[1]);
                      }
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ChaptersScreen(book: widget.book,chapterId: widget.chapterId,fromList: true,chapterListIndex: chapIndex,)));
                    }),
              ),
              widget.button,
              FutureBuilder(
                future: intiSharedPrefs(),
                builder: (context,snapshot){
                  if(snapshot.connectionState==ConnectionState.done){
                    // print(percent/10);
                    String p = (percent*01).toString().replaceAll('.', '').substring(0,2);
                    return Container(
                      width: 0.35.sw,
                      child: GFProgressBar(
                        lineHeight: 0.03.sh,
                        autoLive: true,
                        percentage: (percent/10),
                        progressBarColor: globals.primary,
                        child: Center(child: Text('completed '+p+'%',style: TextStyle(color: Colors.white),)),
                      ),
                    );
                  }
                  else{
                    return Container();
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
