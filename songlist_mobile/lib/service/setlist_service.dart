import 'package:songlist_mobile/database/dao/setlist_dao.dart';
import 'package:songlist_mobile/models/song.dart';

class SetlistService {
  SetlistDao _dao = SetlistDao();

  void save(int showId, List<Song> songs) {
    if (songs.isNotEmpty) {
      this._dao.save(showId, songs);
    }
  }

  Future<int> getNumberOfSongs(int showId) {
    return this._dao.getNumberOfSongs(showId);
  }

  //Get all songs that are not in a specific show's setlist yet
  Future<List<Song>> getAvailableSongs(int showId) {
    Future<List<Song>> availableSongs = this._dao.getAvailableSongs(showId);
    return availableSongs;
  }

  //Get all songs that belong to a specific show's setlist
    Future<List<Song>> getSelectedSongs(int showId) {
    Future<List<Song>> selectedSongs = this._dao.getSelectedSongs(showId);
    return selectedSongs;
  }
}
