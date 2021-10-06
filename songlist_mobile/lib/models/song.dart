class Song {
  int? _id;
  late String _title;
  String? _artist;
  String? _key;
  int? _tempo;
  String? _duration;
  String? _lyrics;
  String? _notes;

  Song(
    this._id,
    this._title,
    this._artist,
    this._key,
    this._tempo,
    this._duration,
    this._lyrics,
    this._notes,
  );

  get id => this._id;

  set id(value) => this._id = value;

  get title => this._title;

  set title(value) => this._title = value;

  get artist => this._artist;

  set artist(value) => this._artist = value;

  get key => this._key;

  set key(value) => this._key = value;

  get tempo => this._tempo;

  set tempo(value) => this._tempo = value;

  get duration => this._duration;

  set duration(value) => this._duration = value;

  get lyrics => this._lyrics;

  set lyrics(value) => this._lyrics = value;

  get notes => this._notes;

  set notes(value) => this._notes = value;

  @override
  String toString() {
    return 'Song(_id: $id, _title: $title, _artist: $artist, _key: $key, _tempo: $tempo, _duration: $duration, _lyrics: $lyrics, _notes: $notes)';
  }
}
