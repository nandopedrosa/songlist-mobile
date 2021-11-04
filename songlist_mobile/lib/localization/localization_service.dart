import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:songlist_mobile/localization/localization_strings.dart';
import 'dart:io';

class LocalizationService {
  //Private constructor
  LocalizationService._();
  //Singleton implementation
  static final LocalizationService instance = LocalizationService._();

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

  //Param: ISO8601 formatted date (YYY-MM-DD HH:MM)
  //Return: 01/01/1996, HH24:
  //Obs: if the date parameter is not in the correct format, we just return the raw paramater date
  String? getFullLocalizedDateAndTime(String? iso8601Date) {
    if (!_isValidDate(iso8601Date)) return iso8601Date;

    String platformLocaleName = Platform.localeName;
    initializeDateFormatting(platformLocaleName, null);
    var parsedDate = DateTime.parse(iso8601Date!);
    var formatter = new DateFormat.yMd(platformLocaleName).add_Hm();
    String result = formatter.format(parsedDate);
    return result;
  }

  //If the date has any alphabetical characters, it is not valid
  bool _isValidDate(String? date) {
    if (date == null) return false;
    return !date.contains(RegExp(r'[A-Z|a-z]'));
  }
}
