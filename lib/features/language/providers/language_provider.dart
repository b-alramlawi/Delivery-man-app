import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:emarket_delivery_boy/features/language/domain/models/language_model.dart';
import 'package:emarket_delivery_boy/features/language/domain/reposotories/language_repo.dart';

class LanguageProvider with ChangeNotifier {
  final LanguageRepo? languageRepo;

  LanguageProvider({this.languageRepo});

  int? _selectIndex = 0;
  List<LanguageModel> _languages = [];

  int? get selectIndex => _selectIndex;

  List<LanguageModel> get languages => _languages;

  Future<void> loadSelectedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? savedIndex = prefs.getInt('selected_language_index');
    if (savedIndex != null &&
        savedIndex >= 0 &&
        savedIndex < _languages.length) {
      _selectIndex = savedIndex;
    } else {
      _selectIndex = 0;
    }
    notifyListeners();
  }

  Future<void> saveSelectedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_selectIndex != null) {
      await prefs.setInt('selected_language_index', _selectIndex!);
    }
  }

  void changeSelectIndex(int? index) {
    _selectIndex = index;
    saveSelectedLanguage();
    notifyListeners();
  }

  void searchLanguage(String query, BuildContext context) {
    if (query.isEmpty) {
      _languages.clear();
      _languages = languageRepo!.getAllLanguages(context: context);
    } else {
      _selectIndex = -1;
      _languages = [];
      languageRepo!.getAllLanguages(context: context).forEach((product) async {
        if (product.languageName!.toLowerCase().contains(query.toLowerCase())) {
          _languages.add(product);
        }
      });
    }
    notifyListeners();
  }

  void initializeAllLanguages(BuildContext context) {
    if (_languages.isEmpty) {
      _languages.clear();
      _languages = languageRepo!.getAllLanguages(context: context);
    }
  }
}
