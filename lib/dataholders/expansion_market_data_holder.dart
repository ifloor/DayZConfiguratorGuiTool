import 'package:dayz_configurator_gui_tool/serialization/models/market/profiles_market.dart';
import 'package:dayz_configurator_gui_tool/serialization/engine/market/market_categories_serializer.dart';

class ExpansionMarketDataHolder {
  List<ProfilesMarket>? categories;
  final MarketCategoriesLoader _marketCategoriesLoader;
  final List<ProfilesMarket> _marketsPendingDeletion = [];

  ExpansionMarketDataHolder.loadFromDisk(): _marketCategoriesLoader = MarketCategoriesLoader() {
    _marketCategoriesLoader.promiseWhenFinishedLoading().then((fetchedCategories) {
      categories = fetchedCategories;
      categories?.sort((a, b) {
       return a.DisplayName.compareTo(b.DisplayName);
      });
    });
  }

  Future<List<ProfilesMarket>> promiseWhenFinishedLoading() {
    return _marketCategoriesLoader.promiseWhenFinishedLoading();
  }

  Future<void> saveToDisk() {
    _deleteAllTaggeds();
    return _marketCategoriesLoader.writeChangesToDisk();
  }

  void tagToDeletion(ProfilesMarket marketToDelete) {
    _marketsPendingDeletion.add(marketToDelete);
  }

  void _deleteAllTaggeds() {
    for (var marketToDelete in _marketsPendingDeletion) {
      _marketCategoriesLoader.deleteMarketFromDisk(marketToDelete);
    }

    _marketsPendingDeletion.clear();
  }
}