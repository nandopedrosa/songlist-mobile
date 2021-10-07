import 'package:devicelocale/devicelocale.dart';

class PreferredLanguage {
  static String _preferredLanguage = '';

  static Future<String> getPreferredLanguage() async {
    if (_preferredLanguage == '') {
      //The current language is the first one
      List? languages = await Devicelocale.preferredLanguages;
      _preferredLanguage = languages![0];
    }

    return _preferredLanguage;
  }
}
