import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:novel/screens/chapters_screen.dart';
import 'package:novel/screens/create_book.dart';
import 'package:novel/screens/profile_screen.dart';
import 'package:novel/screens/search_screen.dart';
class MyDrawer extends StatelessWidget {
  const MyDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final styleOfTexts = GoogleFonts.roboto(color: Colors.black,fontSize: 25);

    return Drawer(
      child: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 40.0,
                      backgroundImage: NetworkImage(
                        'https://www.mobilesmspk.net/user/images/wallpaper_images/2011/04/4/www.mobilesmspk.net_harry-potter_1589.jpg',
                      ),
                    ),
                    SizedBox(width: 20.0,),
                    Text('Haris Atiq',style: styleOfTexts,),
                  ],
                ),
              ),
              Divider(thickness: 2.0,indent: 20.0,endIndent: 20.0,color: HexColor('#ffebe7'),),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen()));
                },
                child: Container(
                  padding: EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.person,size: 30.0,),
                      SizedBox(width: 10.0,),
                      Text('Profile',style: GoogleFonts.roboto(fontSize: 20.0),)
                    ],
                  ),
                ),
              ),
              Divider(thickness: 2.0,indent: 60.0,endIndent: 60.0,color: HexColor('#ffebe7'),),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchScreen()));
                },
                child: Container(
                  padding: EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.search,size: 30.0,),
                      SizedBox(width: 10.0,),
                      Text('Search',style: GoogleFonts.roboto(fontSize: 20.0),)
                    ],
                  ),
                ),
              ),

              Divider(thickness: 2.0,indent: 60.0,endIndent: 60.0,color: HexColor('#ffebe7'),),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen()));
                },
                child: Container(
                  padding: EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.person,size: 30.0,),
                      SizedBox(width: 10.0,),
                      Text('Profile',style: GoogleFonts.roboto(fontSize: 20.0),)
                    ],
                  ),
                ),
              ),
              Divider(thickness: 2.0,indent: 60.0,endIndent: 60.0,color: HexColor('#ffebe7'),),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateBook()));
                },
                child: Container(
                  padding: EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.auto_stories,size: 30.0,),
                      SizedBox(width: 10.0,),
                      Text('Create Book',style: GoogleFonts.roboto(fontSize: 20.0),)
                    ],
                  ),
                ),
              ),
              Divider(thickness: 2.0,indent: 60.0,endIndent: 60.0,color: HexColor('#ffebe7'),),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ChaptersScreen()));
                },
                child: Container(
                  padding: EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.auto_stories,size: 30.0,),
                      SizedBox(width: 10.0,),
                      Text('Chapters',style: GoogleFonts.roboto(fontSize: 20.0),)
                    ],
                  ),
                ),
              ),
              Divider(thickness: 2.0,indent: 60.0,endIndent: 60.0,color: HexColor('#ffebe7'),),

            ],
          ),
        ),
      ),
    );
  }
}
