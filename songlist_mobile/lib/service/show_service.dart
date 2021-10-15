import 'package:songlist_mobile/database/dao/show_dao.dart';
import 'package:songlist_mobile/database/dto/show_dto.dart';

class ShowService {
  ShowDao _dao = ShowDao();

  Future<List<ShowDto>> getRecentShows() async {
    Future<List<ShowDto>> recentShows = this._dao.getRecentShows();
    return recentShows;
  }

  Future<List<ShowDto>> getAllShows() async {
    Future<List<ShowDto>> allShows = this._dao.getAllShows();
    return allShows;
  }

  Future<List<ShowDto>> getShowsByName(String term) async {
    Future<List<ShowDto>> shows;

    if (term.isEmpty) {
      shows = getAllShows();
    } else {
      term = term.toLowerCase().trim();
      shows = this._dao.getShowsByName(term);
    }

    return shows;
  }
}
