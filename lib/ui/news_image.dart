import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewsImage extends StatefulWidget {
  const NewsImage({Key? key}) : super(key: key);

  @override
  State<NewsImage> createState() => _NewsImageState();
}

class _NewsImageState extends State<NewsImage> {
  final Image newsImage = Get.arguments['image'];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: newsImage,
    );
  }
}
