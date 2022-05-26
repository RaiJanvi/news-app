import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:user_management_module/business_logic/facts/facts_cubit.dart';
import 'package:user_management_module/business_logic/internet/internet_cubit.dart';
import 'package:user_management_module/constants/ui_helpers.dart';
import 'package:user_management_module/ui/home_page.dart';
import 'package:user_management_module/widgets/no_internet_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../strings.dart';

///to display random

class DidYouKnowPage extends StatefulWidget {
  const DidYouKnowPage({Key? key}) : super(key: key);

  @override
  State<DidYouKnowPage> createState() => _DidYouKnowPageState();
}

class _DidYouKnowPageState extends State<DidYouKnowPage> {
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocListener<InternetCubit, InternetState>(
      listener: (context, state) {
        if (state is InternetConnected) {
          BlocProvider.of<FactsCubit>(context).getFacts();
        } else if (state is InternetDisconnected) {
          BlocProvider.of<FactsCubit>(context).noInternet();
        }
      },
      child: Scaffold(
        backgroundColor: primaryC,
        body: Column(
          children: [
            Expanded(
                flex: 3,
                child: Container(
                  //color: Colors.indigo,
                  padding: EdgeInsets.only(top: 30.0.h, left: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: const Icon(Icons.arrow_back_ios)),
                      verticalSpaceRegular,
                      Center(
                        child: Text(
                          Strings.dyk,
                          style: GoogleFonts.bebasNeue(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 55.sp,
                                color: Colors.amber),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            Expanded(
              flex: 7,
              child: BlocBuilder<FactsCubit, FactsState>(
                builder: (context, state) {
                  if (state is FactsInitial) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is FactsLoaded) {
                    return Column(
                      children: [
                        Expanded(
                          flex: 3,
                          child: SmartRefresher(
                            controller: _refreshController,
                            onRefresh: () {
                              if (HomePageState.internet) {
                                BlocProvider.of<FactsCubit>(context).getFacts();
                              } else {
                                BlocProvider.of<FactsCubit>(context).noInternet();
                              }
                              _refreshController.refreshCompleted();
                            },
                            child: CarouselSlider.builder(
                              itemCount: 5,
                              options: CarouselOptions(
                                aspectRatio: 1.1,
                                enlargeCenterPage: true,
                                scrollDirection: Axis.horizontal,
                                enableInfiniteScroll: false,
                                onPageChanged: (index, change){
                                  setState(() {
                                    _currentIndex = index;
                                  });
                                }
                                //autoPlay: true,
                              ),
                              itemBuilder: (context, itemIndex, pageIndex) {
                                return Card(
                                  elevation: 10.0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 25.0.h),
                                    height: MediaQuery.of(context).size.height * 0.5,
                                    width: MediaQuery.of(context).size.width * 0.85,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      image: const DecorationImage(
                                        image: AssetImage('assets/images/questionMark.png'),
                                        opacity: 0.2,
                                      ),
                                    ),
                                    child: Center(
                                      child: SingleChildScrollView(
                                        child: Text(
                                          state.facts[itemIndex]!.fact,
                                          style: GoogleFonts.bitter(
                                            textStyle: TextStyle(fontSize: 28.sp, //letterSpacing: 2.0
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for(int i = 0; i < 5; i++)
                                  Container(
                                      height: 10, width: (_currentIndex == i)? 18 : 10,
                                      margin: EdgeInsets.all(2.0.w),
                                      decoration: BoxDecoration(
                                          color: i == _currentIndex ? Colors.amber : Colors.grey,
                                          borderRadius: BorderRadius.circular(5)
                                      )
                                  )
                              ]
                          ),
                        )
                      ],
                    );
                  } else if (state is FactsNotFound) {
                    print("no facts");
                    return Center(
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.newspaper,
                              size: 100.h,
                              color: Colors.grey,
                            ),
                            Text(
                              Strings.noFacts,
                              style: TextStyle(
                                  fontWeight: Theme.of(context).textTheme.headline5?.fontWeight,
                                  fontSize: Theme.of(context).textTheme.headline5?.fontSize,
                                  color: Colors.grey),
                            )
                          ],
                        ),
                      ),
                    );
                  } else if (state is FactsError) {
                    return Text(Strings.errFacts);
                  } else if (state is NoInternet) {
                    print("no internet");
                    return noInternetConnection(context);
                  } else {
                    return Text(Strings.errFacts);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
