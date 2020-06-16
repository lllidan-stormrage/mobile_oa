import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobileoa/home/homePage.dart';
import 'package:mobileoa/widget/cricle_path.dart';

/// app 登陆
class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.white,
          primaryIconTheme: IconThemeData(color: Colors.white, opacity: 0.7)),
      home: _LoginHome(),
    );
  }
}

class _LoginHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginWidget();
}

class _LoginWidget extends State<_LoginHome> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;
  var begin = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);
    _animation = new Tween(begin: begin, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {
          //update
          if (_animation.value >= 1) {
            //延时2s跳转
            Future.delayed(Duration(seconds: 2), () {
              Navigator.of(context).push(PageRouteBuilder(pageBuilder:
                  (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) {
                return AnimatedBuilder(
                  animation: animation,
                  builder: (context, child) {
                    return ClipPath(
                      clipper: CirclePath(animation.value),
                      child: child,
                    );
                  },
                  child: HomePage(),
                );
              }));
            });
          }
        });
      });

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/login_bg.jpeg"), fit: BoxFit.cover)),
        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ClipOval(
              child: Image(
                image: NetworkImage(
                    'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                width: 90,
                height: 90,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              maxLines: 1,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: '请输入用户名',
                contentPadding: EdgeInsets.all(10),
                icon: Icon(Icons.person),
//                  enabledBorder: UnderlineInputBorder(
//                    borderSide: BorderSide(color: Colors.orange),
//              ),focusedBorder: UnderlineInputBorder(
//                borderSide: BorderSide(color: Colors.red),
//              )
              ),
              autofocus: false,
              cursorColor: Colors.white,
            ),
            TextField(
              maxLines: 1,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  hintText: '请输入密码',
                  contentPadding: EdgeInsets.all(10),
                  icon: Icon(Icons.lock)),
              autofocus: false,
              obscureText: true,
              cursorColor: Colors.white,
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: 200,
              height: 40,
              child: Stack(
                alignment: Alignment(0, 0),
                children: <Widget>[
                  Positioned(
                    width: 200 - _animation.value * 160,
                    child: RaisedButton(
                      child: Text(
                        _animation.value > begin ? "" : "登陆",
                        style: TextStyle(fontSize: 15),
                      ),
                      color: Color.fromRGBO(231, 37, 68, 1),
                      textColor: Colors.white,
                      onPressed: () {
                        _login();
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  Positioned(
                      child: Offstage(
                    offstage: _animation.value >= 1.0 ? false : true,
                    child: Container(
                      width: 23,
                      height: 23,
                      child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              new AlwaysStoppedAnimation<Color>(Colors.white)),
                    ),
                  ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _login() {
    if (_controller.isAnimating) {
      return;
    }
    _controller.forward();
  }
}
