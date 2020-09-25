import 'package:mobileoa/constant.dart';
import 'package:mobileoa/db/db_util.dart';
import 'package:mobileoa/model/user_sign.dart';
import 'package:sqflite/sqflite.dart';

class SignDao {
  static String tabName = Constant.tableSign;

  //外界入口
  factory SignDao.getInstance() => _getInstance();

  static SignDao _instance;

  static Database _database;

  SignDao._internal() {
    //
  }

  static _getInstance() {
    if (_instance == null) {
      _instance = SignDao._internal();
    }
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await DbHelperInstance.getInstance().dataBase;
    return _database;
  }

  Map<String, dynamic> toMap(UserSignEntity user) {
    return {
      "id": user.id,
      "userId": user.userId,
      "amSignTime": user.amSignTime,
      "amSignPlace": user.amSignPlace,
      "pmSignPlace": user.pmSignPlace,
      "pmSignTime": user.pmSignTime,
      "year": user.year,
      "month": user.month,
      "day": user.day,
      "amIsSign": user.amIsSign,
      "pmIsSign": user.pmIsSign,
    };
  }

  Future<void> updateSign(UserSignEntity user) async {
    // Get a reference to the database (获得数据库引用)
    final db = await database;
    // Update the given Dog (修改给定的狗狗的数据)
    await db.update(
      tabName,
      toMap(user),
      // Ensure that the user has a matching id (确定给定的狗狗id是否匹配)
      where: "id = ?",
      // Pass the user's id as a whereArg to prevent SQL injection (通过 whereArg 传递狗狗的 id 可以防止 SQL 注入)
      whereArgs: [user.id],
    );
  }

  Future<List<UserSignEntity>> getSign(
      int useId, int year, int month, int day) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'select * from $tabName where userId= ? and year = ? and month = ? and day = ?',
        [useId, year, month, day]);
    return List.generate(maps.length, (i) {
      return UserSignEntity(
        id: maps[i]["id"],
        userId: maps[i]['userId'],
        amSignTime: maps[i]['amSignTime'],
        amSignPlace: maps[i]['amSignPlace'],
        pmSignPlace: maps[i]['pmSignPlace'],
        pmSignTime: maps[i]['pmSignTime'],
        year: maps[i]['year'],
        month: maps[i]['month'],
        day: maps[i]['day'],
        amIsSign: maps[i]['amIsSign'],
        pmIsSign: maps[i]['pmIsSign'],
      );
    });
  }

  Future<List<UserSignEntity>> getSignByMonthWithUser(
      int useId, int year, int month) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'select * from $tabName where userId= ? and year = ? and month = ? and (amIsSign = ? or pmIsSign = ?)order by id DESC',
        [useId, year, month, 1, 1]);
    return List.generate(maps.length, (i) {
      bool early = false;
      bool late = false;
      if (maps[i]['pmIsSign'] == 1) {
        String pmTime = maps[i]['pmSignTime'];
        if (int.parse(pmTime.substring(0,2).toString()) <
            Constant.offWorkTime) {
          early = true;
        }
      }

      if (maps[i]['amIsSign'] == 1) {
        String pmTime = maps[i]['amSignTime'];
        if (int.parse(pmTime.substring(0, 2).toString()) >=
            Constant.onWorkTime) {
          late = true;
        }
      }

      return UserSignEntity(
        id: maps[i]["id"],
        userId: maps[i]['userId'],
        amSignTime: maps[i]['amSignTime'],
        amSignPlace: maps[i]['amSignPlace'],
        pmSignPlace: maps[i]['pmSignPlace'],
        pmSignTime: maps[i]['pmSignTime'],
        year: maps[i]['year'],
        month: maps[i]['month'],
        day: maps[i]['day'],
        amIsSign: maps[i]['amIsSign'],
        pmIsSign: maps[i]['pmIsSign'],
        leaveWorkEarly: early,
        workLate: late,
      );
    });
  }

  Future<List<UserSignEntity>> getSignAllByUseId(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.rawQuery('select * from $tabName where id= ?', [id]);
    return List.generate(maps.length, (i) {
      return UserSignEntity(
        id: maps[i]["id"],
        userId: maps[i]['userId'],
        amSignTime: maps[i]['amSignTime'],
        amSignPlace: maps[i]['amSignPlace'],
        pmSignPlace: maps[i]['pmSignPlace'],
        pmSignTime: maps[i]['pmSignTime'],
        year: maps[i]['year'],
        month: maps[i]['month'],
        day: maps[i]['day'],
        amIsSign: maps[i]['amIsSign'],
        pmIsSign: maps[i]['pmIsSign'],
      );
    });
  }

  Future<void> insertOrUpdateSign(UserSignEntity user) async {
    // Get a reference to the database (获得数据库引用)
    final Database db = await database;
    // Insert the Dog into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same dog is inserted
    // multiple times, it replaces the previous data.
    // 在正确的数据表里插入狗狗的数据。我们也要在这个操作中指定 `conflictAlgorithm` 策略。
    // 如果同样的狗狗数据被多次插入，后一次插入的数据将会覆盖之前的数据。

    var data = await getSign(user.userId, user.year, user.month, user.day);
    if (data != null && data.isNotEmpty) {
      user.id = data[0].id;
    }
    await db.insert(
      tabName,
      toMap(user),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //此方法存在则不进行更新，用于脚本执行
  Future<void> insertByScript(UserSignEntity user) async {
    // Get a reference to the database (获得数据库引用)
    final Database db = await database;
    // Insert the Dog into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same dog is inserted
    // multiple times, it replaces the previous data.
    // 在正确的数据表里插入狗狗的数据。我们也要在这个操作中指定 `conflictAlgorithm` 策略。
    // 如果同样的狗狗数据被多次插入，后一次插入的数据将会覆盖之前的数据。

    var data = await getSign(user.userId, user.year, user.month, user.day);
    if (data != null && data.isNotEmpty) {
      return;
    }
    await db.insert(
      tabName,
      toMap(user),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
