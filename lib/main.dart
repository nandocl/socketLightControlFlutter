import 'package:flutter/material.dart';

//Pages
import 'package:front/src/pages/login.page.dart';
import 'package:front/src/pages/menu.page.dart';
import 'package:front/src/pages/luz.page.dart';
import 'package:front/src/pages/settings.page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Socket light',
      initialRoute: 'home',
      routes: {
        'home': (BuildContext context) => LoginPage(),
        'menu': (BuildContext context) => MenuPage(),
        'luzRoute': (BuildContext context) => LuzPage(),
        'settingsRoute': (BuildContext context) => SettingsPage(),
      },
    );
  }
}
