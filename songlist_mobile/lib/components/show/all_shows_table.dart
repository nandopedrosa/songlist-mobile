import 'package:flutter/material.dart';
import 'package:songlist_mobile/database/dto/show_dto.dart';
import 'package:songlist_mobile/localization/localization_service.dart';
import 'package:songlist_mobile/main.dart';
import 'package:songlist_mobile/screens/show/edit_show_screen.dart';
import 'package:songlist_mobile/service/show_service.dart';
import 'package:songlist_mobile/util/responsive.dart';
import '../../util/constants.dart';

// ignore: must_be_immutable
class AllShowsTable extends StatefulWidget {
  const AllShowsTable({
    Key? key,
  }) : super(key: key);

  @override
  _AllShowsTableState createState() => _AllShowsTableState();
}

class _AllShowsTableState extends State<AllShowsTable> {
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    this.service = ShowService();
    this.shows = service.getAllShows();
  }

  late ShowService service;
  late Future<List<ShowDto>> shows;

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
          child: AllShowsFutureBuilder(shows: shows),
        ),
      ],
    );
  }

  void _search(String term) {
    this.setState(() {
      this.shows = this.service.getShowsByName(term);
    });
  }

  void _clear() {
    this.setState(() {
      this.searchController.text = '';
      this.shows = this.service.getAllShows();
    });
  }
}

class AllShowsFutureBuilder extends StatelessWidget {
  const AllShowsFutureBuilder({
    Key? key,
    required this.shows,
  }) : super(key: key);

  final Future<List<ShowDto>> shows;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ShowDto>>(
        future: this.shows,
        builder: (BuildContext context, AsyncSnapshot<List<ShowDto>> snapshot) {
          List<Widget> children = [];

          //Snapshot is ASYNC, we have to check if it has data before accessing it
          if (snapshot.hasData) {
            // We have to check if there is any data found, otherwise Paginated Data Table throws an error with 0 rows.
            if (snapshot.data!.length == 0) {
              children = <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Expanded(
                    child: Text(LocalizationService.instance
                        .getLocalizedString("no_shows_found")),
                  ),
                )
              ];
            } else {
              children = <Widget>[
                PaginatedDataTable(
                  columnSpacing: defaultPadding,
                  headingRowHeight: dataTableHeadingRowHeight,
                  showCheckboxColumn: false,
                  //Remove empty rows if the data length is less than rows per page
                  rowsPerPage: snapshot.data!.length > defaultRowsPerPage
                      ? defaultRowsPerPage
                      : snapshot.data!.length,
                  source: AllShowsData(snapshot.data, context),
                  columns: [
                    DataColumn(
                      label: Text(LocalizationService.instance
                          .getLocalizedString("name")),
                    ),
                    DataColumn(
                      label: Text(LocalizationService.instance
                          .getLocalizedString("when")),
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

class AllShowsData extends DataTableSource {
  AllShowsData(List<ShowDto>? data, BuildContext tableContext) {
    this._data = data;
    this.tableContext = tableContext;
  }
  late BuildContext tableContext;
  List<ShowDto>? _data;

  bool get isRowCountApproximate => false;
  int get rowCount => _data!.length;
  int get selectedRowCount => 0;
  DataRow getRow(int index) {
    String? whenCell = LocalizationService.instance
        .getFullLocalizedDateAndTime(_data![index].when);
    if (whenCell == null) {
      whenCell = "";
    }
    return DataRow(
        onSelectChanged: (value) {
          Navigator.push(
            tableContext,
            MaterialPageRoute(
              builder: (context) => SonglistPlusMobileApp(
                activeScreen: EditShowScreen(
                  showId: _data![index].id,
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
                  _data![index].name,
                  style: TextStyle(color: Colors.white70),
                )),
          ),
          DataCell(
            Container(
              width: Responsive.getTableCellWidth(2, tableContext),
              child: Text(whenCell, style: TextStyle(color: Colors.white70)),
            ),
          ),
        ]);
  }
}
