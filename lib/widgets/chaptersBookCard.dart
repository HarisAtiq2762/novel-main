import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:novel/models/book.dart';
import 'package:novel/globals.dart' as globals;
class ChaptersBookCard extends StatelessWidget {
  Book book;
  ChaptersBookCard({Key key,@required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(360, 690),
        orientation: Orientation.portrait);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20.0)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 0.150.sh,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.0),bottom: Radius.circular(20.0)),
                child: Image.network(
                  book.image,
                  // height: MediaQuery.of(context).size.height * 0.23,
                  // alignment: Alignment(-offset.abs(), 0),
                  fit: BoxFit.cover,
                  // width: 240,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
