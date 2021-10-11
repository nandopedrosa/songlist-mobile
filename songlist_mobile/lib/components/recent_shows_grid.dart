import 'package:songlist_mobile/components/recent_show_card.dart';
import 'package:songlist_mobile/database/dto/show_dto.dart';
import 'package:songlist_mobile/localization/localization_service.dart';
import 'package:songlist_mobile/responsive.dart';
import 'package:flutter/material.dart';
import 'package:songlist_mobile/service/show_service.dart';
import '../../../constants.dart';

class RecentShowsGrid extends StatefulWidget {
  const RecentShowsGrid({
    Key? key,
  }) : super(key: key);

  @override
  _RecentShowsGridState createState() => _RecentShowsGridState();
}

class _RecentShowsGridState extends State<RecentShowsGrid> {
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                LocalizationService.instance.getLocalizedString('recent_shows'),
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
              label: Text(
                LocalizationService.instance.getLocalizedString('new_show'),
              ),
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
class RecentShowsCardGridView extends StatefulWidget {
  RecentShowsCardGridView(
      {Key? key, int crossAxisCount = 4, double childAspectRatio = 1})
      : super(key: key) {
    this.crossAxisCount = crossAxisCount;
    this.childAspectRatio = childAspectRatio;
  }

  late int crossAxisCount;
  late double childAspectRatio;

  @override
  _RecentShowsCardGridViewState createState() =>
      _RecentShowsCardGridViewState();
}

class _RecentShowsCardGridViewState extends State<RecentShowsCardGridView> {
  @override
  void initState() {
    super.initState();
    this.service = ShowService();
    this.recentShows = service.getRecentShows();
  }

  late ShowService service;
  late Future<List<ShowDto>> recentShows;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ShowDto>>(
        future: this.recentShows,
        builder: (BuildContext context, AsyncSnapshot<List<ShowDto>> snapshot) {
          List<Widget> children = [];

          //Snapshot is ASYNC, we have to check if it has data before accessing it
          if (snapshot.hasData) {
            children = <Widget>[
              GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: widget.crossAxisCount,
                  crossAxisSpacing: defaultPadding,
                  mainAxisSpacing: defaultPadding,
                  childAspectRatio: widget.childAspectRatio,
                ),
                itemBuilder: (context, index) =>
                    RecentShowCard(show: snapshot.data![index]),
              ),
            ];
          }

          return Column(
            children: children,
          );
        });
  }
}
