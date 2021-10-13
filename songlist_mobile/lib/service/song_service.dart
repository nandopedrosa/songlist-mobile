import 'package:songlist_mobile/database/dao/song_dao.dart';
import 'package:songlist_mobile/localization/localization_service.dart';
import 'package:songlist_mobile/models/song.dart';
import 'package:songlist_mobile/util/validation.dart';

class SongService {
  SongDao _dao = SongDao();

  Validation validate(Song song) {
    Validation validation = Validation(isValid: true, messages: []);

    if (song.title.isEmpty) {
      validation.isValid = false;
      validation.messages.add(
          LocalizationService.instance.getLocalizedString('title_mandatory'));
    }

    if (song.artist.isEmpty) {
      validation.isValid = false;
      validation.messages.add(
          LocalizationService.instance.getLocalizedString('artist_mandatory'));
    }

    if (song.created_on.isEmpty) {
      validation.isValid = false;
      validation.messages.add(LocalizationService.instance
          .getLocalizedString('created_on_mandatory'));
    }

    return validation;
  }

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
