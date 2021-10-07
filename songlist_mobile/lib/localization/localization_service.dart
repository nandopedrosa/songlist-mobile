import 'package:songlist_mobile/localization/localization_strings.dart';
import 'dart:io';

class LocalizationService {
  //Singleton implementation
  static LocalizationService _instance = LocalizationService._();

  //Private constructor
  LocalizationService._();

  //Get singleton instance
  static LocalizationService getInstance() {
    return _instance;
  }

  String _preferredLanguage = '';

  String getPreferredLanguage() {
    return this._preferredLanguage;
  }

  //English is the default language
  //We only change to Portuguese if that is the user's preferred language.
  //Anything else is not supported and defaults to English
  String getLocalizedString(String key) {
    if (this._preferredLanguage == '') {
      String currentSystemLocale =
          Platform.localeName; // Returns locale string in the form 'en_US'
      if (currentSystemLocale.startsWith('pt')) {
        this._preferredLanguage = 'pt';
      } else {
        this._preferredLanguage = 'en';
      }
    }

    // English (default, index 0)
    // Portuguese (index 1)
    // We use these indexes to fetch values from associative map
    int index = this._preferredLanguage == 'en' ? 0 : 1;

    String localizedString = LocalizationStrings.localizedStrings[key]![index];

    return localizedString;
  }
}
