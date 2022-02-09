import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:novel/models/user.dart';
import 'package:novel/widgets/myappbar.dart';
import 'package:novel/widgets/peoplesCard.dart';
class ViewFollowersScreen extends StatefulWidget {
  List followers;
  String title;
  ViewFollowersScreen({Key key,@required this.followers,@required this.title}) : super(key: key);

  @override
  _ViewFollowersScreenState createState() => _ViewFollowersScreenState();
}

class _ViewFollowersScreenState extends State<ViewFollowersScreen> {
  @override
  Widget build(BuildContext context) {
    final styleOfTexts = GoogleFonts.roboto(color: Colors.black,fontSize: 18);
    return widget.followers.length>0?
    Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xffEABFB9),// HexColor('#ffebe7'),
        title: Text(widget.title,style: styleOfTexts,),
        leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios,color: Colors.black,size: 30,)
        ),
      ),
      body: ListView.builder(
        itemCount: widget.followers.length,
        itemBuilder: (context,index){
          User user = widget.followers[index];
          return PeopleCard(user: user);
        },
      ),
    ):Scaffold(
      body: Center(
        child: Text('No ${widget.title} Found'),
      ),
    );
  }
}
