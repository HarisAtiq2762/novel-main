import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:novel/widgets/writerhubBookCard.dart';
class WriterHubScreen extends StatelessWidget {
  const WriterHubScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final styleOfTexts = GoogleFonts.roboto(color: Colors.black,fontSize: 25);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor('#cc7471'),
        title: Text('Writer Hub',style: styleOfTexts,),
        leading: IconButton(
          icon:Icon(Icons.arrow_back_ios),
          color: Colors.black, onPressed: () { Navigator.pop(context); },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: HexColor('#cc7471'),
                ),
                child: Text('  Your Stories   ',style: GoogleFonts.roboto(fontSize: 20.0,fontWeight: FontWeight.w500,wordSpacing: 0.5 ),),
              ),
            ),
            WriterhubBookCard(),
            WriterhubBookCard(),
            WriterhubBookCard(),
            WriterhubBookCard(),
          ],
        ),
      ),
    );
  }
}
