import 'package:mobileoa/constant.dart';
import 'package:mobileoa/db/db_util.dart';
import 'package:mobileoa/model/meeting_room.dart';
import 'package:mobileoa/model/user_sign.dart';
import 'package:sqflite/sqflite.dart';

class MeetingRoomDao {
  static String tabName = Constant.tableMeetingRoom;

  //外界入口
  factory MeetingRoomDao.getInstance() => _getInstance();

  static MeetingRoomDao _instance;

  static Database _database;

  MeetingRoomDao._internal() {
    //
  }

  static _getInstance() {
    if (_instance == null) {
      _instance = MeetingRoomDao._internal();
    }
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await DbHelperInstance.getInstance().dataBase;
    return _database;
  }

  Map<String, dynamic> toMap(MeetingRoomEntity room) {
    return {
      "id": room.id,
      "floor": room.floor,
      "name": room.name,
    };
  }

  Future<List<MeetingRoomEntity>> getRoom(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.rawQuery('select * from $tabName where id= ?', [id]);
    return List.generate(maps.length, (i) {
      return MeetingRoomEntity(
        id: maps[i]["id"],
        name: maps[i]["name"],
        floor: maps[i]['floor'],
      );
    });
  }

  Future<List<MeetingRoomEntity>> getRooms() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tabName,orderBy: "floor DESC");
    return List.generate(maps.length, (i) {
      return MeetingRoomEntity(
        id: maps[i]["id"],
        name: maps[i]["name"],
        floor: maps[i]['floor'],
      );
    });
  }


  //此方法存在则不进行更新，用于脚本执行
  Future<int> insertByScript(MeetingRoomEntity roomEntity) async {
    final Database db = await database;
    var data = await getRoom(roomEntity.id);
    if (data != null && data.isNotEmpty) {
      return 1;
    }
    await db.insert(
      tabName,
      toMap(roomEntity),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return 0;
  }
}
