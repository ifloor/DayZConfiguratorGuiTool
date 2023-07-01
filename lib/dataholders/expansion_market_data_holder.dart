import 'package:dayz_configurator_gui_tool/serialization/models/market/profiles_market.dart';
import 'package:dayz_configurator_gui_tool/serialization/engine/market/market_categories_serializer.dart';

class ExpansionMarketDataHolder {
  List<ProfilesMarket>? categories;
  final MarketCategoriesLoader _marketCategoriesLoader;

  ExpansionMarketDataHolder.loadFromDisk(): _marketCategoriesLoader = MarketCategoriesLoader() {
    _marketCategoriesLoader.promiseWhenFinishedLoading().then((fetchedCategories) {
      categories = fetchedCategories;
    });
  }

  Future<List<ProfilesMarket>> promiseWhenFinishedLoading() {
    return _marketCategoriesLoader.promiseWhenFinishedLoading();
  }

  Future<void> saveToDisk() {
    return _marketCategoriesLoader.writeChangesToDisk();
  }

}