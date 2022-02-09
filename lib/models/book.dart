import 'dart:convert';
import 'dart:math';

import 'package:novel/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:novel/models/comment.dart';
import 'package:novel/models/review.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Book {
  final _count = 103;
  final _itemsPerPage = 5;
  int _currentPage = 0;

  Book({
    this.authorId,
    this.author,
    this.bookId,
    this.bookTitle,
    this.complete,
    this.copyrights,
    this.description,
    this.genre,
    this.image,
    this.mature,
    this.tags,
    this.rating,
    this.comments,
    this.chapterList,
    this.bookStatusActive,
    this.bookStatusPublish,
    this.totalViews,
    this.totalVotes
  });

  int totalViews;
  int totalVotes;
  String bookStatusPublish;
  String bookStatusActive;
  int authorId;
  String author;
  int bookId;
  String bookTitle;
  String complete;
  String copyrights;
  String description;
  String genre;
  String image;
  String mature;
  String tags;
  String rating;
  List<Comment> comments;
  List chapterList;

  Future getBooks(int id)async{
    var headers = {
      'Content-Transfer-Encoding': 'multipart/form-data',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(globals.baseUrl+'user_profile_api'));
    request.body = json.encode({
      "user_id": id.toString()
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      dynamic data = await response.stream.bytesToString();
      data = jsonDecode(data);
      // print(data);
      var success = data['success'];
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // prefs.setString('UserData', data['user_data'].toString());
      // print(data['user_data']);
      if(success == true)
      {
        List userBooks=[];
        for(var book in data['book_data']){
          userBooks.add(await getBookDetails(book['book_id']));
          // userBooks.add(Book(
          //   author: book["author"],
          //   bookId: book["book_id"],
          //   bookTitle: book["book_title"],
          //   complete: book["complete"],
          //   copyrights: book["copyrights"],
          //   description: book["description"],
          //   genre: book["genre"],
          //   mature: book["mature"],
          //   tags: book["tags"],
          //   image: globals.baseUrl+'static/images/books/'+book["image"],
          // ));
        }
        // globals.logedInUser.following = data['user_data']['following'];
        // globals.logedInUser.followers = data['user_data']['followers'];
        // globals.logedInUser.totalBooks = data['user_data']['total_books'];
        // print(userBooks);
        // print('returning');
        return userBooks;
      }
    }
    else {
      print(response.reasonPhrase);
    }
  }

  Future getBookDetails(int bookId)async{
    // print(bookId);
    var headers = {
      'Content-Transfer-Encoding': 'multipart/form-data',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(globals.baseUrl+'book_details_api'));
    request.body = json.encode({
      "book_id": bookId
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      dynamic data = await response.stream.bytesToString();
      data = jsonDecode(data);
      // print(data);
      Book book = Book(
          author: data['book_data'][0]["author"],
          bookId: data['book_data'][0]["book_id"],
          bookTitle: data['book_data'][0]["book_title"],
          complete: data['book_data'][0]["complete"],
          copyrights: data['book_data'][0]["copyrights"],
          description: data['book_data'][0]["description"],
          genre: data['book_data'][0]["genre"],
          mature: data['book_data'][0]["mature"],
          tags: data['book_data'][0]["tags"],
          image: globals.baseUrl+'static/images/books/'+data['book_data'][0]["image"],
          rating: data['rating_data'].toString(),
          comments: getComments(data['comments']),
          chapterList: data['chapters_list'],
          authorId: data['book_data'][0]["user_id"],
          bookStatusActive: data['book_data'][0]["book_inactive"],
          bookStatusPublish: data['book_data'][0]["publish_status"],
          totalViews: data['total_views'][0]['views'],
          totalVotes: data['total_votes'][0]['votes']
      );
      return book;
    }
    else {
      print(response.reasonPhrase);
    }
  }

  List<Comment> getComments(List data){
    // print(data.length);
    List<Comment> commentsOfBooks = [];
    for(var comment in data){
      // print(comment);
      commentsOfBooks.add(
        Comment(
          name: comment['username'],
          comment: comment['comment'],
          commentId: comment['comment_id'],
          timestamp: comment['timestamp'],
          userId: comment['user_id'],
          userimage: globals.baseUrl+'static/images/user_profile/'+comment['userimage'],
        )
      );
    }
    return commentsOfBooks;
  }

  Future addBookToLibrary(int bookId)async{
    var headers = {
      'Content-Transfer-Encoding': 'multipart/form-data',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(globals.baseUrl+'add_library_books_api'));
    request.body = json.encode({
      "book_id": bookId,
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

  Future getLibraryBooks()async{
    var headers = {
      'Content-Transfer-Encoding': 'multipart/form-data',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(globals.baseUrl+'library_books_api'));
    request.body = json.encode({
      "user_id": globals.logedInUser.userId
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      dynamic data = await response.stream.bytesToString();
      data = jsonDecode(data);
      var success = data['success'];
      if(success == true)
      {
        List userLibraryBooks=[];
        for(var book in data['data']){
          userLibraryBooks.add(await getBookDetails(book['book_id']));
        }
        return userLibraryBooks;
      }
    }
    else {
      print(response.reasonPhrase);
    }
  }

  Future removeBookFromLibrary(int bookId)async{
    var headers = {
      'Content-Transfer-Encoding': 'multipart/form-data',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(globals.baseUrl+'remove_library_books_api'));
    request.body = json.encode({
      "book_id": bookId,
      "user_id": globals.logedInUser.userId
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

  Future publishBook(int bookId)async{
    var headers = {
      'Content-Transfer-Encoding': 'multipart/form-data',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(globals.baseUrl+'book_publish_api'));
    request.body = json.encode({
      "book_id": bookId
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

  Future unPublishBook(int bookId)async{
    var headers = {
      'Content-Transfer-Encoding': 'multipart/form-data',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(globals.baseUrl+'book_unpublish_api'));
    request.body = json.encode({
      "book_id": bookId
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

  Future updateBook(String bookId,String name,dynamic _selectedItem,bool completed,bool _mature,dynamic selectedActivity,dynamic tags,dynamic description,dynamic imageProfile) async {
    var headers = {
      'Content-Transfer-Encoding': 'multipart/form-data'
    };
    var request = http.MultipartRequest('POST', Uri.parse(globals.baseUrl+'book_edit_api'));
    request.fields.addAll({
      'name': name,
      'genre': _selectedItem.value.toString(),
      'complete': completed.toString(),
      'mature': _mature.toString(),
      'copyrights': selectedActivity.title,
      'tags': tags,
      'description': description.text,
      'book_id': bookId,
    });
    if(imageProfile!=null){
      request.files.add(await http.MultipartFile.fromPath('image', imageProfile.path));
    }
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      dynamic data = await response.stream.bytesToString();
      data = jsonDecode(data);
      print(data);
      return data;
    }
    else {
      print(response.reasonPhrase);
    }
  }

  Future getTopStories()async{
    var request = http.Request('GET', Uri.parse(globals.baseUrl+'top-stories-books-api'));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      dynamic data = await response.stream.bytesToString();
      data = jsonDecode(data);
      var success = data['success'];
      if(success == true)
      {
        List userBooks=[];
        for(var book in data['top_stories']){
          userBooks.add(await getBookDetails(book['book_id']));
        }
        return userBooks;
      }
    }
    else {
      print(response.reasonPhrase);
    }
  }

  Future<List> getEditorsPick()async{
    final n = min(_itemsPerPage, _count - _currentPage * _itemsPerPage);
    var request = http.Request('GET', Uri.parse(globals.baseUrl+'editors-pick-books-api'));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      dynamic data = await response.stream.bytesToString();
      data = jsonDecode(data);
      var success = data['success'];
      if(success == true)
      {
        List userBooks=[];
        for(var book in data['editors_pick']){
          userBooks.add(await getBookDetails(book['book_id']));
        }
        _currentPage++;
        return userBooks;
      }
    }
    else {
      print(response.reasonPhrase);
      return [];
    }
  }

  Future getDailyTopPicks()async{
    var request = http.Request('GET', Uri.parse(globals.baseUrl+'daily-top-picks-api'));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      dynamic data = await response.stream.bytesToString();
      data = jsonDecode(data);
      var success = data['success'];
      if(success == true)
      {
        List userBooks=[];
        for(var book in data['daily_top']){
          userBooks.add(await getBookDetails(book['book_id']));
        }
        return userBooks;
      }
    }
    else {
      print(response.reasonPhrase);
    }
  }

  Future getNewReleases()async{
    var request = http.Request('GET', Uri.parse(globals.baseUrl+'new_release_api'));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      dynamic data = await response.stream.bytesToString();
      data = jsonDecode(data);
      var success = data['success'];
      if(success == true)
      {
        List userBooks=[];
        for(var book in data['data']){
          userBooks.add(await getBookDetails(book['book_id']));
        }
        return userBooks;
      }
    }
    else {
      print(response.reasonPhrase);
    }
  }

  Future getTopRomance()async{
    var request = http.Request('GET', Uri.parse(globals.baseUrl+'romance_genre_api'));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      dynamic data = await response.stream.bytesToString();
      data = jsonDecode(data);
      var success = data['success'];
      if(success == true)
      {
        List userBooks=[];
        for(var book in data['data']){
          userBooks.add(await getBookDetails(book['book_id']));
        }
        return userBooks;
      }
    }
    else {
      print(response.reasonPhrase);
    }
  }

  Future getBestWerewolf()async{
    var request = http.Request('GET', Uri.parse(globals.baseUrl+'werewolf_genre_api'));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      dynamic data = await response.stream.bytesToString();
      data = jsonDecode(data);
      var success = data['success'];
      if(success == true)
      {
        List userBooks=[];
        for(var book in data['data']){
          userBooks.add(await getBookDetails(book['book_id']));
        }
        return userBooks;
      }
    }
    else {
      print(response.reasonPhrase);
    }
  }

  Future getNewAdult()async{
    var request = http.Request('GET', Uri.parse(globals.baseUrl+'new_adult_genre_api'));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      dynamic data = await response.stream.bytesToString();
      data = jsonDecode(data);
      var success = data['success'];
      if(success == true)
      {
        List userBooks=[];
        for(var book in data['data']){
          userBooks.add(await getBookDetails(book['book_id']));
        }
        return userBooks;
      }
    }
    else {
      print(response.reasonPhrase);
    }
  }

  Future getBillionaire()async{
    var request = http.Request('GET', Uri.parse(globals.baseUrl+'billionaire_genre_api'));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      dynamic data = await response.stream.bytesToString();
      data = jsonDecode(data);
      var success = data['success'];
      if(success == true)
      {
        List userBooks=[];
        for(var book in data['data']){
          userBooks.add(await getBookDetails(book['book_id']));
        }
        return userBooks;
      }
    }
    else {
      print(response.reasonPhrase);
    }
  }

  Future getLiterature()async{
    var request = http.Request('GET', Uri.parse(globals.baseUrl+'literature_genre_api'));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      dynamic data = await response.stream.bytesToString();
      data = jsonDecode(data);
      var success = data['success'];
      if(success == true)
      {
        List userBooks=[];
        for(var book in data['data']){
          userBooks.add(await getBookDetails(book['book_id']));
        }
        return userBooks;
      }
    }
    else {
      print(response.reasonPhrase);
    }
  }

  Future getHistorical()async{
    var request = http.Request('GET', Uri.parse(globals.baseUrl+'historical_fiction_genre_api'));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      dynamic data = await response.stream.bytesToString();
      data = jsonDecode(data);
      var success = data['success'];
      if(success == true)
      {
        List userBooks=[];
        for(var book in data['data']){
          userBooks.add(await getBookDetails(book['book_id']));
        }
        return userBooks;
      }
    }
    else {
      print(response.reasonPhrase);
    }
  }

  Future giveRating(String bookId,int rating,String review)async{
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(globals.baseUrl+'book_rating_api'));
    request.body = json.encode({
      "book_id": bookId,
      "user_id": globals.logedInUser.userId,
      "rating": rating,
      "text":review
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

  Future deleteBook(int id)async{
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(globals.baseUrl+'book_delete_api'));
    request.body = json.encode({
      "book_id": id
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

  Future getBookReviews(int id)async{
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('https://novel.vidseries.com/book_reviews_api'));
    request.body = json.encode({
      "book_id": id
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      dynamic data = jsonDecode(await response.stream.bytesToString());
      List reviews=[];
      for(var reviewTemp in data['reviews']){
        reviews.add(
            Review.fromJson(reviewTemp)
        );
      }
      return reviews;
    }
    else {
      print(response.reasonPhrase);
    }
  }
}