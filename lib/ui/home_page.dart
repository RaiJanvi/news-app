import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:user_management_module/business_logic/internet/internet_cubit.dart';
import 'package:user_management_module/constants/ui_helpers.dart';
import 'package:user_management_module/data/api_manager.dart';
import 'package:user_management_module/auth_services.dart';
import 'package:user_management_module/data/lists.dart';
import 'package:user_management_module/data/models/news.dart';
import 'package:user_management_module/ui/location_news_page.dart';
import 'package:user_management_module/ui/news_feed_page.dart';
import 'package:user_management_module/widgets/drawer.dart';

import '../business_logic/news/news_cubit.dart';
import '../services/local_notification_service.dart';
import '../strings.dart';

///Home Page of the app- Displays news and search bar

class HomePage extends StatefulWidget {
  HomePage({Key? key, this.countryCode}) : super(key: key);

  String? countryCode;
  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  static bool internet = false;

  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;

  AuthServices authServices = AuthServices();

  APIManager apiManager = APIManager();

  String? userName, email;

  static int selectedIndex = 0;

  List<Widget> getPageList(){
    List<Widget> pages = <Widget>[
      NewsFeedPage(countryCode: widget.countryCode,),
      LocationNewsPage(),
    ];
    return pages;
  }

  //fetches current user data from firebase
  getUserData() async {
    user = auth.currentUser;
    print("get user");
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();

    setState(() {
      userName = snap['name'];
      email = snap['email'];
    });

    print("Name : ${snap['name']}, Email: ${snap['email']} ");
  }

  late List<Widget> pages;

  @override
  void initState() {
    super.initState();
    print("init");
    getUserData();
    pages = getPageList();

    LocalNotificationService.initialize(context);

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        final msg = message.data["title"];
        print(msg);

        Article article = Article.frommap({
          "source": message.data['source'],
          "author": message.data["author"],
          "title": message.data["title"],
          "description": message.data["description"],
          "url": message.data["url"],
          "urlToImage": message.data["urlToImage"],
          "publishedAt": message.data["publishedAt"],
          "content": message.data["content"],
        });

        Get.toNamed('/description', arguments: {'news' : article, 'isBookmarked' : false});

        print("In getinitialize");
      }
    });

    ///works when app is in foreground
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        print(message.notification!.title);
        print(message.notification!.body);
        print("In onMessage");
      }

      Article article = Article.frommap({
        "source": message.data['source'],
        "author": message.data["author"],
        "title": message.data["title"],
        "description": message.data["description"],
        "url": message.data["url"],
        "urlToImage": message.data["urlToImage"],
        "publishedAt": message.data["publishedAt"],
        "content": message.data["content"],
      });

      LocalNotificationService.display(message, article);

    });

    ///gets called when app is in background and open, and user taps on notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
       Article article = Article.frommap({
         "source": message.data['source'],
         "author": message.data["author"],
         "title": message.data["title"],
         "description": message.data["description"],
         "url": message.data["url"],
         "urlToImage": message.data["urlToImage"],
         "publishedAt": message.data["publishedAt"],
         "content": message.data["content"],
       });

       Get.toNamed('/description', arguments: {'news' : article, 'isBookmarked' : false});

      //Navigator.pushNamed(context, routeMessage);

      print(article);
      print("In onMessageOpend");
    });
  }

  _onItemTapped(int index){
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("code = ${widget.countryCode}");
    return BlocListener<InternetCubit, InternetState>(
      listener: (context, state) {
        if(state is InternetConnected){
          internet = true;
          BlocProvider.of<NewsCubit>(context).refreshNews();
        }else if(state is InternetDisconnected){
          internet = false;
          BlocProvider.of<NewsCubit>(context).noInternet();
        }
    },
    child: Scaffold(
      appBar: (selectedIndex ==0)?AppBar(
        elevation: 0,
        title: Text(Strings.homePage),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: CustomDelegate(),
                );
              },
              icon: Icon(Icons.search)),
        ],
      ): AppBar(elevation: 0,toolbarHeight: 0,),
      drawer: CustomDrawer(
        name: userName ?? "uName",
        email: email ?? "email",
      ),
      body: IndexedStack(       //preserves the state of tabs while switching
        index: selectedIndex,
        children: pages,
      ),

      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: [BoxShadow(blurRadius: 8, color: Colors.black26)],
        ),
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          elevation: 10,
          iconSize: 30,
          selectedItemColor: white,
          backgroundColor: Theme.of(context).primaryColor,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: const Icon(Icons.home),label: Strings.home,),
            BottomNavigationBarItem(icon: const Icon(Icons.public), label: Strings.globe),
          ],
          onTap: _onItemTapped,
        ),
      ),
    ),
);
  }
}

//search bar
class CustomDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(Icons.clear)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return (IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    ));
  }

  @override
  Widget buildResults(BuildContext context) {
    BlocProvider.of<NewsCubit>(context).getNews(category: query);
    Get.back();
    return ListTile();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? categories
        : categories.where((element) => element.startsWith(query)).toList();
    return ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (context, index){
        return ListTile(
          title: RichText(text: TextSpan(
            text: suggestionList[index].substring(0,query.length),
            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
            children:[
              TextSpan(
                text: suggestionList[index].substring(query.length),
                style: TextStyle(color: Colors.grey),
              )
            ],
          )),
          onTap: (){
            if(query.isEmpty){
              BlocProvider.of<NewsCubit>(context).getNews(category: suggestionList[index]);
              showResults(context);
            }else{
              close(context, null);
            }
            }
        );
    });
  }
}
