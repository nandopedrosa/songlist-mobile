import 'package:songlist_mobile/models/song.dart';

class Show {
  int? id;
  String name;
  String? when;
  String? pay;
  String? duration;
  String? address;
  String? contact;
  String? notes;
  List<Song> songs = [];
  // ignore: non_constant_identifier_names
  String created_on;

  Show({
    this.id,
    required this.name,
    this.when,
    this.pay,
    this.duration,
    this.address,
    this.contact,
    this.notes,
    // ignore: non_constant_identifier_names
    required this.created_on,
  });

  void addSong(Song song) {
    this.songs.add(song);
  }

  void removeSong(int songId) {
    for (var i = 0; i < this.songs.length; i++) {
      if (this.songs[i].id == songId) {
        this.songs.removeAt(i);
        break;
      }
    }
  }

  @override
  String toString() {
    return 'Show(id: $id, name: $name, total songs: ${songs.length})';
  }
}
