import 'dart:async';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_management_module/ui/home_page.dart';
import 'package:user_management_module/ui/login_page.dart';
import 'package:page_transition/page_transition.dart';
import 'package:user_management_module/ui/onboarding_page.dart';
import 'package:lottie/lottie.dart';

///Splash screen of the app

class SplashScreenPage extends StatefulWidget {
  SplashScreenPage({Key? key}) : super(key: key);

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  FirebaseAuth auth = FirebaseAuth.instance;

  late SharedPreferences loginState, onBoard;

  Widget nextScreen = SplashScreenPage();

  //Checks whether user is already logged in or not
  //and navigates to login page or home page accordingly
  Future<void> checkUserState() async{
    try{
      onBoard = await SharedPreferences.getInstance();
      bool onBoardState = onBoard.getBool('onBoard') ?? true;
      print("OnBoard : $onBoardState");

      if(onBoardState){
        print("Go onBoard");
        setState(() {
          nextScreen = OnBoardingPage();
        });
      }else{
        loginState = await SharedPreferences.getInstance();
        print("Loggin State : ${loginState.getBool('loggedIn')}");
        bool userState = loginState.getBool('loggedIn') ?? false;
        if(userState){
          setState(() {
            nextScreen = HomePage();
          });
        }else{
          setState(() {
            nextScreen = LoginPage();
          });
        }
      }
    }catch (e){
      print(e);
      nextScreen = LoginPage();
    }
  }

  @override
  void initState() {
    super.initState();
    checkUserState();
  }

  @override
  Widget build(BuildContext context) {
    print("Next Screen = ${nextScreen.toString()}");
    return AnimatedSplashScreen(splash: Lottie.network("https://assets8.lottiefiles.com/datafiles/98a3d0add75fc3c86f6d6f9b148c111e/Newspaper animation.json",
      repeat: true, fit: BoxFit.contain),
    //Icon(Icons.newspaper, color: Colors.white, size: 150.h),
      duration: 3000,
      splashIconSize: double.maxFinite,
      nextScreen: nextScreen,
      backgroundColor: Color(0xFF5C6BC0),//primaryC,
      pageTransitionType: PageTransitionType.fade,
      //disableNavigation: true,
    );
  }
}
