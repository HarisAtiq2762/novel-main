import 'package:novel/globals.dart' as globals;
import 'package:novel/models/message.dart';
import 'package:novel/screens/chatScreenSocket.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
class Chat{
  String id;
  String lastMessageCount;
  String lastMessageTime;
  List messages;
  String roomName;
  String userOneId;
  String userTwoId;
  String userOneName;
  String userTwoName;

  Chat({
    this.id='',
    @required this.messages,
    this.lastMessageCount='',
    this.lastMessageTime='',
    this.roomName='',
    this.userOneId='',
    this.userOneName='',
    this.userTwoId='',
    this.userTwoName=''
  });
  // dynamic getAllChat() async {
  //   String userId = globals.logedInUser.userId.toString();
  //   String userName = globals.logedInUser.name;
  //   var url = Uri.parse(globals.baseUrl+'chat-api?username=$userName&userid=$userId');
  //   var response = await http.get(url,headers: {"Content-Type": "application/json"});
  //   var res = jsonDecode(response.body);
  //   //print(res['data']);
  //   List allChatsList=[];
  //   res['data'].forEach((chat){
  //     Chat chatData = Chat(
  //         id: chat['_id'],
  //         messages: chat['messages'],
  //         lastMessageCount: chat['lastmessagecount'].toString(),
  //         lastMessageTime: chat['lastmessagetime'],
  //         roomName: chat['roomname'],
  //         userOneId: chat['user1'],
  //         userOneName: chat['user1name'],
  //         userTwoId: chat['user2'],
  //         userTwoName: chat['user2name']
  //     );
  //     allChatsList.add(chatData);
  //   });
  //   return allChatsList;
  // }
  dynamic getAllChatFromUser(String user2id) async {
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(globals.baseUrl+'getmessages'));
    request.body = json.encode({
      "userid1": globals.logedInUser.userId,
      "userid2": user2id
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      List messages=[];
      dynamic data = await response.stream.bytesToString();

      if(jsonDecode(data)['messages'][0]!=null){
        if (jsonDecode(data)['success'] == true) {
          for (var message in jsonDecode(data)['messages']) {
            messages.add(Message().messageFromJson(jsonEncode(message)));
          }
          return messages;
        } else {
          return messages;
        }
      }
      else{
        return messages;
      }
    }
    else {
      print(response.reasonPhrase);
    }
  }
  Future createRoom(String user2id)async{
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(globals.baseUrl+'chatting'));
    request.body = json.encode({
      "userid1": globals.logedInUser.userId,
      "userid2": user2id
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      dynamic data = await response.stream.bytesToString();
      data = jsonDecode(data);
      // print(data);
      return data;
    }
    else {
      print(response.reasonPhrase);
    }
  }

  Future getAllMessage()async{
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(globals.baseUrl+'all-messages'));
    request.body = json.encode({
      "userid1": globals.logedInUser.userId,
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      dynamic data = await response.stream.bytesToString();
      data = jsonDecode(data);
      return data['data'];
    }
    else {
      print(response.reasonPhrase);
    }
  }

}