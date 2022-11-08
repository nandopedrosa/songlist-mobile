import 'package:flutter/material.dart';

import 'package:songlist_mobile/components/common/header.dart';
import 'package:songlist_mobile/components/common/toast_message.dart';
import 'package:songlist_mobile/components/show/all_shows_table.dart';
import 'package:songlist_mobile/localization/localization_service.dart';
import 'package:songlist_mobile/main.dart';
import 'package:songlist_mobile/screens/show/edit_show_screen.dart';
import 'package:songlist_mobile/util/responsive.dart';

import '../../util/constants.dart';

// ignore: must_be_immutable
class AllShowsScreen extends StatefulWidget {
  // We need this to show a snackbar message after deleting a show (coming from the Edit Screen)
  late bool didDelete;

  AllShowsScreen({
    Key? key,
    this.didDelete = false,
  }) : super(key: key);

  @override
  _AllShowsScreenState createState() => _AllShowsScreenState(didDelete);
}

class _AllShowsScreenState extends State<AllShowsScreen> {
  late bool didDelete;
  _AllShowsScreenState(bool didDelete) {
    this.didDelete = didDelete;
  }
  void initState() {
    super.initState();
    // We need this to show a snackbar message after deleting a show (coming from the Edit Screen)
    if (didDelete)
      WidgetsBinding.instance.addPostFrameCallback((_) =>
          ToastMessage.showSuccessToast(
              LocalizationService.instance
                  .getLocalizedString('show_successfully_deleted'),
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
                    LocalizationService.instance.getLocalizedString('shows')),
            SizedBox(height: defaultPadding),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: NewShowButton(),
                        ),
                      ],
                    ),
                    SizedBox(height: defaultPadding),
                    AllShowsTable(),
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

class NewShowButton extends StatelessWidget {
  const NewShowButton({
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
              activeScreen: EditShowScreen(),
            ),
          ),
        );
      },
      icon: Icon(Icons.add),
      label: Text(
        LocalizationService.instance.getLocalizedString('new_show'),
      ),
    );
  }
}
