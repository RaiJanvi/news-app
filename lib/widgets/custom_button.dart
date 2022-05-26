import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_management_module/constants/ui_helpers.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class CustomButton extends StatelessWidget {
  CustomButton({
    Key? key,
    required this.callBack,
    required this.title,
    this.disable = false,
  }) : super(key: key);

  final Function callBack;
  final String title;
  bool disable;

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    // return RoundedLoadingButton(
    //     controller: _btnController,
    //     color: Theme.of(context).primaryColor,
    //     onPressed: (){
    //       callBack(context, _btnController);
    //       _btnController.reset();
    //     },
    //     child: Text(title));

    return ElevatedButton(
      onPressed: disable
          ? null
          : () {
              FocusManager.instance.primaryFocus?.unfocus();
              callBack(context);
            },
      child: Text(
        title,
        style: TextStyle(fontSize: 16.sp),
      ),
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 38.h),
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
