import 'package:songlist_mobile/controllers/CustomMenuController.dart';
import 'package:songlist_mobile/util/constants.dart';
import 'package:songlist_mobile/util/responsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Application header for primary screens
// ignore: must_be_immutable
class Header extends StatelessWidget {
  Header(
      {Key? key,
      required this.title,
      this.showSideMenu = true,
      this.scaffoldKey})
      : super(key: key);

  final String title;
  bool showSideMenu;
  GlobalKey<ScaffoldState>? scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: defaultPadding),
      child: Row(
        children: [
          //Desktop: open drawer, no hamburguer menu
          //Mobile: closed drawer, with hamburguer menu
          //Either way, title always shows
          if (!Responsive.isDesktop(context) && showSideMenu)
            IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  context.read<CustomMenuController>().controlMenu(scaffoldKey);
                }),
          Text(
            this.title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          if (!Responsive.isMobile(context))
            Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
        ],
      ),
    );
  }
}
