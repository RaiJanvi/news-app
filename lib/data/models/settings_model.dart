import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Settings{
  String title;
  IconData icon;

  Settings(this.title, this.icon);

  static List<Settings> getSettings(){
    return [
      Settings("Account", Icons.person_outline),
      Settings("Notifications", Icons.notifications_outlined),
      Settings("Appearance", Icons.visibility_outlined),
      Settings("About", Icons.info_outline),
    ];
  }
}

