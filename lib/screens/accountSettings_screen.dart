import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:novel/globals.dart' as globals;
import 'package:novel/models/user.dart';
import 'package:novel/screens/AuthScreens/login.dart';
import 'package:novel/widgets/bottomNavbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
class AccountSettingScreen extends StatefulWidget {
  AccountSettingScreen({Key key}) : super(key: key);

  @override
  _AccountSettingScreenState createState() => _AccountSettingScreenState();
}

class _AccountSettingScreenState extends State<AccountSettingScreen> {
  Future _imgFromCamera() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
    setState(() {
      imageProfile = File(pickedFile.path);
    });
  }

  Future _imgFromGallery() async {
    final pickedFile =
    await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      imageProfile = File(pickedFile.path);
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext buildContext) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.photo_library_outlined),
                  title: Text('Photo Gallery'),
                  onTap: () {
                    _imgFromGallery();
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_camera_outlined),
                  title: Text('Camera'),
                  onTap: () {
                    _imgFromCamera();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }
  Future loginuser() async {
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(globals.baseUrl+'login_api'));
    request.body = json.encode({
      "email": globals.logedInUser.email,
      "password": globals.logedInUser.password,
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      dynamic data = await response.stream.bytesToString();
      data = jsonDecode(data);
      var success = data['success'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('UserDate', data['data'].toString());
      if(success == true)
      {
        User logedInUser = await User().getUserDetails(data['data']['user_id']);
        globals.logedInUser = logedInUser;
        setState(() {});
        // Navigator.push(context, MaterialPageRoute(builder: (context)=>MyBottomNavBar()));
      }
    }
    else {
      print(response.reasonPhrase);
    }

  }

  Future updateProfile()async{
    var headers = {
      'Content-Transfer-Encoding': 'multipart/form-data'
    };
    var request = http.MultipartRequest('POST', Uri.parse(globals.baseUrl+'user_profile_update_api'));
    request.fields.addAll({
      'name': globals.logedInUser.name,
      'birthday': globals.logedInUser.birthday.toString(),
      'email': globals.logedInUser.email,
      'password': globals.logedInUser.password,
      'phone_number': globals.logedInUser.phoneNumber,
      'bio': bio.text==''?globals.logedInUser.bio:bio.text,
      'user_id': globals.logedInUser.userId.toString()
    });
    if(imageProfile!=null){
      request.files.add(await http.MultipartFile.fromPath('image', imageProfile.path));
    }
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      dynamic data = await response.stream.bytesToString();
      data = jsonDecode(data);
      loginuser();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(data['msg']),
        backgroundColor: Colors.green,
        duration: Duration(milliseconds: 2500),
      ));
    }
    else {
    print(response.reasonPhrase);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bio.text = globals.logedInUser.bio;
  }

  @override
  Widget build(BuildContext context) {
    // print(globals.logedInUser.image);
    final styleOfTexts = GoogleFonts.roboto(color: globals.primaryTextColor,fontSize: 15.sp);
    // bio.text=globals.logedInUser.bio;
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(360, 690),
        orientation: Orientation.portrait);
    return Scaffold(
      backgroundColor: globals.darkBackgroud==true?Colors.white10:Colors.white,
      appBar: AppBar(
        backgroundColor: globals.primary,
        title: Text('Account Setting',style: GoogleFonts.roboto(color: globals.primaryTextColor,fontSize: 15.sp),),
        leading: IconButton(
          icon:Icon(Icons.arrow_back_ios,color: globals.primaryTextColor),
          color: Colors.black, onPressed: () { Navigator.pop(context); },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 0.02.sh,),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    child: GestureDetector(
                      onTap: () {
                        _showPicker(context);
                      },
                      child: CircleAvatar(
                        radius: 0.05.sh,
                        backgroundImage: imageProfile == null
                            ? NetworkImage(globals.logedInUser.image)
                            : Image.file(
                          imageProfile,
                          fit: BoxFit.cover,
                        ).image,
                      ),
                    ),
                  ),
                  Text(globals.logedInUser.name,style: GoogleFonts.roboto(color: Colors.black,fontSize: 15.sp),),
                ],
              ),
            ),
            Divider(thickness: 2.0,indent: 20.0,endIndent: 20.0,color: globals.primary,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: globals.primary,
                ),
                child: Text('  Bio   ',style: GoogleFonts.roboto(fontSize: 15.0.sp,fontWeight: FontWeight.w500,wordSpacing: 0.5,color: globals.primaryTextColor ),),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 8.0),
                  child: TextField(
                    maxLines: 6,
                    controller: bio,
                    maxLength: 200,
                    decoration: InputDecoration(
                      enabled: true,
                      hintStyle: GoogleFonts.roboto(fontSize: 15.0.sp,color: Colors.black),
                      hintText: globals.logedInUser.bio==''?'Lorem ipsum dolor sit amet consectetur adipisicing elit.'
                          'Maxime mollitia,molestiae quas vel sint commodi repudiandae consequuntur voluptatum '
                          'laborumnumquam blanditiis harum quisquam eius sed odit fugiat iusto fuga praesentiumoptio, '
                          'eaque rerum! Provident similique accusantium nemo autem.':globals.logedInUser.bio,
                    ),
                    style: GoogleFonts.roboto(fontSize: 15.0.sp),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GFButton(
                      color: globals.primary,
                      text: 'Update',
                      textStyle: GoogleFonts.roboto(color: globals.primaryTextColor),
                      onPressed: ()async{
                        updateProfile();
                      }
                      ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Account',style: GoogleFonts.roboto(color: Colors.black,fontSize: 15.sp),),
            ),
            Divider(thickness: 2.0,indent: 20.0,endIndent: 20.0,color: globals.primary,),
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.person,color:globals.primaryTextColor),
                                SizedBox(width: 0.05.sw,),
                                Text('User Name',style: styleOfTexts,),
                              ],
                            ),
                            Text(globals.logedInUser.name,style: styleOfTexts,),
                          ],
                        ))
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.lock,color:globals.primaryTextColor),
                                SizedBox(width: 0.05.sw,),
                                Text('Password',style: styleOfTexts,),
                              ],
                            ),
                            Text(globals.logedInUser.password,style: styleOfTexts,),
                          ],
                        ))
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.cake,color:globals.primaryTextColor),
                                SizedBox(width: 0.05.sw,),
                                Text('Birthday',style: styleOfTexts,),
                              ],
                            ),
                            Text(globals.logedInUser.birthday.day.toString()+'/'+globals.logedInUser.birthday.month.toString()+'/'+globals.logedInUser.birthday.year.toString(),style: styleOfTexts,),
                          ],
                        ))
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.email,color:globals.primaryTextColor),
                                SizedBox(width: 0.05.sw,),
                                Text('Email',style: styleOfTexts,),
                              ],
                            ),
                            Text(globals.logedInUser.email!=null?globals.logedInUser.email:'',style: styleOfTexts,),
                          ],
                        ))
                ),
              ),
            ),
            SizedBox(height: 0.050.sh,),
          ],
        ),
      ),
    );
  }

  TextEditingController bio = TextEditingController();

  File imageProfile;
}
