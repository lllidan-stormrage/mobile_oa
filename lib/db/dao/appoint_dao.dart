import 'package:mobileoa/constant.dart';
import 'package:mobileoa/db/db_util.dart';
import 'package:mobileoa/model/appoint_entity.dart';
import 'package:sqflite/sqflite.dart';

class AppointmentDao {
  static String tabName = Constant.tableAppointment;

  //外界入口
  factory AppointmentDao.getInstance() => _getInstance();

  static AppointmentDao _instance;

  static Database _database;

  AppointmentDao._internal() {
    //
  }

  static _getInstance() {
    if (_instance == null) {
      _instance = AppointmentDao._internal();
    }
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await DbHelperInstance.getInstance().dataBase;
    return _database;
  }

  Map<String, dynamic> toMap(MeetingAppointmentEntity appoint) {
    return {
      "id": appoint.id,
      "appointUseId": appoint.appointUseId,
      "year": appoint.year,
      "day": appoint.day,
      "month": appoint.month,
      "startTime": appoint.startTime,
      "endTime": appoint.endTime,
      "meetingTitle": appoint.meetingTitle,
      "meetingDesc": appoint.meetingDesc,
      "roomId": appoint.roomId,
      'appointUserName': appoint.appointUserName,
      'roomName': appoint.roomName,
    };
  }

  Future<List<MeetingAppointmentEntity>> getAppointmentsByMonth(
      int year, int month, int userId) async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.rawQuery(
        'select  * from $tabName where year= ? and month = ? and appointUseId =? order by startTime DESC',
        [year, month, userId]);
    return List.generate(maps.length, (i) {
      return MeetingAppointmentEntity(
        id: maps[i]["id"],
        appointUseId: maps[i]["appointUseId"],
        year: maps[i]["year"],
        month: maps[i]["month"],
        day: maps[i]["day"],
        startTime: maps[i]["startTime"],
        endTime: maps[i]["endTime"],
        meetingDesc: maps[i]["meetingDesc"],
        meetingTitle: maps[i]["meetingTitle"],
        roomId: maps[i]["roomId"],
        appointUserName: maps[i]['appointUserName'],
        roomName: maps[i]['roomName'],
      );
    });
  }

  Future<List<MeetingAppointmentEntity>> getAppointments(
      int year, int month, int day, int roomId,
      {int userId}) async {
    final db = await database;
    List<Map<String, dynamic>> maps;
    if (userId != null) {
      maps = await db.rawQuery(
          'select * from $tabName where year = ? and month = ? and day = ? and roomId = ? and appointUseId = ?',
          [year, month, day, roomId, userId]);
    } else {
      maps = await db.rawQuery(
          'select * from $tabName where year = ? and month = ? and day = ? and roomId = ?',
          [year, month, day, roomId]);
    }
    return List.generate(maps.length, (i) {
      return MeetingAppointmentEntity(
        id: maps[i]["id"],
        appointUseId: maps[i]["appointUseId"],
        year: maps[i]["year"],
        month: maps[i]["month"],
        day: maps[i]["day"],
        startTime: maps[i]["startTime"],
        endTime: maps[i]["endTime"],
        meetingDesc: maps[i]["meetingDesc"],
        meetingTitle: maps[i]["meetingTitle"],
        roomId: maps[i]["roomId"],
        appointUserName: maps[i]['appointUserName'],
        roomName: maps[i]['roomName'],
      );
    });
  }

  Future<int> insertOrUpdateAppointment(
      MeetingAppointmentEntity appointment) async {
    // Get a reference to the database (获得数据库引用)
    final Database db = await database;
    //判断会议此期间是否被使用

    var dataList = await getAppointments(appointment.year, appointment.month,
        appointment.day, appointment.roomId);
    if (dataList.isNotEmpty && dataList.length > 0) {
      //开始时间不在会议预约记录里
      for (int i = 0; i < dataList.length; i++) {
        if (Comparable.compare(appointment.startTime, dataList[i].startTime) >=
                0 &&
            Comparable.compare(appointment.startTime, dataList[i].endTime) <=
                0) {
          return 1;
        }
      }
    }
    await db.insert(
      tabName,
      toMap(appointment),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return 0;
  }
}
