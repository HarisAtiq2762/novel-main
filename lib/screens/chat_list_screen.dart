import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:novel/globals.dart' as globals;
import 'package:novel/models/chat.dart';
import 'package:novel/models/user.dart';
import 'package:http/http.dart' as http;
import 'chatScreenSocket.dart';
class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key key}) : super(key: key);

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  Widget build(BuildContext context) {
    final styleOfTexts = GoogleFonts.roboto(color: globals.primaryTextColor,fontSize: 18.sp);
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(360, 690),
        orientation: Orientation.portrait);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: globals.primary,
        title: Text('Chats',style: styleOfTexts,),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,color: globals.primaryTextColor,),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        child: FutureBuilder(
          future: Chat(messages: []).createRoom('0'),
          builder: (context,messages){
            // print(messages.data['data']);
            // return Container();
            return ListView.builder(
              itemCount: messages.data['data'].length,
              itemBuilder: (context,index){
                return Column(
                  children: [
                    FutureBuilder(
                      future: User().getUserDetails(messages.data['data'][index]['user_id']),
                      builder: (context,snapshot){
                        User user = snapshot.data;
                        // List msg = (messages.data['data'][index]['messages'].toString().split('&&')[messages.data['data'][index]['messages'].toString().split('&&').length-1]).split(',');
                        if(snapshot.connectionState==ConnectionState.done){
                          return GestureDetector(
                            onTap: () async {
                              var messageHistory = await Chat(messages: []).getAllChatFromUser(messages.data['data'][index]['user_id'].toString());
                              dynamic data = await Chat(messages: []).createRoom(messages.data['data'][index]['user_id'].toString());
                              // print(messageHistory);
                              // print(data['roomname']);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          BuildWithSocketStream(
                                            pastMessages: messageHistory,
                                            roomName: data['roomname'] != null
                                                ? data['roomname']
                                                : '',
                                          )));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 1.0.sw,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 0.04.sh,
                                      backgroundImage: NetworkImage(user.image),
                                    ),
                                    SizedBox(
                                      width: 0.05.sw,
                                    ),
                                    Container(
                                      width: 0.3.sw,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            user.name,
                                            style: GoogleFonts.roboto(
                                                color: Colors.black,
                                                fontSize: 15.sp),
                                          ),
                                          // SizedBox(
                                          //   height: 0.01.sh,
                                          // ),
                                          // Text(msg.toString() != '[null]'
                                          //     ? msg[1]
                                          //         .toString()
                                          //         .split(':')[1]
                                          //         .replaceAll('\'', '')
                                          //     : ''),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 0.3.sw,
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete), onPressed: ()async{
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        content: Text('deleting chat please wait'),
                                        duration: Duration(milliseconds: 2000),
                                      ));
                                        dynamic data = await deleteChat(messages.data['data'][index]['user_id']);
                                        data = jsonDecode(data);
                                        print(data);
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content: Text(data['msg']),
                                          duration: Duration(milliseconds: 3000),
                                        ));
                                        setState(() {});
                                      }
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                        else{
                          return GFLoader();
                        }
                      },
                    ),
                    Divider(thickness: 2.0,indent: 20.0,endIndent: 20.0,color: globals.primary,),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future deleteChat(int id)async{
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('https://novel.vidseries.com/chat_delete_api'));
    request.body = json.encode({
      "userid1": globals.logedInUser.userId,
      "userid2": id
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return await response.stream.bytesToString();
    }
    else {
      print(response.reasonPhrase);
    }
  }
}
