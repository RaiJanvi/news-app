import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:intl/intl.dart';
import 'package:user_management_module/data/lists.dart';
import 'package:user_management_module/strings.dart';
import 'package:user_management_module/ui/home_page.dart';
import 'package:user_management_module/widgets/news_card.dart';
import 'package:user_management_module/widgets/no_internet_widget.dart';
import '../business_logic/news/news_cubit.dart';
import '../constants/ui_helpers.dart';
import '../data/models/news.dart';

class NewsFeedPage extends StatefulWidget {
  NewsFeedPage({Key? key, this.countryCode,}) : super(key: key);

  String? countryCode;
  @override
  State<NewsFeedPage> createState() => _NewsFeedPageState();
}

class _NewsFeedPageState extends State<NewsFeedPage> {
  News? news;

  final RefreshController refreshController = RefreshController(initialRefresh: false);

  int selectedCategory = 1;
  ScrollController _scrollController = ScrollController();

  _scrollToTop() {
    _scrollController.animateTo(_scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 1000), curve: Curves.easeIn);
    //setState(() => _isOnTop = true);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
          children: [
            Expanded(
              flex: 1,
              child: horizontalList()),
            Expanded(
              flex: 11,
              child: customCard(),
            ),
          ],
        );
  }

  //horizontal list to display news categories
  Widget horizontalList(){
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index){
          return Row(
            children: [
              ChoiceChip(
                label: Text(categories[index]),
                selected: selectedCategory == index,
                shape: StadiumBorder(side: BorderSide(color: Theme.of(context).primaryColor)),
                backgroundColor: Colors.transparent,
                selectedColor: primaryC,
                labelStyle: TextStyle(
                  color: (selectedCategory==index)? Colors.white : Colors.black,
                ),
                onSelected: (bool value){
                  setState(() {
                    selectedCategory = index;
                  });
                  BlocProvider.of<NewsCubit>(context).getNews(isRefresh: false, countryCode: null, category: categories[index]);
                },),
              horizontalSpaceTiny,
            ],
          );
        });
  }

  //card displaying news
  Widget customCard() {
    return BlocBuilder<NewsCubit, NewsState>(
      builder: (context, state) {
        if (state is NewsInitial) {
          print("LOADING");
          return const Center(child: CircularProgressIndicator());
        } else if (state is NewsLoaded) {
          print("LOADED");
          news = state.news;
          return SmartRefresher(
            controller: refreshController,
            enablePullUp: true,
            //enablePullDown: false,
            onRefresh: () {
              BlocProvider.of<NewsCubit>(context).refreshNews(countryCode: widget.countryCode);
              print("REFRESHING");
              refreshController.refreshCompleted();
            },
            onLoading: () {
              BlocProvider.of<NewsCubit>(context).getNews(countryCode: widget.countryCode);
              print("LOADING");
              refreshController.loadComplete();
            },
            child: ListView.builder(
              controller: _scrollController,
                itemCount: news?.articles.length,
                itemBuilder: (context, index) {
                  var article = news?.articles[index];
                  var date = article?.publishedAt;
                  final DateFormat dateFormat = DateFormat('dd-mm-yyyy');
                  String fDate = dateFormat.format(date!);
                  return GestureDetector(
                    onTap: (){Get.toNamed('description', arguments: {'news': news!.articles[index], 'isBookmarked': false});},
                    child: NewsCard(article: article),
                  );
                }),
          );
        }else if(state is NewsNotFound){
          print("no news");
          return Center(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.newspaper, size: 100.h, color: Colors.grey,),
                  Text(Strings.noNews, style: TextStyle(
                    fontWeight: Theme.of(context).textTheme.headline5?.fontWeight,
                    fontSize: Theme.of(context).textTheme.headline5?.fontSize,
                    color: Colors.grey
                  ),)],
              ),
            ),
          );
        }else if(state is NoInternet){
          print("no internet");
          return noInternetConnection(context);
        } else if(state is NewsError){
          return Text(Strings.errNews);
        } else {
          return Text(Strings.errNews);
        }
      },
    );
  }
}
