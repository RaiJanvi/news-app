part of 'facts_cubit.dart';

abstract class FactsState extends Equatable {
  const FactsState();
}

class FactsInitial extends FactsState {
  @override
  List<Object> get props => [];
}

class FactsLoaded extends FactsState {
  List<Facts?> facts;

  FactsLoaded({required this.facts});

  @override
  List<Object> get props => [facts];
}

class FactsNotFound extends FactsState {

  @override
  List<Object> get props => [];
}

class FactsError extends FactsState {
  final message;

  const FactsError(this.message);

  @override
  List<Object> get props => [message];
}

class NoInternet extends FactsState{

  @override
  List<Object?> get props => [];
}
