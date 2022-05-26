import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_management_module/business_logic/login/login_bloc.dart';
import 'package:user_management_module/constants/ui_helpers.dart';

import '../strings.dart';

class SignInWithGoogleBtn extends StatelessWidget {
  SignInWithGoogleBtn({Key? key, this.callback=true}) : super(key: key);

  bool callback;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: callback
            ? (){BlocProvider.of<LoginBloc>(context).add(GoogleLoginEvent());}
            : null,

        label: Text(Strings.googleSignIn, style: TextStyle(color: Colors.black, fontSize: 14.sp),),
        icon: Image.asset("assets/images/google_logo.png", height: 20.h, width: 20.w,),
        style: ElevatedButton.styleFrom(
          elevation: 5,
          primary: Colors.white,
          minimumSize: Size(double.infinity, 38.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
      ),
    );
  }
}
