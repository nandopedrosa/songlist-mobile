class ShowDto {
  int id;
  String name;
  String duration;
  int? numberOfSongs;

  ShowDto({
    required this.id,
    required this.name,
    required this.duration,
    this.numberOfSongs,
  });

  get getId => this.id;

  set setId(id) => this.id = id;

  get getName => this.name;

  set setName(name) => this.name = name;

  get getDuration => this.duration;

  set setDuration(duration) => this.duration = duration;

  get getNumberOfSongs => this.numberOfSongs;

  set setNumberOfSongs(numberOfSongs) => this.numberOfSongs = numberOfSongs;
}
