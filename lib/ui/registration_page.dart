import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:user_management_module/business_logic/registration/registration_bloc.dart';
import '../auth_services.dart';
import '../business_logic/login/login_bloc.dart';
import '../constants/ui_helpers.dart';
import '../strings.dart';
import '../validations.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/signin_with_google_btn.dart';
import '../widgets/top_container.dart';

///Registration Page

class RegistrationPage extends StatelessWidget {
  RegistrationPage({Key? key}) : super(key: key);

  AuthServices authServices = AuthServices();

  final registrationFormKey = GlobalKey<FormState>();

  TextEditingController fNameTEC = TextEditingController();
  TextEditingController emailTEC = TextEditingController();
  TextEditingController passwordTEC = TextEditingController();

  //for validating entered details and registering the user
  registrationCallBack(BuildContext context) {
    if (registrationFormKey.currentState!.validate()) {
      String fName = fNameTEC.text;
      String email = emailTEC.text;
      String password = passwordTEC.text;

      BlocProvider.of<RegistrationBloc>(context).add(
          RegistrationEvent(email: email, password: password, fName: fName));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegistrationBloc(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: BlocListener<RegistrationBloc, RegistrationState>(
          listener: (context, state) {
            if (state is Registered) {
              Get.offAndToNamed('/login');
            }
          },
          child: Column(
            children: [
              Expanded(
                  flex: 3,
                  child: TopContainer(
                    title: Strings.register,
                  )),
              Expanded(
                flex: 3,
                child: Container(
                  margin: EdgeInsets.only(top: 20.h),
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: registrationFormKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          context: context,
                          controller: fNameTEC,
                          hint: Strings.fName,
                          keyboardType: TextInputType.text,
                          validationFunction: emptyValidation,
                          prefixIcon: Icons.person,
                          isObscure: false,
                          suffix: false,
                        ),
                        verticalSpaceRegular,
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
                      BlocBuilder<RegistrationBloc, RegistrationState>(
                        builder: (context, state) {
                          if (state is RegistrationValidating) {
                            return CustomButton(callBack: registrationCallBack,
                              title: Strings.signUp,
                              disable: true,);
                          } else {
                            return CustomButton(callBack: registrationCallBack,
                                title: Strings.signUp);
                          }
                        },
                      ),
                      //verticalSpaceSmall,
                      BlocBuilder<LoginBloc, LoginState>(
                        builder: (context, state) {
                          if(state is GoogleLoginValidating) {
                            return SignInWithGoogleBtn(callback: false);
                          } else {
                            return SignInWithGoogleBtn();
                          }
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(Strings.acc),
                          GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: Text(
                                Strings.signIn,
                                style: TextStyle(
                                    color: Theme
                                        .of(context)
                                        .primaryColor),
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
      ),
    );
  }
}
