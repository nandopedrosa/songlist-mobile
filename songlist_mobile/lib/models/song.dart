class Song {
  int? id;
  String title;
  String artist;
  String? key;
  int? tempo;
  String? duration;
  String? lyrics;
  String? notes;
  // ignore: non_constant_identifier_names
  String created_on;

  Song(
      {this.id,
      required this.title,
      required this.artist,
      this.key,
      this.tempo,
      this.duration,
      this.lyrics,
      this.notes,
      // ignore: non_constant_identifier_names
      required this.created_on});

  static Map<String, dynamic> toMap(Song song) {
    final Map<String, dynamic> songMap = Map();
    songMap['id'] = song.id;
    songMap['title'] = song.title;
    songMap['artist'] = song.artist;
    songMap['key'] = song.key;
    songMap['tempo'] = song.tempo;
    songMap['duration'] = song.duration;
    songMap['lyrics'] = song.lyrics;
    songMap['notes'] = song.notes;
    songMap['created_on'] = song.created_on;
    return songMap;
  }

  get getCreatedOn => this.created_on;

  // ignore: non_constant_identifier_names
  set setCreatedOn(String created_on) => this.created_on = created_on;

  get getId => this.id;

  set setId(id) => this.id = id;

  get getTitle => this.title;

  set setTitle(title) => this.title = title;

  get getArtist => this.artist;

  set setArtist(artist) => this.artist = artist;

  get getKey => this.key;

  set setKey(key) => this.key = key;

  get getTempo => this.tempo;

  set setTempo(tempo) => this.tempo = tempo;

  get getDuration => this.duration;

  set setDuration(duration) => this.duration = duration;

  get getLyrics => this.lyrics;

  set setLyrics(lyrics) => this.lyrics = lyrics;

  get getNotes => this.notes;

  set setNotes(notes) => this.notes = notes;

  @override
  String toString() {
    return 'Song(id: $id, title: $title, artist: $artist)';
  }
}
