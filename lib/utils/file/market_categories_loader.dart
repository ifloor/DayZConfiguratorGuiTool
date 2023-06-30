import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dayz_configurator_gui_tool/serializing/market/profiles_market.dart';
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
  
  Future<List<ProfilesMarket>> promiseWhenFinished() {
    if (loadedMarkets != null) {
      return Future.value(loadedMarkets!);
    }

    var completer = Completer<List<ProfilesMarket>>();
    _waitingPromises.add(completer);

    return completer.future;
  }

  String _folderDirectoryPath() {
    var folderSelection = FolderSelection.getInstance();
    return "${folderSelection.selectedFolder ?? "n/a"}/${folderSelection.profilesName}/ExpansionMod/Market";
  }
}