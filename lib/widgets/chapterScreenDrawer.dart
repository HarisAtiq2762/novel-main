import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'chaptersBookCard.dart';
import 'package:novel/globals.dart' as globals;
class ChapterScreenDrawer extends StatelessWidget {
  const ChapterScreenDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final styleOfTexts = GoogleFonts.roboto(color: Colors.black,fontSize: 25);
    return Drawer(
      child: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Book',style: styleOfTexts,),
                ),
                ChaptersBookCard(),
                Divider(thickness: 2.0,indent: 60.0,endIndent: 60.0,color: globals.primary,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Chapters',style: styleOfTexts,),
                ),
                GestureDetector(
                  onTap: (){
                    // Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen()));
                  },
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.star,size: 30.0,),
                            SizedBox(width: 10.0,),
                            Text('Chapter 1',style: GoogleFonts.roboto(fontSize: 20.0),)
                          ],
                        ),
                        SizedBox(height: 5,),
                        Container(
                            child: Text(
                              'Adaptation of the first of J.K. Rowlings popular childrens novels about Harry Potter. Lorem ipsum dolor sit amet consectetur adipisicing elit. Maxime mollitia,molestiae quas vel sint commodi',
                              style: GoogleFonts.roboto(fontSize: 15.0),))
                      ],
                    ),
                  ),
                ),
                Divider(thickness: 2.0,indent: 6.0,endIndent: 6.0,color: globals.primary,),
                GestureDetector(
                  onTap: (){
                    // Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen()));
                  },
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.star,size: 30.0,),
                            SizedBox(width: 10.0,),
                            Text('Chapter 2',style: GoogleFonts.roboto(fontSize: 20.0),)
                          ],
                        ),
                        SizedBox(height: 5,),
                        Container(
                            child: Text(
                              'Adaptation of the first of J.K. Rowlings popular childrens novels about Harry Potter. Lorem ipsum dolor sit amet consectetur adipisicing elit. Maxime mollitia,molestiae quas vel sint commodi',
                              style: GoogleFonts.roboto(fontSize: 15.0),))
                      ],
                    ),
                  ),
                ),
                Divider(thickness: 2.0,indent: 6.0,endIndent: 6.0,color: globals.primary,),
                GestureDetector(
                  onTap: (){
                    // Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen()));
                  },
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.star,size: 30.0,),
                            SizedBox(width: 10.0,),
                            Text('Chapter 3',style: GoogleFonts.roboto(fontSize: 20.0),)
                          ],
                        ),
                        SizedBox(height: 5,),
                        Container(
                            child: Text(
                              'Adaptation of the first of J.K. Rowlings popular childrens novels about Harry Potter. Lorem ipsum dolor sit amet consectetur adipisicing elit. Maxime mollitia,molestiae quas vel sint commodi',
                              style: GoogleFonts.roboto(fontSize: 15.0),))
                      ],
                    ),
                  ),
                ),
                Divider(thickness: 2.0,indent: 6.0,endIndent: 6.0,color: globals.primary,),
                GestureDetector(
                  onTap: (){
                    // Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen()));
                  },
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.star,size: 30.0,),
                            SizedBox(width: 10.0,),
                            Text('Chapter 4',style: GoogleFonts.roboto(fontSize: 20.0),)
                          ],
                        ),
                        SizedBox(height: 5,),
                        Container(
                            child: Text(
                              'Adaptation of the first of J.K. Rowlings popular childrens novels about Harry Potter. Lorem ipsum dolor sit amet consectetur adipisicing elit. Maxime mollitia,molestiae quas vel sint commodi',
                              style: GoogleFonts.roboto(fontSize: 15.0),))
                      ],
                    ),
                  ),
                ),
                Divider(thickness: 2.0,indent: 6.0,endIndent: 6.0,color: globals.primary,),
                GestureDetector(
                  onTap: (){
                    // Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen()));
                  },
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.star,size: 30.0,),
                            SizedBox(width: 10.0,),
                            Text('Chapter 5',style: GoogleFonts.roboto(fontSize: 20.0),)
                          ],
                        ),
                        SizedBox(height: 5,),
                        Container(
                            child: Text(
                              'Adaptation of the first of J.K. Rowlings popular childrens novels about Harry Potter. Lorem ipsum dolor sit amet consectetur adipisicing elit. Maxime mollitia,molestiae quas vel sint commodi',
                              style: GoogleFonts.roboto(fontSize: 15.0),))
                      ],
                    ),
                  ),
                ),
                Divider(thickness: 2.0,indent: 6.0,endIndent: 6.0,color: globals.primary,),
                GestureDetector(
                  onTap: (){
                    // Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen()));
                  },
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.star,size: 30.0,),
                            SizedBox(width: 10.0,),
                            Text('Chapter 6',style: GoogleFonts.roboto(fontSize: 20.0),)
                          ],
                        ),
                        SizedBox(height: 5,),
                        Container(
                            child: Text(
                              'Adaptation of the first of J.K. Rowlings popular childrens novels about Harry Potter. Lorem ipsum dolor sit amet consectetur adipisicing elit. Maxime mollitia,molestiae quas vel sint commodi',
                              style: GoogleFonts.roboto(fontSize: 15.0),))
                      ],
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
