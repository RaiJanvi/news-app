part of 'news_cubit.dart';

abstract class NewsState extends Equatable {
  const NewsState();
}

class NewsInitial extends NewsState {
  @override
  List<Object> get props => [];
}

class NewsLoaded extends NewsState {
  News news;

  NewsLoaded({required this.news});

  @override
  List<Object> get props => [news];
}

class NewsNotFound extends NewsState {
  // News news;
  //
  // NewsNotFound({required this.news});

  @override
  List<Object> get props => [];
}

class NewsError extends NewsState {
  final message;

  const NewsError(this.message);

  @override
  List<Object> get props => [message];
}

class NoInternet extends NewsState{

  @override
  List<Object?> get props => [];
}
