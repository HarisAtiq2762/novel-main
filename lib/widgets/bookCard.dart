import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:novel/models/book.dart';
import 'package:novel/screens/book_details.dart';
class BookCard extends StatelessWidget {
  Book book;
  BookCard({Key key,this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(360, 690),
        orientation: Orientation.portrait);
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>BookDetails(book: book,)));
      },
      child: Container(
        width: 0.3.sw,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 0.26.sw,
              height: 0.17.sh,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(0.020.sh)
              ),
              child: ClipRRect(
                child: Image.network(
                  book.image,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Container(
              width: 0.25.sw,
              height: 0.05.sh,
              child: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(book.bookTitle,style: GoogleFonts.roboto(fontSize: 15.sp),)
                )
              )
            ),
            Text(book.author,style: GoogleFonts.roboto(fontSize: 12.sp),),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.star,size: 0.02.sh,),
                        Text(book.totalVotes.toString()),
                      ],
                    ),
                  ),

                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.remove_red_eye_outlined,size: 0.02.sh),
                        Text(' '+book.totalViews.toString()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 0.01.sh,),
          ],
        ),
      ),
    );
  }
}
