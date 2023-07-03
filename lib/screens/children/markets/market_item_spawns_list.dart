import 'package:dayz_configurator_gui_tool/serialization/models/market/profiles_market_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MarketItemsSpawnsList extends StatefulWidget {
  final ProfilesMarketItem? _item;

  const MarketItemsSpawnsList(this._item, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _MarketItemsSpawnsListState();
  }
}

class _MarketItemsSpawnsListState extends State<MarketItemsSpawnsList> {
  List<String>? _filteredAttachments;
  String? _attachedToItem;

  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    if (_attachedToItem != widget._item?.ClassName) {
      _attachedToItem = widget._item?.ClassName;
      _filteredAttachments = widget._item?.SpawnAttachments;
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.15,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SearchBar(
            hintText: "Filter spawn with attachments",
            leading: const Icon(Icons.search),
            onChanged: _didChangeFilterText,
          ),
          const Divider(),
          SizedBox(
            height: _getListHeight(),
            child: ListView.separated(
              separatorBuilder: (BuildContext context, int index) => const Divider(),
              scrollDirection: Axis.vertical,
              itemCount: _filteredAttachments?.length ?? 0,
              itemBuilder: (context, index) {
                return ListTile(
                  enableFeedback: true,
                  selectedTileColor: Colors.black12,
                  selected: _selectedIndex == index,
                  title: Text(_filteredAttachments?[index] ?? "N/A"),
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
    _filteredAttachments = [];

    widget._item?.SpawnAttachments.forEach((attachment) {
      if (newFilterText.isEmpty || attachment.toLowerCase().contains(newFilterText.toLowerCase())) _filteredAttachments?.add(attachment);
    });

    setState(() {});
  }

}