import 'package:app/model/news.dart';
import 'package:app/newsCarousel.dart';
import 'package:app/newsList.dart';
import 'package:flutter/material.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,

      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> categories = ["general", "business", "health", "science", "sports"];
  String selectedLanguage = "English";
  String selectedCategory = "general";

  // final NewsData news = NewsData();
  @override
  void initState() {
    getCarouselNews(selectedCategory, selectedLanguage);
    // print("qweqwe\n");
    super.initState();
    // newsData = news.getNews();
  }

    void changeLanguage(String? language) {
    setState(() {
      selectedLanguage = language!;
    });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text("Nyuuuz", style: TextStyle()),
        centerTitle: true,
      ),drawer:  Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Text(
                'Welcome',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            LanguageSelector(selectedLanguage: selectedLanguage, onLanguageSelected: (language){
              changeLanguage(language);
            }),
          ],
        ),
      ),body: SingleChildScrollView(
        child: Column(
          
          children: [
            Container(
              height: 70,
              child:  ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) => GestureDetector( 
                  onTap: () {
                    setState(() {
                      selectedCategory = categories[index];
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color:  categories[index] == selectedCategory?
                       Color.fromARGB(255, 233, 233, 233):
                       const Color.fromARGB(255, 207, 207, 207)
                    ),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Text(
                      categories[index],
                      style: const TextStyle(
                        color: Colors.black,fontSize: 20,
                        fontWeight: FontWeight.w700),),
                    ),
                ),
                ),
            ),
            NewsCarousel(category: selectedCategory, language: selectedLanguage,),
            NewsList(category: selectedCategory, language: selectedLanguage),
          ],),
      ),
    );
  }
}
 

class LanguageSelector extends StatefulWidget {
  final String selectedLanguage;
  final Function(String?) onLanguageSelected;

  LanguageSelector({required this.selectedLanguage, required this.onLanguageSelected});

  @override
  _LanguageSelectorState createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
        });
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("choose your language :"),
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: DropdownButton(items: [
                    DropdownMenuItem(child: Text("English"), value: "English",),
                    DropdownMenuItem(child: Text("French"), value: "French"),
                    DropdownMenuItem(child: Text("Arabic"), value : "Arabic")
                    ],
                     value: widget.selectedLanguage,
                     onChanged: (String? selected){
                      widget.onLanguageSelected(selected);
                     },borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                )
              ],
            ),
            
          ),
        ],
      ),
    );
  }
}

