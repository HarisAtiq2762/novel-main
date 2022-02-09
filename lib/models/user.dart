import 'dart:convert';
import 'package:novel/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class User {
  User({
    this.totalBooks,
    this.balance,
    this.bio,
    this.birthday,
    this.credit,
    this.email,
    this.followers,
    this.following,
    this.image,
    this.name,
    this.password,
    this.phoneNumber,
    this.points,
    this.rating,
    this.timestamp,
    this.userId,
    this.userInactive,
  });
  int totalBooks;
  int balance;
  String bio;
  DateTime birthday;
  int credit;
  String email;
  int followers;
  int following;
  String image;
  String name;
  String password;
  String phoneNumber;
  int points;
  int rating;
  String timestamp;
  int userId;
  String userInactive;

  Future getUserDetails(int userId)async{
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(globals.baseUrl+'user_profile_api'));
    request.body = json.encode({
      "user_id": userId
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      dynamic data = await response.stream.bytesToString();
      data = jsonDecode(data);
      // prefs.setInt('balance', data['user_data']["balance"]);
      // prefs.setString('bio', data['user_data']["bio"]);
      // prefs.setString('birthday', data['user_data']['birthday']);
      // prefs.setInt('credit', data['user_data']['credit']);
      // prefs.setString('email', data['user_data']['email']);
      // prefs.setInt('followers', data['user_data']['followers']);
      // prefs.setInt('following', data['user_data']['following']);
      // prefs.setString('image', globals.baseUrl+'static/images/user_profile/'+data['user_data']["image"]);
      // prefs.setString('name', data['user_data']['name']);
      // prefs.setString('password', data['user_data']['password']);
      // prefs.setString('phone_number', data['user_data']['phone_number']);
      // prefs.setInt('points', data['user_data']['points']);
      // prefs.setInt('rating', data['user_data']['rating']);
      // prefs.setString('timestamp', data['user_data']['timestamp']);
      // prefs.setInt('userId', userId);
      // prefs.setInt('user_inactive', data['user_data']["user_inactive"]);
      // prefs.setInt('total_books', data['user_data']["total_books"]);

      return User(
        balance: data['user_data']["balance"],
        bio: data['user_data']["bio"],
        birthday: DateTime.parse(data['user_data']['birthday']),
        credit: data['user_data']["credit"],
        email: data['user_data']["email"],
        followers: data['user_data']["followers"],
        following: data['user_data']["following"],
        image: globals.baseUrl+'static/images/user_profile/'+data['user_data']["image"],
        name: data['user_data']["name"],
        password: data['user_data']["password"],
        phoneNumber: data['user_data']["phone_number"],
        points: data['user_data']["points"],
        rating: data['user_data']["rating"],
        timestamp: data['user_data']["timestamp"],
        userId: userId,
        userInactive: data['user_data']["user_inactive"],
        totalBooks: data['user_data']["total_books"],
      );
    }
    else {
      print(response.reasonPhrase);
    }
  }

  Future getFollowingList(int userId)async{
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(globals.baseUrl+'following_list'));
    request.body = json.encode({
      "following_id": userId
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      dynamic data = await response.stream.bytesToString();
      data = jsonDecode(data);
      List followings = [];
      for(var user in data['user_following']){
        followings.add(User(
            userId: user['user_id'],
            name: user['name'],
            image: globals.baseUrl+'static/images/user_profile/'+user['image']
        ));
      }
      return followings;
    }
    else {
      print(response.reasonPhrase);
    }
  }

  Future getFollowersList(int userId)async{
    // print(userId);
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(globals.baseUrl+'followers_list'));
    request.body = json.encode({
      "follower_id": userId
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      dynamic data = await response.stream.bytesToString();
      data = jsonDecode(data);
      List followings = [];
      for(var user in data['user_followers']){
        followings.add(User(
            userId: user['user_id'],
            name: user['name'],
            image: globals.baseUrl+'static/images/user_profile/'+user['image']
        ));
      }
      return followings;
    }
    else {
      print(response.reasonPhrase);
    }
  }

  Future followUser(int followingId)async{
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(globals.baseUrl+'follow_api'));
    request.body = json.encode({
      "follower_id": globals.logedInUser.userId,
      "following_id": followingId
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // print(await response.stream.bytesToString());
    }
    else {
      print(response.reasonPhrase);
    }
  }

  Future unFollowUser(int followId)async{
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(globals.baseUrl+'unfollow_api'));
    request.body = json.encode({
      "following_id": followId,
      "follower_id": globals.logedInUser.userId,
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      // print(await response.stream.bytesToString());
    }
    else {
      print(response.reasonPhrase);
    }
  }


}