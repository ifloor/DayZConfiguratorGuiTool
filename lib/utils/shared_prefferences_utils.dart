import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtils {
  static SharedPreferencesUtils? _instance = null;
  late SharedPreferences _prefs;

  SharedPreferencesUtils._internal() {
    SharedPreferences.getInstance().then((value) {
      _prefs = value;
    });
  }

  SharedPreferences get prefs => _prefs;

  static SharedPreferencesUtils getInstance() {
    if (_instance == null) _instance = SharedPreferencesUtils._internal();

    return _instance!;
  }
}