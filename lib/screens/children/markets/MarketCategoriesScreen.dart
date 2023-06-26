import 'package:dayz_configurator_gui_tool/dataholders/expansion_market_data_holder.dart';
import 'package:flutter/cupertino.dart';

class MarketCategoriesScreen extends StatefulWidget {
  ExpansionMarketDataHolder dataHolder;

  MarketCategoriesScreen(this.dataHolder, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _MarketCategoriesScreenState(dataHolder);
  }

}

class _MarketCategoriesScreenState extends State<MarketCategoriesScreen> {
  ExpansionMarketDataHolder dataHolder;

  _MarketCategoriesScreenState(this.dataHolder);

  @override
  Widget build(BuildContext context) {
    return Text("asdadasdads");
  }


}
