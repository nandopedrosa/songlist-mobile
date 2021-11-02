import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:songlist_mobile/components/common/back_header.dart';
import 'package:songlist_mobile/components/common/save_button.dart';
import 'package:songlist_mobile/components/common/share_setlist_button.dart';
import 'package:songlist_mobile/components/common/toast_message.dart';
import 'package:songlist_mobile/localization/localization_service.dart';
import 'package:songlist_mobile/main.dart';
import 'package:songlist_mobile/models/song.dart';
import 'package:songlist_mobile/screens/show/edit_show_screen.dart';
import 'package:songlist_mobile/service/setlist_service.dart';
import 'package:songlist_mobile/service/show_service.dart';
import 'package:songlist_mobile/service/song_service.dart';
import 'package:songlist_mobile/util/constants.dart';
import 'package:songlist_mobile/util/responsive.dart';

// ignore: must_be_immutable
class ManageSetlistScreen extends StatefulWidget {
  final String showName;
  final int showId;

  const ManageSetlistScreen(
      {Key? key, required this.showName, required this.showId})
      : super(key: key);

  @override
  _ManageSetlistScreen createState() =>
      _ManageSetlistScreen(showName: this.showName, showId: this.showId);
}

class _ManageSetlistScreen extends State<ManageSetlistScreen> {
  _ManageSetlistScreen({required this.showName, required this.showId});

  final String showName;
  final int showId;

  late SongService songService;
  late ShowService showService;
  late SetlistService setlistService;
  late Future<List<Song>> availableSongs;
  late Future<List<Song>> selectedSongs;

