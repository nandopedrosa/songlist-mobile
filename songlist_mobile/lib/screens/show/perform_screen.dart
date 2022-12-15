import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  final String showName;

  const PerformScreen({Key? key, required this.showId, required this.showName})
      : super(key: key);

  @override
  _PerformScreen createState() =>
      _PerformScreen(showId: this.showId, showName: this.showName);
}

class _PerformScreen extends State<PerformScreen> {
  _PerformScreen({required this.showId, required this.showName});

  final int showId;
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
  final TextEditingController _songDurationController = TextEditingController();
  final _dropDownKey = GlobalKey<DropdownSearchState<Song>>();
  double _lyricsFontSizeSingleColumn = 16;
  double _lyricsFontSizeDoubleColumn = 24;
  double _fontSizeIncrements = 4;

  void _updateControllers(Song song) {
    _songTempoController.text =
        song.tempo == null ? "" : song.tempo.toString() + " bpm";
    _songKeyController.text = song.key == null ? "" : song.key!;
    _songDurationController.text = song.duration == null ? "" : song.duration!;
    _songTitleController.text = song.title;
    _songLyricsController.text = song.lyrics == null ? '' : song.lyrics!;
    _firstColumnLyricsController.text =
        _getLyricsColumnText(_songLyricsController.text, 1);
    _secondColumnLyricsController.text =
        _getLyricsColumnText(_songLyricsController.text, 2);
    setState(() {
      if (isAutoScroll) {
        _scroll(song.duration);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    this.setlistService = SetlistService();
    this.performanceSongsFuture = setlistService.getPerformanceSongs(showId);
    performanceSongsFuture.then((value) {
      if (value.length > 0) {
        this._updateControllers(
            value[0]); //update controllers with the first song values
      }
    });
  }

  bool isAutoScroll = false;
  ScrollController _scrollController = ScrollController();
  double speedFactor = 20;
  GlobalKey keyFinal =
      GlobalKey(); // serve para identificar a posicao do final da tela

  // Converts mm:ss format to seconds
  // If no duration is given, we default to 180 seconds
  int _durationToSeconds(String? songDuration) {
    if (songDuration == null || songDuration.isEmpty) {
      return 180;
    } else {
      String m = songDuration.split(":")[0];
      String s = songDuration.split(":")[1];
      if (m.startsWith("0")) {
        m = m.substring(1);
      }
      if (s.startsWith("0")) {
        s = s.substring(1);
      }

      return int.parse(m) * 60 + int.parse(s);
    }
  }

  // Fazemos o scroll proporcional à duração da música (em segundos)
  _scroll(String? songDuration) {
    _scrollController.jumpTo(0); //antes de cada scroll posicionamos no início
    int durationSeconds = _durationToSeconds(
        songDuration); //a velocidade depende da duracao da música

    // o scroll vai até o icone final, após a letra (fix para iOS)
    RenderBox box = keyFinal.currentContext!.findRenderObject() as RenderBox;
    Offset pos = box.localToGlobal(Offset.zero);
    double yFinal = pos.dy;

    _scrollController.animateTo(
      yFinal, // sempre vai para o fim da tela (ícone)
      duration: Duration(
        seconds: (durationSeconds),
      ),
      curve: Curves.linear,
    );
  }

  _stopScroll() {
    // Para parar a animação, simplesmente animamos para o Offset atual (ou seja, não faz nada)
    _scrollController.animateTo(_scrollController.offset,
        duration: Duration(seconds: 1), curve: Curves.linear);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          controller: _scrollController,
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
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(LocalizationService.instance
                                  .getLocalizedString('auto_scroll')),
                              Switch(
                                value: isAutoScroll,
                                onChanged: (_) {
                                  setState(() {
                                    isAutoScroll = !isAutoScroll;
                                  });

                                  if (isAutoScroll) {
                                    // Pegamos a música atual e sua duração
                                    Song s = this
                                        ._dropDownKey
                                        .currentState!
                                        .getSelectedItem!;
                                    _scroll(s.duration);
                                  } else {
                                    _stopScroll();
                                  }
                                },
                                activeTrackColor: Colors.lightGreenAccent,
                                activeColor: Colors.green,
                              ),
                              IconButton(
                                onPressed: () {
                                  this._decreaseFontSize();
                                },
                                icon: SvgPicture.asset(
                                  "assets/icons/decrease-font.svg",
                                  color: increaseAndDecreaseIconColor,
                                  height: increaseAndDecreaseIconHeight,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  this._increaseFontSize();
                                },
                                icon: SvgPicture.asset(
                                  "assets/icons/increase-font.svg",
                                  color: increaseAndDecreaseIconColor,
                                  height: increaseAndDecreaseIconHeight,
                                ),
                              ),
                            ],
                          ),
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
                          Padding(
                            padding: EdgeInsets.only(
                                left: formFieldPadding,
                                right: formFieldPadding),
                            child: Row(
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
                                                  emptyBuilder: (context,
                                                          searchEntry) =>
                                                      Center(
                                                          child: Text(LocalizationService
                                                              .instance
                                                              .getLocalizedString(
                                                                  "no_songs_found"))),
                                                  maxHeight: Responsive
                                                      .getDropdownSearchHeight(
                                                          context),
                                                  key: _dropDownKey,
                                                  compareFn: (i, s) =>
                                                      i?.isEqual(s!) ?? false,
                                                  mode: Mode.MENU,
                                                  items: snapshot.data,
                                                  selectedItem:
                                                      snapshot.data![0],
                                                  itemAsString: (Song? s) => s!
                                                      .songAsStringWithPosition(),
                                                  dropdownSearchDecoration:
                                                      InputDecoration(
                                                    labelText:
                                                        LocalizationService
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
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: TextFormFieldDisabled(
                                                  controller:
                                                      _songTempoController,
                                                  color: Colors.white54),
                                            ),
                                            Expanded(
                                              child: TextFormFieldDisabled(
                                                  controller:
                                                      _songKeyController,
                                                  color: Colors.white54),
                                            ),
                                            Expanded(
                                              child: TextFormFieldDisabled(
                                                  controller:
                                                      _songDurationController,
                                                  color: Colors.white54),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: TextFormFieldDisabled(
                                                alignment: TextAlign.start,
                                                controller:
                                                    _songTitleController,
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
                          ),
                          if (Responsive.isMobile(context))
                            SingleColumnLyrics(
                              songLyricsController: _songLyricsController,
                              fontSize: this._lyricsFontSizeSingleColumn,
                            )
                          else
                            DoubleColumnLyrics(
                                firstColumnLyricsController:
                                    this._firstColumnLyricsController,
                                secondColumnLyricsController:
                                    this._secondColumnLyricsController,
                                fontSize: this._lyricsFontSizeDoubleColumn),
                          Icon(
                            Icons.remove,
                            key: keyFinal,
                          ), // fim das letras - scrollar até aqui
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

  void _increaseFontSize() {
    setState(() {
      this._lyricsFontSizeSingleColumn += this._fontSizeIncrements;
      this._lyricsFontSizeDoubleColumn += this._fontSizeIncrements;
    });
  }

  void _decreaseFontSize() {
    setState(() {
      this._lyricsFontSizeSingleColumn -= this._fontSizeIncrements;
      this._lyricsFontSizeDoubleColumn -= this._fontSizeIncrements;
    });
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

  //This function calculates how much text should go on each column
  //The goal is to distribute text evenly between the two columns, but it is just an approximation
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
}

// ignore: must_be_immutable
class SingleColumnLyrics extends StatelessWidget {
  SingleColumnLyrics(
      {Key? key,
      required TextEditingController songLyricsController,
      required double fontSize})
      : _songLyricsController = songLyricsController,
        _fontSize = fontSize,
        super(key: key);

  TextEditingController _songLyricsController;
  double _fontSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
                right: formFieldPadding,
                left: formFieldPadding,
                bottom: defaultPadding),
            child: TextFormFieldDisabled(
              fontSize: _fontSize,
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
  DoubleColumnLyrics(
      {Key? key,
      required TextEditingController firstColumnLyricsController,
      required TextEditingController secondColumnLyricsController,
      required double fontSize})
      : _firstColumnLyricsController = firstColumnLyricsController,
        _secondColumnLyricsController = secondColumnLyricsController,
        _fontSize = fontSize,
        super(key: key);

  TextEditingController _firstColumnLyricsController;
  TextEditingController _secondColumnLyricsController;
  double _fontSize;

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
                    right: formFieldPadding,
                    left: formFieldPadding,
                    bottom: defaultPadding),
                child: TextFormFieldDisabled(
                  fontSize: _fontSize,
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
                  fontSize: _fontSize,
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
