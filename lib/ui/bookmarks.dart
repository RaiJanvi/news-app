import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:user_management_module/widgets/news_card.dart';

import '../constants/ui_helpers.dart';
import '../data/models/news.dart';

///Displays bookmarked news

class BookMarks extends StatefulWidget {
  const BookMarks({Key? key}) : super(key: key);

  @override
  State<BookMarks> createState() => _BookMarksState();
}

class _BookMarksState extends State<BookMarks> {

  User? user = FirebaseAuth.instance.currentUser;
  News? news;
  late final Stream<QuerySnapshot> _usersStream;
  late QuerySnapshot snap;

  getBookMarks() async {
    _usersStream =
        FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('bookmarks').snapshots();
  }

  @override
  void initState() {
    getBookMarks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BookMarks"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _usersStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                print(document.id);
                Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
                Article? article = Article.frommap(data);
                //print(article);
                return GestureDetector(
                  onTap: (){
                    Get.toNamed('description', arguments: {'news': article, 'isBookmarked': true});
                      print(Article.fromJson(data).toString());
                    },
                  child: NewsCard(article: article),
                );
              }).toList(),
            );
          }),
    );
  }
}
