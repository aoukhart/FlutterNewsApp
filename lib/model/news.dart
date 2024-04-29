import 'dart:convert';
import 'package:http/http.dart';
// import 'dart:convert';


class News{
  late String source;
  late String title;
  late String image;
  late String releaseDate;
  late String content;
  late String url;
  late String author;
  
  News(String source, String title, String image, String Content, String releaseDate, String url, String Author){
    if (source.isEmpty) {
      source = "not available";
    }
    if (title.isEmpty) {
      title = "not available";
    }
    if (image.isEmpty) {
      image = "not available";
    }
    if (releaseDate.isEmpty) {
      releaseDate = "not available";
    }
    if (Content.isEmpty) {
      Content = "not available";
    }
    if (url.isEmpty){
      url = "not available";
    }
    if (Author.isEmpty){
      Author = "not available";
    }
    this.image = image;
    this.releaseDate = releaseDate;
    this.title = title;
    this.source = source; 
    this.content = Content;
    this.url = url;
    this.author = Author;
  } 

}

  Future <List<News>> getCarouselNews(String category, String language) async {
    // print("waa waaaaa");
    late List<News> dataTmp = [];
    String lang = language == "English" ? "en": "fr";
    Response res = await get(Uri.parse("https://newsapi.org/v2/everything?apiKey=afd7a3109fad4c849b6385b493f11839&language=$lang&q=$category&pageSize=20"));
    if (res.statusCode == 200){
      // print(jsonDecode(res.body));
      var decoded = jsonDecode(res.body);
      List<dynamic> data = decoded['articles'];
      for (Map<dynamic, dynamic> obj in data){
        if (obj['source']['name'] != null &&
            obj['title'] != null &&
            obj['urlToImage'] != null &&
            obj['content'] != null &&
            obj['publishedAt'] != null &&
            obj['url'] != null &&
            obj['author'] != null){
          News info = News(
            obj['source']['name'],
            obj['title'],
            obj['urlToImage'],
            obj['content'],
            obj['publishedAt'],
            obj['url'],
            obj['author']
        );
        // var icon = await FaviconFinder.getBest(info.url);
        // print(info.image);
        // print(i);
        dataTmp.add(info);
      }
      }
    }
    return dataTmp;
  }
