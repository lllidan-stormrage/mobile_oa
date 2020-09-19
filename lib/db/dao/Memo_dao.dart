import 'package:mobileoa/model/memo.dart';
import 'package:sqflite/sqflite.dart';

import '../../constant.dart';
import '../db_util.dart';

class MemoDao {
  static String tabName = Constant.tableMemo;

  factory MemoDao.getInstance() => _getInstance();

  static MemoDao _instance;
  static Database _database;

  MemoDao._internal() {
    //
  }

  static _getInstance() {
    if (_instance == null) {
      _instance = MemoDao._internal();
    }
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await DbHelperInstance.getInstance().dataBase;
    return _database;
  }

  Map<String, dynamic> toMap(MemoEntity memo) {
    return {
      "id": memo.id,
      "title": memo.title,
      "desc": memo.desc,
      "isOver": memo.isOver,
      "year": memo.year,
      "month": memo.month,
      "day": memo.day,
      "userId": memo.userId,
    };
  }

  Future<List<MemoEntity>> getRecordById(int userId, int recordId) async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.rawQuery(
        'select * from $tabName where userId = ? and id = ?', [userId, recordId]);
    return List.generate(maps.length, (i) {
      return MemoEntity(
        id: maps[i]['id'],
        title: maps[i]['title'],
        desc: maps[i]['desc'],
        userId: maps[i]['userId'],
        isOver: maps[i]['isOver'],
        year: maps[i]['year'],
        month: maps[i]['month'],
        day: maps[i]['day'],
      );
    });
  }

  Future<List<MemoEntity>> getRecords(int userId, int year,
      {int month = 0, int day = 0}) async {
    final db = await database;
    List<Map<String, dynamic>> maps;
    if (month > 0) {
      maps = await db.rawQuery(
          'select * from $tabName where year = ? and month = ? and userId = ?',
          [year, month, userId]);
    } else {
      maps = await db.rawQuery(
          'select * from $tabName where year = ? and userId = ?',
          [year, userId]);
    }

    return List.generate(maps.length, (i) {
      return MemoEntity(
        id: maps[i]['id'],
        userId: maps[i]['userId'],
        title: maps[i]['title'],
        desc: maps[i]['desc'],
        isOver: maps[i]['isOver'],
        year: maps[i]['year'],
        month: maps[i]['month'],
        day: maps[i]['day'],
      );
    });
  }

  Future<int> insert(MemoEntity memo) async {
    // Get a reference to the database (获得数据库引用)
    final Database db = await database;
    // Insert the Dog into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same dog is inserted
    // multiple times, it replaces the previous data.
    // 在正确的数据表里插入狗狗的数据。我们也要在这个操作中指定 `conflictAlgorithm` 策略。
    // 如果同样的狗狗数据被多次插入，后一次插入的数据将会覆盖之前的数据。
    await db.insert(
      tabName,
      toMap(memo),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> modify(MemoEntity memo) async {
    // Get a reference to the database (获得数据库引用)
    final Database db = await database;
    // Insert the Dog into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same dog is inserted
    // multiple times, it replaces the previous data.
    // 在正确的数据表里插入狗狗的数据。我们也要在这个操作中指定 `conflictAlgorithm` 策略。
    // 如果同样的狗狗数据被多次插入，后一次插入的数据将会覆盖之前的数据。
    await db.insert(
      tabName,
      toMap(memo),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
