import 'package:mobileoa/constant.dart';
import 'package:mobileoa/db/dbUtil.dart';
import 'package:mobileoa/model/user.dart';
import 'package:sqflite/sqflite.dart';

class UserDao {
  static String tabName = Constant.tableUser;

  //外界入口
  factory UserDao.getInstance() => _getInstance();

  static UserDao _instance;

  static Database _database;

  UserDao._internal() {
    //
  }

  static _getInstance() {
    if (_instance == null) {
      _instance = UserDao._internal();
    }
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await DbHelperInstance.getInstance().dataBase;
    return _database;
  }

  Map<String, dynamic> toMap(User user) {
    return {
      "id": user.id,
      "name": user.name,
      "age": user.age,
      "password": user.password,
      "company": user.company,
    };
  }

  Future<void> updateUser(User user) async {
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

  Future<List<User>> getUser(String name, String pass) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'select * from $tabName where name= ? and password = ?', [name, pass]);
    return List.generate(maps.length, (i) {
      return User(
        id: maps[i]['id'],
        name: maps[i]['name'],
        age: maps[i]['age'],
        sex: maps[i]['sex'],
        password: maps[i]['password'],
        company: maps[i]["company"],
      );
    });
  }

  Future<List<User>> getUserById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.rawQuery('select * from $tabName where id= ?', [id]);
    return List.generate(maps.length, (i) {
      return User(
        id: maps[i]['id'],
        name: maps[i]['name'],
        age: maps[i]['age'],
        sex: maps[i]['sex'],
        password: maps[i]['password'],
        company: maps[i]["company"],
      );
    });
  }

  Future<List<User>> getUsers() async {
    // Get a reference to the database (获得数据库引用)
    final Database db = await database;
    // Query the table for all The Dogs (查询数据表，获取所有的狗狗们)
    final List<Map<String, dynamic>> maps = await db.query(tabName);
    // Convert the List<Map<String, dynamic> into a List<Dog> (将 List<Map<String, dynamic> 转换成 List<Dog> 数据类型)
    return List.generate(maps.length, (i) {
      return User(
        id: maps[i]['id'],
        name: maps[i]['name'],
        age: maps[i]['age'],
        sex: maps[i]['sex'],
        password: maps[i]['password'],
        company: maps[i]["company"],
      );
    });
  }

  Future<void> deleteUser(int id) async {
    // Get a reference to the database (获得数据库引用)
    final db = await database;
    // Remove the Dog from the database (将狗狗从数据库移除)
    await db.delete(
      'user',
      // Use a `where` clause to delete a specific dog (使用 `where` 语句删除指定的狗狗)
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection (通过 `whereArg` 将狗狗的 id 传递给 `delete` 方法，以防止 SQL 注入)
      whereArgs: [id],
    );
  }

  Future<void> insertUser(User user) async {
    // Get a reference to the database (获得数据库引用)
    final Database db = await database;
    // Insert the Dog into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same dog is inserted
    // multiple times, it replaces the previous data.
    // 在正确的数据表里插入狗狗的数据。我们也要在这个操作中指定 `conflictAlgorithm` 策略。
    // 如果同样的狗狗数据被多次插入，后一次插入的数据将会覆盖之前的数据。
    await db.insert(
      tabName,
      toMap(user),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
