import 'package:songlist_mobile/components/recent_show_card.dart';
import 'package:songlist_mobile/models/show.dart';
import 'package:songlist_mobile/responsive.dart';
import 'package:flutter/material.dart';
import 'package:songlist_mobile/service/show_service.dart';
import '../../../constants.dart';

class RecentShowsGrid extends StatelessWidget {
  const RecentShowsGrid({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Recently Added Shows",
                style: Theme.of(context).textTheme.subtitle1!),
            ElevatedButton.icon(
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: defaultPadding,
                  vertical:
                      defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
                ),
              ),
              onPressed: () {},
              icon: Icon(Icons.add),
              label: Text("New Show"),
            ),
          ],
        ),
        SizedBox(height: defaultPadding),
        Responsive(
          mobile: RecentShowsCardGridView(
              crossAxisCount: _size.width < 650 ? 2 : 4,
              childAspectRatio: _size.width < 650 ? 1.3 : 1),
          tablet: RecentShowsCardGridView(),
          desktop: RecentShowsCardGridView(
            childAspectRatio: _size.width < 1400 ? 1.1 : 1.4,
          ),
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class RecentShowsCardGridView extends StatelessWidget {
  RecentShowsCardGridView(
      {Key? key, int crossAxisCount = 4, double childAspectRatio = 1}) {
    this.crossAxisCount = crossAxisCount;
    this.childAspectRatio = childAspectRatio;
    this.recentShows = ShowService.getRecentShows();
  }

  late int crossAxisCount;
  late double childAspectRatio;
  late List<Show> recentShows;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: recentShows.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) => RecentShowCard(show: recentShows[index]),
    );
  }
}
