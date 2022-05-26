import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:user_management_module/auth_services.dart';
import 'package:user_management_module/business_logic/facts/facts_cubit.dart';
import 'package:user_management_module/business_logic/internet/internet_cubit.dart';
import 'package:user_management_module/business_logic/login/login_bloc.dart';
import 'package:user_management_module/business_logic/news/news_cubit.dart';
import 'package:user_management_module/data/api_manager.dart';
import 'package:user_management_module/data/drift/drift_database.dart';
import 'package:user_management_module/data/repository.dart';
import 'package:user_management_module/ui/bookmarks.dart';
import 'package:user_management_module/ui/did_you_know_page.dart';
import 'package:user_management_module/ui/downloads_page.dart';
import 'package:user_management_module/ui/forgot_password.dart';
import 'package:user_management_module/ui/home_page.dart';
import 'package:user_management_module/ui/location_news_page.dart';
import 'package:user_management_module/ui/login_page.dart';
import 'package:user_management_module/ui/news_description.dart';
import 'package:user_management_module/ui/onboarding_page.dart';
import 'package:user_management_module/ui/progile_page.dart';
import 'package:user_management_module/ui/registration_page.dart';
import 'package:user_management_module/ui/settings_page.dart';
import 'package:user_management_module/ui/splash_screen.dart';

class MyApp extends StatefulWidget {
  const MyApp({
    Key? key, required this.connectivity
  }) : super(key: key);

  final Connectivity connectivity;

  static var db;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final dbFolder;

  late final file;

  @override
  void initState() {
    super.initState();
    getDBPath();
  }

  //initialize local database and set path for it.
  getDBPath() async{
    dbFolder = await getApplicationDocumentsDirectory();
    file = File(join(dbFolder.path, 'db.sqlite'));
    print("File: $file");
    MyApp.db = AppDatabase(NativeDatabase(file, logStatements: true));
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Repository repository = Repository(apiManager: APIManager());
    FactsRepository factsRepository = FactsRepository(apiManager: APIManager());
    LoginRepository loginRepository = LoginRepository(authServices: AuthServices());

    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      builder: () => MultiBlocProvider(
        providers: [
          BlocProvider<InternetCubit>(
              create: (context) => InternetCubit(connectivity: widget.connectivity)),
          BlocProvider<NewsCubit>(
            create: (context) => NewsCubit(repository: repository),
          ),
          BlocProvider<FactsCubit>(
            create: (context) => FactsCubit(factsRepository: factsRepository),
          ),
          BlocProvider<LoginBloc>(
            create: (context) => LoginBloc(loginRepository: loginRepository),
          ),
        ],
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.indigo,
            textTheme: TextTheme(
              //for home page
              headline1: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w400, color: Colors.white),
              headline2: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold,),
              headline3: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold,),
              //for profile page
              headline4: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold,),
              headline5: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w400,),
            ),
            pageTransitionsTheme: const PageTransitionsTheme(builders: {
              TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            }),
          ),
          getPages: [
            GetPage(name: '/', page: () => SplashScreenPage()),
            GetPage(name: '/onBoarding', page: () => OnBoardingPage()),
            GetPage(name: '/home', page: () => HomePage()),
            GetPage(name: '/login', page: () => LoginPage()),
            GetPage(name: '/register', page: () => RegistrationPage()),
            GetPage(name: '/forgotPsw', page: () => ForgotPassword()),
            GetPage(name: '/profile', page: () => ProfilePage()),
            GetPage(name: '/description', page: () => NewsDescription()),
            GetPage(name: '/settings', page: () => SettingsPage()),
            GetPage(name: '/facts', page: () => DidYouKnowPage()),
            GetPage(name: '/bookmarks', page: () => BookMarks()),
            GetPage(name: '/downloads', page: () => DownloadsPage()),
          ],
        ),
      ),
    );
  }
}
