import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:songlist_mobile/components/common/back_header.dart';
import 'package:songlist_mobile/components/common/text_form_field_disabled.dart';
import 'package:songlist_mobile/components/show/setlist_navigation_button.dart';
import 'package:songlist_mobile/localization/localization_service.dart';
import 'package:songlist_mobile/main.dart';
import 'package:songlist_mobile/models/song.dart';
import 'package:songlist_mobile/screens/show/edit_show_screen.dart';
import 'package:songlist_mobile/service/setlist_service.dart';
import 'package:songlist_mobile/util/constants.dart';

// ignore: must_be_immutable
class PerformScreen extends StatefulWidget {
  final int showId;
  final String showWhen;

  const PerformScreen({Key? key, required this.showId, required this.showWhen})
      : super(key: key);

  @override
  _PerformScreen createState() =>
      _PerformScreen(showId: this.showId, showWhen: this.showWhen);
}

class _PerformScreen extends State<PerformScreen> {
  _PerformScreen({required this.showId, required this.showWhen});

  final int showId;
  final String showWhen;
  late SetlistService setlistService;
  late Future<List<Song>> performanceSongsFuture;
  late List<Song> performanceSongsResolved;
  final TextEditingController _songTitleController = TextEditingController();
  final TextEditingController _songLyricsController = TextEditingController();
  final TextEditingController _songTempoController = TextEditingController();
  final TextEditingController _songKeyController = TextEditingController();
  final _dropDownKey = GlobalKey<DropdownSearchState<Song>>();

  void _updateControllers(Song s) {
    String tempoStr =
        LocalizationService.instance.getLocalizedString('tempo_no_bpm') + ": ";
    String keyStr =
        LocalizationService.instance.getLocalizedString('key') + ": ";

    _songTitleController.text = s.title;
    _songLyricsController.text = s.lyrics == null ? '' : s.lyrics!;
    _songTempoController.text =
        s.tempo == null ? tempoStr + "-" : tempoStr + s.tempo.toString();
    _songKeyController.text = s.key == null ? keyStr + "-" : keyStr + s.key!;
  }

  @override
  void initState() {
    super.initState();
    this.setlistService = SetlistService();
    this.performanceSongsFuture = setlistService.getPerformanceSongs(showId);
    setlistService
        .getFirstSongInPerformance(showId)
        .then((value) => _updateControllers(value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  // It takes 5/6 part of the screen
                  flex: 5,
                  child: SafeArea(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(
                          top: defaultPadding,
                          left: defaultPadding,
                          right: defaultPadding),
                      child: Column(
                        children: [
                          BackHeader(goBack: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SonglistPlusMobileApp(
                                  activeScreen: EditShowScreen(
                                    showId: showId,
                                    whenLabel: showWhen,
                                  ),
                                ),
                              ),
                            );
                          }),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: SetlistNavigationButton(
                                    onPressed: this._previous,
                                    topPad: 0,
                                    label: LocalizationService.instance
                                        .getLocalizedString("previous")),
                              ),
                              Expanded(
                                child: SetlistNavigationButton(
                                    topPad: 0,
                                    onPressed: this._next,
                                    label: LocalizationService.instance
                                        .getLocalizedString("next")),
                              ),
                            ],
                          ),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: Column(
                                    children: [
                                      FutureBuilder<List<Song>>(
                                        //Use this to await on multiple futures
                                        future: this.performanceSongsFuture,
                                        builder: (BuildContext context,
                                            AsyncSnapshot<List<Song>>
                                                snapshot) {
                                          List<Widget> children = [];
                                          if (snapshot.hasData) {
                                            this.performanceSongsResolved =
                                                snapshot.data!;
                                            children = <Widget>[
                                              DropdownSearch<Song>(
                                                key: _dropDownKey,
                                                compareFn: (i, s) =>
                                                    i?.isEqual(s!) ?? false,
                                                mode: Mode.MENU,
                                                items: snapshot.data,
                                                selectedItem: snapshot.data![0],
                                                itemAsString: (Song? s) => s!
                                                    .songAsStringWithPosition(),
                                                dropdownSearchDecoration:
                                                    InputDecoration(
                                                  labelText: LocalizationService
                                                      .instance
                                                      .getLocalizedString(
                                                          'setlist'),
                                                ),
                                                onChanged: (data) {
                                                  setState(() {
                                                    this._updateControllers(
                                                        data!);
                                                  });
                                                },
                                                showSearchBox: true,
                                              )
                                            ];
                                          }
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: children,
                                          );
                                        },
                                      ),
                                      SizedBox(height: defaultPadding),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Flexible(
                                                flex: 1,
                                                child: TextFormFieldDisabled(
                                                    controller:
                                                        _songTempoController,
                                                    color: Colors.white54)),
                                            Flexible(
                                                flex: 2,
                                                child: TextFormFieldDisabled(
                                                    controller:
                                                        _songKeyController,
                                                    color: Colors.white54)),
                                          ]),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextFormFieldDisabled(
                                              controller: _songTitleController,
                                              fontSize: defaultFontSize * 2,
                                              keyBoardType:
                                                  TextInputType.multiline,
                                              maxLines: null,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ])
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                        right: defaultPadding,
                        left: defaultPadding,
                        bottom: defaultPadding),
                    child: TextFormFieldDisabled(
                      controller: this._songLyricsController,
                      keyBoardType: TextInputType.multiline,
                      maxLines: null,
                    ),
                  ),
                )
              ],
            )
          ]),
        ),
      ),
    );
  }

  void _next() {
    Song currentSelectedSong = this._dropDownKey.currentState!.getSelectedItem!;
    //We go next only if this is not the last song
    // Position is indexed by 1, NOT by zero
    if (currentSelectedSong.position! < this.performanceSongsResolved.length) {
      Song nextSong =
          this.performanceSongsResolved[currentSelectedSong.position!];
      this._dropDownKey.currentState!.changeSelectedItem(nextSong);
    }
  }

  void _previous() {
    Song currentSelectedSong = this._dropDownKey.currentState!.getSelectedItem!;
    //We go previous only if this is not the first song
    // Position is indexed by 1, NOT by zero
    if (currentSelectedSong.position! != 1) {
      Song previousSong =
          this.performanceSongsResolved[currentSelectedSong.position! - 2];
      this._dropDownKey.currentState!.changeSelectedItem(previousSong);
    }
  }
}
