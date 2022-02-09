import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:novel/globals.dart' as globals;
import 'package:http/http.dart' as http;
class ContactUsScreen extends StatefulWidget {
  ContactUsScreen({Key key}) : super(key: key);

  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  TextEditingController email = new TextEditingController();

  TextEditingController msg = new TextEditingController();

  TextEditingController name = new TextEditingController();

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
              Center(child: Row(
                children: [
                  IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: (){Navigator.pop(context);}),
                  Text('Contact Us',style: TextStyle(fontWeight: FontWeight.bold,
                    color: HexColor('#D57E7E'),
                    fontSize: 15.0.sp,),),
                ],
              )),
              Padding(
                padding: EdgeInsets.fromLTRB(0.05.sw, 0.0, 0.0, 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 0.04.sh,),
                    Container(
                        width: 0.9.sw,
                        child: Material(
                          borderRadius: BorderRadius.circular(10.0),
                          elevation: 10.0,
                          shadowColor: globals.primary,
                          child: TextFormField(
                            obscureText: false,
                            enabled: true,
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
                            obscureText: false,
                            enabled: true,
                            autofocus: false,
                            controller: email,
                            decoration: InputDecoration(
                              icon: Padding(
                                padding: EdgeInsets.all(0.01.sw),
                                child: new Icon(CupertinoIcons.mail, color: globals.primary,size: 0.03.sh,),
                              ),
                              labelText: 'E-mail',
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
                            controller: msg,
                            obscureText: false,
                            autofocus: false,
                            maxLines: 10,
                            decoration: InputDecoration(
                              hintText: 'Message',
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
                  ],
                ),
              ),
              Center(
                child: GestureDetector(
                  onTap: ()async{
                    var headers = {
                      'Content-Type': 'application/json'
                    };
                    var request = http.Request('POST', Uri.parse(globals.baseUrl+'contactus'));
                    request.body = json.encode({
                      "name": name.text,
                      "email": email.text,
                      "msg": msg.text
                    });
                    request.headers.addAll(headers);

                    http.StreamedResponse response = await request.send();

                    if (response.statusCode == 200) {
                      dynamic data = await response.stream.bytesToString();
                      data = jsonDecode(data);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(data['msg']),
                        duration: Duration(milliseconds: 2500),
                      ));
                    }
                    else {
                      print(response.reasonPhrase);
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
                      child: Center(child: Text('Send Message',style: TextStyle(color: Colors.white,fontSize: 16.sp,fontWeight: FontWeight.bold),))
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
