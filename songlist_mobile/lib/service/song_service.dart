import 'package:songlist_mobile/database/dao/song_dao.dart';
import 'package:songlist_mobile/models/song.dart';

class SongService {
  static List<Song> getRecentSongs() {
    List<Song> recentSongs = [];
    recentSongs = SongDao.getRecentSongs();
    return recentSongs;
  }
}
