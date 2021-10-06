import 'package:songlist_mobile/models/song.dart';

class Show {
  int? _id;
  late String _name;
  DateTime? _startDate;
  double? _pay;
  String? _address;
  String? _contactInfo;
  String? _notes;
  String? _duration;
  List<Song> _songs = [];

  Show(
    this._id,
    this._name,
    this._startDate,
    this._pay,
    this._address,
    this._contactInfo,
    this._notes,
    this._duration,
  );

  void addSong(Song song) {
    this._songs.add(song);
  }

  void removeSong(int songId) {
    for (var i = 0; i < this._songs.length; i++) {
      if (this._songs[i].id == songId) {
        this._songs.removeAt(i);
        break;
      }
    }
  }

  List<Song> get songs => this._songs;

  set songs(List<Song> value) => this._songs = value;

  get duration => this._duration;

  set duration(value) => this._duration = value;

  get id => this._id;

  set id(value) => this._id = value;

  get name => this._name;

  set name(value) => this._name = value;

  get startDate => this._startDate;

  set startDate(value) => this._startDate = value;

  get pay => this._pay;

  set pay(value) => this._pay = value;

  get address => this._address;

  set address(value) => this._address = value;

  get contactInfo => this._contactInfo;

  set contactInfo(value) => this._contactInfo = value;

  get notes => this._notes;

  set notes(value) => this._notes = value;

  @override
  String toString() {
    return 'Show(_id: $id, _name: $name, _startDate: $startDate, _pay: $pay, _address: $address, _contactInfo: $contactInfo, _notes: $notes, _duration: $duration)';
  }
}
