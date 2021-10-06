import 'package:songlist_mobile/controllers/MenuController.dart';
import 'package:songlist_mobile/responsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Header extends StatelessWidget {
  const Header({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!Responsive.isDesktop(context))
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: context.read<MenuController>().controlMenu,
          ),
        Text(
          "Welcome",
          style: Theme.of(context).textTheme.headline6,
        ),
      ],
    );
  }
}
