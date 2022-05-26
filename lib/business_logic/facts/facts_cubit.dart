import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_management_module/data/repository.dart';

import '../../data/models/facts.dart';

part 'facts_state.dart';

class FactsCubit extends Cubit<FactsState> {
  FactsCubit({required this.factsRepository}) : super(FactsInitial()){
    getFacts();
  }

  final FactsRepository factsRepository;

  Future<List<Facts>?>getFacts() async{
    try{
      print("In get Facts");
      factsRepository.fetchFacts().then((facts) {
        print("Facts length ${facts.length}");
        if(facts.length !=0){
          emit(FactsLoaded(facts: facts));
        }else{
          emit(FactsNotFound());
        }
      });
    }catch(e){
      print(e);
      emit(FactsError(e));
    }
    return null;
  }

  noInternet(){
    emit(NoInternet());
  }
}
