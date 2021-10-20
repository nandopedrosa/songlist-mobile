import 'package:songlist_mobile/database/dao/song_dao.dart';
import 'package:songlist_mobile/localization/localization_service.dart';
import 'package:songlist_mobile/models/song.dart';
import 'package:songlist_mobile/util/validation.dart';

class SongService {
  SongDao _dao = SongDao();
  static const int _recentSongsLimit = 4;

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

    if (song.duration != null && song.duration!.isNotEmpty) {
      final durationRegex = RegExp(r'^[0-9][0-9]:[0-9][0-9]$');
      if (!durationRegex.hasMatch(song.duration!)) {
        validation.isValid = false;
        validation.messages.add(
            LocalizationService.instance.getLocalizedString('duration_format'));
      }
    }

    if (song.created_on.isEmpty) {
      validation.isValid = false;
      validation.messages.add(LocalizationService.instance
          .getLocalizedString('created_on_mandatory'));
    }

    return validation;
  }

  Future<int> save(Song song) {
    if (song.id == null) {
      return this._dao.insert(song);
    } else {
      return this._dao.update(song);
    }
  }

  void delete(int id) {
    this._dao.delete(id);
  }

  Future<Song> find(int id) {
    return this._dao.find(id);
  }

  Future<List<Song>> getRecentSongs() {
    Future<List<Song>> recentSongs =
        this._dao.getRecentSongs(_recentSongsLimit);
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
