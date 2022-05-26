import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:user_management_module/constants/ui_helpers.dart';

class TopContainer extends StatelessWidget {
  const TopContainer({
    Key? key,
    required this.title,
    this.icon = Icons.person_rounded,
    this.initial = "U",
  }) : super(key: key);

  final String title, initial;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        right: 20.w,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (title == "Forgot Password ?" || title == "Profile") ...[
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  Get.back();
                },
              ),
            )
          ],
          Center(
            child: (title == "Profile")
                ? CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white70,
                    child: Text(
                      initial,
                      style: TextStyle(fontSize: 35.h),
                    ),
                  )
                : CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.white,
                    child: Icon(
                      icon,
                      color: Theme.of(context).primaryColor,
                      size: 42.h,
                    ),
                  ),
          ),
          Align(
              alignment: Alignment.bottomRight,
              child: Text(
                title,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp),
              )),
        ],
      ),
      decoration: BoxDecoration(
          borderRadius:
              const BorderRadius.only(bottomLeft: Radius.circular(90)),
          gradient: LinearGradient(
              colors: [primaryC, secondaryC],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter)),
    );
  }
}
