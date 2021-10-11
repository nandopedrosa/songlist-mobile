import 'package:songlist_mobile/database/dao/song_dao.dart';
import 'package:songlist_mobile/models/song.dart';

class SongService {
  SongDao _dao = SongDao();

  Future<List<Song>> getRecentSongs() {
    Future<List<Song>> recentSongs = this._dao.getRecentSongs();
    return recentSongs;
  }

  Future<List<Song>> getAllSongs() {
    Future<List<Song>> allSongs = this._dao.getAllSongs();
    return allSongs;
  }

  Future<List<Song>> getSongsByTitleOrArtist(String term) {
    Future<List<Song>> songs;

    if (term.isEmpty) {
      songs = getAllSongs();
    } else {
      term = term.toLowerCase().trim();
      songs = this._dao.getSongsByTitleOrArtist(term);
    }

    return songs;
  }
}
