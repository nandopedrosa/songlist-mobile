class SetlistDao {
  static const String tableSql = """
  CREATE TABLE "setlist" (
	"show_id"	INTEGER NOT NULL,
	"song_id"	INTEGER NOT NULL,
	"song_position"	INTEGER NOT NULL,
	UNIQUE("show_id","song_id"),
	CONSTRAINT "FK_SHOW_ID" FOREIGN KEY("show_id") REFERENCES show(id),
	CONSTRAINT "FK_SONG_ID" FOREIGN KEY("song_id") REFERENCES song(id));
""";

  static const String insertSetlist1 =
      """INSERT INTO "setlist" ("show_id", "song_id", "song_position") VALUES ('1', '1', '1');""";
  static const String insertSetlist2 =
      """INSERT INTO "setlist" ("show_id", "song_id", "song_position") VALUES ('1', '2', '2');""";
  static const String insertSetlist3 =
      """INSERT INTO "setlist" ("show_id", "song_id", "song_position") VALUES ('1', '3', '3');""";
  static const String insertSetlist4 =
      """INSERT INTO "setlist" ("show_id", "song_id", "song_position") VALUES ('2', '1', '1');""";
  static const String insertSetlist5 =
      """INSERT INTO "setlist" ("show_id", "song_id", "song_position") VALUES ('2', '2', '2');""";
  static const String insertSetlist6 =
      """INSERT INTO "setlist" ("show_id", "song_id", "song_position") VALUES ('2', '3', '3');""";
  static const String insertSetlist7 =
      """INSERT INTO "setlist" ("show_id", "song_id", "song_position") VALUES ('2', '4', '4');""";
}
