import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:songlist_mobile/components/side_menu.dart';
import 'package:songlist_mobile/controllers/MenuController.dart';
import 'package:songlist_mobile/responsive.dart';

class MainScreen extends StatelessWidget {
  final Widget activeScreen;

  const MainScreen({
    Key? key,
    required this.activeScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuController>().scaffoldKey,
      drawer: SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: SideMenu(),
              ),
            Expanded(
              // It takes 5/6 part of the screen
              flex: 5,
              child: this.activeScreen,
            ),
          ],
        ),
      ),
    );
  }
}
