import 'package:dayz_configurator_gui_tool/utils/folder_selection.dart';
import 'package:file_selector/file_selector.dart';

class ProjectSelection {

  static Future<void> select() async {
    String? folder = await getDirectoryPath(confirmButtonText: "Select server root folder");

    if (folder == null) return;

    _selectedFolder(folder);
  }

  static void _selectedFolder(String folder) {
    FolderSelection.getInstance().selectedFolder = folder;
  }
}