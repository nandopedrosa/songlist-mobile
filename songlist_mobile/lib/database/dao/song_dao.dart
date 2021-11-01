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
    VALUES ('Imagine', 'John Lennon', 'C', '76', '03:53', 'Imagine there''s no heaven
It''s easy if you try
No hell below us
Above us, only sky

Imagine all the people
Livin'' for today
Ah

Imagine there''s no countries
It isn''t hard to do
Nothing to kill or die for
And no religion, too

Imagine all the people
Livin'' life in peace
You

You may say I''m a dreamer
But I''m not the only one
I hope someday you''ll join us
And the world will be as one

Imagine no possessions
I wonder if you can
No need for greed or hunger
A brotherhood of man

Imagine all the people
Sharing all the world
You

You may say I''m a dreamer
But I''m not the only one
I hope someday you''ll join us
And the world will live as one', 'Played on piano', '2016-01-01 10:20:05');
  """;

  static const String insertRecentSong2 = """ 
  INSERT INTO "song" ( "title", "artist", "key", "tempo", "duration", "lyrics", "notes", "created_on") 
  VALUES ('Hotel California', 'Eagles', 'Bm', '75', '06:31', 'On a dark desert highway, cool wind in my hair
Warm smell of colitas, rising up through the air
Up ahead in the distance, I saw a shimmering light
My head grew heavy and my sight grew dim
I had to stop for the night
There she stood in the doorway;
I heard the mission bell
And I was thinking to myself,
This could be Heaven or this could be Hell
Then she lit up a candle and she showed me the way
There were voices down the corridor,
I thought I heard them say...

Welcome to the Hotel California
Such a lovely place (Such a lovely place)
Such a lovely face
Plenty of room at the Hotel California
Any time of year (Any time of year)
You can find it here

Her mind is Tiffany-twisted, she got the Mercedes bends
She got a lot of pretty, pretty boys she calls friends
How they dance in the courtyard, sweet summer sweat.
Some dance to remember, some dance to forget

So I called up the Captain,
Please bring me my wine
He said, We haven''t had that spirit here since nineteen sixty nine
And still those voices are calling from far away,
Wake you up in the middle of the night
Just to hear them say...

Welcome to the Hotel California
Such a lovely place (Such a lovely place)
Such a lovely face
They livin'' it up at the Hotel California
What a nice surprise (what a nice surprise)
Bring your alibis

Mirrors on the ceiling,
The pink champagne on ice
And she said We are all just prisoners here, of our own device
And in the master''s chambers,
They gathered for the feast
They stab it with their steely knives,
But they just can''t kill the beast

Last thing I remember, I was
Running for the door
I had to find the passage back
To the place I was before
Relax,  said the night man,
We are programmed to receive.
You can check-out any time you like,
But you can never leave!', 'Great solo', '2016-01-01 11:20:05');
  """;

  static String insertRecentSong3 = """ 
  INSERT INTO "song" ("title", "artist", "key", "tempo", "duration", "lyrics", "notes", "created_on") 
  VALUES ( 'Smells like teen spirit', 'Nirvana', 'F', '117', '04:38', 'Load up on guns, bring your friends
It''s fun to lose and to pretend
She''s over-bored and self-assured
Oh no, I know a dirty word

Hello, hello, hello, how low
Hello, hello, hello, how low
Hello, hello, hello, how low
Hello, hello, hello

With the lights out, it''s less dangerous
Here we are now, entertain us
I feel stupid and contagious
Here we are now, entertain us
A mulatto, an albino, a mosquito, my libido
Yeah, hey

I''m worse at what I do best
And for this gift I feel blessed
Our little group has always been
And always will until the end

Hello, hello, hello, how low
Hello, hello, hello, how low
Hello, hello, hello, how low
Hello, hello, hello

With the lights out, it''s less dangerous
Here we are now, entertain us
I feel stupid and contagious
Here we are now, entertain us
A mulatto, an albino, a mosquito, my libido
Yeah, hey

And I forget just why I taste
Oh yeah, I guess it makes me smile
I found it hard, was hard to find
Oh well, whatever, never mind

Hello, hello, hello, how low
Hello, hello, hello, how low
Hello, hello, hello, how low
Hello, hello, hello

With the lights out, it''s less dangerous
Here we are now, entertain us
I feel stupid and contagious
Here we are now, entertain us
A mulatto, an albino, a mosquito, my libido
A denial, a denial, a denial, a denial, a denial
A denial, a denial, a denial, a denial', 'Legendary riff' , '2016-01-01 12:20:05');
  """;

  static String insertRecentSong4 = """
  INSERT INTO "song" ("title", "artist", "key", "tempo", "duration", "lyrics", "notes", "created_on") 
  VALUES ( 'Girl from Ipanema', 'Tom Jobim', 'F', '145', '04:03', 'Olha que coisa mais linda mais cheia de graça
É ela menina que vem que passa
Num doce balanço caminho do mar

Moça do corpo dourado do sol de Ipanema
O seu balançado é mais que um poema
É a coisa mais linda que eu já vi passar

Ah, porque estou tão sozinho
Ah, porque tudo é tão triste
Ah, a beleza que existe
A beleza que não é só minha
Que também passa sozinha

Ah, se ela soubesse
Que quando ela passa
O mundo sorrindo se enche de graça
E fica mais lindo por causa do amor

Tall and tan and young and lovely
The girl from Ipanema goes walking
And when she passes Each one she passes goes, ah

When she walks, she''s like a samba
That swings so cool and sways so gently
That when she passes Each one she passes goes, ah

Oh, but he watches so sadly
How can he tell her he loves her
Yes, he would give his heart gladly
But each day, when she walks to the sea
She looks straight ahead, not at him

Tall, and tan, and young, and lovely
The girl from Ipanema goes walking
And when she passes He smiles, but she doesn''t see

Oh, but he sees her so sadly
How can he tell her he loves her
Yes, he would give his heart gladly
But each day, when she walks to the sea
She looks straight ahead, not at him

Tall, and tan, and young, and lovely
The girl from Ipanema goes walking
And when she passes he smiles, but she doesn''t see
She just doesn''t see, no she just doesn''t see
But she doesn''t see, she doesn''t see, no she just doesn''t see', 'Bossa nova' , '2016-01-01 13:20:05');
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
    return db!
        .update(_tableName, songMap, where: "id = ?", whereArgs: [song.id]);
  }

  void delete(int id) async {
    Database? db = await DatabaseHelper.instance.database;
    db!.delete(_tableName, where: "id = ?", whereArgs: [id]);
  }
}
