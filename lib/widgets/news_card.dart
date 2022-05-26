import 'package:flutter/material.dart';
import 'package:user_management_module/data/models/news.dart';

import '../constants/ui_helpers.dart';

class NewsCard extends StatelessWidget {
  NewsCard({Key? key, required this.article}) : super(key: key);

  Article? article;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(containerRadius)),
      margin: const EdgeInsets.all(10.0),
      child: Container(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(containerRadius),
                    image: DecorationImage(
                      image: NetworkImage(article?.urlToImage ?? "https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg"),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(6.0),
                  width: double.infinity,
                  // color: Colors.black54,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(containerRadius), topRight: Radius.circular(containerRadius)),
                    color: Colors.black54,),
                  child: Text(article?.title ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headline1),),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top:4.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(article!.source!.name, style: Theme.of(context).textTheme.headline2,)),
                      horizontalSpaceTiny,
                      Text(article!.publishedAt.toString().substring(0, 10), style: Theme.of(context).textTheme.headline3,),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
