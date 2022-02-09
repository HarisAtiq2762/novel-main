import 'dart:convert';
import 'package:novel/globals.dart' as globals;
import 'package:http/http.dart' as http;
class Like {
  Like({
    this.image,
    this.name,
    this.userId,
  });

  String image;
  String name;
  int userId;

  Future likeOrDislikeComment(int commentId)async{
    var headers = {
      'Content-Transfer-Encoding': 'multipart/form-data',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(globals.baseUrl+'comment_like_dislike_api'));
    request.body = json.encode({
      "comment_id": commentId,
      "user_id": globals.logedInUser.userId
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    }
    else {
      print(response.reasonPhrase);
    }
  }
  Future getLikerList(int commentId)async{
    var headers = {
      'Content-Transfer-Encoding': 'multipart/form-data',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(globals.baseUrl+'likes_user_profile_list'));
    request.body = json.encode({
      "comment_id": commentId
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    }
    else {
      print(response.reasonPhrase);
    }
  }
}