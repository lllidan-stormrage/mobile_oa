import 'package:flutter/material.dart';

import 'login/app_login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //初始化sp
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'open eyes',
      home: SplashPage(),
    );
  }
}

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LaunchPage();
}

class _LaunchPage extends State<SplashPage> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
        duration: const Duration(milliseconds: 3000), vsync: this);
    _animation = new Tween(begin: 0.5, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {
          //update
          if (_animation.value >= 1) {
//            Navigator.push(context,
//                new MaterialPageRoute(builder: (context) => LoginPage()));
            Navigator.pushAndRemoveUntil(
              context,
              new MaterialPageRoute(builder: (context) => LoginPage()),
              (route) => route == null,
            );
          }
        });
      });
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _animation?.value ?? 0,
      child: Container(
          child: Image(
        image: AssetImage(
          "images/launch_screen.jpg",
        ),
        fit: BoxFit.cover,
      )),
    );
  }
}
