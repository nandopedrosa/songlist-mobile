import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:songlist_mobile/models/song.dart';
import 'package:songlist_mobile/service/song_service.dart';

import '../../../constants.dart';

// ignore: must_be_immutable
class RecentSongsTable extends StatefulWidget {
  const RecentSongsTable({
    Key? key,
  }) : super(key: key);

  @override
  _RecentSongsTableState createState() => _RecentSongsTableState();
}

class _RecentSongsTableState extends State<RecentSongsTable> {
  _RecentSongsTableState() {
    this.service = SongService();
    this.recentSongs = service.getRecentSongs();
  }

  late SongService service;
  late Future<List<Song>> recentSongs;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: FutureBuilder<List<Song>>(
                future: this.recentSongs,
                builder:
                    (BuildContext context, AsyncSnapshot<List<Song>> snapshot) {
                  List<Widget> children = [];

                  //Snapshot is ASYNC, we have to check if it has data before accessing it
                  if (snapshot.hasData) {
                    children = <Widget>[
                      DataTable2(
                        columnSpacing: defaultPadding,
                        showCheckboxColumn: false,
                        columns: [
                          DataColumn(
                            label: Text("Title"),
                          ),
                          DataColumn(
                            label: Text("Artist"),
                          ),
                        ],
                        rows: List.generate(
                          snapshot.data!.length,
                          (index) => recentFileDataRow(snapshot.data![index]),
                        ),
                      )
                    ];
                  }

                  return Column(
                    children: children,
                  );
                }),
          ),
        ],
      ),
    );
  }
}

DataRow recentFileDataRow(Song song) {
  return DataRow(
    onSelectChanged: (value) {
      print("tapped song: " + song.id.toString());
    },
    cells: [
      DataCell(Text(song.title, style: TextStyle(color: Colors.white70))),
      DataCell(Text(song.artist, style: TextStyle(color: Colors.white70))),
    ],
  );
}
