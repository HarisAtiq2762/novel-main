import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:http/http.dart' as http;
import 'package:novel/globals.dart' as globals;
class TermsOfUseScreen extends StatelessWidget {
  const TermsOfUseScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(360, 690),
        orientation: Orientation.portrait);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: globals.primary,
        title: Text('Terms Of Use',style: TextStyle(color: globals.primaryTextColor),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,color: globals.primaryTextColor,),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder(
        future: getPrivacyPolicy(),
        builder: (context,snapshot){
          if(snapshot.connectionState==ConnectionState.done){
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              itemBuilder: (context,index){
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(snapshot.data[index]['title'],style: TextStyle(fontSize: 20.sp,fontWeight: FontWeight.bold,color: Colors.black),),
                      SizedBox(height: 0.01.sh,),
                      Text(snapshot.data[index]['terms'],style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w300,color: Colors.black)),
                    ],
                  ),
                );
              },
            );
          }
          return GFLoader();
        },
      ),
    );
  }

  Future getPrivacyPolicy()async{
    var request = http.Request('GET', Uri.parse(globals.baseUrl+'terms_of_use_api'));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString())['data'];
    }
    else {
      print(response.reasonPhrase);
    }
  }
}
