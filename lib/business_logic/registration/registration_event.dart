part of 'registration_bloc.dart';

class RegistrationEvent extends Equatable {
  final String email, password, fName;

  const RegistrationEvent({required this.email, required this.password, required this.fName});

  @override
  List<Object?> get props => [email, password, fName];
}
