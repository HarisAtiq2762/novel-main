import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:novel/globals.dart' as globals;
class TagsWidget extends StatelessWidget {
  String title;
  TagsWidget({this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: globals.primary,
        ),
        child: Text('  #$title   ',style: GoogleFonts.roboto(fontSize: 15.0,fontWeight: FontWeight.w500,wordSpacing: 0.5 ),),
      ),
    );
  }
}
