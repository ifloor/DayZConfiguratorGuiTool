class FolderSelection {
  static FolderSelection? _instance;

  String? selectedFolder;

  FolderSelection._internal();

  static FolderSelection getInstance() {
    _instance ??= FolderSelection._internal();

    return FolderSelection._instance!;
  }
}