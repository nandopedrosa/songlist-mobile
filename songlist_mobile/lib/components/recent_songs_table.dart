import 'dart:developer';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:songlist_mobile/models/song.dart';
import 'package:songlist_mobile/service/song_service.dart';

import '../../../constants.dart';

// ignore: must_be_immutable
class RecentSongsTable extends StatelessWidget {
  RecentSongsTable({Key? key}) {
    this.recentSongs = SongService.getRecentSongs();
  }

  late List<Song> recentSongs;

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
            child: DataTable2(
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
                this.recentSongs.length,
                (index) => recentFileDataRow(this.recentSongs[index]),
              ),
            ),
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
