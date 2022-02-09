import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:novel/globals.dart' as globals;
Review ReviewFromJson(String str) => Review.fromJson(json.decode(str));

String ReviewToJson(Review data) => json.encode(data.toJson());

class Review extends ChangeNotifier{
  Review({
    this.bookId,
    this.chapterId,
    this.rating,
    this.ratingId,
    this.text,
    this.timestamp,
    this.userId,
  });

  int bookId;
  int chapterId;
  int rating;
  int ratingId;
  String text;
  String timestamp;
  int userId;

  factory Review.fromJson(Map<String, dynamic> json) => Review(
    bookId: json["book_id"],
    chapterId: json["chapter_id"],
    rating: json["rating"],
    ratingId: json["rating_id"],
    text: json["text"],
    timestamp: json["timestamp"],
    userId: json["user_id"],
  );

  Map<String, dynamic> toJson() => {
    "book_id": bookId,
    "chapter_id": chapterId,
    "rating": rating,
    "rating_id": ratingId,
    "text": text,
    "timestamp": timestamp,
    "user_id": userId,
  };

  Future deleteReview(int bookId)async{
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('https://novel.vidseries.com/delete_book_reviews_api'));
    request.body = json.encode({
      "book_id": bookId,
      "user_id": globals.logedInUser.userId
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      notifyListeners();
    }
    else {
      print(response.reasonPhrase);
    }
  }

}
