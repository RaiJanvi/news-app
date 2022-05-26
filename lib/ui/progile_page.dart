import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/nav2/get_router_delegate.dart';
import 'package:user_management_module/constants/ui_helpers.dart';
import 'package:user_management_module/widgets/top_container.dart';
import 'package:get/get.dart';

///profile page of the user

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);

  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  late String name, email;

  @override
  Widget build(BuildContext context) {
   name = Get.arguments['name'];
   email = Get.arguments['email'];
   print('${Get.arguments['name']}, ${Get.arguments['email']}');
    user = auth.currentUser;
    String initials = name.substring(0,1);
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: TopContainer(title: "Profile", initial: initials,)),
          Expanded(
            flex: 4,
            child: Container(
              margin: EdgeInsets.all(12.0),
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.only(left: 25.0,),
                    title: Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Text("Name",
                        style: Theme.of(context).textTheme.headline4,),
                    ),
                    subtitle: Text(name,
                      style: Theme.of(context).textTheme.headline5,),
                  ),
                  verticalSpaceRegular,
                  ListTile(
                    contentPadding: EdgeInsets.only(left: 25.0,),
                    title: Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Text("Email",
                        style: Theme.of(context).textTheme.headline4,),
                    ),
                    subtitle: Text(email,
                      style: Theme.of(context).textTheme.headline5,),
                  ),
                ],
              ),
            ),)
        ],
      ),
    );
  }
}
