import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:user_management_module/auth_services.dart';

import '../constants/ui_helpers.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer({Key? key, this.name ='Name', this.email = 'email'}) : super(key: key);

  final String name, email;

  AuthServices authServices = AuthServices();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Container(
          color: white,
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              drawerHeader(context),
              drawerBody(),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Divider(thickness: 2,),
                    ListTile(title: Text('Logout', style: TextStyle(fontSize: 15.sp),),
                      leading: const Icon(Icons.logout),
                      onTap: (){ authServices.logOut();},),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget drawerHeader(BuildContext context){
    return Container(
      color: Theme.of(context).primaryColor,
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.25,
      padding: EdgeInsets.only(left: 20.0.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 33.h,
            backgroundColor: Colors.white70,
            child: Text(name.substring(0,1), style: TextStyle(fontSize: 30.h),),
          ),
          verticalSpaceSmall,
          Text(name, style: TextStyle(color: white, fontSize: 15.h, fontWeight: FontWeight.bold),),
          verticalSpaceTiny,
          Text(email,style: TextStyle(color: white, fontSize: 13.h,),),
        ],
      ),
    );
  }

  Widget drawerBody(){
    return Column(
      children: [
        ListTile(title:  Text('Bookmarks', style: TextStyle(fontSize: 15.sp),),
          leading: const Icon(Icons.bookmark),
          onTap: ()=> Get.offAndToNamed('/bookmarks'),),
        ListTile(title:  Text('Did You Know ?', style: TextStyle(fontSize: 15.sp),),
          leading: const Icon(Icons.lightbulb),
          onTap: ()=> Get.offAndToNamed('/facts'),),
        ListTile(title:  Text('Downloads', style: TextStyle(fontSize: 15.sp),),
          leading: const Icon(Icons.download),
          onTap: ()=> Get.offAndToNamed('/downloads'),),
        ListTile(title: Text('Profile', style: TextStyle(fontSize: 15.sp),),
          leading: const Icon(Icons.person),
          onTap: ()=> Get.offAndToNamed('/profile', arguments: {'name': name, 'email': email}),),
        ListTile(title: Text('Settings', style: TextStyle(fontSize: 15.sp),),
          leading: const Icon(Icons.settings),
          onTap: ()=> Get.offAndToNamed('/settings'),),
      ],
    );
  }
}
