import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:songlist_mobile/localization/localization_service.dart';
import 'package:songlist_mobile/main.dart';
import 'package:songlist_mobile/models/song.dart';
import 'package:songlist_mobile/screens/song/edit_song_screen.dart';
import 'package:songlist_mobile/service/song_service.dart';

import '../../util/constants.dart';

// ignore: must_be_immutable
class RecentSongsTable extends StatefulWidget {
  const RecentSongsTable({
    Key? key,
  }) : super(key: key);

  @override
  _RecentSongsTableState createState() => _RecentSongsTableState();
}

class _RecentSongsTableState extends State<RecentSongsTable> {
  @override
  void initState() {
    super.initState();
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
            child: RecentSongsFutureBuilder(recentSongs: recentSongs),
          ),
        ],
      ),
    );
  }
}

class RecentSongsFutureBuilder extends StatelessWidget {
  const RecentSongsFutureBuilder({
    Key? key,
    required this.recentSongs,
  }) : super(key: key);

  final Future<List<Song>> recentSongs;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Song>>(
        future: this.recentSongs,
        builder: (BuildContext context, AsyncSnapshot<List<Song>> snapshot) {
          List<Widget> children = [];

          //Snapshot is ASYNC, we have to check if it has data before accessing it
          if (snapshot.hasData) {
            children = <Widget>[
              DataTable2(
                //imported library
                columnSpacing: defaultPadding,
                showCheckboxColumn: false,
                columns: [
                  DataColumn(
                    label: Text(LocalizationService.instance
                        .getLocalizedString("title")),
                  ),
                  DataColumn(
                    label: Text(LocalizationService.instance
                        .getLocalizedString("artist")),
                  ),
                ],
                rows: List.generate(
                  snapshot.data!.length,
                  (index) => tableDataRow(snapshot.data![index], context),
                ),
              )
            ];
          }
          return Column(
            children: children,
          );
        });
  }
}

DataRow tableDataRow(Song song, BuildContext tableContext) {
  final Color rowColor = Colors.white70;
  return DataRow(
    onSelectChanged: (value) {
      //action when selecting a row
      Navigator.push(
        tableContext,
        MaterialPageRoute(
          builder: (context) => SonglistPlusMobileApp(
            activeScreen: EditSongScreen(songId: song.id),
          ),
        ),
      );
    },
    cells: [
      DataCell(Text(song.title, style: TextStyle(color: rowColor))),
      DataCell(Text(song.artist, style: TextStyle(color: rowColor))),
    ],
  );
}
