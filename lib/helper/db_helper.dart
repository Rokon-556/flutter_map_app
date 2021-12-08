import 'package:new_login_app/models/user_model.dart';
import 'package:new_login_app/models/visit_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static final String CREATE_TABLE_USER = ''' create table $TABLE_USER(
  $COL_USER_ID integer primary key autoincrement not null,
  $COL_USER_NAME text not null,
  $COL_USER_PHONE text not null,
  $COL_USER_EMAIL text not null,
  $COL_USER_PASSWORD text not null
  )''';


  static final String CREATE_TABLE_PLACE = ''' create table $TABLE_PLACE(
  $COL_PLACE_ID integer primary key autoincrement not null,
  $COL_PLACE_NAME text not null,
  $COL_PLACE_LATITUDE real not null,
  $COL_PLACE_LONGITUDE real not null
  
  )''';



  static void _onCreate(Database db, int version) {
    db.execute(CREATE_TABLE_USER);
    db.execute(CREATE_TABLE_PLACE);
  }

  static Future<Database> createDBUser() async {
    final dbpath = await getDatabasesPath();
    final path = join(dbpath, 'user.db');
    Database db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }


  static Future<int> insertUser(UserModel user) async {
    print('its ok');
    final db = await createDBUser();
    print('its ok2');
    var result = await db.insert(TABLE_USER, user.toMap());
    print('its ok3');
    return result;
  }

  static Future<UserModel?> getUserInfo(String email, String password) async {
    print('final');
    final db = await createDBUser();
    print('final2');
    var users = await db.rawQuery("SELECT * FROM $TABLE_USER WHERE "
        "$COL_USER_EMAIL = '$email' AND "
        "$COL_USER_PASSWORD = '$password'");
    print('final3');
    if (users.length > 0) {
      return UserModel.fromMap(users.first);
    }
    return null;
  }

  static Future<Database> createDBPlace() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'place.db');
    Database db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  static Future<int> insertPlace(
      String tableName, Map<String, dynamic> data) async {
    final db = await createDBPlace();
    return db.insert(tableName, data,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<VisitModel>> getPlace() async {
    final db = await createDBPlace();
    final List<Map<String, dynamic>> placeMap =
        await db.query(TABLE_PLACE, orderBy: COL_PLACE_NAME);
    return List.generate(
        placeMap.length, (index) => VisitModel.fromMap(placeMap[index]),);
  }

  static Future<void> deletePlace(int id) async {
    final db = await createDBPlace();
    await db.delete(TABLE_PLACE, where: '$COL_PLACE_ID = ?', whereArgs: [id]);
  }

  // static Future<void> getInfoByID(int id)async{
  //   final db=await createDBPlace();
  //   await db.rawQuery("SELECT * FROM $TABLE_USER WHERE "
  //   "$COL_PLACE_ID = FK_user_ID");
  // }

  static Future<VisitModel?> getPlacesByID(int id) async {
    final db = await createDBPlace();
    final List<Map<String, dynamic>> places = await db
        .query(TABLE_PLACE, where: '$COL_PLACE_ID = ?',whereArgs: [id]);
    if (places.length > 0) {
       return VisitModel.fromMap(places.first);
    }
    return null;
  }

  static Future<int> updatePlace(VisitModel visitModel) async {
    final db = await createDBPlace();
    return await db.update(TABLE_PLACE, visitModel.toMap(),
        where: '$COL_PLACE_ID = ?', whereArgs: [visitModel.id]);
  }
}
