import 'package:path/path.dart';
import 'package:songlist_mobile/database/dao/setlist_dao.dart';
import 'package:songlist_mobile/database/dao/song_dao.dart';
import 'package:sqflite/sqflite.dart';
import 'package:songlist_mobile/database/dao/show_dao.dart';

class DatabaseHelper {
  //Private constructor
  DatabaseHelper._privateConstructor();
  //Singleton implementation
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;

    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    final String path = join(await getDatabasesPath(), 'songlist_mobile.db');
    return await openDatabase(path,
        version: 1,
        onCreate: _onCreate,
        onDowngrade: onDatabaseDowngradeDelete);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    //Create tables
    await db.execute(SongDao.tableSql);
    await db.execute(ShowDao.tableSql);
    await db.execute(SetlistDao.tableSql);

    // prepopulate a few rows to illustrate some app features
    await db.rawInsert(SongDao.insertRecentSong1);
    await db.rawInsert(SongDao.insertRecentSong2);
    await db.rawInsert(SongDao.insertRecentSong3);
    await db.rawInsert(SongDao.insertRecentSong4);
    await db.rawInsert(ShowDao.insertRecentShow1);
    await db.rawInsert(ShowDao.insertRecentShow2);
    await db.rawInsert(SetlistDao.insertSetlist1);
    await db.rawInsert(SetlistDao.insertSetlist2);
    await db.rawInsert(SetlistDao.insertSetlist3);
    await db.rawInsert(SetlistDao.insertSetlist4);
    await db.rawInsert(SetlistDao.insertSetlist5);
    await db.rawInsert(SetlistDao.insertSetlist6);
    await db.rawInsert(SetlistDao.insertSetlist7);
  }
}
