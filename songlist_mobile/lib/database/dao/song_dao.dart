import 'package:songlist_mobile/models/song.dart';
import 'package:sqflite/sqflite.dart';
import 'package:songlist_mobile/database/database_helper.dart';

class SongDao {
  static const String _tableName = 'song';

  static const String tableSql = """
      CREATE TABLE "$_tableName" (
      "id"	INTEGER,
      "title"	TEXT NOT NULL,
      "artist"	TEXT NOT NULL,
      "key"	TEXT,
      "tempo"	INTEGER,
      "duration"	TEXT,
      "lyrics"	TEXT,
      "notes"	TEXT,
      "created_on" TEXT NOT NULL,
      PRIMARY KEY("id" AUTOINCREMENT));      
    """;

  static const String dropTableSql = "DROP TABLE IF EXISTS $_tableName";

  //The app comes with pre-loaded songs to illustrate features to the user
  static const String insertRecentSong1 = """
    INSERT INTO "song" ("title", "artist", "key", "tempo", "duration", "lyrics", "notes", "created_on") 
    VALUES ('Annabelle', 'Ray Henderson', 'C', '76', '03:53', 'Pretty Little Annabelle Liked a lot of beaus, 
    
And her sweetie Johnny Brown Wanted her to settle down, 
    
How he coaxes sweet Annabell, 
    
Goodness only knows.

Chorus:	Oh! Annabelle, You have made a wild man out of me. 

Cause every day in every way, You get me jealous as can be.', '', '2016-01-01 10:20:05');
  """;

  static const String insertRecentSong2 = """ 
  INSERT INTO "song" ( "title", "artist", "key", "tempo", "duration", "lyrics", "notes", "created_on") 
  VALUES ('Broken Hearted Melody', 'Edgar Jones', 'Bm', '75', '06:31', 'Verse:	Out of the dear long ago, I hear a song sweet and low. 
  
Drifting it seems, out of the dreams, Dreams that we used to know, dear.

Chorus:	Just a broken hearted melody, Just a song that ends with a sigh. 

Like the sweet refrain you sang to me on the night we said good-bye, 

Dear.', 'Great solo', '2016-01-01 11:20:05');
  """;

  static String insertRecentSong3 = """ 
  INSERT INTO "song" ("title", "artist", "key", "tempo", "duration", "lyrics", "notes", "created_on") 
  VALUES ( 'Covered Wagon Days', 'Will Morrissey', 'F', '117', '04:38', 'Verse:	In the days of forty-nine, There was no one who wouldd decline, The call out West where all the best of fortune seemed to shine.
Chorus:	Old covered wagon days. Gold dragging in their ways. Your deeds in history play Parts that grip the hearts of our nation.', 'Old classic' , '2016-01-01 12:20:05');
  """;

  static String insertRecentSong4 = """
  INSERT INTO "song" ("title", "artist", "key", "tempo", "duration", "lyrics", "notes", "created_on") 
  VALUES ( 'Farewell Blues', 'Rappolo', 'F', '145', '04:03', 'Verse:	Sadness just makes me sigh. I have come to say goodbye. Altho I go Ive got those farewell blues.
Chorus:	Those farewell blues make me years That parting kiss seems to burn. Farewell dearie Some day I will return...', 'Great blues' , '2016-01-01 13:20:05');
  """;

  Future<List<Song>> getRecentSongs(int recentSongsLimit) async {
    // get a reference to the database
    Database? db = await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> result = await db!.rawQuery(
        'select id, title, artist, created_on from song order by created_on desc, title asc LIMIT $recentSongsLimit;');

    List<Song> recentSongs = List.generate(result.length, (i) {
      return Song(
        id: result[i]['id'],
        title: result[i]['title'],
        artist: result[i]['artist'],
        created_on: result[i]['created_on'],
      );
    });

    return recentSongs;
  }

  // All fields, except ID.
  // Songs ordered by title.
  Future<List<Song>> exportSongs() async {
    // get a reference to the database
    Database? db = await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> result =
        await db!.rawQuery("select * from song order by title;");

    List<Song> allSongs = List.generate(result.length, (i) {
      return Song(
        title: result[i]['title'],
        artist: result[i]['artist'],
        key: result[i]['key'],
        tempo: result[i]['tempo'],
        duration: result[i]['duration'],
        lyrics: result[i]['lyrics'],
        notes: result[i]['notes'],
        created_on: result[i]['created_on'],
      );
    });

    return allSongs;
  }

  //Doesn't return all fields, only the mandatory ones
  Future<List<Song>> getAllSongs() async {
    // get a reference to the database
    Database? db = await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> result = await db!.rawQuery(
        "select id, title, artist, created_on from song order by title;");

    List<Song> allSongs = List.generate(result.length, (i) {
      return Song(
        id: result[i]['id'],
        title: result[i]['title'],
        artist: result[i]['artist'],
        created_on: result[i]['created_on'],
      );
    });

    return allSongs;
  }

  // Check if a song is associated with any setlist.
  // This is useful to mantain referential integrity (don't allow deleting this song)
  Future<bool> isInSetlist(int songId) async {
    Database? db = await DatabaseHelper.instance.database;
    String querySql =
        "select count(*) as ocurrences from setlist where song_id  = ? ";
    final int? ocurrences =
        Sqflite.firstIntValue(await db!.rawQuery(querySql, [songId]));

    if (ocurrences! > 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<Song>> getSongsByTitleOrArtist(String term) async {
    Database? db = await DatabaseHelper.instance.database;

    List<Map<String, dynamic>> result = await db!.rawQuery("""
        select id, title, artist, created_on 
        from song 
        where lower(title) like ? or lower(artist) like ? 
        order by title;
        """, ['%$term%', '%$term%']);

    List<Song> songs = List.generate(result.length, (i) {
      return Song(
        id: result[i]['id'],
        title: result[i]['title'],
        artist: result[i]['artist'],
        created_on: result[i]['created_on'],
      );
    });

    return songs;
  }

  Future<Song> find(int id) async {
    Database? db = await DatabaseHelper.instance.database;
    var res = await db!.query(_tableName, where: "id = ?", whereArgs: [id]);
    Song song = Song.fromMap(res.first);
    return song;
  }

  Future<int> insert(Song song) async {
    Database? db = await DatabaseHelper.instance.database;
    Map<String, dynamic> songMap = Song.toMap(song);
    return db!.insert(_tableName, songMap);
  }

  Future<int> update(Song song) async {
    Database? db = await DatabaseHelper.instance.database;
    Map<String, dynamic> songMap = Song.toMap(song);
    db!.update(_tableName, songMap, where: "id = ?", whereArgs: [song.id]);
    return Future.value(song.id);
  }

  void delete(int id) async {
    Database? db = await DatabaseHelper.instance.database;
    db!.delete(_tableName, where: "id = ?", whereArgs: [id]);
  }
}
