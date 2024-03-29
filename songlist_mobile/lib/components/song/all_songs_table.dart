// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:songlist_mobile/localization/localization_service.dart';
import 'package:songlist_mobile/main.dart';
import 'package:songlist_mobile/models/song.dart';
import 'package:songlist_mobile/screens/song/edit_song_screen.dart';
import 'package:songlist_mobile/service/song_service.dart';
import 'package:songlist_mobile/util/responsive.dart';
import '../../util/constants.dart';

class AllSongsTable extends StatefulWidget {
  double songTableFontSize;
  AllSongsTable({
    Key? key,
    required this.songTableFontSize,
  }) : super(key: key);

  @override
  _AllSongsTableState createState() => _AllSongsTableState();
}

class _AllSongsTableState extends State<AllSongsTable> {
  final searchController = TextEditingController();

  late SongService service;
  late Future<List<Song>> songs;

  @override
  void initState() {
    super.initState();
    this.service = SongService();
    //This doesn't return the songs' lyrics for faster loading
    this.songs = service.getAllSongs();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    left: formFieldPadding / 2,
                    bottom: defaultPadding,
                    right: formFieldPadding / 2,
                    top: defaultPadding),
                child: TextField(
                  controller: searchController,
                  onSubmitted: (value) {
                    _search(searchController.text); //search
                  },
                  decoration: InputDecoration(
                    hintText: LocalizationService.instance
                        .getLocalizedString('search'),
                    fillColor: secondaryColor,
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    suffixIcon: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            _clear();
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () {
                            _search(searchController.text);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        SizedBox(
          width: double.infinity,
          child: AllSongsFutureBuilder(
            songs: songs,
            fontsize: widget.songTableFontSize,
          ),
        ),
      ],
    );
  }

  void _search(String term) {
    this.setState(() {
      this.songs = this.service.getSongsByTitleOrArtist(term);
    });
  }

  void _clear() {
    this.setState(() {
      this.searchController.text = '';
      this.songs = this.service.getAllSongs();
    });
  }
}

class AllSongsFutureBuilder extends StatelessWidget {
  AllSongsFutureBuilder({
    Key? key,
    required this.songs,
    required this.fontsize,
  }) : super(key: key);

  double fontsize;
  final Future<List<Song>> songs;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Song>>(
        future: this.songs,
        builder: (BuildContext context, AsyncSnapshot<List<Song>> snapshot) {
          List<Widget> children = [];
          //Snapshot is ASYNC, we have to check if it has data before accessing it
          if (snapshot.hasData) {
            // We have to check if there is any data found, otherwise Paginated Data Table throws an error with 0 rows.
            if (snapshot.data!.length == 0) {
              children = <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(LocalizationService.instance
                      .getLocalizedString("no_songs_found")),
                )
              ];
            } else {
              children = <Widget>[
                PaginatedDataTable(
                  columnSpacing: defaultPadding,
                  headingRowHeight: dataTableHeadingRowHeight,
                  dataRowMinHeight: Responsive.getTableRowHeight(this.fontsize),
                  dataRowMaxHeight: Responsive.getTableRowHeight(this.fontsize),
                  showCheckboxColumn: false,
                  //Remove empty rows if the data length is less than rows per page
                  rowsPerPage: snapshot.data!.length > defaultRowsPerPage
                      ? defaultRowsPerPage
                      : snapshot.data!.length,
                  source: AllSongsData(snapshot.data, context, this.fontsize),
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
                )
              ];
            }
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          );
        });
  }
}

class AllSongsData extends DataTableSource {
  AllSongsData(List<Song>? data, BuildContext tableContext, double fontSize) {
    this._data = data;
    this.tableContext = tableContext;
    this.fontSize = fontSize;
  }

  late BuildContext tableContext;
  List<Song>? _data;
  late double fontSize;

  bool get isRowCountApproximate => false;
  int get rowCount => _data!.length;
  int get selectedRowCount => 0;
  DataRow getRow(int index) {
    return DataRow(
      onSelectChanged: (value) {
        Navigator.push(
          tableContext,
          MaterialPageRoute(
            builder: (context) => SonglistPlusMobileApp(
              activeScreen: EditSongScreen(
                songId: _data![index].id,
              ),
            ),
          ),
        );
      },
      cells: [
        DataCell(
          Container(
            width: Responsive.getTableCellWidth(2, tableContext),
            child: Text(
              _data![index].title,
              style: TextStyle(fontSize: this.fontSize, color: Colors.white70),
            ),
          ),
        ),
        DataCell(
          Container(
            width: Responsive.getTableCellWidth(2, tableContext),
            child: Text(
              _data![index].artist,
              style: TextStyle(fontSize: fontSize, color: Colors.white70),
            ),
          ),
        ),
      ],
    );
  }
}
