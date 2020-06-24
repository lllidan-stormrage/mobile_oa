import 'package:mobileoa/db/dao/sign_dao.dart';
import 'package:mobileoa/model/remake_sign.dart';
import 'package:sqflite/sqflite.dart';
import 'package:mobileoa/constant.dart';
import 'package:mobileoa/db/dbUtil.dart';

class RemakeSignDao {
  static String tabName = Constant.tableReSign;

  //外界入口
  factory RemakeSignDao.getInstance() => _getInstance();

  static RemakeSignDao _instance;

  static Database _database;

  RemakeSignDao._internal() {
    //
  }

  static _getInstance() {
    if (_instance == null) {
      _instance = RemakeSignDao._internal();
    }
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await DbHelperInstance.getInstance().dataBase;
    return _database;
  }

  Map<String, dynamic> toMap(ReMakeSign sign) {
    return {
      "id": sign.id,
      "userId": sign.userId,
      "year": sign.year,
      "month": sign.month,
      "place": sign.place,
      "signTimeStamp": sign.signTimeStamp,
    };
  }

  Future<List<ReMakeSign>> getSignByUser(int useId, int year, int month) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'select * from $tabName where userId= ? and year = ? and month = ? ',
        [useId, year, month]);
    return List.generate(maps.length, (i) {
      return ReMakeSign(
        id: maps[i]['id'],
        userId: maps[i]['userId'],
        year: maps[i]['year'],
        month: maps[i]['month'],
        place: maps[i]['place'],
        signTimeStamp: maps[i]['signTimeStamp'],
      );
    });
  }

  ///  code 0 成功，1失败,2已存在,3时间超前

  Future<int> insertOrUpdateSign(ReMakeSign remake) async {
    // Get a reference to the database (获得数据库引用)
    final Database db = await database;

    //查询当天的签到数据
    var signDate = DateTime.fromMillisecondsSinceEpoch(remake.signTimeStamp);
    var data = await SignDao.getInstance()
        .getSign(remake.userId, remake.year, remake.month, signDate.day);

    //检查收否超过当前时间
    var nowTime = DateTime.now();
    if (signDate.year > nowTime.year) {
      return 3;
    }
    if (signDate.month > nowTime.month) {
      return 3;
    }
    if (signDate.day > nowTime.day) {
      return 3;
    }

    if (data != null && data.isNotEmpty) {
      if (data[0].amIsSign == 1 && data[0].pmIsSign == 1) {
        return 2;
      } else if (data[0].amIsSign == 0) {
        //上午没签到，补上
        data[0].amIsSign = 1;
        data[0].amSignPlace = remake.place;
        data[0].amSignTime =
            '${signDate.hour.toString().padLeft(2, '0')}:${signDate.minute.toString().padLeft(2, '0')}'
            ':${signDate.second.toString().padLeft(2, '0')}';
      } else if (data[0].pmIsSign == 0) {
        //下午没签到，补上
        data[0].pmIsSign = 1;
        data[0].pmSignPlace = remake.place;
        data[0].pmSignTime =
            '${signDate.hour.toString().padLeft(2, '0')}:${signDate.minute.toString().padLeft(2, '0')}'
            ':${signDate.second.toString().padLeft(2, '0')}';
      }
    } else {
      //无记录
      return 1;
    }
    await db.insert(
      tabName,
      toMap(remake),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    //更新sign表
    await SignDao.getInstance().insertOrUpdateSign(data[0]);
    print("reSign:${remake.toString()}");
    print("userSign${remake.toString()}");
    return 0;
  }
}
