import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtils {
  static SharedPreferencesUtils? _instance = null;
  late SharedPreferences _prefs;
  Future? _initiliazedPromise;

  SharedPreferencesUtils._internal() {
    Completer initializedCompleter = Completer();
    _initiliazedPromise = initializedCompleter.future;
    SharedPreferences.getInstance().then((value) {
      _prefs = value;
      initializedCompleter.complete();
    });
  }

  SharedPreferences get prefs => _prefs;

  Future<bool> waitUntilInitialized() async {
    while (_initiliazedPromise == null) {
      debugPrint("Waiting for initialization of shared preferences");
    }

    await _initiliazedPromise;
    return true;
  }

  static SharedPreferencesUtils getInstance() {
    if (_instance == null) _instance = SharedPreferencesUtils._internal();

    return _instance!;
  }
}