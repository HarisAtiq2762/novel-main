import 'dart:convert';

class Message {
  Message({
    this.message,
    this.status,
    this.time,
    this.type,
  });

  String message;
  int status;
  String time;
  String type;

  Message messageFromJson(String str) => Message.fromJson(json.decode(str));

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    message: json["message"],
    status: json["status"],
    time: json["time"],
    type: json["type"],
  );
}