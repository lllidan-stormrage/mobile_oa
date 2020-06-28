import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobileoa/db/dao/user_dao.dart';
import 'package:mobileoa/home/home_tab_page.dart';
import 'package:mobileoa/model/user.dart';
import 'package:mobileoa/util/app_util.dart';
import 'package:mobileoa/util/common_toast.dart';

/// app 登陆
class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginWidget();
}

class _LoginWidget extends State<LoginPage> with TickerProviderStateMixin {
  //文件控制器
  var nameController = new TextEditingController();
  var passController = new TextEditingController();

  //动画控制器
  AnimationController _controller;
  Animation<double> _animation;

  //动画开始值
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
              Navigator.pushAndRemoveUntil(
                context,
                new MaterialPageRoute(
                    builder: (context) => HomeNavigationPage()),
                (route) => route == null,
              );
            });
          }
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.white,
          primaryIconTheme: IconThemeData(color: Colors.white, opacity: 0.7)),
      home: Scaffold(
        body: Stack(
          children: <Widget>[
            Image(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              image: AssetImage("images/login_bg.jpeg"),
                fit: BoxFit.cover,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ClipOval(
                    child: Image(
                      image: AssetImage("images/ic_img_avatar.png"),
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
                    controller: nameController,
                    keyboardType: TextInputType.text,
                    style: TextStyle(color: Colors.white),
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
                    controller: passController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        hintText: '请输入密码',
                        contentPadding: EdgeInsets.all(10),
                        icon: Icon(Icons.lock)),
                    style: TextStyle(color: Colors.white),
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
                                    valueColor: new AlwaysStoppedAnimation<Color>(
                                        Colors.white)),
                              ),
                            ))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        )
      ),
    );
  }

  void _login() async {
    //绑定一个管理员
    UserDao.getInstance().insertUser(new UserEntity(
        id: 1,
        name: "admin",
        password: "123456",
        sex: 1,
        age: 19,
        company: "字节跳动"));

    if (nameController.text.length > 0 && passController.text.length > 0) {
      //db查询
      List<UserEntity> users = await UserDao.getInstance()
          .getUser(nameController.text, passController.text);

      if (users.isNotEmpty &&
          users[0].name == nameController.text &&
          users[0].password == passController.text) {
        print(users[0].toString());
        if (_controller.isAnimating) {
          return;
        }
        AppUtils.saveLoginUserId(users[0].id);
        _controller.forward();
      } else {
        ToastUtils.showError("账户或密码不正确");
      }
    } else {
      ToastUtils.showError("请输入账户和密码");
    }
  }
}
