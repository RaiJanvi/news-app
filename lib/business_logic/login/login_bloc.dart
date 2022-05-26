import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_management_module/auth_services.dart';
import 'package:user_management_module/data/repository.dart';

part 'login_event.dart';
part 'login_state.dart';

AuthServices authServices = AuthServices();

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginRepository loginRepository;

  LoginBloc({required this.loginRepository}) : super(LoginInitial()) {
    on<EmailLoginEvent>(_onEmailLoginEvent);
    on<GoogleLoginEvent>(_onGoogleLoginEvent);
  }

  void _onEmailLoginEvent(EmailLoginEvent event, Emitter<LoginState> emit) async{
    emit(LoginValidating());
    await loginRepository.validate(event.email, event.password).then((value) {
      if(value == "Success"){
        emit(LoggedIn());
      }else{
        authServices.catchError(value);
        emit(LoginFailed());
      }
    });
  }

  void _onGoogleLoginEvent(GoogleLoginEvent event, Emitter emit) async{
    emit(GoogleLoginValidating());
    await authServices.googleSignIn().then((value) {
      print("Value : $value");
      if(value == "Success"){
        emit(LoggedIn());
      }else{
        AuthServices().catchError(value);
        emit(GoogleLoginFailed());
      }
    });
  }
}

