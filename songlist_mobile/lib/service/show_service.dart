import 'package:songlist_mobile/database/dao/show_dao.dart';
import 'package:songlist_mobile/models/show.dart';

class ShowService {
  static List<Show> getRecentShows() {
    List<Show> recentShows = [];
    recentShows = ShowDao.getRecentShows();
    return recentShows;
  }
}
