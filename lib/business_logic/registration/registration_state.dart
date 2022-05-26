part of 'registration_bloc.dart';

abstract class RegistrationState extends Equatable {
  const RegistrationState();
}

class RegistrationInitial extends RegistrationState {
  @override
  List<Object> get props => [];
}

class Registered extends RegistrationState {
  @override
  List<Object> get props => [];
}

class RegistrationValidating extends RegistrationState {
  final String status = "validating";
  @override
  List<Object?> get props => [status];
}

class RegistrationFailed extends RegistrationState {
  final String status = "failed";
  @override
  List<Object> get props => [status];
}