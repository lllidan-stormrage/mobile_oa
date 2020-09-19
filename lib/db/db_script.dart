import 'package:flutter/material.dart';
import 'package:mobileoa/db/dao/meeting_room_dao.dart';
import 'package:mobileoa/db/dao/user_dao.dart';
import 'package:mobileoa/db/dao/sign_dao.dart';
import 'package:mobileoa/model/meeting_room.dart';
import 'package:mobileoa/model/user.dart';
import 'package:mobileoa/model/user_sign.dart';
import 'package:mobileoa/util/date_util.dart';

///数据脚本，跑数据生成表
class DbScript {
  //默认账户
  static Future<void> insertOrUpdateTableUser() async {
    await UserDao.getInstance().insertUser(new UserEntity(
        id: 1,
        name: "admin",
        password: "123456",
        age: 18,
        sex: 1,
        phone: "18682901254",
        company: "字节跳动"));
    await UserDao.getInstance().insertUser(new UserEntity(
        id: 2,
        name: "test",
        password: "123456",
        age: 19,
        sex: 1,
        phone: "15882901254",
        company: "字节跳动"));
    await UserDao.getInstance().insertUser(new UserEntity(
        id: 3,
        name: "xxx",
        password: "123456",
        age: 16,
        sex: 1,
        phone: "15682901234",
        company: "字节跳动"));
    await UserDao.getInstance().insertUser(new UserEntity(
        id: 4,
        name: "hello",
        password: "123456",
        age: 28,
        sex: 0,
        phone: "17382901234",
        company: "字节跳动"));
  }

  //插入会议室
  static Future<void> insertOrUpdateTableMeetingRoom() async {
    List<MeetingRoomEntity> rooms = List();
    rooms.add(MeetingRoomEntity(id: 1, floor: 1, name: "上海厅"));
    rooms.add(MeetingRoomEntity(id: 2, floor: 1, name: "武汉厅"));
    rooms.add(MeetingRoomEntity(id: 3, floor: 1, name: "香港厅"));
    rooms.add(MeetingRoomEntity(id: 4, floor: 1, name: "杭州厅"));

    rooms.add(MeetingRoomEntity(id: 5, floor: 2, name: "纽约厅"));
    rooms.add(MeetingRoomEntity(id: 6, floor: 2, name: "洛杉矶厅"));
    rooms.add(MeetingRoomEntity(id: 7, floor: 2, name: "伦敦厅"));
    rooms.add(MeetingRoomEntity(id: 8, floor: 2, name: "巴黎厅"));

    rooms.add(MeetingRoomEntity(id: 9, floor: 3, name: "汉堡厅"));
    rooms.add(MeetingRoomEntity(id: 10, floor: 3, name: "米兰厅"));
    rooms.add(MeetingRoomEntity(id: 11, floor: 3, name: "莫斯科厅"));
    rooms.add(MeetingRoomEntity(id: 12, floor: 3, name: "多伦多厅"));

    rooms.add(MeetingRoomEntity(id: 13, floor: 4, name: "维也纳厅"));
    rooms.add(MeetingRoomEntity(id: 14, floor: 4, name: "新加坡厅"));
    rooms.add(MeetingRoomEntity(id: 15, floor: 4, name: "开普敦厅"));
    rooms.add(MeetingRoomEntity(id: 16, floor: 4, name: "布鲁塞尔厅"));
    for (int i = 0; i < rooms.length; i++) {
      int result = await MeetingRoomDao.getInstance().insertByScript(rooms[i]);
      if(result == 1){
        //已经存在就不要执行了
        break;
      }
    }
  }

  //生成一个月的签到表
  static Future<void> insertOrUpdateTableSign(int userId) async {
    var date = DateTime.now();
    int day = DateUtils.getMonthDay(date.year, date.month);
    for (int i = 1; i <= day; i++) {
      await SignDao.getInstance().insertByScript(new UserSignEntity(
          userId: userId,
          year: date.year,
          month: date.month,
          day: i,
          amIsSign: 0,
          pmIsSign: 0));
    }
  }
}
