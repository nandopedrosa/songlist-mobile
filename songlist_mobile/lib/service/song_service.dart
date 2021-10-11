import 'package:songlist_mobile/database/dao/song_dao.dart';
import 'package:songlist_mobile/models/song.dart';

class SongService {
  SongDao _dao = SongDao();

  Future<List<Song>> getRecentSongs() {
    Future<List<Song>> recentSongs = this._dao.getRecentSongs();
    return recentSongs;
  }
}
