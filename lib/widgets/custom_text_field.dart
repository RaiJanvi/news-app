import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_management_module/constants/ui_helpers.dart';

///Custom TextFormField

class CustomTextField extends StatefulWidget {
  BuildContext context;
  TextEditingController controller;
  String hint;
  bool isObscure;
  TextInputType keyboardType;
  IconData prefixIcon;
  Function validationFunction;
  String? passwordText;
  bool suffix;

  CustomTextField({required this.context, required this.controller,
    required this.hint,
    required this.isObscure,
    required this.keyboardType,
    required this.prefixIcon,
    required this.suffix,
    required this.validationFunction, this.passwordText});

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {

  @override
  Widget build(BuildContext context) {

    BuildContext context = widget.context;
    TextEditingController controller =widget.controller;
    String hint = widget.hint;
    bool isObscure =widget.isObscure;
    TextInputType keyboardType = widget.keyboardType;
    IconData prefixIcon = widget.prefixIcon;
    bool suffix = widget.suffix;
    Function validationFunction=widget.validationFunction;

    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(radius),
      child: TextFormField(
        obscureText: isObscure,
        controller: controller,
        keyboardType: keyboardType,
        textInputAction: TextInputAction.next,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(prefixIcon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(radius),
            borderSide: BorderSide.none,),
          suffixIcon: (!suffix) ? null : IconButton(
            icon: Icon(
                isObscure
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: Theme.of(context).iconTheme.color),
            onPressed: () {
              setState(() {
                widget.isObscure = !widget.isObscure;
              });
            },
          ),
            contentPadding: EdgeInsets.only(left: 17, right: 3, top: 14,),
            errorStyle: TextStyle(fontSize: 9.sp, height: 1.h),
        ),
        validator: (value) => validationFunction(value, hint),
      ),
    );
  }
}

