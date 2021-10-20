import 'package:songlist_mobile/database/dao/show_dao.dart';
import 'package:songlist_mobile/database/dto/show_dto.dart';
import 'package:songlist_mobile/localization/localization_service.dart';
import 'package:songlist_mobile/models/show.dart';
import 'package:songlist_mobile/util/validation.dart';

class ShowService {
  ShowDao _dao = ShowDao();

  static const int _recentShowsLimit = 4;

  Validation validate(Show show) {
    Validation validation = Validation(isValid: true, messages: []);

    if (show.name.isEmpty) {
      validation.isValid = false;
      validation.messages.add(
          LocalizationService.instance.getLocalizedString('name_mandatory'));
    }

    if (show.created_on.isEmpty) {
      validation.isValid = false;
      validation.messages.add(LocalizationService.instance
          .getLocalizedString('created_on_mandatory'));
    }

    return validation;
  }

  void updateDuration(int showId, String duration) {
    this._dao.updateDuration(showId, duration);
  }

  Future<int> save(Show show) {
    if (show.id == null) {
      return this._dao.insert(show);
    } else {
      return this._dao.update(show);
    }
  }

  void delete(int id) {
    this._dao.delete(id);
  }

  Future<Show> find(int id) {
    return this._dao.find(id);
  }

  Future<String> getDuration(int id) {
    return this._dao.getDuration(id);
  }

  Future<List<ShowDto>> getRecentShows() async {
    Future<List<ShowDto>> recentShows =
        this._dao.getRecentShows(_recentShowsLimit);
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
