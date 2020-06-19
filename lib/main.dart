import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

import 'login/app_login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //初始化sp
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'hello meto',
        home: SplashScreen(
          seconds: 3,
          title: new Text(
            'Welcome In MobileOA',
            style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
          navigateAfterSeconds: LoginPage(),
          styleTextUnderTheLoader: new TextStyle(),
          image: new Image.network('https://i.imgur.com/TyCSG9A.png'),
          backgroundColor: Colors.white,
          photoSize: 100.0,
        ));
  }
}

