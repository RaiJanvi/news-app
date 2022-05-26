part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();
}

class LoginInitial extends LoginState {
  @override
  List<Object> get props => [];
}

class LoggedIn extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginValidating extends LoginState {
  final String status = "validating";
  @override
  List<Object?> get props => [status];
}

class LoginFailed extends LoginState {
  final String status = "failed";
  @override
  List<Object> get props => [status];
}

class GoogleLoginValidating extends LoginState {
  final String status = "google validating";
  @override
  List<Object?> get props => [status];
}

class GoogleLoginFailed extends LoginState {
  final String status = "google failed";
  @override
  List<Object> get props => [status];
}