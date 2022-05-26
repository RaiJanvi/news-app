import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/ui_helpers.dart';
import '../strings.dart';

Widget noInternetConnection(BuildContext context){
  return Center(
    child: Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/no_internet.png", height: 150.h,),
          verticalSpaceRegular,
          Text(Strings.offline, style: TextStyle(
              fontWeight: Theme.of(context).textTheme.headline5?.fontWeight,
              fontSize: Theme.of(context).textTheme.headline5?.fontSize,
              color: Colors.grey
          ),),
          Text(Strings.checkConnection, style: TextStyle(
              fontWeight: Theme.of(context).textTheme.headline5?.fontWeight,
              fontSize: Theme.of(context).textTheme.headline5?.fontSize,
              color: Colors.grey
          ),)],
      ),
    ),
  );
}