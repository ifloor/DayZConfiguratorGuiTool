import 'package:dayz_configurator_gui_tool/interfaces/changes_controller.dart';
import 'package:dayz_configurator_gui_tool/serialization/models/market/profiles_market_item.dart';
import 'package:dayz_configurator_gui_tool/utils/dialog_utils.dart';
import 'package:flutter/material.dart';

class MarketItemsVariantsList extends StatefulWidget {
  final ProfilesMarketItem? _item;
  final ChangesController? _changesController;


  const MarketItemsVariantsList(this._item, this._changesController, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _MarketItemsVariantsListState();
  }
}

class _MarketItemsVariantsListState extends State<MarketItemsVariantsList> {
  final _searchController = TextEditingController();

  List<String>? _filteredVariants;
  String? _attachedToItem;

  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    if (_attachedToItem != widget._item?.ClassName) {
      _attachedToItem = widget._item?.ClassName;
      _filteredVariants = widget._item?.Variants;
      _selectedIndex = null;
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
            controller: _searchController,
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
    _filteredVariants = [];

    widget._item?.Variants.forEach((variant) {
      if (newFilterText.isEmpty || variant.toLowerCase().contains(newFilterText.toLowerCase())) _filteredVariants?.add(variant);
    });

    setState(() {});
  }

  void _didTapRemove() {
    if (_selectedIndex == null) {
      DialogUtils.showTextDialog(context, "No variant selected. Not possible to remove", _getNotPossibleToRemoveActions());
      return;
    }

    widget._item?.Variants.removeAt(_selectedIndex!);
    _selectedIndex = null;
    _searchController.text = "";
    _didChangeFilterText("");
    widget._changesController?.changed();
  }

  void _didTapOnAdd() {
    DialogUtils.showInputTextDialog(context, "Add new variant", "Item Classname").then((typedVariant) {
      if (typedVariant != null) {
        setState(() {
          _selectedIndex = null;
          widget._item?.Variants.add(typedVariant);
          _searchController.text = "";
          _didChangeFilterText("");
          widget._changesController?.changed();
        });
      }
    });
  }

}