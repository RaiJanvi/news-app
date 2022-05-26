import 'package:http/http.dart' as http;

import 'models/facts.dart';
import 'models/news.dart';


class APIManager{
  //String category = "trending";
  int pageSize=10;
  late int totalPages;

  News? news;
  List<Facts>? facts;

  Future<News> fetchNews(bool isRefresh , String category, String? countryCode) async{
    try{
      var response;
      if(isRefresh){
        pageSize=10;
      }
      if(countryCode != null){
        response = await http.get(Uri.parse("https://newsapi.org/v2/top-headlines?country=$countryCode&sortBy=publishedAt&pageSize=$pageSize&apiKey=4423f352fc0243aca382a637d627ae97"));
      }else{
        response = await http.get(Uri.parse("https://newsapi.org/v2/everything?q=$category&sortBy=publishedAt&pageSize=$pageSize&apiKey=4423f352fc0243aca382a637d627ae97"));
      }


      if(response.statusCode == 200){
        var newsList = newsFromJson(response.body);
          pageSize += 10;
        print(newsList.totalResults);
        return newsList;
      }else{
        print(response.statusCode);
        return Future.error("Server error");
      }
    }catch(e){
      print(e);
      return Future.error("Error fetching news");
    }
  }
  
  Future fetchFacts() async{
    try{
      var response = await http.get(Uri.parse("https://api.api-ninjas.com/v1/facts?limit=5"),
          headers: {
            'X-Api-Key': 'timqygv5p9UwY0zuTy677A==4htLKhPFZYQHOZKs'
          });

      if(response.statusCode == 200){
        facts = factsFromJson(response.body);
        return facts;
      }else{
        print(response.statusCode);
        return Future.error("Server error");
      }
    }catch(e){
      print(e);
      return Future.error("Error fetching facts");
    }
  }

}


///api key: d2273ca298cf47e79fb42f78bb189fb0
///api key 2: 0073f5130e7048a59736d1005c706f73
///api key 3: 8004011a4343412081417d43e04abb4d
///api key 4: 4423f352fc0243aca382a637d627ae97