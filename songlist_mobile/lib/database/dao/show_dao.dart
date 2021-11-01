import 'package:songlist_mobile/database/dto/show_dto.dart';
import 'package:songlist_mobile/models/show.dart';
import 'package:sqflite/sqflite.dart';
import 'package:songlist_mobile/database/database_helper.dart';

class ShowDao {
  static const String _tableName = 'show';

  static const String tableSql = """ 
  CREATE TABLE $_tableName (
	id INTEGER NOT NULL, 	
	name TEXT NOT NULL, 
	"when" TEXT, 	
  pay TEXT, 
	address TEXT, 
	contact TEXT,	
	notes TEXT, 
  duration	TEXT NOT NULL, 
  "created_on" TEXT NOT NULL,
  "number_of_songs"	INTEGER NOT NULL DEFAULT 0,
	PRIMARY KEY (id));
  """;

  static const String dropTableSql = "DROP TABLE IF EXISTS $_tableName";

  static const String insertRecentShow1 = """ 
    INSERT INTO $_tableName (name, "when", pay, address, contact, notes, duration, created_on, number_of_songs)
     VALUES (
      'My first show', '2016-07-30 10:20:05', '500.00', 
      '4 Pennsylvania Plaza, New York, NY 10001, USA', 'promoter@gmail.com', 
      'My first big show', '40:00', '2016-01-01 10:20:05', 3);    
  """;

  static const String insertRecentShow2 = """ 
    INSERT INTO $_tableName (name, "when", pay, address, contact, notes, duration, created_on, number_of_songs)
     VALUES (
      'Battle of the Bands', '2016-04-17 11:20:05','1000.00' , 
      'Mercedes-Benz Stadium in Atlanta, Georgia', 'battle@gmail.com', 'Battle!', '35:00', '2016-01-01 11:20:05', 4);    
  """;

  Future<List<ShowDto>> getAllShows() async {
    // get a reference to the database
    Database? db = await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> result = await db!.rawQuery(
        'select id, name, duration, "when", number_of_songs from show order by created_on desc;');

    List<ShowDto> allShows = [];
    allShows = List.generate(result.length, (i) {
      return ShowDto(
        id: result[i]['id'],
        name: result[i]['name'],
        duration: result[i]['duration'],
        when: result[i]['when'],
        numberOfSongs: result[i]['number_of_songs'],
      );
    });

    return allShows;
  }

  Future<String> getDuration(int id) async {
    Database? db = await DatabaseHelper.instance.database;
    String sql = "select duration from $_tableName where id = ?";
    var result = await db!.rawQuery(sql, [id]);
    Object? totalDuration = result[0]['duration'];
    return totalDuration!.toString();
  }

  Future<List<ShowDto>> getRecentShows(int recentShowsLimit) async {
    Database? db = await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> result = await db!.rawQuery(
        'select id, name, duration, "when", number_of_songs from show order by created_on desc LIMIT $recentShowsLimit;');

    //First we get each show
    List<ShowDto> recentShows = [];
    recentShows = List.generate(result.length, (i) {
      return ShowDto(
        id: result[i]['id'],
        name: result[i]['name'],
        duration: result[i]['duration'],
        when: result[i]['when'],
        numberOfSongs: result[i]['number_of_songs'],
      );
    });

    return recentShows; //returns an empty list if nothing was found
  }

  Future<List<ShowDto>> getShowsByName(String term) async {
    Database? db = await DatabaseHelper.instance.database;

    List<Map<String, dynamic>> result = await db!.rawQuery("""
        select id, name, duration, "when", number_of_songs
        from show 
        where lower(name) like ? 
        order by name;
        """, ['%$term%']);

    List<ShowDto> shows = List.generate(result.length, (i) {
      return ShowDto(
        id: result[i]['id'],
        name: result[i]['name'],
        duration: result[i]['duration'],
        when: result[i]['when'],
        numberOfSongs: result[i]['number_of_songs'],
      );
    });

    return shows;
  }

  Future<Show> find(int id) async {
    Database? db = await DatabaseHelper.instance.database;
    var res = await db!.query(_tableName, where: "id = ?", whereArgs: [id]);
    Show song = Show.fromMap(res.first);
    return song;
  }

  Future<int> insert(Show show) async {
    Database? db = await DatabaseHelper.instance.database;
    Map<String, dynamic> songMap = Show.toMap(show);
    return db!.insert(_tableName, songMap);
  }

  Future<int> update(Show show) async {
    Database? db = await DatabaseHelper.instance.database;
    Map<String, dynamic> songMap = Show.toMap(show);
    return db!
        .update(_tableName, songMap, where: "id = ?", whereArgs: [show.id]);
  }

  Future<void> updateDuration(int showId, String duration) async {
    Database? db = await DatabaseHelper.instance.database;
    String sql = "update $_tableName set duration = ? where id = ?";
    await db!.rawUpdate(sql, [duration, showId]);
  }

  Future<void> updateNumberOfSongs(int showId, int numberOfSongs) async {
    Database? db = await DatabaseHelper.instance.database;
    String sql = "update $_tableName set number_of_songs = ? where id = ?";
    await db!.rawUpdate(sql, [numberOfSongs, showId]);
  }

  void delete(int id) async {
    Database? db = await DatabaseHelper.instance.database;
    db!.delete(_tableName, where: "id = ?", whereArgs: [id]);
  }
}
