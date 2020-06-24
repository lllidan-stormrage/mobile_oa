import 'package:flutter/material.dart';
import 'package:mobileoa/db/dao/UserDao.dart';
import 'package:mobileoa/db/dao/sign_dao.dart';
import 'package:mobileoa/model/user.dart';
import 'package:mobileoa/model/user_sign.dart';
import 'package:mobileoa/util/date_util.dart';

///数据脚本，跑数据生成表
class DbScript {
  //默认账户
 static Future<void> insertOrUpdateTableUser() async {
    await UserDao.getInstance().insertUser(new User(
        id: 1,
        name: "admin",
        password: "123456",
        age: 18,
        sex: 1,
        company: "字节跳动"));
    await UserDao.getInstance().insertUser(new User(
        id: 2,
        name: "test",
        password: "123456",
        age: 19,
        sex: 1,
        company: "百度"));
    await UserDao.getInstance().insertUser(new User(
        id: 3,
        name: "xxx",
        password: "123456",
        age: 16,
        sex: 1,
        company: "阿里云"));
    await UserDao.getInstance().insertUser(new User(
        id: 4,
        name: "hello",
        password: "123456",
        age: 28,
        sex: 0,
        company: "蘑菇Joe"));
  }

  //生成一个月的签到表
 static Future<void> insertOrUpdateTableSign(int userId) async {
    var date = DateTime.now();
    int day = DateUtils.getMonthDay(date.year, date.month);
    for (int i = 1; i <= day; i++) {
      await SignDao.getInstance().insertOrUpdateSign(new UserSign(
          userId: userId, year: date.year, month: date.month, day: i,amIsSign: 0,pmIsSign: 0));
    }
  }


}
