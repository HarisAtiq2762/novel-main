// To parse this JSON data, do
//
//     final announcement = announcementFromJson(jsonString);

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:novel/globals.dart' as globals;
Announcement announcementFromJson(String str) => Announcement.fromJson(json.decode(str));

String announcementToJson(Announcement data) => json.encode(data.toJson());

class Announcement {
  Announcement({
    this.announcement,
    this.id,
    this.timestamp,
    this.userId,
  });

  String announcement;
  int id;
  String timestamp;
  int userId;

  factory Announcement.fromJson(Map<String, dynamic> json) => Announcement(
    announcement: json["announcement"],
    id: json["id"],
    timestamp: json["timestamp"],
    userId: json["user_id"],
  );

  Map<String, dynamic> toJson() => {
    "announcement": announcement,
    "id": id,
    "timestamp": timestamp,
    "user_id": userId,
  };

  Future makeAnnoucement(String ann)async{
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(globals.baseUrl+'announcement_add_api'));
    request.body = json.encode({
      "user_id": globals.logedInUser.userId,
      "announcement": ann
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
  Future getAnnouncements(int id)async{
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(globals.baseUrl+'announcement_api'));
    request.body = json.encode({
      "user_id": id
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      dynamic data = await response.stream.bytesToString();
      data = jsonDecode(data);
      List announcements=[];
      for(var ann in data['data']){
        announcements.add(Announcement.fromJson(ann));
      }
      return announcements;
    }
    else {
      print(response.reasonPhrase);
    }
  }

  Future deleteAnnouncement(int id)async{
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(globals.baseUrl+'announcement_delete_api'));
    request.body = json.encode({
      "id": id
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return (await response.stream.bytesToString());
    }
    else {
      print(response.reasonPhrase);
    }
  }
}
