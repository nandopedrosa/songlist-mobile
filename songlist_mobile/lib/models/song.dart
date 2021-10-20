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

  factory Song.fromMap(Map<String, dynamic> json) => Song(
        id: json["id"],
        title: json["title"],
        artist: json["artist"],
        key: json["key"],
        tempo: json["tempo"],
        duration: json["duration"],
        lyrics: json["lyrics"],
        notes: json["notes"],
        created_on: json["created_on"],
      );

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
    if (this.artist.isEmpty) {
      return '';
    } else {
      return this.title + ' ($artist)';
    }
  }

  String getPrettyTotalDuration(Duration totalDuration) {
    String totalDurationRaw = totalDuration.toString();
    String d = totalDurationRaw.substring(0, totalDurationRaw.indexOf("."));

    if (d.startsWith("0")) {
      d = d.substring(d.indexOf(":") + 1);
      d = d.replaceFirst(":", "m:");
    } else {
      d = d.substring(d.indexOf(":") + 1);
      d = d.replaceFirst(":", "m:");
      d = totalDurationRaw.substring(0, totalDurationRaw.indexOf(":")) +
          "h:" +
          d;
    }

    return d + "s";
  }

  Duration getDurationObject() {
    Duration d = Duration(minutes: _getMinutes(), seconds: _getSeconds());
    return d;
  }

  int _getMinutes() {
    return int.parse(this.duration!.substring(0, 2));
  }

  int _getSeconds() {
    return int.parse(this.duration!.substring(3, 5));
  }
}
