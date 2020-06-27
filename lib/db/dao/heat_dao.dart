import 'package:mobileoa/constant.dart';
import 'package:mobileoa/db/db_util.dart';
import 'package:mobileoa/model/appoint_entity.dart';
import 'package:mobileoa/model/heat_entity.dart';
import 'package:sqflite/sqflite.dart';

class HeatDao {
  static String tabName = Constant.tableHeat;

  //外界入口
  factory HeatDao.getInstance() => _getInstance();

  static HeatDao _instance;

  static Database _database;

  HeatDao._internal() {
    //
  }

  static _getInstance() {
    if (_instance == null) {
      _instance = HeatDao._internal();
    }
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await DbHelperInstance.getInstance().dataBase;
    return _database;
  }

  Map<String, dynamic> toMap(HeatEntity heat) {
    return {
      "id": heat.id,
      "userId": heat.userId,
      "amHeat": heat.amHeat,
      "pmHeat": heat.pmHeat,
      "createTime": heat.createTime,
      "year": heat.year,
      "month": heat.month,
      "day": heat.day,
      "state":heat.state,
    };
  }

  Future<List<HeatEntity>> getHeatsByUserId(int userId) async {
    final db = await database;
    List<Map<String, dynamic>> maps =
        await db.rawQuery('select * from $tabName where userId = ?', [userId]);

    return List.generate(maps.length, (i) {
      return HeatEntity(
          id: maps[i]["id"],
          userId: maps[i]["userId"],
          createTime: maps[i]["createTime"],
          amHeat: maps[i]["amHeat"],
          pmHeat: maps[i]["pmHeat"],
          year: maps[i]["year"],
          month: maps[i]["month"],
          day: maps[i]["day"],
          state: maps[i]["state"]);
    });
  }

  Future<List<HeatEntity>> getHeatsByUserIdAndDay(
      int userId, int year, int month, int day) async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.rawQuery(
        'select * from $tabName where userId = ? and year = ? and month = ? and day = ?',
        [userId, year, month, day]);

    return List.generate(maps.length, (i) {
      return HeatEntity(
        id: maps[i]["id"],
        userId: maps[i]["userId"],
        createTime: maps[i]["createTime"],
        amHeat: maps[i]["amHeat"],
        pmHeat: maps[i]["pmHeat"],
        year: maps[i]["year"],
        month: maps[i]["month"],
        day: maps[i]["day"],
        state: maps[i]["state"],
      );
    });
  }

  Future<int> insertOrUpdateAppointment(HeatEntity heat) async {
    // Get a reference to the database (获得数据库引用)
    final Database db = await database;
    //判断会议此期间是否被使用
    var dataList = await getHeatsByUserIdAndDay(
        heat.userId, heat.year, heat.month, heat.day);
    if (dataList.isNotEmpty && dataList.length > 0) {
      print(
          "find data length = ${dataList.length}/// ${dataList[0].toString()}");
      heat.id = dataList[0].id;
    }
    await db.insert(
      tabName,
      toMap(heat),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return 0;
  }
}
