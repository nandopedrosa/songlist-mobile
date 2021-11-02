import 'package:songlist_mobile/database/dao/song_dao.dart';
import 'package:songlist_mobile/localization/localization_service.dart';
import 'package:songlist_mobile/models/song.dart';
import 'package:songlist_mobile/util/validation.dart';
import 'dart:convert';

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

  // We only delete the song if it is not associated with any setlist.
  // Otherwise we do nothing and return false.
  Future<bool> delete(int songId) async {
    bool isInSetlist = await this.isInSetlist(songId);
    if (isInSetlist) {
      return false;
    } else {
      this._dao.delete(songId);
      return true;
    }
  }

  Future<bool> isInSetlist(int songId) {
    return this._dao.isInSetlist(songId);
  }

  Future<Song> find(int id) {
    return this._dao.find(id);
  }

  Future<List<Song>> getRecentSongs() {
    Future<List<Song>> recentSongs =
        this._dao.getRecentSongs(_recentSongsLimit);
    return recentSongs;
  }

  //returns number of songs imported
  Future<int> importSongs(String jsonListOfSongs) async {
    int count = 0;
    Iterable it = json.decode(jsonListOfSongs);
    List<Song> songs = List<Song>.from(it.map((song) => Song.fromMap(song)));
    for (Song s in songs) {
      await this.save(s);
      count++;
    }
    return Future.value(count);
  }

  //exports songs to a json file, so the user can save it somewhere
  Future<List<Song>> exportSongs() {
    Future<List<Song>> allSongs = this._dao.exportSongs();
    return allSongs;
  }

  //Does not return lyrics
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
