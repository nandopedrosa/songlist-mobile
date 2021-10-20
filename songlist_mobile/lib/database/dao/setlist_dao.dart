import 'package:songlist_mobile/database/database_helper.dart';
import 'package:songlist_mobile/models/song.dart';
import 'package:sqflite/sqflite.dart';

class SetlistDao {
  static const String _tableName = 'setlist';

  static const String tableSql = """
  CREATE TABLE "$_tableName" (
	"show_id"	INTEGER NOT NULL,
	"song_id"	INTEGER NOT NULL,
	"song_position"	INTEGER NOT NULL,
	UNIQUE("show_id","song_id"),
	CONSTRAINT "FK_SHOW_ID" FOREIGN KEY("show_id") REFERENCES show(id),
	CONSTRAINT "FK_SONG_ID" FOREIGN KEY("song_id") REFERENCES song(id));
""";

  static const String dropTableSql = "DROP TABLE IF EXISTS $_tableName";

  static const String insertSetlist1 =
      """INSERT INTO $_tableName ("show_id", "song_id", "song_position") VALUES ('1', '1', 0);""";
  static const String insertSetlist2 =
      """INSERT INTO $_tableName ("show_id", "song_id", "song_position") VALUES ('1', '2', 1);""";
  static const String insertSetlist3 =
      """INSERT INTO $_tableName ("show_id", "song_id", "song_position") VALUES ('1', '3', 2);""";
  static const String insertSetlist4 =
      """INSERT INTO $_tableName ("show_id", "song_id", "song_position") VALUES ('2', '1', 0);""";
  static const String insertSetlist5 =
      """INSERT INTO $_tableName ("show_id", "song_id", "song_position") VALUES ('2', '2', 1);""";
  static const String insertSetlist6 =
      """INSERT INTO $_tableName ("show_id", "song_id", "song_position") VALUES ('2', '3', 2);""";
  static const String insertSetlist7 =
      """INSERT INTO $_tableName ("show_id", "song_id", "song_position") VALUES ('2', '4', 3);""";

  Future<void> save(int showId, List<Song> songs) async {
    Database? db = await DatabaseHelper.instance.database;

    //First we delete all rows (so we don't have to deal with updates)
    String deleteSql = "delete from $_tableName where show_id = ?";
    await db!.rawInsert(deleteSql, [showId]);

    //Now we insert all rows
    String insertSql =
        "insert into $_tableName (show_id, song_id, song_position) values (?,?,?)";
    for (var i = 0; i < songs.length; i++) {
      await db.rawInsert(insertSql, [showId, songs[i].id, i]);
    }
  }

  Future<int> getNumberOfSongs(int showId) async {
    Database? db = await DatabaseHelper.instance.database;
    String querySql =
        "select count(*) as number_of_songs from $_tableName where show_id  = ? ";
    final int? numberOfSongs =
        Sqflite.firstIntValue(await db!.rawQuery(querySql, [showId]));
    return numberOfSongs!;
  }

  Future<List<Song>> getAvailableSongs(int showId) async {
    Database? db = await DatabaseHelper.instance.database;
    String querySql =
        """select song.id, song.title, song.artist, song.duration, song.created_on from song 
        where song.id not in (select setlist.song_id from setlist where show_id = ?) order by song.title""";
    List<Map<String, dynamic>> result = await db!.rawQuery(querySql, [showId]);

    List<Song> availableSongs = List.generate(result.length, (i) {
      return Song(
        id: result[i]['id'],
        title: result[i]['title'],
        artist: result[i]['artist'],
        duration: result[i]['duration'],
        created_on: result[i]['created_on'],
      );
    });

    return availableSongs;
  }

  Future<List<Song>> getSelectedSongs(int showId) async {
    Database? db = await DatabaseHelper.instance.database;
    String querySql =
        """select song.id, song.title, song.artist, song.duration, song.created_on from song ,  setlist
           where setlist.song_id = song.id and setlist.show_id =?  order by setlist.song_position """;
    List<Map<String, dynamic>> result = await db!.rawQuery(querySql, [showId]);

    List<Song> selectedSongs = List.generate(result.length, (i) {
      return Song(
        id: result[i]['id'],
        title: result[i]['title'],
        artist: result[i]['artist'],
        duration: result[i]['duration'],
        created_on: result[i]['created_on'],
      );
    });

    return selectedSongs;
  }
}
