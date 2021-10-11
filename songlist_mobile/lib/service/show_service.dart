import 'package:songlist_mobile/database/dao/show_dao.dart';
import 'package:songlist_mobile/database/dto/show_dto.dart';

class ShowService {
  ShowDao _dao = ShowDao();

  Future<List<ShowDto>> getRecentShows() async {
    Future<List<ShowDto>> recentShows = this._dao.getRecentShows();
    return recentShows;
  }
}
