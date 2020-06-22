
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


/// db 辅助类
class DbHelperInstance {

  static final _dataBaseName = "MobileOA.db";

  static final _databaseVersion = 1;

  static Database _database;


  factory DbHelperInstance.getInstance() => _getInstance();

  static DbHelperInstance _instance;

  DbHelperInstance._internal() {
    //内部初始化
  }

  static _getInstance() {
    if (_instance == null) {
      _instance = new DbHelperInstance._internal();
    }
    return _instance;
  }

  Future<Database> get dataBase async {
    if (_database == null) {
      _database = await _initDataBase();
    }
    return _database;
  }

  _initDataBase() async {
    String path = join(await getDatabasesPath(), _dataBaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)");
    await db.execute(
        "CREATE TABLE User(id INTEGER PRIMARY KEY,name TEXT,password TEXT,age INTEGER,sex INTEGER)");
  }
}
