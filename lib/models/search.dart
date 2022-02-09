import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:novel/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:novel/models/auth.dart';
import 'package:novel/models/user.dart';
import 'book.dart';
class Search {
  Search({
    this.data,
    this.genre,
    this.peoples,
    this.success,
  });

  List data;
  List genre;
  List peoples;
  bool success;

  Future getSearchResult(String keyword,BuildContext context)async{
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(globals.baseUrl+'search-api'));
    request.body = json.encode({
      "keyword": keyword
    });
    request.headers.addAll(headers);
    // Auth().showLoadingModal2(context);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      dynamic data = await response.stream.bytesToString();
      data = jsonDecode(data);
      var success = data['success'];
      if(success == true)
      {
        List userBooks=[];
        for(var book in data['data']){
          userBooks.add(await Book().getBookDetails(book['book_id']));
        }
        List genreList = [];
        for(var genre in data['genre']){
          genreList.add(await Book().getBookDetails(genre['book_id']));
        }
        List peopleList = [];
        for(var people in data['peoples']){
          peopleList.add(await User().getUserDetails(people['user_id']));
        }
        return Search(data: userBooks,genre: genreList,peoples: peopleList);
      }
    }
    else {
      print(response.reasonPhrase);
    }
  }

  Future searchBookByGenre(String genre)async{
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(globals.baseUrl+'genre_search_api'));
    request.body = json.encode({
      "genre": genre
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      dynamic data = await response.stream.bytesToString();
      data = jsonDecode(data);
      // print(data);
      var success = data['success'];
      if(success == true)
      {
        List userBooks=[];
        for(var book in data['data']){
          userBooks.add(await Book().getBookDetails(book['book_id']));
        }
        return userBooks;
      }
    }
    else {
      print(response.reasonPhrase);
    }
  }

  Future getTopTags()async{
    var request = http.Request('GET', Uri.parse(globals.baseUrl+'top_tags_api'));


    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      dynamic data = await response.stream.bytesToString();
      data = jsonDecode(data);
      if(data['success']==true){
        return data['top_tags'];
      }
    }
    else {
      print(response.reasonPhrase);
    }
  }

  Future getTagSearchResults(String tag)async{
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(globals.baseUrl+'/tag_search_api'));
    request.body = json.encode({
      "tag": tag
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      dynamic data = await response.stream.bytesToString();
      data = jsonDecode(data);
      var success = data['success'];
      if(success == true)
      {
        List userBooks=[];
        for(var book in data['data']){
          userBooks.add(await Book().getBookDetails(book['book_id']));
        }
        return userBooks;
      }
    }
    else {
      print(response.reasonPhrase);
    }
  }

  Future saveHistory(String keyword,BuildContext context)async{
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(globals.baseUrl+'/search_history_api'));
    request.body = json.encode({
      "user_id": globals.logedInUser.userId,
      "keyword": keyword
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

  Future getHistory()async{
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(globals.baseUrl+'search_history_result_api'));
    request.body = json.encode({
      "user_id": globals.logedInUser.userId,
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      dynamic data = await response.stream.bytesToString();
      data = jsonDecode(data);
      // print(data);
      return data['data'];
    }
    else {
      print(response.reasonPhrase);
    }
  }

}