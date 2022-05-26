import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:user_management_module/data/models/news.dart';

class LocalNotificationService {
  static Article? article;
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize(BuildContext context) {
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings("@mipmap/ic_launcher"));

    _notificationsPlugin.initialize(initializationSettings,onSelectNotification: (String? routePage) async{
      if(routePage != null){
        Get.toNamed(routePage, arguments: {'news' : article, 'isBookmarked' : false});
      }
    });
  }

  static void display(RemoteMessage message, Article _article) async {
    try {
      article = _article;
      final id = DateTime.now().millisecondsSinceEpoch ~/ 10000;
      
      const NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
        "newsapp",
        "newsapp channel",
        channelDescription: "Channel",
        importance: Importance.max,
        priority: Priority.high,
      ));
      
      await _notificationsPlugin.show(id, message.notification!.title,
          message.data['title'], notificationDetails,
          payload: message.data["route"],    //for passing msg to app when tapped on notification
      );

    } on Exception catch (e) {
      print(e);
    }
  }
}
