import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:novel/models/auth.dart';
import 'package:novel/models/review.dart';
import 'package:novel/screens/AuthScreens/login.dart';
import 'package:novel/screens/user_book_libaray.dart';
import 'package:novel/widgets/bottomNavbar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';
import 'globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'models/user.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String email = prefs.getString('u-email');
  String pass = prefs.getString('u-pass');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Review()),
      ],
      child: MyApp(email: email,pass: pass,),
    ),
  );
}

class MyApp extends StatelessWidget {
  String email,pass;
  MyApp({this.email,this.pass});
  @override
  Widget build(BuildContext context) {
    globals.baseUrl = 'https://novel.vidseries.com/';
    MaterialColor kPrimaryColor = MaterialColor(
      0xffDFB2A9,
      <int, Color>{
        50: HexColor('#D57E7E'),
        100: HexColor('#D57E7E'),
        200: HexColor('#D57E7E'),
        300: HexColor('#D57E7E'),
        400: HexColor('#D57E7E'),
        500: HexColor('#D57E7E'),
        600: HexColor('#D57E7E'),
        700: HexColor('#D57E7E'),
        800: HexColor('#D57E7E'),
        900: HexColor('#D57E7E'),
      },
    );
    globals.primary = HexColor('D57E7E');
    // if(email!=null&&pass!=null){
    //   print(email);
    //   loginuser(context);
    // }
    return ScreenUtilInit(
        designSize: Size(360, 750),
        builder: () => MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: kPrimaryColor,
            ),
          home: Center(
              child: Container(
                height: 1.0.sh,
                color: HexColor('#f3e5e6'),
                padding: EdgeInsets.fromLTRB(0.0, 0.2.sh, 0.0, 0.0),
                child: SplashScreen(
                  useLoader: false,
                  seconds: 5,
                  navigateAfterSeconds: LoginScreen(email: email,pass: pass,),
                  title: Text(
                    'Where your imaginations come to life',
                    softWrap: true,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: HexColor('#D57E7E'),
                      fontSize: 15.0.sp,
                    ),),
                  image: Image.asset('asset/logo.png'),
                  backgroundColor: HexColor('#f3e5e6'),
                  photoSize: 0.1.sh,
                ),
              ),
            ),
        )
    );
  }


  // Future loginuser(context) async {
  //   var headers = {
  //     'Content-Type': 'application/json'
  //   };
  //   var request = http.Request('POST', Uri.parse(globals.baseUrl+'login_api'));
  //   request.body = json.encode({
  //     "email": email,
  //     "password": pass,
  //   });
  //   request.headers.addAll(headers);
  //   Auth().showLoadingModal(context);
  //   http.StreamedResponse response = await request.send();
  //   if (response.statusCode == 200) {
  //     dynamic data = await response.stream.bytesToString();
  //     data = jsonDecode(data);
  //     dynamic success = data['success'];
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     prefs.setString('UserData', data['data'].toString());
  //     if(success == true)
  //     {
  //       User logedInUser = await User().getUserDetails(data['data']['user_id']);
  //       globals.logedInUser = logedInUser;
  //       prefs.setString('u-email', logedInUser.email);
  //       prefs.setString('u-pass', logedInUser.password);
  //       Navigator.push(context, MaterialPageRoute(builder: (context)=>MyBottomNavBar()));
  //     }
  //     else{
  //       Navigator.pop(context);
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         content: Text(data['msg']),
  //         backgroundColor: Colors.red,
  //         duration: Duration(milliseconds: 2500),
  //       ));
  //     }
  //   }
  //   else {
  //     print(response.reasonPhrase);
  //   }
  //
  // }
}

