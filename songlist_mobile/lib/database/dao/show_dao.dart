import 'package:songlist_mobile/database/dto/show_dto.dart';
import 'package:sqflite/sqflite.dart';
import 'package:songlist_mobile/database/database_helper.dart';

class ShowDao {
  static const String tableSql = """ 
  CREATE TABLE show (
	id INTEGER NOT NULL, 	
	name TEXT NOT NULL, 
	"when" TEXT, 	
  pay TEXT, 
	address TEXT, 
	contact TEXT,	
	notes TEXT, 
  duration TEXT, 
  "created_on" TEXT NOT NULL,
	PRIMARY KEY (id));
  """;

  static const int _recentShowsLimit = 4;

  static const String insertRecentShow1 = """ 
    INSERT INTO show (name, "when", pay, address, contact, notes, duration, created_on) VALUES (
      'My first show', '2016-01-01 10:20:05', '500.00', 
      '4 Pennsylvania Plaza, New York, NY 10001, USA', 'promoter@gmail.com', 
      'My first big show', '40:00', '2016-01-01 10:20:05');    
  """;

  static const String insertRecentShow2 = """ 
    INSERT INTO show (name, "when", pay, address, contact, notes, duration, created_on) VALUES (
      'Battle of the Bands', '2016-01-01 11:20:05','1000.00' , 
      'Mercedes-Benz Stadium in Atlanta, Georgia', 'battle@gmail.com', 'Battle!', '35:00', '2016-01-01 11:20:05');    
  """;

  Future<List<ShowDto>> getRecentShows() async {
    Database? db = await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> result = await db!.rawQuery(
        'select id, name, duration from show order by created_on desc LIMIT $_recentShowsLimit;');

    //First we get each show
    List<ShowDto> recentShows = [];
    recentShows = List.generate(result.length, (i) {
      return ShowDto(
        id: result[i]['id'],
        name: result[i]['name'],
        duration: result[i]['duration'],
      );
    });

    //Then we find out how many songs each show has
    for (var show in recentShows) {
      List<Map<String, dynamic>> count = await db.rawQuery(
          'select count(*) as total from setlist where show_id= ?;', [show.id]);
      show.numberOfSongs = count[0]['total'];
    }

    return recentShows; //returns an empty list if nothing was found
  }
}
