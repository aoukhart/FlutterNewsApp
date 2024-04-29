import 'package:favicon/favicon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'model/news.dart';

class NewsDetail extends StatelessWidget {
  const NewsDetail({super.key, required this.news});
  final News news;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(), 
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 35, bottom: 5, top: 0),
            child: Container(
              height: 50,
              child: Row(
                children: [
                FutureBuilder(
                  future: FaviconFinder.getBest(news.url),
                  builder: (context, snapshot) {
                    if (snapshot.hasData){
                        if (!snapshot.hasError){
                          return  Container(
                            child: (snapshot.data!.height != 0) ? 
                            Image.network(snapshot.data!.url,fit: BoxFit.fill, height: 40, width: 40)
                            : SvgPicture.network(snapshot.data!.url,fit: BoxFit.fill, height: 40,width: 40));
                        }}
                    return const CircularProgressIndicator();
                  }
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: const VerticalDivider(thickness: 3, color: Colors.black),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(DateFormat("d MMM y").format(DateTime.parse(news.releaseDate))),
                    Text(news.source, style: const TextStyle(
                      fontWeight: FontWeight.w800,fontSize: 18
                    )),
                  ],
                )
              ]),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width*0.85,
            child: Text(news.title.substring(0, news.title.lastIndexOf("-")),
             style: TextStyle(fontSize: 25,fontWeight: FontWeight.w700, wordSpacing: 1.2))),
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade800,
                  offset: Offset(0,0),
                  blurRadius: 8.0,
                  spreadRadius: 3)]),
            width: MediaQuery.of(context).size.width*0.85,
            margin: EdgeInsets.symmetric(vertical: 20),
            child: Image.network(news.image, fit: BoxFit.fill,
            ),
          ),
          Container(


            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
            width: MediaQuery.of(context).size.width*0.87,
            child: Text(news.content.substring(0, news.content.lastIndexOf('[')), 
            style: TextStyle(fontSize: 17, height: 1.4),textAlign: TextAlign.justify,),
            ),
            Expanded(child: Container()),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              width: MediaQuery.of(context).size.width*0.85,
              child: 
                TextButton(child: Text("Read More"),onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> WebViewPage(url: news.url)));
                }
                ))]),
      );
  }
}

class WebViewPage extends StatefulWidget {
  final String url;
  final WebViewController _controller;
  
  WebViewPage({super.key, required this.url}): _controller =  WebViewController()
  ..setJavaScriptMode(JavaScriptMode.unrestricted)
  ..loadRequest(Uri.parse(url));

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: IconButton(onPressed: () {
        Navigator.pop(context);
      },icon: Icon(Icons.arrow_back),
      ),),
      body: WebViewWidget(controller: widget._controller)
      );
  }
}