import 'package:songlist_mobile/util/constants.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BackHeader extends StatelessWidget {
  final String title; //Header title
  final VoidCallback goBack; //Function to go back

  BackHeader({Key? key, this.title = '', required this.goBack})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: defaultPadding),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: goBack,
          ),
          Expanded(
            child: Text(
              this.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          )
        ],
      ),
    );
  }
}
