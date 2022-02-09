import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:novel/screens/accountSettings_screen.dart';
import 'package:novel/globals.dart' as globals;
import 'package:novel/screens/contactus_screen.dart';
import 'package:novel/screens/privacy_policy_screen.dart';
import 'package:novel/screens/termsofuse_screen.dart';

import 'aboutus_screen.dart';
class SettingScreen extends StatefulWidget {
  const SettingScreen({Key key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(360, 690),
        orientation: Orientation.portrait);
    final styleOfTexts = GoogleFonts.roboto(color: globals.primaryTextColor,fontSize: 18.sp);
    return Scaffold(
      backgroundColor: globals.darkBackgroud==true?Colors.white10:Colors.white,
      appBar: AppBar(
        backgroundColor: globals.primary,
        title: Text('Settings',style: styleOfTexts,),
        leading: IconButton(
          icon:Icon(Icons.arrow_back_ios),
          color: globals.primaryTextColor, onPressed: () { Navigator.pop(context); },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  padding: EdgeInsets.all(8.0),
                  width: MediaQuery.of(context).size.width*0.9,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: globals.primary
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.language,color: globals.primaryTextColor,),
                      SizedBox(width: 5,),
                      Center(
                          child: Text('Language = English',style: styleOfTexts,)),
                    ],
                  )
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  padding: EdgeInsets.all(8.0),
                  width: MediaQuery.of(context).size.width*0.9,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: globals.primary
                  ),
                  child: Center(
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>AccountSettingScreen()));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.account_box_rounded,color: globals.primaryTextColor,),
                                SizedBox(width: 5,),
                                Text('Account Setting',style: styleOfTexts,),
                              ],
                            ),
                            Icon(Icons.arrow_forward_ios,color: globals.primaryTextColor,),
                          ],
                        ),
                      ))
              ),
            ),
          ),
          // Center(
          //   child: Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: Container(
          //         padding: EdgeInsets.all(8.0),
          //         width: MediaQuery.of(context).size.width*0.9,
          //         decoration: BoxDecoration(
          //             borderRadius: BorderRadius.circular(10.0),
          //             color: globals.primary
          //         ),
          //         child: Center(
          //             child: Row(
          //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //               children: [
          //                 Row(
          //                   children: [
          //                     Icon(Icons.nightlight_round,color: globals.primaryTextColor,),
          //                     SizedBox(width: 5,),
          //                     Text('Dark Mode',style: styleOfTexts,),
          //                   ],
          //                 ),
          //                 GFToggle(
          //                   onChanged: (val){
          //                     globals.darkBackgroud=val;
          //                     setState(() {});
          //                   },
          //                   enabledThumbColor: Colors.blueGrey,
          //                   enabledTrackColor: Colors.red[100],
          //                   value: globals.darkBackgroud,
          //                 )
          //               ],
          //             ))
          //     ),
          //   ),
          // ),
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>AboutUsScreen()));
            },
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    padding: EdgeInsets.all(8.0),
                    width: MediaQuery.of(context).size.width*0.9,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: globals.primary
                    ),
                    child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(FontAwesomeIcons.addressBook,color: globals.primaryTextColor,),
                                SizedBox(width: 5,),
                                Text('About Us',style: styleOfTexts,),
                              ],
                            ),
                            Icon(Icons.arrow_forward_ios,color: globals.primaryTextColor,),
                          ],
                        ))
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ContactUsScreen()));
            },
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    padding: EdgeInsets.all(8.0),
                    width: MediaQuery.of(context).size.width*0.9,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: globals.primary
                    ),
                    child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(FontAwesomeIcons.phone,color: globals.primaryTextColor,),
                                SizedBox(width: 5,),
                                Text('Contact Us',style: styleOfTexts,),
                              ],
                            ),
                            Icon(Icons.arrow_forward_ios,color: globals.primaryTextColor,),
                          ],
                        ))
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
