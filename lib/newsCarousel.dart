import 'package:animations/animations.dart';
import 'package:app/NewsDetailed.dart';
import 'package:app/model/news.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:favicon/favicon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NewsCarousel extends StatefulWidget {
  const NewsCarousel({super.key, required this.category, required this.language});

  final String category;
  final String language;
  @override
  State<NewsCarousel> createState() => _NewsCarouselState();
}

class _NewsCarouselState extends State<NewsCarousel> {
  List<News> CarouselItems = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getCarouselNews(widget.category, widget.language),
      builder: (context, snapshot) {
        if (snapshot.hasData){
          if (snapshot.hasData){
            return CarouselSlider.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index, realIndex) => OpenContainer(
                closedElevation: 0,
                // tappable: true,
               closedBuilder: (context, open) => Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 12),
                  child: Stack(
                    children:[ 
                      Container(
                        height: 260,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(color: Colors.grey.shade600,spreadRadius: 0.1, blurRadius: 5, offset: const Offset(0, 5)),   
                          // BoxShadow(color: Colors.grey, offset: const Offset(-5, 0),spreadRadius: 0.1, blurRadius: 5)                    
                        ]
                      ),
                        child: Column(
                
                          mainAxisAlignment: MainAxisAlignment.start,
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 205,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.network(snapshot.data![index].image,
                                fit: BoxFit.fill,
                              ),
                            )
                          ),
                          Container(
                            // decoration: BoxDecoration(
                            //   color: Colors.blueGrey
                            // ),
                            alignment: Alignment.center,
                              height: 50,
                              padding: const EdgeInsets.only(left: 10, right: 10),
                              // margin: EdgeInsets.only(top: 5),
                              child: Text(snapshot.data![index].title, style: TextStyle(
                                color: Colors.white,
                                fontSize: 13
                              ),textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              ),
                            ),
                          ],
                        ),),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(120),
                            child: FutureBuilder(
                              future: FaviconFinder.getBest(snapshot.data![index].url),
                              builder: (cntxt, snpsht) {
                                if (snpsht.hasData){
                                  // ResizeImage(snpsht.data!, )
                                  if (snpsht.data!.height == 0 && snpsht.data!.width == 0)
                                  {
                                    // SvgPicture.network()
                                    return SvgPicture.network(snpsht.data!.url, fit: BoxFit.cover,
                                      width: 40, 
                                      height: 40);
                                  }
                                  return Image.network(snpsht.data!.url, fit: BoxFit.cover,
                                    width: 40, 
                                    height: 40);
                                  }
                                  return const CircularProgressIndicator();
                                })),
                                SizedBox(width: 7)
                          ,Text(
                              snapshot.data![index].source.replaceAll(RegExp(r' '), '\n'),
                              style: TextStyle(color: Colors.white),
                              maxLines: 2,
                            ),
                        ],
                      ),
                    ),],
                  ),
                ),
               openBuilder: (context, _) {
                print(index);
                return NewsDetail(news: snapshot.data![1]);
               }
                )
              ,options: CarouselOptions(
                height: 300,
                // disableCenter: true,
                enlargeCenterPage: true,

                enlargeStrategy: CenterPageEnlargeStrategy.height,
                enlargeFactor: 0.26,
                autoPlay: true,
              ),);
          }
        }
        return LinearProgressIndicator();
      }
      );
  }
}