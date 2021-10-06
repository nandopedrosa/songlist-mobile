import 'package:songlist_mobile/models/show.dart';
import 'package:songlist_mobile/models/song.dart';
import 'package:sqflite/sqflite.dart';
import 'package:songlist_mobile/database/app_database.dart';

class ShowDao {
  static const String tableSql = "";

  static List<Show> getRecentShows() {
    List<Show> recentShows = [];

    Show show1 =
        Show(1, 'BlackFish - Moderno', null, null, null, null, null, "40h:34m");
    Show show2 =
        Show(2, 'Fusion (Thiago)', null, null, null, null, null, "33h:11m");

    Song song1 =
        Song(1, "Imagine", "John Lennon", null, null, null, null, null);
    Song song2 =
        Song(2, "Hotel California", "The Eagles", null, null, null, null, null);

    show1.addSong(song1);
    show1.addSong(song2);

    show2.addSong(song1);

    recentShows.add(show1);
    recentShows.add(show2);

    return recentShows;
  }
}
