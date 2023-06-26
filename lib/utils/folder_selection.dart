import 'package:dayz_configurator_gui_tool/utils/shared_prefferences_utils.dart';

class FolderSelection {
  static FolderSelection? _instance;
  static const String _prefsKey = "folder-selection-prefs";

  String? _selectedFolder;
  String profilesName = "profiles";
  String missionName = "dayzOffline.chernarusplus";

  FolderSelection._internal() {
    _selectedFolder = SharedPreferencesUtils.getInstance().prefs.getString(_prefsKey);
  }

  set selectedFolder(String? value) {
    _selectedFolder = value;
    if (value != null) {
      SharedPreferencesUtils.getInstance().prefs.setString(_prefsKey, _selectedFolder!);
    } else {
      SharedPreferencesUtils.getInstance().prefs.remove(_prefsKey);
    }
  }

  String? get selectedFolder => _selectedFolder;

  static FolderSelection getInstance() {
    _instance ??= FolderSelection._internal();

    return FolderSelection._instance!;
  }
}