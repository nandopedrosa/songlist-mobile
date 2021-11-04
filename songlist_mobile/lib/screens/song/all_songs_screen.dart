import 'package:flutter/material.dart';
import 'package:songlist_mobile/components/common/toast_message.dart';
import 'package:songlist_mobile/components/song/all_songs_table.dart';
import 'package:songlist_mobile/components/common/header.dart';
import 'package:songlist_mobile/localization/localization_service.dart';
import 'package:songlist_mobile/main.dart';
import 'package:songlist_mobile/util/responsive.dart';
import 'package:songlist_mobile/screens/song/edit_song_screen.dart';
import '../../util/constants.dart';

// ignore: must_be_immutable
class AllSongsScreen extends StatefulWidget {
  // We need this to show a snackbar message after deleting a song (coming from the Edit Screen)
  late bool didDelete;

  AllSongsScreen({
    Key? key,
    this.didDelete = false,
  }) : super(key: key);

  @override
  _AllSongsScreenState createState() => _AllSongsScreenState(didDelete);
}

class _AllSongsScreenState extends State<AllSongsScreen> {
  late bool didDelete;
  _AllSongsScreenState(bool didDelete) {
    this.didDelete = didDelete;
  }

  void initState() {
    super.initState();
    // We need this to show a snackbar message after deleting a song (coming from the Edit Screen)
    if (didDelete)
      WidgetsBinding.instance!.addPostFrameCallback((_) =>
          ToastMessage.showSuccessToast(
              LocalizationService.instance
                  .getLocalizedString('song_successfully_deleted'),
              context));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(
                title:
                    LocalizationService.instance.getLocalizedString('songs')),
            SizedBox(height: defaultPadding),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        NewSongButton(),
                      ],
                    ),
                    SizedBox(height: defaultPadding),
                    AllSongsTable(),
                  ],
                ),
              )
            ])
          ],
        ),
      ),
    );
  }
}

class NewSongButton extends StatelessWidget {
  const NewSongButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: defaultPadding,
          vertical: defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
        ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SonglistPlusMobileApp(
              activeScreen: EditSongScreen(),
            ),
          ),
        );
      },
      icon: Icon(Icons.add),
      label: Text(
        LocalizationService.instance.getLocalizedString('new_song'),
      ),
    );
  }
}
