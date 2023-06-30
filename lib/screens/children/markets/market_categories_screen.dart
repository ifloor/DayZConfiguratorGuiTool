import 'package:dayz_configurator_gui_tool/dataholders/expansion_market_data_holder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  bool firstLoaded = false;

  _MarketCategoriesScreenState(this.dataHolder);

  @override
  Widget build(BuildContext context) {
    if (! firstLoaded) {
      firstLoaded = true;
      dataHolder.marketCategoriesLoader.promiseWhenFinished().then((_) {
        debugPrint("Loaded");
        // setState(() {});
      });
    }

    return Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        verticalDirection: VerticalDirection.up,
        children: [
          _buildCategoriesList(),
          const Text("asdadasdads"),
        ]);
    // return _buildCategoriesList();
  }

  Widget _buildCategoriesList() {
    return SizedBox(
        height: 200000,
        width: 500,
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: dataHolder.categories?.length ?? 0,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(dataHolder.categories?[index].DisplayName ?? ""),
              );
            }));
  }
}
