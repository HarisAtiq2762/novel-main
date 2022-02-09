import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class WriterhubBookCard extends StatelessWidget {
  const WriterhubBookCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final styleOfTexts = GoogleFonts.roboto(color: Colors.black,fontSize: 25);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Align(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.edit),
                  SizedBox(width: 10,),
                  Text('Edit',style: TextStyle(fontSize: 20),),
                ],
              ),
            ),
            alignment: Alignment.topRight,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: HexColor('#cc7471'),
                borderRadius: BorderRadius.circular(20.0)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 120,
                  height: 150,
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20.0),bottom: Radius.circular(20.0)),
                    child: Image.network(
                      'https://www.mobilesmspk.net/user/images/wallpaper_images/2011/04/4/www.mobilesmspk.net_harry-potter_1589.jpg',
                      // height: MediaQuery.of(context).size.height * 0.23,
                      // alignment: Alignment(-offset.abs(), 0),
                      fit: BoxFit.cover,
                      // width: 240,
                    ),
                  ),
                ),
                SizedBox(width: 20,),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Harry Potter',style: styleOfTexts,),
                      SizedBox(height: 5,),
                      Text('Status: Ongoing'),
                      SizedBox(height: 5,),
                      Text('Chapters : 20'),
                      SizedBox(height: 5,),
                      Text('Word count : 2000'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
