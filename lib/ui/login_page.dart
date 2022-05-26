import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:user_management_module/auth_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_management_module/validations.dart';
import 'package:user_management_module/widgets/custom_button.dart';
import 'package:user_management_module/widgets/custom_text_field.dart';
import 'package:user_management_module/widgets/signin_with_google_btn.dart';
import 'package:user_management_module/widgets/top_container.dart';
import '../business_logic/login/login_bloc.dart';
import '../constants/ui_helpers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../strings.dart';

///Login Page

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AuthServices authServices = AuthServices();

  late SharedPreferences login;

  final loginFormKey = GlobalKey<FormState>();

  TextEditingController emailTEC = TextEditingController();

  TextEditingController passwordTEC = TextEditingController();

  //for validating entered details and loges in the user
  loginCallBack(BuildContext context) async {
    if (loginFormKey.currentState!.validate()) {
      String email = emailTEC.text;
      String password = passwordTEC.text;

      BlocProvider.of<LoginBloc>(context)
          .add(EmailLoginEvent(email: email, password: password));

      //authServices.login(email, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoggedIn) {
            Get.offAndToNamed('/home');
          }
        },
        // builder: (context, state) {
         child: Column(
            children: [
              Expanded(
                  flex: 3,
                  child: TopContainer(
                    title: Strings.login,
                  )),
              Expanded(
                flex: 3,
                child: Container(
                  margin: EdgeInsets.only(top: 20.h),
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: loginFormKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          context: context,
                          controller: emailTEC,
                          hint: Strings.email,
                          keyboardType: TextInputType.emailAddress,
                          validationFunction: emailValidation,
                          prefixIcon: Icons.email,
                          isObscure: false,
                          suffix: false,
                        ),
                        verticalSpaceRegular,
                        CustomTextField(
                          context: context,
                          controller: passwordTEC,
                          hint: Strings.password,
                          keyboardType: TextInputType.visiblePassword,
                          validationFunction: passwordValidation,
                          prefixIcon: Icons.lock,
                          isObscure: true,
                          suffix: true,
                        ),
                        verticalSpaceSmall,
                        GestureDetector(
                          onTap: () {
                            Get.toNamed('/forgotPsw');
                          },
                          child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(Strings.forgotPsw)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding:
                      const EdgeInsets.only(bottom: 25.0, left: 30, right: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BlocBuilder<LoginBloc, LoginState>(
                        builder: (context, state) {
                          if(state is LoginValidating) {
                            return CustomButton(callBack: loginCallBack, title: Strings.signIn, disable: true,);
                          } else {
                            return CustomButton(callBack: loginCallBack, title: Strings.signIn);
                          }
                        },
                      ),
                      //verticalSpaceSmall,
                      BlocBuilder<LoginBloc, LoginState>(
                        builder: (context, state) {
                          if(state is GoogleLoginValidating) {
                            return SignInWithGoogleBtn(callback: false,);
                          } else {
                            return SignInWithGoogleBtn();
                          }
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(Strings.noAcc),
                          GestureDetector(
                              onTap: () {
                                Get.toNamed('/register');
                              },
                              child: Text(
                                Strings.signUp,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
      ),
    );
  }
}
