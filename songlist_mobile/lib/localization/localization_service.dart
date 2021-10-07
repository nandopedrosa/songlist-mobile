import 'package:songlist_mobile/localization/localization_strings.dart';
import 'package:songlist_mobile/localization/preferred_language.dart';

class LocalizationService {
  static Future<String> getLocalizedString(String key) async {
    String preferredLanguage = await PreferredLanguage.getPreferredLanguage();

    int index = 999;
    if (preferredLanguage == 'en' || preferredLanguage == '') {
      //english is the first option
      index = 0;
    } else if (preferredLanguage.startsWith('pt')) {
      //portuguese is the second option
      index = 1;
    }

    String localizedString = LocalizationStrings.localizedStrings[key]![index];

    return localizedString;
  }
}
