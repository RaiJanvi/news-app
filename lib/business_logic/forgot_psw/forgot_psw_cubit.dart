import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_management_module/auth_services.dart';

part 'forgot_psw_state.dart';

class ForgotPswCubit extends Cubit<ForgotPswState> {
  ForgotPswCubit() : super(ForgotPswInitial());

  AuthServices authServices = AuthServices();

  forgotPassword(String email) async{
    emit(ForgotPswValidating());
    await authServices.forgotPassword(email).then((value) {
      if(value == "Success"){
        emit(ForgotPswDone());
      } else{
        authServices.catchError(value);
        emit(ForgotPswFailed());
      }
    });
  }
}
