import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobileoa/db/dao/UserDao.dart';
import 'package:mobileoa/db/dao/sign_dao.dart';
import 'package:mobileoa/model/user.dart';
import 'package:mobileoa/model/user_sign.dart';
import 'package:mobileoa/util/app_util.dart';
import 'package:mobileoa/util/date_util.dart';

class SignPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignView();
}

class _SignView extends State<SignPage> {
  String timeStamp = '';
  DateTime date;
  User mUser = new User();
  bool isCallTimeState = false; //计时器是否setState
  bool xDispose = false;
  UserSign userSign = new UserSign();

  @override
  void initState() {
    _getDefaultData();
    _getDate();
    super.initState();
  }

  _getDefaultData() async {
    int id = await AppUtils.getLoginUserId();
    List<User> user = await UserDao.getInstance().getUserById(id);
    if (user.isNotEmpty) {
      mUser = user[0];
    }
    // 查询用户是有签到过
    var date = new DateTime.now();
    var singInfo = await SignDao.getInstance()
        .getSign(id, date.year, date.month, date.day);
    if (singInfo == null || singInfo.isEmpty) {
      print('111empty');
      userSign = new UserSign(
          userId: id,
          year: date.year,
          month: date.month,
          day: date.day,
          amIsSign: 0,
          amSignTime: "",
          amSignPlace: "",
          pmIsSign: 0,
          pmSignPlace: "",
          pmSignTime: "");
      SignDao.getInstance().insertSign(userSign);
    } else {
      userSign = singInfo[0];
    }
    print('aaa${userSign.toString()}');
    List<UserSign> lists = await SignDao.getInstance().getSignAllByUseId(id);
    print("bbbb${lists.length}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          mUser.company != null ? mUser.company : "",
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 15, top: 15),
                  child: Row(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.transparent,
                        backgroundImage: AssetImage("images/ic_img_avatar.png"),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        mUser.name != null ? mUser.name : "",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 15, top: 15),
                  child: Text(
                    DateUtils.getYYMMDD(),
                    style: TextStyle(fontSize: 14, color: Color(0xff87898C)),
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 15),
              child: Divider(
                height: 1,
                color: Colors.blueGrey,
              ),
            ),
            Container(
                padding: EdgeInsets.all(15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        _buildLine(true),
                        Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(5)),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: _buildSign(
                                userSign.amIsSign == 1 ? true : false,
                                "上班时间 9：00",
                                time: userSign.amSignTime,
                                location: userSign.amSignPlace)),
                        SizedBox(
                          height: 70,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: _buildSign(
                              userSign.pmIsSign == 1 ? true : false,
                              "下班时间 18：00",
                              time: userSign.pmSignTime,
                              location: userSign.pmSignPlace),
                        )
                      ],
                    )
                  ],
                )),
            Padding(
              padding: EdgeInsets.only(top: 50),
              child: _buildButton(),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLine(bool visible) {
    return Container(
      width: visible ? 1.0 : 0.0,
      height: 150.0,
      color: Colors.grey.shade400,
    );
  }

  Widget _buildSign(bool visible, String title,
      {String time = "00：00", String location = "测试"}) {
    return Container(
      height: 85,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title),
          Container(
            padding: EdgeInsets.only(top: 2),
            width: visible ? 300 : 0.0,
            height: visible ? 60 : 0.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "打卡时间 $time",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 2,
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.location_on,
                      color: Colors.green,
                    ),
                    Text(
                      location == null ? "测试地址" : location,
                      style: TextStyle(color: Color(0xff87898C), fontSize: 14),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildButton() {
    return GestureDetector(
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(60),
            gradient: LinearGradient(
                colors: [Colors.lightBlue, Colors.blue],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child: Stack(
          alignment: Alignment(0, 0),
          children: <Widget>[
            Positioned(
              top: 37,
              child: Text(
                userSign.amIsSign == 0 ? "上班打卡" : "下班打卡",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            Positioned(
              bottom: 37,
              child: Text(timeStamp,
                  style: TextStyle(color: Colors.white70, fontSize: 14)),
            )
          ],
        ),
      ),
      onTap: () {
        setState(() {
          if (userSign.amIsSign == 0) {
            //上午签到
            userSign.amSignTime = timeStamp;
            userSign.amSignPlace = "上海东方体育中心";
            userSign.amIsSign = 1;
          } else {
            //下午签到
            userSign.pmSignTime = timeStamp;
            userSign.pmSignPlace = "上海东方体育中心";
            userSign.pmIsSign = 1;
          }
          SignDao.getInstance().insertSign(userSign);
        });
      },
    );
  }

  _getDate() {
    //释放，防止内存leak out
    if (xDispose) {
      return;
    }
    date = DateTime.now();
    if (isCallTimeState) {
      timeStamp =
          '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}';
    } else {
      setState(() {
        timeStamp =
            '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}';
      });
    }
    Future.delayed(Duration(seconds: 1), () {
      _getDate();
    });
  }

  @override
  void dispose() {
    xDispose = true;
    super.dispose();
  }
}
