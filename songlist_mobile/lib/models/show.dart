class Show {
  int? id;
  String name;
  String? when;
  String? pay;
  String duration;
  String? address;
  String? contact;
  String? notes;
  int numberOfSongs;
  // ignore: non_constant_identifier_names
  String created_on;

  Show({
    this.id,
    required this.name,
    this.when,
    this.pay,
    this.duration = '00:00',
    this.address,
    this.contact,
    this.notes,
    this.numberOfSongs = 0,
    // ignore: non_constant_identifier_names
    required this.created_on,
  });

  static Map<String, dynamic> toMap(Show show) {
    final Map<String, dynamic> showMap = Map();
    showMap['id'] = show.id;
    showMap['name'] = show.name;
    showMap['when'] = show.when;
    showMap['pay'] = show.pay;
    showMap['address'] = show.address;
    showMap['contact'] = show.contact;
    showMap['notes'] = show.notes;
    showMap['duration'] = show.duration;
    showMap['created_on'] = show.created_on;
    showMap['number_of_songs'] = show.numberOfSongs;
    return showMap;
  }

  factory Show.fromMap(Map<String, dynamic> json) => Show(
        id: json["id"],
        name: json['name'],
        when: json['when'],
        pay: json['pay'],
        address: json['address'],
        contact: json['contact'],
        notes: json['notes'],
        duration: json['duration'],
        created_on: json['created_on'],
        numberOfSongs: json['number_of_songs'],
      );

  @override
  String toString() {
    return 'Show(id: $id, name: $name)';
  }
}
