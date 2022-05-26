import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_management_module/data/models/settings_model.dart';
import 'package:user_management_module/strings.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({Key? key}) : super(key: key);

  List<Settings> settings = Settings.getSettings();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.settings),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        margin: EdgeInsets.all(20.0),
        child: ListView(
          children: ListTile.divideTiles( //
              context: context,
              tiles: [
              ...settings.map((value) => ListTile(
                contentPadding: EdgeInsets.all(18.0),
                title: Text(value.title, style: TextStyle(fontSize: 15.sp),),
                leading: Icon(value.icon, size: 24.h,),)),
              ]
          ).toList(),
        )
        ),
    );
  }
}
