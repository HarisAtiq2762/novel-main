import 'dart:convert';
import 'package:novel/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
class Auth{

  Auth({
    this.email,
    this.iduser,
    this.msg,
    this.name,
    this.success,
    this.error,
    this.message
  });

  String email;
  int iduser;
  String msg;
  String name;
  bool success;
  String error;
  String message;

  Auth authFromJson(String str) => Auth.fromJson(json.decode(str));

  factory Auth.fromJson(Map<String, dynamic> json) => Auth(
    email: json["email"],
    iduser: json["iduser"],
    msg: json["msg"],
    name: json["name"],
    success: json["success"],
    error: json["error"],
    message: json["message"]
  );

  Future forgetPassword(String email)async{
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(globals.baseUrl+'forgot-password-api'));
    request.body = json.encode({
      "email": email
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      dynamic data = await response.stream.bytesToString();
      Auth auth = authFromJson(data);
      return auth;
    }
    else {
      print(response.reasonPhrase);
    }
  }

  Future updatePassword(int userId,String email,String password,String code)async{
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(globals.baseUrl+'update-password-api'));
    request.body = json.encode({
      "user_id": userId,
      "email": email,
      "password": password,
      "code": code
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      dynamic data = await response.stream.bytesToString();
      print(data);
      Auth auth = authFromJson(data);
      return auth;

    }
    else {
      print(response.reasonPhrase);
    }
  }

  void showLoadingModal(BuildContext context){
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            child: Lottie.asset('asset/loading.json')
        );
      },
    );
  }

  void showLoadingModal2(BuildContext context){
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            child: Lottie.asset('asset/homeLoading.json')
        );
      },
    );
  }
}