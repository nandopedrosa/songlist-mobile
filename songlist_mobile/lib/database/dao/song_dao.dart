import 'package:songlist_mobile/models/song.dart';
import 'package:sqflite/sqflite.dart';
import 'package:songlist_mobile/database/app_database.dart';

class SongDao {
  static const String tableSql = "";

  static List<Song> getRecentSongs() {
    List<Song> recentSongs = [];

    Song song1 =
        Song(1, "Imagine", "John Lennon", null, null, null, null, null);
    Song song2 =
        Song(2, "Hotel California", "The Eagles", null, null, null, null, null);

    recentSongs.add(song1);
    recentSongs.add(song2);

    return recentSongs;
  }
}
