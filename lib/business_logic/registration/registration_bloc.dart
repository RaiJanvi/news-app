import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_management_module/auth_services.dart';

part 'registration_event.dart';
part 'registration_state.dart';

AuthServices authServices = AuthServices();

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  RegistrationBloc() : super(RegistrationInitial()) {
    on<RegistrationEvent>(_onRegistrationEvent);
  }

  _onRegistrationEvent(RegistrationEvent event, Emitter emit) async{
    emit(RegistrationValidating());
    await authServices.register(event.email, event.password, event.fName).then((value) {
      if(value == "Success"){
        emit(Registered());
      }else{
        authServices.catchError(value);
        emit(RegistrationFailed());
      }
    });
  }
}
