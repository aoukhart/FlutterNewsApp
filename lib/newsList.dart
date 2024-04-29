import 'package:animations/animations.dart';
import 'package:app/NewsDetailed.dart';
import 'package:app/model/news.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

class NewsList extends StatelessWidget {
  final String category;
  final String language;
  NewsList({super.key, required this.category, required this.language});

    final  List<News> newsData = [];

    Future<List<News>> getNews() async{
    late List<News> dataTmp = [];
    late String languageAbrev;
    switch (language) {
      case "English":
        languageAbrev = "en";
        break;
      
      case "French":
        languageAbrev = "fr";
        break;
      
      case "Arabic":
        languageAbrev = "ar";
    }
    Response res = await get(Uri.parse(
      "https://newsapi.org/v2/top-headlines?apiKey=afd7a3109fad4c849b6385b493f11839&language=${languageAbrev}&category=$category&pageSize=10"));
    if(res.statusCode == 200){
      var data =  jsonDecode(res.body);
      List<dynamic> asd  = data['articles'];
      print(asd);
      for (Map<String, dynamic> i in asd ){
        if (i['source']['name'] != null &&
            i['title'] != null &&
            i['urlToImage'] != null &&
            i['content'] != null &&
            i['publishedAt'] != null &&
            i['url'] != null &&
            i['author'] != null){

          News info = News(
            i['source']['name'],
            i['title'],
            i['urlToImage'],
            i['content'],
            i['publishedAt'],
            i['url'],
            i['author']
        );
        // print(i);
        dataTmp.add(info);
      }
      }
    }
    return dataTmp;
  }

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 0),
          
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Trending News", style: TextStyle(
                  fontSize: 21, fontWeight: FontWeight.w700
                ),),
              TextButton(onPressed: () {
                
              }, child: Text("View all", style: TextStyle(fontSize: 16),))
            ],
          ),
        ),
        FutureBuilder(future: getNews(),
                     builder: (context, snapshot) {
                      if (snapshot.hasData){
                        if (snapshot.data!.isEmpty)
                          return const Text("data apaah");
                        else {
                          return Container(
                            
                            height: 500,
                            child: ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) => OpenContainer(
                                closedElevation: 0,
                                // openElevation: 10,
        
                                transitionType: ContainerTransitionType.fadeThrough,
                                transitionDuration: Duration(milliseconds: 600),
                                tappable: true,
                                openBuilder: (context, _) => NewsDetail(news: snapshot.data![index]),
                                closedBuilder: (context, _) => Container(
                                  margin: EdgeInsets.only(bottom: 15, left: 10, right: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: const Color.fromARGB(255, 232, 232, 232)
                                  ),
                                  child: Row(
                                    children: [
                                
                                          Container(
                                            // padding: EdgeInsets.symmetric(horizontal: 5),
                                            alignment: Alignment.topCenter,
                                            // width: 180,
                                            // height: 230,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(25))
                                            ),
                                            child: Column(
                                              children: [
                                                ClipRRect(
                                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                                  child: Image.network(snapshot.data![index].image
                                                  ,fit: BoxFit.cover,
                                                  height: MediaQuery.of(context).size.height*0.15,
                                                  width: MediaQuery.of(context).size.width*0.41,
                                            ),
                                                ),
                                        Row(
                                         mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            // Text(snapshot.data![index].source),
                                            // Text(DateFormat("EEE, d MMM").format(DateTime.parse(snapshot.data![index].releaseDate)), softWrap: true,),
                                          ],
                                        ),
                                              ],
                                            )),
                                
                                      SizedBox(width: 10,),
                                      Container(
                                        width: MediaQuery.of(context).size.width*0.45,
                                        child: Text(
                                          snapshot.data![index].title
                                          ,style: const TextStyle(fontSize: 12)
                                        ,softWrap: true,),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                          );
                        }
                        
                      }else if(snapshot.hasError){
                        return Text('${snapshot.error}');
                      }  
                      return const Center(child: CircularProgressIndicator());
                     }),
      ],
    );
  }
}