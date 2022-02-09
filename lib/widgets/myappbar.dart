import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:novel/screens/profile_screen.dart';
import 'package:novel/screens/search_screen.dart';
import 'package:novel/globals.dart' as globals;
class MyAppBar extends StatelessWidget {
  String title;
  MyAppBar({this.title});
  final styleOfTexts = GoogleFonts.roboto(color: Colors.white,fontSize: 25);
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(360, 690),
        orientation: Orientation.portrait);
    return AppBar(
      centerTitle: true,
      backgroundColor: globals.primary,// HexColor('#ffebe7'),
      title: Text(title,style: styleOfTexts,),
      // leading: GestureDetector(
      //   onTap: (){
      //     Navigator.pop(context);
      //   },
      //   child: Icon(Icons.arrow_back_ios,color: globals.primaryTextColor,size: 30,)
      // ),
      actions: [
        Padding(
          padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.02.sw, 0.01.sh),
          child: IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchScreen()));
            },icon:Icon(Icons.search,color: Colors.white,size: 30)),
        )
      ],
    );
  }
}
