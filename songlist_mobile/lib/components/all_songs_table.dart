import 'package:flutter/material.dart';
import 'package:songlist_mobile/localization/localization_service.dart';
import 'package:songlist_mobile/models/song.dart';
import 'package:songlist_mobile/service/song_service.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants.dart';

// ignore: must_be_immutable
class AllSongsTable extends StatefulWidget {
  const AllSongsTable({
    Key? key,
  }) : super(key: key);

  @override
  _AllSongsTableState createState() => _AllSongsTableState();
}

class _AllSongsTableState extends State<AllSongsTable> {
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    this.service = SongService();
    this.songs = service.getAllSongs();
  }

  late SongService service;
  late Future<List<Song>> songs;

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
                    left: defaultPadding / 8,
                    bottom: defaultPadding,
                    right: defaultPadding / 8,
                    top: defaultPadding),
                child: TextField(
                  controller: searchController,
                  onSubmitted: (value) {
                    _search(searchController.text);
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
          child: FutureBuilder<List<Song>>(
              future: this.songs,
              builder:
                  (BuildContext context, AsyncSnapshot<List<Song>> snapshot) {
                List<Widget> children = [];

                //Snapshot is ASYNC, we have to check if it has data before accessing it
                if (snapshot.hasData) {
                  children = <Widget>[
                    PaginatedDataTable(
                      columnSpacing: 48.0,
                      showCheckboxColumn: false,
                      rowsPerPage: 2,
                      source: AllSongsData(snapshot.data),
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

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: children,
                );
              }),
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

class AllSongsData extends DataTableSource {
  AllSongsData(List<Song>? data) {
    this._data = data;
  }

  List<Song>? _data;

  bool get isRowCountApproximate => false;
  int get rowCount => _data!.length;
  int get selectedRowCount => 0;
  DataRow getRow(int index) {
    return DataRow(cells: [
      DataCell(
          Text(_data![index].title, style: TextStyle(color: Colors.white70))),
      DataCell(
          Text(_data![index].artist, style: TextStyle(color: Colors.white70))),
    ]);
  }
}