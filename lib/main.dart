import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_splash_screen/flutter_splash_screen.dart';

import 'login/app_login.dart';

void main() {
  runApp(MyApp());
  //Flutter沉浸式状态栏
  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //初始化sp
    hideSplashScreen();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'hello meto',
      home: LoginPage(),
    );
  }

  Future<void> hideSplashScreen() async {
    Future.delayed(
        Duration(milliseconds: 2000), () => FlutterSplashScreen.hide());
  }
}
