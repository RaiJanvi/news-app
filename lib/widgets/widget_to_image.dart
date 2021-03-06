import 'package:flutter/material.dart';

class WidgetToImage extends StatefulWidget {
  const WidgetToImage({Key? key, required this.builder}) : super(key: key);

  final Function(GlobalKey key) builder;

  @override
  State<WidgetToImage> createState() => _WidgetToImageState();
}

class _WidgetToImageState extends State<WidgetToImage> {
  final globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: globalKey,
      child: widget.builder(globalKey),
    );
  }
}