  @override
  void initState() {
    super.initState();
    this.songService = SongService();
    this.setlistService = SetlistService();
    this.showService = ShowService();
    this.availableSongs = setlistService.getAvailableSongs(showId);
    this.selectedSongs = setlistService.getSelectedSongs(showId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          // THIS IS IMPORTANT FOR THE SETLIST SCROLLING TO WORK, OTHERWISE IT WILL KEEP "PULLING BACK" TO TOP
          physics: ScrollPhysics(),
          child: Column(children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  // It takes 5/6 part of the screen
                  flex: 5,
                  child: SafeArea(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(defaultPadding),
                      child: Column(
                        children: [
                          BackHeader(
                              title: showName,
                              goBack: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SonglistPlusMobileApp(
                                      activeScreen:
                                          EditShowScreen(showId: showId),
                                    ),
                                  ),
                                );
                              }),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: Column(
                                    children: [
                                      FutureBuilder<List<Song>>(
                                        future: this.selectedSongs,
                                        builder: (BuildContext context,
                                            AsyncSnapshot<List<Song>>
                                                snapshot) {
                                          List<Widget> children = [];
                                          if (snapshot.hasData) {
                                            children = <Widget>[
                                              SaveButton(
                                                  onPressed: () {
                                                    this._saveSetlist(
                                                        snapshot.data!);
                                                  },
                                                  leftPadding: 0,
                                                  rightPadding: 0,
                                                  topPadding: defaultPadding),
                                              ShareSetlistButton(
                                                  onPressed: () {
                                                    this._share(snapshot.data!);
                                                  },
                                                  leftPadding: 0,
                                                  rightPadding: 0),
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
                                      FutureBuilder<List<List<Song>>>(
                                        //Use this to await on multiple futures
                                        future: Future.wait([
                                          this.availableSongs,
                                          this.selectedSongs
                                        ]),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<List<List<Song>>>
                                                snapshot) {
                                          List<Widget> children = [];
                                          if (snapshot.hasData) {
                                            children = <Widget>[
                                              DropdownSearch<Song>(
                                                maxHeight: Responsive
                                                    .getDropdownSearchHeight(
                                                        context),
                                                mode: Mode.MENU,
                                                items: snapshot.data![0],
                                                selectedItem: Song(
                                                    title: '',
                                                    artist: '',
                                                    created_on: ''),
                                                dropdownSearchDecoration:
                                                    InputDecoration(
                                                  labelText: LocalizationService
                                                      .instance
                                                      .getLocalizedString(
                                                          'add_song'),
                                                ),
                                                onChanged: (data) {
                                                  setState(() {
                                                    this._addToSetlist(data!,
                                                        snapshot.data![1]);
                                                    this._removeFromAvailableSongs(
                                                        data,
                                                        snapshot.data![0]);
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
                    padding: EdgeInsets.all(defaultPadding),
                    child: FutureBuilder<List<List<Song>>>(
                        //Use this to await on multiple futures
                        future: Future.wait(
                            [this.availableSongs, this.selectedSongs]),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<List<Song>>> snapshot) {
                          List<Widget> children = [];
                          if (snapshot.hasData) {
                            children = <Widget>[
                              //---- This is the selected Setlist -----
                              ReorderableListView.builder(
                                // THIS IS IMPORTANT FOR THE SETLIST SCROLLING TO WORK, OTHERWISE IT WILL KEEP "PULLING BACK" TO TOP
                                physics: BouncingScrollPhysics(),
                                onReorder: (int oldIndex, int newIndex) {
                                  setState(() {
                                    if (oldIndex < newIndex) {
                                      newIndex -= 1;
                                    }
                                    final Song draggedSong =
                                        snapshot.data![1].removeAt(oldIndex);
                                    snapshot.data![1]
                                        .insert(newIndex, draggedSong);
                                  });
                                },
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  final Song song = snapshot.data![1][index];
                                  // ----- Each Song -----
                                  return Card(
                                    key: Key(song.id.toString()),
                                    child: ListTile(
                                      leading: IconButton(
                                        icon: Icon(
                                          Icons.remove_circle,
                                          color:
                                              Color.fromRGBO(255, 67, 67, 0.6),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            Song s = this._removeFromSetlist(
                                                index, snapshot.data![1]);
                                            this._addToAvailableSongs(
                                                s, snapshot.data![0]);
                                          });
                                        },
                                      ),
                                      trailing: Icon(
                                        Icons.drag_handle,
                                        color: Colors.white,
                                      ),
                                      title: Text(
                                        (index + 1).toString() +
                                            '. ' +
                                            song.title,
                                      ),
                                    ),
                                  );
                                },
                                itemCount: snapshot.data![1].length,
                              )
                            ];
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: children,
                          );
                        }),
                  ),
                )
              ],
            )
          ]),
        ),
      ),
    );
  }

  void _share(List<Song> songs) {
    String songTitles = "";
    for (var i = 0; i < songs.length; i++) {
      songTitles += (i + 1).toString() + ". " + songs[i].title + "\n";
    }
    Share.share(songTitles,
        subject:
            LocalizationService.instance.getLocalizedString("setlist_for") +
                ' "' +
                this.showName +
                '"');
  }

  void _reorderAvailableSongs(List<Song> availableSongs) {
    availableSongs.sort((a, b) => a.title.compareTo(b.title));
  }

  void _addToSetlist(Song s, List<Song> selectedSongs) {
    selectedSongs.add(s);
  }

  Song _removeFromSetlist(int i, List<Song> selectedSongs) {
    return selectedSongs.removeAt(i);
  }

  void _addToAvailableSongs(Song s, List<Song> availableSongs) {
    availableSongs.add(s);
    this._reorderAvailableSongs(availableSongs);
  }

  void _removeFromAvailableSongs(Song s, List<Song> availableSongs) {
    for (var i = 0; i < availableSongs.length; i++) {
      if (availableSongs[i].id == s.id) {
        availableSongs.removeAt(i);
        break;
      }
    }
  }

  void _saveSetlist(List<Song> selectedSongs) {
    Duration d = Duration(hours: 0, minutes: 0, seconds: 0);
    for (Song s in selectedSongs) {
      if (s.duration != null && s.duration!.isNotEmpty) {
        d = d + s.getDurationObject();
      }
    }
    String totalDuration = _getPrettyTotalDuration(d);

    this.setlistService.save(this.showId, selectedSongs);
    this.showService.updateDuration(this.showId, totalDuration);
    this.showService.updateNumberOfSongs(this.showId, selectedSongs.length);

    ToastMessage.showSuccessToast(
        LocalizationService.instance.getLocalizedString('setlist_saved'));
  }

  String _getPrettyTotalDuration(Duration totalDuration) {
    String totalDurationRaw = totalDuration.toString();
    String d = totalDurationRaw.substring(0, totalDurationRaw.indexOf("."));

    if (d.startsWith("0")) {
      d = d.substring(d.indexOf(":") + 1);
      d = d.replaceFirst(":", "m:");
    } else {
      d = d.substring(d.indexOf(":") + 1);
      d = d.replaceFirst(":", "m:");
      d = totalDurationRaw.substring(0, totalDurationRaw.indexOf(":")) +
          "h:" +
          d;
    }

    return d + "s";
  }
}
