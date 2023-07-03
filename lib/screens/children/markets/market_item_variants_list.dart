import 'package:dayz_configurator_gui_tool/serialization/models/market/profiles_market_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MarketItemsVariantsList extends StatefulWidget {
  final ProfilesMarketItem? _item;

  const MarketItemsVariantsList(this._item, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _MarketItemsVariantsListState();
  }
}

class _MarketItemsVariantsListState extends State<MarketItemsVariantsList> {
  List<String>? _filteredVariants;
  String? _attachedToItem;

  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    if (_attachedToItem != widget._item?.ClassName) {
      _attachedToItem = widget._item?.ClassName;
      _filteredVariants = widget._item?.Variants;
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.15,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SearchBar(
            hintText: "Filter variants",
            leading: const Icon(Icons.search),
            onChanged: _didChangeFilterText,
          ),
          const Divider(),
          SizedBox(
            height: _getListHeight(),
            child: ListView.separated(
              separatorBuilder: (BuildContext context, int index) => const Divider(),
              scrollDirection: Axis.vertical,
              itemCount: _filteredVariants?.length ?? 0,
              itemBuilder: (context, index) {
                return ListTile(
                  enableFeedback: true,
                  selectedTileColor: Colors.black12,
                  selected: _selectedIndex == index,
                  title: Text(_filteredVariants?[index] ?? "N/A"),
                  dense: true,
                  onTap: () => {_didTapOnItem(index)},
                );
              }
            )
          ),
          const Divider(),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                child: const Icon(Icons.add),
                onPressed: () {},
              ),
              OutlinedButton(
                child: const Icon(Icons.delete),
                onPressed: () {},
              )
            ],
          )
        ],
      )
    );
  }

  double _getListHeight() {
    var calculatedHeight = MediaQuery.of(context).size.height - 505;
    if (calculatedHeight < 0) calculatedHeight = 0;
    return calculatedHeight;
  }

  void _didTapOnItem(int index) {
    _selectedIndex = index;
    setState(() {});
  }

  void _didChangeFilterText(String newFilterText) {
    _filteredVariants = [];

    widget._item?.Variants.forEach((variant) {
      if (newFilterText.isEmpty || variant.toLowerCase().contains(newFilterText.toLowerCase())) _filteredVariants?.add(variant);
    });

    setState(() {});
  }

}