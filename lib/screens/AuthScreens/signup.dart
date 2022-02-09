import 'dart:convert';
import 'package:country_picker/country_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:novel/globals.dart' as globals;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:novel/models/auth.dart';
import 'package:novel/models/user.dart';
import 'package:novel/screens/AuthScreens/login.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import "package:http/http.dart" as http;
import 'package:novel/widgets/bottomNavbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  File imageProfile;
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

  TextEditingController name = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController pnum = new TextEditingController();
  TextEditingController rePassword = new TextEditingController();
  TextEditingController dateOfBirth = new TextEditingController();
  TextEditingController countryController = new TextEditingController();
  bool showPass=false;
  bool showRePass=false;
  bool success;
  var user;

  Future loginuser() async {
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(globals.baseUrl+'login_api'));
    request.body = json.encode({
      "email": email.text,
      "password": password.text,
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      dynamic data = await response.stream.bytesToString();
      data = jsonDecode(data);
      success = data['success'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('UserDate', data['data'].toString());
      if(success == true)
      {
        User logedInUser = await User().getUserDetails(data['data']["user_id"]);
        globals.logedInUser = logedInUser;
        print(logedInUser.name);
        Navigator.push(context, MaterialPageRoute(builder: (context)=>MyBottomNavBar()));
      }
    }
    else {
      print(response.reasonPhrase);
    }

  }


  Future createuser(String names, String email_address, String password, String roless) async {
    var request = http.MultipartRequest('POST', Uri.parse(globals.baseUrl+'signup_api'));
    request.fields.addAll({
      'name': name.text,
      'email': email.text,
      'password': password,
      'birthday': dateOfBirth.text,
      'phone_number': pnum.text,
      'country':countryController.text
    });


    if(imageProfile==null){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Profile picture can not be empty'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ));
    }
    else{
      Auth().showLoadingModal(context);
      request.files.add(await http.MultipartFile.fromPath('image',imageProfile.path));
      http.StreamedResponse response = await request.send();
      print(response.statusCode);
      if (response.statusCode == 200) {
        dynamic data = await response.stream.bytesToString();
        data = jsonDecode(data);
        print(data);
        if(data['success']==true){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(data['msg']),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ));
          loginuser();
        }
        else{
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(data['msg']),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ));
        }
      }
      else {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(response.reasonPhrase),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ));
      }
    }
  }

  DateTime selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900),
        lastDate: DateTime(2101)
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        String mon='';
        String day='';
        if(selectedDate.month<10){
          mon = '0'+selectedDate.month.toString();
        }
        else{
          mon = selectedDate.month.toString();
        }
        if(selectedDate.day<10){
          day = '0'+selectedDate.day.toString();
        }
        else{
          day = selectedDate.day.toString();
        }
        dateOfBirth.text = selectedDate.year.toString()+'-'+mon+'-'+day.toString();
      });
  }

  void showMyCountryPicker(){
    showCountryPicker(
      context: context,
      showPhoneCode: true, // optional. Shows phone code before the country name.
      onSelect: (Country country) {
        print('Select country: ${country.name}');
        countryController.text = country.name;
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(360, 690),
        orientation: Orientation.portrait);
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
              Padding(
                padding: EdgeInsets.fromLTRB(0.05.sw, 0.0, 0.0, 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 0.02.sh,),
                    GestureDetector(child: Icon(Icons.arrow_back,size: 0.03.sh,),onTap: (){Navigator.pop(context);},),
                    SizedBox(height: 0.02.sh,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Create Account',style: TextStyle(fontSize: 0.03.sh,fontWeight: FontWeight.bold),),
                        SizedBox(width: 0.15.sw,),
                        Container(
                          child: GestureDetector(
                            onTap: () {
                              _showPicker(context);
                            },
                            child: CircleAvatar(
                              radius: 0.05.sh,
                              backgroundImage: imageProfile == null
                                  ? AssetImage('asset/imagePicker.png')
                                  : Image.file(
                                imageProfile,
                                fit: BoxFit.cover,
                              ).image,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 0.04.sh,),
                    Container(
                        width: 0.9.sw,
                        child: Material(
                          borderRadius: BorderRadius.circular(10.0),
                          elevation: 10.0,
                          shadowColor: globals.primary,
                          child: TextFormField(
                            obscureText: false,
                            autofocus: false,
                            controller: name,
                            decoration: InputDecoration(
                              icon: Padding(
                                padding: EdgeInsets.all(0.01.sw),
                                child: new Icon(CupertinoIcons.person, color: globals.primary,size: 0.03.sh,),
                              ),
                              labelText: 'Name',
                              fillColor: Colors.transparent,
                              filled: true,
                              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
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
                            controller: email,
                            obscureText: false,
                            autofocus: false,
                            decoration: InputDecoration(
                                icon: Padding(
                                  padding: EdgeInsets.all(0.01.sw),
                                  child: new Icon(CupertinoIcons.mail, color: globals.primary,size: 0.03.sh,),
                                ),
                                labelText: 'Email',
                                fillColor: Colors.transparent,
                                filled: true,
                                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
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
                    // Container(
                    //     width: 0.9.sw,
                    //     child: Material(
                    //       borderRadius: BorderRadius.circular(10.0),
                    //       elevation: 10.0,
                    //       shadowColor: globals.primary,
                    //       child: TextFormField(
                    //         controller: pnum,
                    //         obscureText: false,
                    //         autofocus: false,
                    //         decoration: InputDecoration(
                    //             icon: Padding(
                    //               padding: EdgeInsets.all(0.01.sw),
                    //               child: new Icon(CupertinoIcons.phone, color: globals.primary,size: 0.03.sh,),
                    //             ),
                    //             labelText: 'Phone Number',
                    //             fillColor: Colors.transparent,
                    //             filled: true,
                    //             contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    //           border: InputBorder.none,
                    //           focusedBorder: InputBorder.none,
                    //           enabledBorder: InputBorder.none,
                    //           errorBorder: InputBorder.none,
                    //           disabledBorder: InputBorder.none,
                    //         ),
                    //       ),
                    //     )
                    // ),
                    // SizedBox(height: 0.02.sh,),
                    Container(
                        width: 0.9.sw,
                        child: Material(
                          borderRadius: BorderRadius.circular(10.0),
                          elevation: 10.0,
                          shadowColor: globals.primary,
                          child: TextFormField(
                            controller: password,
                            obscureText: showPass,
                            autofocus: false,
                            decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                onTap: (){
                                  setState(() {
                                    showPass=!showPass;
                                  });
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(0.01.sw),
                                  child: new Icon(showPass==true?CupertinoIcons.eye_slash:CupertinoIcons.eye, color: globals.primary,size: 0.03.sh,),
                                ),
                              ),
                                icon: Padding(
                                  padding: EdgeInsets.all(0.01.sw),
                                  child: new Icon(CupertinoIcons.lock, color: globals.primary,size: 0.03.sh,),
                                ),
                                labelText: 'Password',
                                fillColor: Colors.transparent,
                                filled: true,
                                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
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
                            controller: rePassword,
                            obscureText: showRePass,
                            autofocus: false,
                            decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                onTap: (){
                                  setState(() {
                                    showRePass=!showRePass;
                                  });
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(0.01.sw),
                                  child: new Icon(showRePass==true?CupertinoIcons.eye_slash:CupertinoIcons.eye, color: globals.primary,size: 0.03.sh,),
                                ),
                              ),
                              icon: Padding(
                                  padding: EdgeInsets.all(0.01.sw),
                                  child: new Icon(CupertinoIcons.lock, color: globals.primary,size: 0.03.sh,),
                                ),
                              labelText: 'Re-Password',
                              fillColor: Colors.transparent,
                              filled: false,
                              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                                // enabledBorder: InputBorder.none,
                                // enabledBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(100.0),
                                //     borderSide: BorderSide(color: Colors.transparent, width: 3.0))
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
                            controller: dateOfBirth,
                            obscureText: false,
                            autofocus: false,
                            enabled: true,
                            onChanged: (val){
                              _selectDate(context);
                            },
                            decoration: InputDecoration(
                              // suffixIcon: GestureDetector(
                              //   onTap: (){
                              //     _selectDate(context);
                              //   },
                              //   child: Padding(
                              //     padding: EdgeInsets.all(0.01.sw),
                              //     child: new Icon(CupertinoIcons.calendar_today, color: HexColor('#cc7471,size: 0.03.sh,),
                              //   ),
                              // ),
                              icon: GestureDetector(
                                onTap: (){
                                  _selectDate(context);
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(0.01.sw),
                                  child: new Icon(CupertinoIcons.calendar_today, color: globals.primary,size: 0.03.sh,),
                                ),
                              ),
                              labelText: 'Date Of Birth',
                              fillColor: Colors.transparent,
                              filled: false,
                              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              // enabledBorder: InputBorder.none,
                              // enabledBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(100.0),
                              //     borderSide: BorderSide(color: Colors.transparent, width: 3.0))
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
                            controller: countryController,
                            obscureText: false,
                            autofocus: false,
                            enabled: true,
                            onChanged: (val){
                              showMyCountryPicker();
                            },
                            decoration: InputDecoration(
                              icon: GestureDetector(
                                onTap: (){
                                  _selectDate(context);
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(0.01.sw),
                                  child: new Icon(Icons.flag_outlined, color: globals.primary,size: 0.03.sh,),
                                ),
                              ),
                              labelText: 'Country',
                              fillColor: Colors.transparent,
                              filled: false,
                              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                            ),
                          ),
                        )
                    ),
                    SizedBox(height: 0.05.sh,),

                  ],
                ),
              ),
              Center(
                child: GestureDetector(
                  onTap: (){
                    createuser(name.text, email.text, password.text, '01234567891');
                  },
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(5.0, -0.9), //(x,y)
                            blurRadius: 6.0,
                          ),
                        ],
                      color: globals.primary,
                      borderRadius: BorderRadius.circular(0.01.sh)
                    ),
                    child: Text('Register',style: TextStyle(color: Colors.white,fontSize: 16.sp,fontWeight: FontWeight.bold),)
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

