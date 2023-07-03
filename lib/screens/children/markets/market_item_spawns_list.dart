import 'package:dayz_configurator_gui_tool/interfaces/changes_controller.dart';
import 'package:dayz_configurator_gui_tool/serialization/models/market/profiles_market_item.dart';
import 'package:dayz_configurator_gui_tool/utils/dialog_utils.dart';
import 'package:flutter/material.dart';

class MarketItemsSpawnsList extends StatefulWidget {
  final ProfilesMarketItem? _item;
  final ChangesController? _changesController;


  const MarketItemsSpawnsList(this._item, this._changesController, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _MarketItemsSpawnsListState();
  }
}

class _MarketItemsSpawnsListState extends State<MarketItemsSpawnsList> {
  final _searchController = TextEditingController();

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
            controller: _searchController,
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
                onPressed: _didTapOnAdd,
                child: const Icon(Icons.add),
              ),
              OutlinedButton(
                onPressed: _didTapRemove,
                child: const Icon(Icons.delete),
              )
            ],
          )
        ],
      )
    );
  }

  List<Widget> _getNotPossibleToRemoveActions() {
    return [
      OutlinedButton(
        onPressed: () {
          DialogUtils.hideDialog(context);
        },
        child: const Text("OK"),
      )
    ];
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

  void _didTapRemove() {
    if (_selectedIndex == null) {
      DialogUtils.showTextDialog(context, "No attachment selected. Not possible to remove", _getNotPossibleToRemoveActions());
      return;
    }

    widget._item?.SpawnAttachments.removeAt(_selectedIndex!);
    _selectedIndex = null;
    _searchController.text = "";
    _didChangeFilterText("");
    widget._changesController?.changed();
  }

  void _didTapOnAdd() {
    DialogUtils.showInputTextDialog(context, "Add new attachment", "Item Classname").then((typedVariant) {
      if (typedVariant != null) {
        setState(() {
          _selectedIndex = null;
          widget._item?.SpawnAttachments.add(typedVariant);
          _searchController.text = "";
          _didChangeFilterText("");
          widget._changesController?.changed();
        });
      }
    });
  }
}