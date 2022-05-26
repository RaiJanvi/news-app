import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:user_management_module/auth_services.dart';
import 'package:user_management_module/services/local_notification_service.dart';

import 'my_app.dart';

///News App

Future<void> backgroundHandler(RemoteMessage message) async{
  await Firebase.initializeApp();
  print("Title : ${message.notification!.title}");
  print(message.data["source"]);
  print("In Background");
  // LocalNotificationService.display(message);
}

 Future main() async{
   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();

   FirebaseMessaging.onBackgroundMessage(backgroundHandler);

   SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));

   runApp(MyApp(connectivity: Connectivity(),));
}

