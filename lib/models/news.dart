import 'dart:convert';
import 'package:novel/globals.dart' as globals;
import 'package:http/http.dart' as http;
class News {
  News({
    this.headingImageId,
    this.image,
    this.url,
  });

  int headingImageId;
  String image;
  String url;

  Future getTopNews()async{
    var request = http.Request('GET', Uri.parse(globals.baseUrl+'top-news-api'));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      dynamic data = await response.stream.bytesToString();
      data = jsonDecode(data);
      if(data['success']==true){
        List topNewsList=[];
        for(var news in data['top_news']){
          topNewsList.add(
            News(
              headingImageId: news["heading_image_id"],
              image: globals.baseUrl+'static/images/headingimg/'+news["image"],
              url: news["url"],
            )
          );
        }
        return topNewsList;
      }
    }
    else {
      print(response.reasonPhrase);
    }
  }

}