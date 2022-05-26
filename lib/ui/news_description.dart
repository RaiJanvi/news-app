import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/native.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:user_management_module/data/drift/drift_database.dart';
import 'package:user_management_module/my_app.dart';
import 'package:user_management_module/ui/news_image.dart';
import 'package:user_management_module/utils.dart';
import 'package:user_management_module/widgets/widget_to_image.dart';
import 'package:drift/drift.dart' as drift;

import '../constants/ui_helpers.dart';
import '../data/models/news.dart';

class NewsDescription extends StatefulWidget {
  NewsDescription({
    Key? key,
  }) : super(key: key);

  @override
  State<NewsDescription> createState() => _NewsDescriptionState();
}

class _NewsDescriptionState extends State<NewsDescription> {
  User? user = FirebaseAuth.instance.currentUser;

  final Article? article = Get.arguments['news'];
  bool isBookmarked = Get.arguments['isBookmarked'] ?? false;

  //bool isBookmarked =false;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  late GlobalKey descriptionKey;

  //late Uint8List bytes;

  addBookMark() {
    firestore.collection('users').doc(user?.uid).collection('bookmarks').add({
      "title": article?.title,
      "urlToImage": article?.urlToImage,
      "url": article?.url,
      "content": article?.content,
      "description": article?.description,
      "source": article?.source?.name,
      "publishedAt": article?.publishedAt.toString(),
    });
    print("Bookmark added");
  }

  removeBookmark() {
    firestore
        .collection('users')
        .doc(user?.uid)
        .collection('bookmarks')
        .where('title', isEqualTo: article?.title)
        .get()
        .then((value) {
      value.docs.forEach((element) async {
        await firestore.runTransaction((Transaction myTransaction) async {
          await myTransaction.delete(element.reference);
          print("Deleted! ${element.id}");
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Stack(
        children: [
          WidgetToImage(
            builder: (key) {
              descriptionKey = key;
            return Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: white,
                      child: Image.network(
                        article!.urlToImage ?? "https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg",
                        fit: BoxFit.fill,
                      )),
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              article!.title!,
                              style: TextStyle(
                                  fontSize: 18.sp, fontWeight: FontWeight.w600),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10.0),
                            child: RichText(
                                text: TextSpan(
                              text: article!.content!
                                  .substring(0, article!.content!.length - 14),
                              style: TextStyle(
                                color: Colors.grey.shade800,
                                fontSize: 15.sp,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Read more',
                                  style: TextStyle(color: Colors.blue),
                                  recognizer: new TapGestureRecognizer()
                                    ..onTap = () async {
                                      print("Read More");
                                      var url = Uri.parse(article!.url!);
                                      //String url = "https://www.fluttercampus.com";
                                      var urllaunchable = await canLaunchUrl(
                                          url); //canLaunch is from url_launcher package
                                      if (urllaunchable) {
                                        await launchUrl(
                                            url); //launch is from url_launcher package to launch URL
                                      } else {
                                        print("URL can't be launched.");
                                      }
                                    },
                                )
                              ],
                            )),
                          ),
                        ],
                      )),
                ),
              ],
            );}
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35.0),
                    ),
                    child: SizedBox(
                      width: 35,
                      height: 35,
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_rounded,
                          size: 19,
                        ),
                        color: Colors.black,
                        onPressed: () {
                          Get.back();
                        },
                      ),
                    ),
                  )),
              Row(
                children: [
                  Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35.0),
                        ),
                        child: SizedBox(
                          width: 35,
                          height: 35,
                          child: IconButton(
                            icon: Icon(
                              isBookmarked
                                  ? Icons.bookmark
                                  : Icons.bookmark_border,
                              size: 19,
                              color: Theme.of(context).primaryColor,
                            ),
                            color: Colors.black,
                            onPressed: () {
                              setState(() {
                                isBookmarked = !isBookmarked;
                                if (isBookmarked) {
                                  addBookMark();
                                } else {
                                  removeBookmark();
                                }
                              });
                            },
                          ),
                        ),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35.0),
                        ),
                        child: SizedBox(
                          width: 35,
                          height: 35,
                          child: IconButton(
                            icon: Icon(
                              Icons.download,
                              size: 19,
                              color: Theme.of(context).primaryColor,
                            ),
                            color: Colors.black,
                            onPressed: () async {
                              final bytes = await Utils.capture(descriptionKey);
                              final download = DownloadsCompanion(news: drift.Value(bytes));
                              await MyApp.db.insertNews(download).then((value) =>
                                  Get.snackbar("News Downloaded", '',
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: Colors.green.shade100));
                            },
                          ),
                        ),
                      )),
                ],
              ),
            ],
          ),
        ],
      )),
    );
  }
}
