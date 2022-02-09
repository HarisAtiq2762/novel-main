import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';
import 'package:novel/models/auth.dart';
import 'package:novel/models/news.dart';
import 'package:novel/models/user.dart';
import 'package:novel/screens/AuthScreens/signup.dart';
import 'dart:convert';
import "package:http/http.dart" as http;
import 'package:novel/screens/home_screen.dart';
import 'package:novel/widgets/bookCard.dart';
import 'package:novel/widgets/bottomNavbar.dart';
import 'package:novel/widgets/see_all.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:novel/globals.dart' as globals;
import 'package:webview_flutter/webview_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:lottie/lottie.dart';
import 'package:novel/models/book.dart';


class LoginScreen extends StatefulWidget {
  String email;
  String pass;
  LoginScreen({Key key,this.email,this.pass}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool success;
  var user;
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();

  Future loginuser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(globals.baseUrl+'login_api'));
    request.body = json.encode({
      "email": email.text,
      "password": password.text,
    });
    request.headers.addAll(headers);
    Auth().showLoadingModal(context);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      dynamic data = await response.stream.bytesToString();
      data = jsonDecode(data);
      success = data['success'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('UserData', data['data'].toString());
      if(success == true)
      {
        User logedInUser = await User().getUserDetails(data['data']['user_id']);
        globals.logedInUser = logedInUser;
        prefs.setString('u-email', logedInUser.email);
        prefs.setString('u-pass', logedInUser.password);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyBottomNavBar()));
      }
      else{
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(data['msg']),
          backgroundColor: Colors.red,
          duration: Duration(milliseconds: 2500),
        ));
      }
    }
    else {
      print(response.reasonPhrase);
    }

  }
  Future loginuser2() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(globals.baseUrl+'login_api'));
    request.body = json.encode({
      "email": widget.email,
      "password": widget.pass,
    });
    request.headers.addAll(headers);
    Auth().showLoadingModal(context);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      dynamic data = await response.stream.bytesToString();
      data = jsonDecode(data);
      success = data['success'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('UserData', data['data'].toString());
      if(success == true)
      {
        User logedInUser = await User().getUserDetails(data['data']['user_id']);
        globals.logedInUser = logedInUser;
        prefs.setString('u-email', logedInUser.email);
        prefs.setString('u-pass', logedInUser.password);
        Navigator.pop(context);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyBottomNavBar()));
      }
      else{
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(data['msg']),
          backgroundColor: Colors.red,
          duration: Duration(milliseconds: 2500),
        ));
      }
    }
    else {
      print(response.reasonPhrase);
    }

  }

  bool hidePass=false;
  bool emailEnabled=true;
  bool showOtpSection=false;
  TextEditingController otp = TextEditingController();
  Auth myAuth;

  @override
  void initState() {
    // print('in init');
    // if(widget.email!=null&&widget.pass!=null){
    //   loginuser();
    // }
    super.initState();
  }

  void makeHomeWidget(){
    if(widget.email!=null&&widget.pass!=null){
      loginuser2();
    }
    globals.homeWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FutureBuilder(
          future: News().getTopNews(),
          builder: (context,snapshot){
            if(snapshot.connectionState==ConnectionState.done) {
              return CarouselSlider.builder(
                  options: CarouselOptions(
                    // height: 200,
                    aspectRatio: 2.0,
                    viewportFraction: 0.8,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal,
                  ),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index,
                      int pageViewIndex) {
                    News news = snapshot.data[index];
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(
                          0.0, 10.0, 0.0, 8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                                return WebView(
                                  initialUrl: news.url,
                                  javascriptMode: JavascriptMode
                                      .unrestricted,
                                );
                              }));
                        },
                        child: Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          margin: EdgeInsets.symmetric(horizontal: 0),
                          // decoration: BoxDecoration(
                          //     color: HexColor('#ffebe7')
                          // ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20.0),
                                bottom: Radius.circular(20.0)),
                            child: Image.network(
                              news.image,
                              // height: MediaQuery.of(context).size.height * 0.23,
                              // alignment: Alignment(-offset.abs(), 0),
                              fit: BoxFit.cover,
                              // width: 240,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
              );
            }else{
              return GFLoader();
            }
          },
        ),
        FutureBuilder(
          future: Book().getEditorsPick(),
          builder: (context,snapshot){
            if(snapshot.connectionState==ConnectionState.done){
              return Column(
                children: [
                  Container(
                    color: globals.primary,//HexColor('#ffebe7'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Editor\'s Pick',style: GoogleFonts.roboto(fontSize: 15.sp,color: Colors.white),),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>SeeAllScreen(Noveltype: 'Editor\'s Pick',booksList: snapshot.data,)));
                              },

                              child: Text('See All',style: GoogleFonts.roboto(fontSize: 15,color: globals.primaryTextColor),)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 0.3.sh,
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount:  snapshot.data.length,
                        itemBuilder: (context,index){
                          return BookCard(book: snapshot.data[index],);
                        },
                      ),
                    ),
                  ),
                ],
              );
            }
            else{
              return GFLoader();
            }
          },
        ),
        FutureBuilder(
          future: Book().getTopStories(),
          builder: (context,snapshot){
            if(snapshot.connectionState==ConnectionState.done){
              return Column(
                children: [
                  Container(
                    color: globals.primary,//HexColor('#ffebe7'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Top Stories',style: GoogleFonts.roboto(fontSize: 15.sp,color: Colors.white),),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>SeeAllScreen(Noveltype: "Top Stories",booksList: snapshot.data,)));
                              },

                              child: Text('See All',style: GoogleFonts.roboto(fontSize: 15,color: globals.primaryTextColor),)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 0.3.sh,
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context,index){
                          return BookCard(book: snapshot.data[index],);
                        },
                      ),
                    ),
                  ),
                ],
              );
            }
            else{
              return GFLoader();
            }
          },
        ),
        FutureBuilder(
          future: Book().getNewReleases(),
          builder: (context,snapshot){
            if(snapshot.connectionState==ConnectionState.done){
              return Column(
                children: [
                  Container(
                    color: globals.primary,//HexColor('#ffebe7'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('New Releases',style: GoogleFonts.roboto(fontSize: 15.sp,color: Colors.white),),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>SeeAllScreen(Noveltype: "New Releases",booksList: snapshot.data,)));
                              },
                              child: Text('See All',style: GoogleFonts.roboto(fontSize: 15,color: globals.primaryTextColor),)),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 0.3.sh,
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context,index){
                          return BookCard(book: snapshot.data[index],);
                        },
                      ),
                    ),
                  ),
                ],
              );
            }
            else{
              return GFLoader();
            }
          },
        ),
        FutureBuilder(
          future: Book().getTopRomance(),
          builder: (context,snapshot){
            if(snapshot.connectionState==ConnectionState.done) {
              return Column(
                children: [
                  Container(
                    color: globals.primary,//HexColor('#ffebe7'),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Top Romance',style: GoogleFonts.roboto(fontSize: 15.sp,color: Colors.white),),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>SeeAllScreen(Noveltype: "Top Romance",booksList: snapshot.data,)));
                              },
                              child: Text('See All',style: GoogleFonts.roboto(fontSize: 15,color: globals.primaryTextColor),)),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    height: 0.3.sh,
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return BookCard(book: snapshot.data[index],);
                        },
                      ),
                    ),
                  ),
                ],
              );
            }
            else{
              return GFLoader();
            }
          },
        ),
        FutureBuilder(
          future: Book().getBestWerewolf(),
          builder: (context,snapshot){
            if(snapshot.connectionState==ConnectionState.done){
              return Column(
                children: [
                  Container(
                    color: globals.primary,//HexColor('#ffebe7'),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Best werewolf',style: GoogleFonts.roboto(fontSize: 15.sp,color: Colors.white),),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>SeeAllScreen(Noveltype: "Best werewolf",booksList: snapshot.data,)));
                              },
                              child: Text('See All',style: GoogleFonts.roboto(fontSize: 15,color: globals.primaryTextColor),)),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 0.3.sh,
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context,index){
                          return BookCard(book: snapshot.data[index],);
                        },
                      ),
                    ),
                  ),
                ],
              );
            }
            else{
              return GFLoader();
            }
          },
        ),
        FutureBuilder(
          future: Book().getNewAdult(),
          builder: (context,snapshot){
            if(snapshot.connectionState==ConnectionState.done) {
              return Column(
                children: [
                  Container(
                    color: globals.primary,//HexColor('#ffebe7'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('New Adult',style: GoogleFonts.roboto(fontSize: 15.sp,color: Colors.white),),
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>SeeAllScreen(Noveltype: "New Adult",booksList: snapshot.data,)));
                          },

                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('See All',style: GoogleFonts.roboto(fontSize: 15,color: globals.primaryTextColor),),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    height: 0.3.sh,
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return BookCard(book: snapshot.data[index],);
                        },
                      ),
                    ),
                  ),
                ],
              );
            }
            else{
              return GFLoader();
            }
          },
        ),
        FutureBuilder(
          future: Book().getBillionaire(),
          builder: (context,snapshot){
            if(snapshot.connectionState==ConnectionState.done) {
              return Column(
                children: [
                  Container(
                    color: globals.primary,//HexColor('#ffebe7'),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Billionaire',style: GoogleFonts.roboto(fontSize: 15.sp,color: Colors.white),),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>SeeAllScreen(Noveltype: "Billionaire",booksList:snapshot.data,)));
                              },
                              child: Text('See All',style: GoogleFonts.roboto(fontSize: 15,color: globals.primaryTextColor),)),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    height: 0.3.sh,
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return BookCard(book: snapshot.data[index],);
                        },
                      ),
                    ),
                  ),
                ],
              );
            }
            else{
              return GFLoader();
            }
          },
        ),
        FutureBuilder(
          future: Book().getLiterature(),
          builder: (context,snapshot){
            if(snapshot.connectionState==ConnectionState.done) {
              return Column(
                children: [
                  Container(
                    color: globals.primary,//HexColor('#ffebe7'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Literature',style: GoogleFonts.roboto(fontSize: 15.sp,color: Colors.white),),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>SeeAllScreen(Noveltype: "Literature",booksList: snapshot.data,)));
                              },
                              child: Text('See All',style: GoogleFonts.roboto(fontSize: 15,color: globals.primaryTextColor),)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    height: 0.3.sh,
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return BookCard(book: snapshot.data[index],);
                        },
                      ),
                    ),
                  ),
                ],
              );
            }else return GFLoader();
          },
        ),
        FutureBuilder(
          future: Book().getHistorical(),
          builder: (context,snapshot){
            if(snapshot.connectionState==ConnectionState.done) {
              return Column(
                children: [
                  Container(
                    color: globals.primary,//HexColor('#ffebe7'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Historical Fiction',style: GoogleFonts.roboto(fontSize: 15.sp,color: Colors.white),),
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>SeeAllScreen(Noveltype: "Historical Fiction",booksList: snapshot.data,)));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('See All',style: GoogleFonts.roboto(fontSize: 15,color: globals.primaryTextColor),),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    height: 0.3.sh,
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return BookCard(book: snapshot.data[index],);
                        },
                      ),
                    ),
                  ),
                ],
              );
            }
            else return GFLoader();
          },
        ),
        SizedBox(height: 20,),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // if(widget.email!=null&&widget.pass!=null){
    //   loginuser();
    // }
    makeHomeWidget();
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(360, 690),
        orientation: Orientation.portrait);
    if(widget.email!=null&&widget.pass!=null){
      return Scaffold();
    }
    else{
      return Scaffold(
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipPath(
                  clipper: WaveClipperOne(),
                  child: Container(
                    height: 0.15.sh,
                    color: globals.primary,
                  ),
                ),
                Center(child: Column(
                  children: [
                    Image.asset(
                      'asset/logo.png', width: 0.3.sw, height: 0.2.sh,),
                    Text('Where your imaginations come to life',
                      style: TextStyle(fontWeight: FontWeight.bold,
                        color: HexColor('#D57E7E'),
                        fontSize: 15.0.sp,),),
                  ],
                )),
                Padding(
                  padding: EdgeInsets.fromLTRB(0.05.sw, 0.0, 0.0, 0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SizedBox(height: 0.04.sh,),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   children: [
                      //     Text('Welcome Back!',style: TextStyle(fontSize: 0.03.sh,fontWeight: FontWeight.bold),),
                      //     SizedBox(width: 0.15.sw,),
                      //   ],
                      // ),
                      SizedBox(height: 0.04.sh,),
                      Container(
                          width: 0.9.sw,
                          child: Material(
                            borderRadius: BorderRadius.circular(10.0),
                            elevation: 10.0,
                            shadowColor: globals.primary,
                            child: TextFormField(
                              obscureText: false,
                              enabled: emailEnabled,
                              autofocus: false,
                              controller: email,
                              decoration: InputDecoration(
                                icon: Padding(
                                  padding: EdgeInsets.all(0.01.sw),
                                  child: new Icon(
                                    CupertinoIcons.mail, color: globals.primary,
                                    size: 0.03.sh,),
                                ),
                                labelText: 'E-mail',
                                fillColor: Colors.transparent,
                                filled: true,
                                contentPadding: EdgeInsets.fromLTRB(
                                    20.0, 10.0, 20.0, 10.0),
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                              ),
                            ),
                          )
                      ),
                      SizedBox(height: 0.02.sh,),
                      Container(
                          width: 0.9.sw,
                          child: Material(
                            borderRadius: BorderRadius.circular(10.0),
                            elevation: 10.0,
                            shadowColor: globals.primary,
                            child: TextFormField(
                              controller: password,
                              obscureText: !hidePass,
                              autofocus: false,
                              decoration: InputDecoration(
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      hidePass = !hidePass;
                                    });
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(0.01.sw),
                                    child: new Icon(
                                      hidePass == false ? CupertinoIcons
                                          .eye_slash : CupertinoIcons.eye,
                                      color: globals.primary, size: 0.03.sh,),
                                  ),
                                ),
                                icon: Padding(
                                  padding: EdgeInsets.all(0.01.sw),
                                  child: Icon(
                                    CupertinoIcons.lock, color: globals.primary,
                                    size: 0.03.sh,),
                                ),
                                labelText: showOtpSection == true
                                    ? 'New Password'
                                    : 'Password',
                                fillColor: Colors.transparent,
                                filled: true,
                                contentPadding: EdgeInsets.fromLTRB(
                                    20.0, 10.0, 20.0, 10.0),
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                              ),
                            ),
                          )
                      ),
                      SizedBox(height: 0.02.sh,),
                      showOtpSection == true ?
                      Container(
                          width: 0.9.sw,
                          child: Material(
                            borderRadius: BorderRadius.circular(10.0),
                            elevation: 10.0,
                            shadowColor: globals.primary,
                            child: TextFormField(
                              controller: otp,
                              obscureText: false,
                              autofocus: false,
                              decoration: InputDecoration(
                                icon: Padding(
                                  padding: EdgeInsets.all(0.01.sw),
                                  child: Icon(
                                    CupertinoIcons.time, color: globals.primary,
                                    size: 0.03.sh,),
                                ),
                                labelText: 'Enter code we just sent you',
                                fillColor: Colors.transparent,
                                filled: true,
                                contentPadding: EdgeInsets.fromLTRB(
                                    20.0, 10.0, 20.0, 10.0),
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                              ),
                            ),
                          )
                      ) :
                      Container(),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      onPressed: () async {
                        if (showOtpSection == false) {
                          final snackBar = SnackBar(
                            content: Text('Sending otp please wait.'),
                            action: SnackBarAction(
                              label: 'Ok',
                              onPressed: () {},
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          Auth auth = await Auth().forgetPassword(email.text);
                          if (auth.success == true) {
                            setState(() {
                              emailEnabled = false;
                              showOtpSection = true;
                              myAuth = auth;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(auth.msg),
                              backgroundColor: Colors.green,
                              duration: Duration(seconds: 2),
                            ));
                          }
                          else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(auth.error),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 2),
                            ));
                          }
                        }
                        else {
                          setState(() {
                            emailEnabled = true;
                            showOtpSection = false;
                          });
                        }
                      },
                      child: Text(
                          showOtpSection != true ?
                          'Forget Password?' :
                          'Login'
                      ),
                    ),
                  ),
                ),
                Center(
                  child: GestureDetector(
                    onTap: () async {
                      if (showOtpSection == true) {
                        Auth auth = await Auth().updatePassword(
                            myAuth.iduser, myAuth.email, password.text,
                            otp.text);
                        if (auth.success == true) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(auth.message),
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 2),
                          ));
                          setState(() {
                            showOtpSection = false;
                            emailEnabled = true;
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(auth.error),
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 2),
                          ));
                        }
                      }
                      else {
                        loginuser();
                      }
                    },
                    child: Container(
                        width: 0.7.sw,
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(5.0, 3.0), //(x,y)
                                blurRadius: 5.0,
                              ),
                            ],
                            color: globals.primary,
                            borderRadius: BorderRadius.circular(0.01.sh)
                        ),
                        child: Center(child: Text(
                          showOtpSection != true ? 'Login' : 'Change Password',
                          style: TextStyle(color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold),))
                    ),
                  ),
                ),
                showOtpSection != true ?
                Container(
                  child: Column(
                    children: [
                      SizedBox(height: 0.02.sh,),
                      Center(child: Text('Or')),
                      SizedBox(height: 0.02.sh,),
                      Center(
                        child: GestureDetector(
                          onTap: () async {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => SignupScreen()));
                          },
                          child: Container(
                              width: 0.7.sw,
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(5.0, 3.0), //(x,y)
                                      blurRadius: 5.0,
                                    ),
                                  ],
                                  color: globals.primary,
                                  borderRadius: BorderRadius.circular(0.01.sh)
                              ),
                              child: Center(child: Text('Signup',
                                style: TextStyle(color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold),))
                          ),
                        ),
                      ),
                    ],
                  ),
                ) : Container(),
              ],
            ),
          ),
        ),
      );
    }
  }
}
