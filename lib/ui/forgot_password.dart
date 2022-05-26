import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:user_management_module/auth_services.dart';
import 'package:user_management_module/business_logic/forgot_psw/forgot_psw_cubit.dart';
import 'package:user_management_module/constants/ui_helpers.dart';
import 'package:user_management_module/validations.dart';
import 'package:user_management_module/widgets/custom_button.dart';
import 'package:user_management_module/widgets/custom_text_field.dart';
import 'package:user_management_module/widgets/top_container.dart';

import '../strings.dart';


///Forgot Password Page

class ForgotPassword extends StatelessWidget {
  ForgotPassword({Key? key}) : super(key: key);

  TextEditingController fEmailTEC = TextEditingController();

  AuthServices authServices = AuthServices();

  final forgotPasswordKey = GlobalKey<FormState>();

  //to reset password
  forgotPasswordCallBack(BuildContext context) {
    if (forgotPasswordKey.currentState!.validate()) {
      BlocProvider.of<ForgotPswCubit>(context).forgotPassword(fEmailTEC.text);
      //authServices.forgotPassword(fEmailTEC.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgotPswCubit(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: BlocListener<ForgotPswCubit, ForgotPswState>(
          listener: (context, state) {
            if (state is ForgotPswDone) {
              Get.offAndToNamed("/login");
            }
          },
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: TopContainer(
                  title: Strings.forgotPsw, icon: Icons.lock,),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: forgotPasswordKey,
                      child: Column(
                        children: [
                          verticalSpaceMedium,
                          CustomTextField(context: context,
                              controller: fEmailTEC,
                              hint: Strings.email,
                              isObscure: false,
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: Icons.email,
                              suffix: false,
                              validationFunction: emailValidation),
                          verticalSpaceMedium,
                          BlocBuilder<ForgotPswCubit, ForgotPswState>(
                            builder: (context, state) {
                              if(state is ForgotPswValidating){
                                return CustomButton(callBack: forgotPasswordCallBack, title: Strings.reset, disable: true,);
                              } else {
                                return CustomButton(callBack: forgotPasswordCallBack, title: Strings.reset);
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
