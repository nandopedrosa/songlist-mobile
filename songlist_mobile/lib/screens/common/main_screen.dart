import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:songlist_mobile/components/common/side_menu.dart';
import 'package:songlist_mobile/controllers/CustomMenuController.dart';
import 'package:songlist_mobile/util/responsive.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';

//Main screen template for other screens
//Includes a header and a body
class MainScreen extends StatefulWidget {
  //The current active screen
  final Widget activeScreen;

  const MainScreen({Key? key, required this.activeScreen}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<CustomMenuController>().scaffoldKey,
      drawer: SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screens
            if (Responsive.isDesktop(context))
              Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: SideMenu(),
              ),
            Expanded(
              // It takes 5/6 part of the screen
              flex: 5,
              child: this.widget.activeScreen,
            ),
          ],
        ),
      ),
    );
  }
}
