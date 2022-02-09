import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:novel/globals.dart' as globals;
class Chapter {
  Chapter({
    this.description,
    this.timestamp,
    this.title,
    this.wordCount,
    this.publishStatus
  });

  String description;
  String timestamp;
  String title;
  String publishStatus;
  dynamic wordCount;
  Future getChapterDetails(int chapterId)async{
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
      data = jsonDecode(data);
      // print(data);
      Chapter chapter = Chapter(
        description: globals.baseUrl+"static/content/chapters/"+data['chapter_data'][0]["description"],
        timestamp: data['chapter_data'][0]["timestamp"],
        title: data['chapter_data'][0]["title"],
        wordCount: data['chapter_data'][0]["word_count"],
        publishStatus: data['chapter_data'][0]["publish_status"],
      );
      return chapter;
    }
    else {
      print(response.reasonPhrase);
    }
  }
  Future voteChapter(int chapterId,int bookId)async{
    var headers = {
      'Content-Transfer-Encoding': 'multipart/form-data',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(globals.baseUrl+'chapter_vote_api'));
    request.body = json.encode({
      "user_id": globals.logedInUser.userId,
      "chapter_id": chapterId,
      "book_id":bookId,
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
  Future getChapterVotes(int id)async{
    var headers = {
      'Content-Transfer-Encoding': 'multipart/form-data',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(globals.baseUrl+'chapter_views_votes'));
    request.body = json.encode({
      "chapter_id": id
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      dynamic data = await response.stream.bytesToString();
      data = jsonDecode(data);
      if(data['success']==true){
        print(data);
        return data['total_votes'][0]['votes'];
      }
    }
    else {
      print(response.reasonPhrase);
    }
  }

  Future incrementChapterViewCount(int chapterId,int bookId)async{
    var headers = {
      'Content-Transfer-Encoding': 'multipart/form-data',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(globals.baseUrl+'chapter_view_api'));
    request.body = json.encode({
      "user_id": globals.logedInUser.userId,
      "chapter_id": chapterId,
      "book_id":bookId
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
  Future publishChapter(int chapterId)async{
    var headers = {
      'Content-Transfer-Encoding': 'multipart/form-data',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(globals.baseUrl+'chapter_publish_api'));
    request.body = json.encode({
      "chapter_id": chapterId
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
  Future unPublishChapter(int chapterId)async{
    var headers = {
      'Content-Transfer-Encoding': 'multipart/form-data',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(globals.baseUrl+'chapter_unpublish_api'));
    request.body = json.encode({
      "chapter_id": chapterId
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
  Future deleteChapter(int chapterId)async{
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(globals.baseUrl+'chapter-delete-api'));
    request.body = json.encode({
      "chapter_id": chapterId
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
}