import 'package:dayz_configurator_gui_tool/serializing/market/profiles_market.dart';
import 'package:dayz_configurator_gui_tool/utils/file/market_categories_loader.dart';

class ExpansionMarketDataHolder {
  List<ProfilesMarket>? categories;
  MarketCategoriesLoader marketCategoriesLoader;

  ExpansionMarketDataHolder.loadFromDisk(): marketCategoriesLoader = MarketCategoriesLoader() {
    marketCategoriesLoader.promiseWhenFinished().then((fetchedCategories) {
      categories = fetchedCategories;
    });
  }

  MarketCategoriesLoader getCategoriesLoader() {
    return marketCategoriesLoader;
  }

}