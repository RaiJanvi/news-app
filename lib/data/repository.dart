import 'package:user_management_module/auth_services.dart';
import 'package:user_management_module/data/api_manager.dart';

import 'models/facts.dart';
import 'models/news.dart';

class Repository{
  final APIManager apiManager;

  Repository({required this.apiManager});

  Future<News> fetchNews({bool isRefresh = false, String category = "trending", String? countryCode}) async{
    final news = await apiManager.fetchNews(isRefresh, category,countryCode);
    return news;
  }
}

class FactsRepository{
  final APIManager apiManager;

  FactsRepository({required this.apiManager});

  Future<List<Facts>> fetchFacts() async{
    final facts = await apiManager.fetchFacts();
    print(facts?.first.fact);
    return facts;
  }
}

class LoginRepository{
  final AuthServices authServices;

  LoginRepository({required this.authServices});

  Future validate(String email, String password) async{
    String msg = await authServices.login(email, password);
    print("RetString : $msg");
    return msg;
  }
}