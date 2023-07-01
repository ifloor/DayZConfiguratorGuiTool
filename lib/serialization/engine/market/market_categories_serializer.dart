import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dayz_configurator_gui_tool/serialization/models/market/profiles_market.dart';
import 'package:dayz_configurator_gui_tool/utils/folder_selection.dart';
import 'package:flutter/cupertino.dart';

class MarketCategoriesLoader {
  final List<Completer<List<ProfilesMarket>>> _waitingPromises = [];
  List<ProfilesMarket>? loadedMarkets;

  MarketCategoriesLoader() {
    var files = Directory(_folderDirectoryPath()).listSync();
    // TODO toast when error happens about directory not working
    List<ProfilesMarket> parsedMarkets = [];
    for (var fileRef in files) {
      debugPrint("file: ${fileRef.path}");
      var file = File(fileRef.path);
      file.readAsString().then((fileContent) {
        debugPrint("Read: ${fileRef.path}");

        var jsonDecoded = jsonDecode(fileContent);
        var market = ProfilesMarket.fromJson(jsonDecoded);
        market.diskFilename =  file.path.split("\\").last.split("/").last ?? "";

        parsedMarkets.add(market);

        if (parsedMarkets.length == files.length) {
          debugPrint("Read it all");
          _loadedMarkets(parsedMarkets);
        }
      });
    }
  }

  void _loadedMarkets(List<ProfilesMarket> parsedMarkets) {
    loadedMarkets = parsedMarkets;

    for (var waitingPromise in _waitingPromises) {
      waitingPromise.complete(loadedMarkets);
    }

    _waitingPromises.clear();
  }
  
  Future<List<ProfilesMarket>> promiseWhenFinishedLoading() {
    if (loadedMarkets != null) {
      return Future.value(loadedMarkets!);
    }

    var completer = Completer<List<ProfilesMarket>>();
    _waitingPromises.add(completer);

    return completer.future;
  }

  Future<void> writeChangesToDisk() {
    if (loadedMarkets == null) {
      debugPrint("Impossible to save because markets are null");
      return Future(() => null);
    }

    var folderDirectory = _folderDirectoryPath();

    final futureCompleter = Completer();

    const jsonEncoder = JsonEncoder.withIndent("    ");
    var finishedWrites = 0;
    for (final profileMarket in loadedMarkets!) {
      final jsonString = jsonEncoder.convert(profileMarket);
      final targetFilePath = "$folderDirectory/${profileMarket.diskFilename}";

      var file = File(targetFilePath);
      file.writeAsString(jsonString).then((_) {
        debugPrint("Finished writing $targetFilePath");
        finishedWrites++;

        if (finishedWrites == loadedMarkets!.length) {
          futureCompleter.complete(null);
        }
      });
    }

    return futureCompleter.future;
  }

  String _folderDirectoryPath() {
    var folderSelection = FolderSelection.getInstance();
    return "${folderSelection.selectedFolder ?? "n/a"}/${folderSelection.profilesName}/ExpansionMod/Market";
  }
}