import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_splash_screen/flutter_splash_screen.dart';
import 'package:mobileoa/db/db_script.dart';
import 'package:mobileoa/home/home_page.dart';
import 'package:mobileoa/util/app_util.dart';

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

  var mUserId = 0;

  @override
  Widget build(BuildContext context) {
    //初始化sp
    hideSplashScreen();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'hello meto',
      home: mUserId > 0 ? HomePage() : LoginPage(),
    );
  }

  Future<void> hideSplashScreen() async {
    mUserId = await AppUtils.getLoginUserId();
    Future.delayed(
        Duration(milliseconds: 2000), () => FlutterSplashScreen.hide());
    DbScript.insertOrUpdateTableUser();
  }
}
