import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:novel/models/user.dart';
import 'package:novel/globals.dart' as globals;
import 'package:novel/screens/view_user_profile_screen.dart';
class PeopleCard extends StatelessWidget {
  User user;
  PeopleCard({Key key,@required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final styleOfTexts = GoogleFonts.roboto(color: globals.primaryTextColor,fontSize: 25);
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
            color: globals.primary,
            borderRadius: BorderRadius.circular(20.0)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              child: GestureDetector(
                onTap: ()async{
                  User tempUser = await User().getUserDetails(user.userId);
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewUserProfileScreen(user: tempUser)));
                },
                child: CircleAvatar(
                  radius: 40.0,
                  backgroundImage: NetworkImage(
                    user.image,
                    // width: 240,
                  ),
                ),
              ),
            ),
            SizedBox(width: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              user.name,
                              style: styleOfTexts,
                            ),
                          )
                      ),
                      Container(
                        width: 0.7.sw,
                        child: Text(user.bio==null?'':user.bio,style: TextStyle(color: globals.primaryTextColor),),
                      ),
                      SizedBox(height: 0.02.sh,),
                    ],
                  ),
                ),
                // SizedBox(width: 60.0,),
                // user.userId==globals.logedInUser.userId?
                // //     Container():
                // // Padding(
                // //   padding: const EdgeInsets.fromLTRB(0, 0, 0.0, 0),
                // //   child: Icon(FontAwesomeIcons.userPlus),
                // // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
