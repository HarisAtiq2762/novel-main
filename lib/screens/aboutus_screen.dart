import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:novel/screens/privacy_policy_screen.dart';
import 'package:novel/globals.dart' as globals;
import 'package:novel/screens/termsofuse_screen.dart';
class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(360, 690),
        orientation: Orientation.portrait);
    final styleOfTexts = GoogleFonts.roboto(color: globals.primaryTextColor,fontSize: 15.sp);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: globals.primary,
        title: Text('About Us',style: GoogleFonts.roboto(color: globals.primaryTextColor,fontSize: 20.sp),),
        leading: IconButton(
          icon:Icon(Icons.arrow_back_ios),
          color: globals.primaryTextColor, onPressed: () { Navigator.pop(context); },
        ),
      ),
      body: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>PrivacyPolicyScreen()));
                },
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
                                Icon(Icons.privacy_tip,color: globals.primaryTextColor,),
                                SizedBox(width: 5,),
                                Text('Privacy Policy',style: styleOfTexts,),
                              ],
                            ),
                            Icon(Icons.arrow_forward_ios,color: globals.primaryTextColor,),
                          ],
                        ))
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>TermsOfUseScreen()));
                },
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
                                Icon(Icons.info,color: globals.primaryTextColor,),
                                SizedBox(width: 5,),
                                Text('Terms Of Use',style: styleOfTexts,),
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
