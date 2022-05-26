import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

class Utils {
  static capture(GlobalKey key) async{
    RenderRepaintBoundary? boundary = key.currentContext!.findRenderObject() as RenderRepaintBoundary?;
    final image = await boundary?.toImage(pixelRatio: 3);
    final byteData = await image?.toByteData(format: ui.ImageByteFormat.png);
    final pngBytes = byteData?.buffer.asUint8List();

    return pngBytes;
  }
}