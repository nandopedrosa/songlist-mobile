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

  //The app comes with pre-loaded songs to illustrate features to the user
  static const String insertRecentSong1 = """
    INSERT INTO "song" ("title", "artist", "key", "tempo", "duration", "lyrics", "notes", "created_on") 
    VALUES ('Imagine', 'John Lennon', 'C', '76', '03:53', '<p>Imagine there''s no heaven<br>
    It''s easy if you try<br>
    No hell below us<br>
    Above us, only sky<br>
    Imagine all the people<br>
    Livin'' for today<br>
    Ah<br>
    Imagine there''s no countries<br>
    It isn''t hard to do<br>
    Nothing to kill or die for<br>
    And no religion, too<br>
    Imagine all the people<br>
    Livin'' life in peace<br>
    You<br>
    You may say I''m a dreamer<br>
    But I''m not the only one<br>
    I hope someday you''ll join us<br>
    And the world will be as one<br>
    Imagine no possessions<br>
    I wonder if you can<br>
    No need for greed or hunger<br>
    A brotherhood of man<br>
    Imagine all the people<br>
    Sharing all the world<br>
    You<br>
    You may say I''m a dreamer<br>
    But I''m not the only one<br>
    I hope someday you''ll join us<br>
    And the world will live as one</p>', 'Played on piano', '2016-01-01 10:20:05');
  """;

  static const String insertRecentSong2 = """ 
  INSERT INTO "song" ( "title", "artist", "key", "tempo", "duration", "lyrics", "notes", "created_on") 
  VALUES ('Hotel California', 'Eagles', 'Bm', '75', '06:31', '<p>On a dark desert highway, cool wind in my hair<br>
  Warm smell of colitas, rising up through the air<br>
  Up ahead in the distance, I saw a shimmering light<br>
  My head grew heavy and my sight grew dim<br>
  I had to stop for the night<br>
  There she stood in the doorway;<br>
  I heard the mission bell<br>
  And I was thinking to myself,<br>
  &quot;This could be Heaven or this could be Hell&quot;<br>
  Then she lit up a candle and she showed me the way<br>
  There were voices down the corridor,<br>
  I thought I heard them say...<br>
  Welcome to the Hotel California<br>
  Such a lovely place (Such a lovely place)<br>
  Such a lovely face<br>
  Plenty of room at the Hotel California<br>
  Any time of year (Any time of year)<br>
  You can find it here<br>
  Her mind is Tiffany-twisted, she got the Mercedes bends<br>
  She got a lot of pretty, pretty boys she calls friends<br>
  How they dance in the courtyard, sweet summer sweat.<br>
  Some dance to remember, some dance to forget<br>
  So I called up the Captain,<br>
  &quot;Please bring me my wine&quot;<br>
  He said, &quot;We haven''t had that spirit here since nineteen sixty nine&quot;<br>
  And still those voices are calling from far away,<br>
  Wake you up in the middle of the night<br>
  Just to hear them say...<br>
  Welcome to the Hotel California<br>
  Such a lovely place (Such a lovely place)<br>
  Such a lovely face<br>
  They livin'' it up at the Hotel California<br>
  What a nice surprise (what a nice surprise)<br>
  Bring your alibis<br>
  Mirrors on the ceiling,<br>
  The pink champagne on ice<br>
  And she said &quot;We are all just prisoners here, of our own device&quot;<br>
  And in the master''s chambers,<br>
  They gathered for the feast<br>
  They stab it with their steely knives,<br>
  But they just can''t kill the beast<br>
  Last thing I remember, I was<br>
  Running for the door<br>
  I had to find the passage back<br>
  To the place I was before<br>
  &quot;Relax, &quot; said the night man,<br>
  &quot;We are programmed to receive.<br>
  You can check-out any time you like,<br>
  But you can never leave! &quot;</p>', 'Great solo', '2016-01-01 11:20:05');
  """;

  static String insertRecentSong3 = """ 
  INSERT INTO "song" ("title", "artist", "key", "tempo", "duration", "lyrics", "notes", "created_on") 
  VALUES ( 'Smells like teen spirit', 'Nirvana', 'F', '117', '04:38', '<p>Load up on guns, bring your friends<br>
  It''s fun to lose and to pretend<br>
  She''s over-bored and self-assured<br>
  Oh no, I know a dirty word<br>
  Hello, hello, hello, how low<br>
  Hello, hello, hello, how low<br>
  Hello, hello, hello, how low<br>
  Hello, hello, hello<br>
  With the lights out, it''s less dangerous<br>
  Here we are now, entertain us<br>
  I feel stupid and contagious<br>
  Here we are now, entertain us<br>
  A mulatto, an albino, a mosquito, my libido<br>
  Yeah, hey<br>
  I''m worse at what I do best<br>
  And for this gift I feel blessed<br>
  Our little group has always been<br>
  And always will until the end<br>
  Hello, hello, hello, how low<br>
  Hello, hello, hello, how low<br>
  Hello, hello, hello, how low<br>
  Hello, hello, hello<br>
  With the lights out, it''s less dangerous<br>
  Here we are now, entertain us<br>
  I feel stupid and contagious<br>
  Here we are now, entertain us<br>
  A mulatto, an albino, a mosquito, my libido<br>
  Yeah, hey<br>
  And I forget just why I taste<br>
  Oh yeah, I guess it makes me smile<br>
  I found it hard, was hard to find<br>
  Oh well, whatever, never mind<br>
  Hello, hello, hello, how low<br>
  Hello, hello, hello, how low<br>
  Hello, hello, hello, how low<br>
  Hello, hello, hello<br>
  With the lights out, it''s less dangerous<br>
  Here we are now, entertain us<br>
  I feel stupid and contagious<br>
  Here we are now, entertain us<br>
  A mulatto, an albino, a mosquito, my libido<br>
  A denial, a denial, a denial, a denial, a denial<br>
  A denial, a denial, a denial, a denial</p>', 'Legendary riff' , '2016-01-01 12:20:05');
  """;

  static String insertRecentSong4 = """
  INSERT INTO "song" ("title", "artist", "key", "tempo", "duration", "lyrics", "notes", "created_on") 
  VALUES ( 'Girl from Ipanema', 'Tom Jobim', 'F', '145', '04:03', '<p>Olha que coisa mais linda mais cheia de gra&ccedil;a<br>
  &Eacute; ela menina que vem que passa<br>
  Num doce balan&ccedil;o caminho do mar<br>
  Mo&ccedil;a do corpo dourado do sol de Ipanema<br>
  O seu balan&ccedil;ado &eacute; mais que um poema<br>
  &Eacute; a coisa mais linda que eu j&aacute; vi passar<br>
  Ah, porque estou t&atilde;o sozinho<br>
  Ah, porque tudo &eacute; t&atilde;o triste<br>
  Ah, a beleza que existe<br>
  A beleza que n&atilde;o &eacute; s&oacute; minha<br>
  Que tamb&eacute;m passa sozinha<br>
  Ah, se ela soubesse<br>
  Que quando ela passa<br>
  O mundo sorrindo se enche de gra&ccedil;a<br>
  E fica mais lindo por causa do amor<br>
  Tall and tan and young and lovely<br>
  The girl from Ipanema goes walking<br>
  And when she passes Each one she passes goes, ah<br>
  When she walks, she''s like a samba<br>
  That swings so cool and sways so gently<br>
  That when she passes Each one she passes goes, ah<br>
  Oh, but he watches so sadly<br>
  How can he tell her he loves her<br>
  Yes, he would give his heart gladly<br>
  But each day, when she walks to the sea<br>
  She looks straight ahead, not at him<br>
  Tall, and tan, and young, and lovely<br>
  The girl from Ipanema goes walking<br>
  And when she passes He smiles, but she doesn''t see<br>
  Oh, but he sees her so sadly<br>
  How can he tell her he loves her<br>
  Yes, he would give his heart gladly<br>
  But each day, when she walks to the sea<br>
  She looks straight ahead, not at him<br>
  Tall, and tan, and young, and lovely<br>
  The girl from Ipanema goes walking<br>
  And when she passes he smiles, but she doesn''t see<br>
  She just doesn''t see, no she just doesn''t see<br>
  But she doesn''t see, she doesn''t see, no she just doesn''t see</p>', 'Bossa nova' , '2016-01-01 13:20:05');
  """;

  Future<List<Song>> getRecentSongs(int recentSongsLimit) async {
    // get a reference to the database
    Database? db = await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> result = await db!.rawQuery(
        'select id, title, artist, created_on from song order by created_on desc LIMIT $recentSongsLimit;');

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

  Future<int> insert(Song song) async {
    Database? db = await DatabaseHelper.instance.database;
    Map<String, dynamic> songMap = Song.toMap(song);
    return db!.insert(_tableName, songMap);
  }

  Future<int> update(Song song) async {
    Database? db = await DatabaseHelper.instance.database;
    Map<String, dynamic> songMap = Song.toMap(song);
    return db!
        .update(_tableName, songMap, where: "id = ?", whereArgs: [song.id]);
  }

  void delete(int id) async {
    Database? db = await DatabaseHelper.instance.database;
    db!.delete(_tableName, where: "id = ?", whereArgs: [id]);
  }
}
