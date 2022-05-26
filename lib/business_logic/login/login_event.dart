part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {

  @override
  List<Object> get props => [];
}

class EmailLoginEvent extends LoginEvent {
  final String email, password;

  EmailLoginEvent({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class GoogleLoginEvent extends LoginEvent {
  GoogleLoginEvent();

  @override
  List<Object> get props => [];
}
