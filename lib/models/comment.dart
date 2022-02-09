import 'dart:convert';
import 'package:novel/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:novel/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Comment {
  Comment({
    this.comment,
    this.commentId,
    this.timestamp,
    this.userId,
    this.userimage,
    this.name,
    this.replyId
  });

  String comment;
  int commentId;
  String timestamp;
  int userId;
  String userimage;
  String name;
  int replyId;

  //getting message board
  Future getProfileComments(int id)async{
    // print(globals.logedInUser.userId);
    var headers = {
      'Content-Transfer-Encoding': 'multipart/form-data',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(globals.baseUrl+'user_profile_api'));
    request.body = json.encode({
      "user_id": id
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      dynamic data = await response.stream.bytesToString();
      data = jsonDecode(data);
      var success = data['success'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('UserData', data['user_data'].toString());
      if(success == true)
      {
        List profileComments=[];
        for(var comment in data['comments_data']){
          profileComments.add(Comment(
            name: comment['username'],
            comment: comment["comment"],
            commentId: comment["comment_id"],
            timestamp: comment["timestamp"],
            userId: comment["user_id"],
            userimage: globals.baseUrl+'static/images/user_profile/'+comment["userimage"],
          ));
        }
        globals.profileComments = profileComments;
        return profileComments;
      }
    }
    else {
      print(response.reasonPhrase);
    }
  }


  //delete comment
  Future commentDelete(int id)async{
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(globals.baseUrl+'comments_delete_api'));
    request.body = json.encode({
      "comment_id": id,
      "commentator_id": globals.logedInUser.userId
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

  //delete reply
  Future replyDelete(int id)async{
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(globals.baseUrl+'reply_delete_api'));
    request.body = json.encode({
      "reply_id": id,
      "user_id": globals.logedInUser.userId
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

  //posting comments
  Future postComment(String comment,int id)async{
    var headers = {
      'Content-Transfer-Encoding': 'multipart/form-data',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(globals.baseUrl+'user_profile_comments_api'));
    request.body = json.encode({
      "comment": comment,
      "user_id": id,
      "commentator_id": globals.logedInUser.userId
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      dynamic data = await response.stream.bytesToString();
      return true;
    }
    else {
      print(response.reasonPhrase);
    }
  }

  //getting count of like and reply of every comment
  Future getCommentLikeAndReplyCount(int commentId)async{
    var headers = {
      'Content-Transfer-Encoding': 'multipart/form-data',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(globals.baseUrl+'comment_like_reply_api'));
    request.body = json.encode({
      "comment_id": commentId
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      return jsonDecode(data);
    }
    else {
      print(response.reasonPhrase);
    }
  }

  //replying a comment
  Future replyToAComment(String comment,int commentId)async{
    var headers = {
      'Content-Transfer-Encoding': 'multipart/form-data',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(globals.baseUrl+'reply_add_api'));
    request.body = json.encode({
      "user_id": globals.logedInUser.userId,
      "comment_id": commentId,
      "reply": comment
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

  //getting list of replies
  Future listOfReplies(int commentId)async{
    var headers = {
      'Content-Transfer-Encoding': 'multipart/form-data',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(globals.baseUrl+'reply_list_api'));
    request.body = json.encode({
      "comment_id": commentId
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      dynamic data = await response.stream.bytesToString();
      data = jsonDecode(data);
      var success = data['success'];
      List repliesOfAComment=[];
      if(success == true)
      {
        for(var comment in data['data']){
          repliesOfAComment.add(Comment(
            comment: comment["reply"],
            name: comment["name"],
            userId: comment["user_id"],
            userimage: globals.baseUrl+'static/images/user_profile/'+comment["image"],
            replyId: comment["reply_id"],
          ));
        }
        return repliesOfAComment;
      }
    }
    else {
      print(response.reasonPhrase);
    }
  }

  //getting comments of book
  Future postBookComment(String comment,int bookId,int userId)async{
    var headers = {
      'Content-Transfer-Encoding': 'multipart/form-data',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(globals.baseUrl+'book_comments_api'));
    request.body = json.encode({
      "comment": comment,
      "book_id": bookId,
      "commentator_id": userId
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

  //posting comment to a chapter
  Future postChapterComment(int chapterId,String comment)async{
    var headers = {
      'Content-Transfer-Encoding': 'multipart/form-data',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(globals.baseUrl+'chapter_comments_api'));
    request.body = json.encode({
      "comment": comment,
      "chapter_id": chapterId,
      "commentator_id": globals.logedInUser.userId
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

  //getting chapter comments
  Future getChapterComments(int chapterId)async{
    var headers = {
      'Content-Transfer-Encoding': 'multipart/form-data',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(globals.baseUrl+'chapters_api'));
    request.body = json.encode({
      "chapter_id": chapterId
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      dynamic data = await response.stream.bytesToString();
      // print(data);
      data = jsonDecode(data);
      // print(data['data']);
      // user=data['data'];
      var success = data['success'];
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // prefs.setString('UserDate', data['data'].toString());
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('UserData', data['user_data'].toString());
      // print(data['comment_data']);
      if(success == true)
      {
        // print(data);
        List profileComments=[];
        for(var comment in data['comment_data']){
          profileComments.add(Comment(
            name: comment['username'],
            comment: comment["comment"],
            commentId: comment["comment_id"],
            timestamp: comment["timestamp"],
            userId: comment["user_id"],
            userimage: globals.baseUrl+'static/images/user_profile/'+comment["userimage"],
          ));
        }
        return profileComments;
      }
    }
    else {
      print(response.reasonPhrase);
    }
  }

  //getting comment Liker List
  Future getCommentLikersList(int commentId)async{
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(globals.baseUrl+'/likes_user_profile_list'));
    request.body = json.encode({
      "comment_id": commentId
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      dynamic data = await response.stream.bytesToString();
      data = jsonDecode(data);
      List likers = [];
      for(var liker in data['data']){
        likers.add(User(
          image: globals.baseUrl+'static/images/user_profile/'+liker['image'],
          name: liker['name'],
          userId: liker['user_id'],
        ));
      }
      return likers;
    }
    else {
      print(response.reasonPhrase);
    }
  }

}