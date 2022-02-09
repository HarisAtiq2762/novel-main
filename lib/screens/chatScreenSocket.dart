import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getwidget/components/button/gf_icon_button.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:novel/globals.dart' as globals;
import 'package:novel/models/message.dart';
import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;



List allMessages=[];
IO.Socket socket = IO.io(globals.baseUrl, IO.OptionBuilder().setTransports(['websocket']).build());
class BuildWithSocketStream extends StatefulWidget {
  final String roomName;
  List pastMessages;
  BuildWithSocketStream({@required this.roomName,@required this.pastMessages});
  final TextEditingController _msg = TextEditingController();
  @override
  _BuildWithSocketStreamState createState() => _BuildWithSocketStreamState();
}

class _BuildWithSocketStreamState extends State<BuildWithSocketStream> {
  final socketResponse= StreamController();
  Stream get getResponse {
    return socketResponse.stream;
  }
  ScrollController _scrollController = new ScrollController();
  void sendMessage(String userName,String roomName,String msg,int userId){
    socket.emit(
        'my event',{
      "user_name": userId,
      "message": msg,
      "roomname": roomName,
      "userid": userId
    });
    print('message sent!');

  }

  @override
  void initState() {
    super.initState();
    socket.onConnect((_) {
      print('connect');
      socket.emit(
          'my event',{
        "user_name": globals.logedInUser.name,
        "message": 'connected',
        "time":DateTime.now().hour.toString()+':'+DateTime.now().minute.toString(),
        "roomname": widget.roomName,
        "userid": globals.logedInUser.userId
      }
      );
    });
    socket.on('my response', (data) {
      print('samn wale ka msg');
      var dataRes = {
        'user_name': data['username'],
        'message': data['message'],
        "time":DateTime.now().hour.toString()+':'+DateTime.now().minute.toString(),
        'roomname': data['roomname'],
        'status': data['userid'],
      };
      if(allMessages.contains(dataRes)){
        print('in if');
        return socketResponse.sink.add(dataRes);
      }
      else{
        print('in else');
        // print(dataRes);
        allMessages.add(Message().messageFromJson(jsonEncode(dataRes)));
        // allMessages.add(dataRes);
        return socketResponse.sink.add(dataRes);
      }
    });
  }
  @override
  void dispose() {
    socketResponse.close();
    socket.off('my event');
    socket.off('my response');
    super.dispose();
  }

  bool isScrolled=false;
  @override
  Widget build(BuildContext context) {
    allMessages = widget.pastMessages;
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(360, 690),
        orientation: Orientation.portrait);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          title: Text('Conversation',style: TextStyle(color: Colors.black),),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              socketResponse.close();
              socket.off('my event');
              socket.off('my response');
              Navigator.pop(context);
            },
          ),
        ),
        body: StreamBuilder(
            stream: getResponse,
            builder: (context,snapshot){
              return ListView(
                scrollDirection: Axis.vertical,
                physics: BouncingScrollPhysics(),
                children: [
                  widget.pastMessages!=null?
                  Container(
                    height: 0.7.sh,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: widget.pastMessages.length,
                      shrinkWrap: true,
                      // reverse: true,
                      controller: _scrollController,
                      padding: EdgeInsets.only(top: 10,bottom: 10),
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index){
                        globals.allMessages = widget.pastMessages;
                        if(isScrolled==false){
                          SchedulerBinding.instance?.addPostFrameCallback((_) {
                            _scrollController.animateTo(
                                _scrollController.position.maxScrollExtent,
                                duration: Duration(milliseconds: 50),
                                curve: Curves.fastOutSlowIn);
                          });
                          isScrolled=true;
                        }
                        return Container(
                          padding: EdgeInsets.only(left: 14,right: 14,top: 10,bottom: 10),
                          child: Align(
                            alignment: (globals.allMessages[index].status != globals.logedInUser.userId?Alignment.topLeft:Alignment.topRight),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: (globals.allMessages[index].status != globals.logedInUser.userId?HexColor('#F5F5F5'):globals.primary),
                              ),
                              padding: EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(globals.allMessages[index].message, style: TextStyle(fontSize: 15.sp,color: globals.allMessages[index].status == globals.logedInUser.userId?globals.primaryTextColor:Colors.black),softWrap: true,overflow: TextOverflow.clip,),
                                  SizedBox(height: 0.01.sh,),
                                  Text(globals.allMessages[index].time!=null?globals.allMessages[index].time.toString():'', style: TextStyle(fontSize: 10.sp,color: globals.allMessages[index].status == globals.logedInUser.userId?globals.primaryTextColor:Colors.black),)
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ):
                  Container(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: (MediaQuery.of(context).size.width/100)*85,
                        child: TextField(
                          keyboardType: TextInputType.multiline,
                          maxLines: 2,
                          controller: widget._msg,
                          decoration: InputDecoration(
                            hintText: 'Type a Message',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      GFIconButton(
                        color: globals.primary,
                        onPressed: ()async{
                          if(widget._msg.text!=''&&widget._msg.text!=' '){
                            sendMessage(globals.logedInUser.name,widget.roomName,widget._msg.text,globals.logedInUser.userId);
                            setState(() {
                              widget._msg.text='';
                            });
                            // await Future.delayed(const Duration(milliseconds: 300));
                            // SchedulerBinding.instance?.addPostFrameCallback((_) {
                            //   _scrollController.animateTo(
                            //       _scrollController.position.maxScrollExtent,
                            //       duration: Duration(milliseconds: 500),
                            //       curve: Curves.fastOutSlowIn);
                            // });
                          }
                        },
                        icon: Icon(Icons.send,),
                      )
                    ],
                  ),
                  SizedBox(height: 0.05.sh,)
                ],
              );
            })
    );
  }
}


