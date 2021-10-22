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
import 'package:songlist_mobile/util/responsive.dart';

// ignore: must_be_immutable
class PerformScreen extends StatefulWidget {
  final int showId;
  final String showWhen;
  final String showName;

  const PerformScreen(
      {Key? key,
      required this.showId,
      required this.showWhen,
      required this.showName})
      : super(key: key);

  @override
  _PerformScreen createState() => _PerformScreen(
      showId: this.showId, showWhen: this.showWhen, showName: this.showName);
}

class _PerformScreen extends State<PerformScreen> {
  _PerformScreen(
      {required this.showId, required this.showWhen, required this.showName});

  final int showId;
  final String showWhen;
  final String showName;
  late SetlistService setlistService;
  late Future<List<Song>> performanceSongsFuture;
  late List<Song> performanceSongsResolved;
  final TextEditingController _songTitleController = TextEditingController();
  final TextEditingController _songLyricsController = TextEditingController();
  final TextEditingController _firstColumnLyricsController =
      TextEditingController();
  final TextEditingController _secondColumnLyricsController =
      TextEditingController();
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
    _firstColumnLyricsController.text =
        _getLyricsColumnText(_songLyricsController.text, 1);
    _secondColumnLyricsController.text =
        _getLyricsColumnText(_songLyricsController.text, 2);
    _songTempoController.text =
        s.tempo == null ? tempoStr + "-" : tempoStr + s.tempo.toString();
    _songKeyController.text = s.key == null ? keyStr + "-" : keyStr + s.key!;
  }

  String _getLyricsColumnText(String fullLyrics, int column) {
    if (fullLyrics.isEmpty) return '';

    String s = '';
    int halfIndex = (fullLyrics.length / 2).floor();
    int doubleLineBreakBeforeHalfIndex =
        fullLyrics.substring(0, halfIndex).lastIndexOf("\n\n");
    int sigleLineBreakBeforeHalfIndex =
        fullLyrics.substring(0, halfIndex).lastIndexOf("\n");

    if (column == 1) {
      if (doubleLineBreakBeforeHalfIndex != -1)
        s = fullLyrics.substring(0, doubleLineBreakBeforeHalfIndex);
      else
        s = fullLyrics.substring(0, sigleLineBreakBeforeHalfIndex);
    } else if (column == 2) {
      if (doubleLineBreakBeforeHalfIndex != -1)
        s = fullLyrics.substring(doubleLineBreakBeforeHalfIndex);
      else
        s = fullLyrics.substring(sigleLineBreakBeforeHalfIndex);
    }

    return s.trim();
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
                          BackHeader(
                              title: showName,
                              goBack: () {
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
                                                flex: 3,
                                                child: TextFormFieldDisabled(
                                                    controller:
                                                        _songKeyController,
                                                    color: Colors.white54)),
                                          ]),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextFormFieldDisabled(
                                              alignment: TextAlign.center,
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
                              ]),
                          if (Responsive.isMobile(context))
                            SingleColumnLyrics(
                                songLyricsController: _songLyricsController)
                          else
                            DoubleColumnLyrics(
                              firstColumnLyricsController:
                                  this._firstColumnLyricsController,
                              secondColumnLyricsController:
                                  this._secondColumnLyricsController,
                            )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
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

class SingleColumnLyrics extends StatelessWidget {
  const SingleColumnLyrics({
    Key? key,
    required TextEditingController songLyricsController,
  })  : _songLyricsController = songLyricsController,
        super(key: key);

  final TextEditingController _songLyricsController;

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}

// ignore: must_be_immutable
class DoubleColumnLyrics extends StatelessWidget {
  DoubleColumnLyrics({
    Key? key,
    required TextEditingController firstColumnLyricsController,
    required TextEditingController secondColumnLyricsController,
  })  : _firstColumnLyricsController = firstColumnLyricsController,
        _secondColumnLyricsController = secondColumnLyricsController,
        super(key: key);

  TextEditingController _firstColumnLyricsController;
  TextEditingController _secondColumnLyricsController;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    right: defaultPadding,
                    left: defaultPadding * 2,
                    bottom: defaultPadding),
                child: TextFormFieldDisabled(
                  controller: this._firstColumnLyricsController,
                  keyBoardType: TextInputType.multiline,
                  maxLines: null,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    right: defaultPadding,
                    left: defaultPadding,
                    bottom: defaultPadding),
                child: TextFormFieldDisabled(
                  controller: this._secondColumnLyricsController,
                  keyBoardType: TextInputType.multiline,
                  maxLines: null,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
