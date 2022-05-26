import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_management_module/constants/ui_helpers.dart';

/// Introduction Page - when user opens app for the first time

class OnBoardingPage extends StatelessWidget {
  late SharedPreferences onBoard, loginState;

  //set flag after onBoarding page is displayed
  setFlag() async{
    onBoard = await SharedPreferences.getInstance();
    onBoard.setBool('onBoard', false);
    print("on board false");
  }

  @override
  Widget build(BuildContext context) {
    setFlag();
    return IntroductionScreen(
    pages: [
      PageViewModel(
        title: ''' "A Good News Paper is A Nation Talking To Itself." ''',
        body: 'Keep yourself updated with the latest news.',
        image: buildImage('assets/images/intro1.png'),
        decoration: getPageDecoration(),
      ),
      PageViewModel(
        title: 'Read News of Your Choice',
        body: 'Available right at your fingertips',
        image: buildImage('assets/images/intro2.png'),
        decoration: getPageDecoration(),
      ),
      PageViewModel(
        title: 'Use Globe',
        body: 'To know whats happening around the world',
        image: buildImage('assets/images/intro3.png'),
        decoration: getPageDecoration(),
      ),
      PageViewModel(
        title: 'Never Miss On Any Updates',
        body: '',
        footer: ElevatedButton(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Let's Get Started", style: TextStyle(fontSize: 20.sp,),),
          ),
          onPressed: (){},
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          ),
        ),
        image: buildImage('assets/images/intro4.png'),
        decoration: getPageDecoration(),
      ),
    ],
    done: Text('Start', style: TextStyle(fontWeight: FontWeight.w600,)),
    onDone: () => goToLogin(context),
    showSkipButton: true,
    skip: Text('Skip',),
    onSkip: () => goToLogin(context),
    showNextButton: false,
    dotsDecorator: getDotDecoration(),
    globalBackgroundColor: white,
  );
  }

  void goToLogin(context) async{
    Get.offNamedUntil('/login', (route) => false);
  }

  Widget buildImage(String path) =>
      Center(child: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: Image.asset(path, width: 350,),
      ));

  DotsDecorator getDotDecoration() => DotsDecorator(
    size: Size(10, 10),
    activeSize: Size(22, 10),
    activeShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    ),
  );

  PageDecoration getPageDecoration() => PageDecoration(
    titleTextStyle: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: primaryC),),
    bodyTextStyle: TextStyle(fontSize: 20, color: primaryC),
    imagePadding: EdgeInsets.only(top: 24),
    //pageColor: Colors.indigo.shade400,
  );
}