import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:emarket_delivery_boy/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationProvider extends ChangeNotifier {
  final SharedPreferences? sharedPreferences;

  LocalizationProvider({required this.sharedPreferences}) {
    _loadCurrentLanguage();
  }

  Locale _locale = const Locale('en', 'US');
  bool _isLtr = true;

  Locale get locale => _locale;

  bool get isLtr => _isLtr;

  void setLanguage(Locale locale) {
    _locale = locale;
    if (_locale.languageCode == 'ar') {
      _isLtr = false;
    } else {
      _isLtr = true;
    }
    _saveLanguage(_locale);
    notifyListeners();
  }

  _loadCurrentLanguage() async {
    String? languageCode =
        sharedPreferences?.getString(AppConstants.languageCode);
    String? countryCode =
        sharedPreferences?.getString(AppConstants.countryCode);

    if (languageCode == null || countryCode == null) {
      Locale systemLocale = PlatformDispatcher.instance.locale;

      _locale =
          Locale(systemLocale.languageCode, systemLocale.countryCode ?? 'US');
      _isLtr = systemLocale.languageCode == 'en';

      _saveLanguage(_locale);
    } else {
      _locale = Locale(languageCode, countryCode);
      _isLtr = _locale.languageCode == 'en';
    }

    notifyListeners();
  }

  _saveLanguage(Locale locale) async {
    sharedPreferences!
        .setString(AppConstants.languageCode, locale.languageCode);
    sharedPreferences!.setString(AppConstants.countryCode, locale.countryCode!);
  }
}
