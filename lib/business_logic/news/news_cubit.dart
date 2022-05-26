import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_management_module/data/repository.dart';

import '../../data/models/news.dart';

part 'news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  NewsCubit({required this.repository}) : super(NewsInitial()){
   getNews();
  }

  final Repository repository;

  Future<News?> getNews({bool isRefresh = false, String category = "trending", String? countryCode}) async{
    try{
        repository.fetchNews(isRefresh: isRefresh, category: category, countryCode: countryCode).then((news) {
          if(news.totalResults != 0){
            emit(NewsLoaded(news: news));
          }else{
            emit(NewsNotFound());
          }
          //emit(NewsLoaded(news: news));
        });
    }catch (e){
      print(e);
      emit(NewsError(e.toString()));
    }
    return null;
  }
  refreshNews({String? countryCode}) async{
    try{
      repository.fetchNews(isRefresh: true, countryCode: countryCode).then((news) {
        if(news.totalResults != 0){
          emit(NewsLoaded(news: news));
        }else{
          emit(NewsNotFound());
        }
        //emit(NewsLoaded(news: news));
      });
    }catch (e){
      print(e);
      emit(NewsError(e.toString()));
    }
  }

  noInternet(){
    emit(NoInternet());
  }

}
