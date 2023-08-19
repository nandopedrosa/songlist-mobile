import 'package:flutter/material.dart';
import 'package:songlist_mobile/database/dto/show_dto.dart';
import 'package:songlist_mobile/main.dart';
import 'package:songlist_mobile/screens/show/edit_show_screen.dart';
import '../../util/constants.dart';

class RecentShowCard extends StatelessWidget {
  const RecentShowCard({
    Key? key,
    required this.show,
  }) : super(key: key);

  final ShowDto show;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SonglistPlusMobileApp(
              activeScreen: EditShowScreen(showId: show.id),
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(defaultPadding),
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              show.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const Divider(
              height: 10,
              thickness: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${show.getNumberOfSongs} Songs",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Colors.white70),
                ),
                Text(
                  show.duration,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Colors.white70),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
