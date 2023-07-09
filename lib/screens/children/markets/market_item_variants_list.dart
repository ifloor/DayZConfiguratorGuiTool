import 'package:dayz_configurator_gui_tool/components/button/styled_button.dart';
import 'package:dayz_configurator_gui_tool/interfaces/changes_controller.dart';
import 'package:dayz_configurator_gui_tool/serialization/models/market/profiles_market_item.dart';
import 'package:dayz_configurator_gui_tool/utils/dialog_utils.dart';
import 'package:dayz_configurator_gui_tool/utils/extensions/swappable_list.dart';
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
          _buildListActions(),
        ],
      )
    );
  }

  Widget _buildListActions() {
    List<Widget> rowChildren = [
      StyledButton.get(
        onPressed: _didTapAdd,
        child: const Icon(Icons.add),
      ),
      const SizedBox(width: 2),
      StyledButton.get(
        onPressed: _didTapRemove,
        child: const Icon(Icons.delete),
      ),
    ];

    if (_searchController.value.text.isEmpty) {
      if (_selectedIndex != null && _selectedIndex! > 0) {
        rowChildren.addAll([
          const SizedBox(width: 2),
          StyledButton.get(
            onPressed: _didTapSwapUp,
            child: const Icon(Icons.arrow_upward_sharp),
          ),
        ]);
      }

      if (_selectedIndex != null && _selectedIndex! < _filteredVariants!.length - 1) {
        rowChildren.addAll([
          const SizedBox(width: 2),
          StyledButton.get(
            onPressed: _didTapSwapDown,
            child: const Icon(Icons.arrow_downward_sharp),
          ),
        ]);
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: rowChildren,
    );
  }

  List<Widget> _getDialogOkActions() {
    return [
      OutlinedButton(
        onPressed: () {
          DialogUtils.hideDialog(context);
        },
        child: const Text("OK"),
      )
    ];
  }

  int _translateFilteredIndexToList() {
    if (_selectedIndex == null) return -1;
    if (widget._item == null) return -1;


    String filteredItemClassName = _filteredVariants?[_selectedIndex!] ?? "";

    int foundIndex = -1;
    for (int i = 0; i < widget._item!.Variants.length; i++) {
      String variantClassname = widget._item!.Variants[i];

      if (variantClassname == filteredItemClassName) {
        foundIndex = i;
        break;
      }
    }

    return foundIndex;
  }

  double _getListHeight() {
    var calculatedHeight = MediaQuery.of(context).size.height - 505;
    if (calculatedHeight < 0) calculatedHeight = 0;
    return calculatedHeight;
  }

  void _didChangeFilterText(String newFilterText) {
    _filteredVariants = [];

    widget._item?.Variants.forEach((variant) {
      if (newFilterText.isEmpty || variant.toLowerCase().contains(newFilterText.toLowerCase())) _filteredVariants?.add(variant);
    });

    _selectedIndex = null;
    setState(() {});
  }

  void _didTapOnItem(int index) {
    _selectedIndex = index;
    setState(() {});
  }

  void _didTapRemove() {
    if (_selectedIndex == null) {
      DialogUtils.showTextDialog(context, "No variant selected. Not possible to remove", _getDialogOkActions());
      return;
    }

    int translatedIndex = _translateFilteredIndexToList();
    if (translatedIndex < 0) return;

    widget._item?.Variants.removeAt(translatedIndex);
    _selectedIndex = null;
    _searchController.text = "";
    _didChangeFilterText("");
    widget._changesController?.changed();
  }

  void _didTapSwapUp() {
    if (_selectedIndex == null) {
      DialogUtils.showTextDialog(context, "No variant selected. Not possible to swap", _getDialogOkActions());
      return;
    }

    if(_selectedIndex == 0) return;

    setState(() {
      widget._item?.Variants.swap(_selectedIndex!, _selectedIndex! - 1);
      _selectedIndex = _selectedIndex! - 1;
      widget._changesController?.changed();
      _didChangeFilterText(_searchController.text);
    });
  }

  void _didTapSwapDown() {
    if (_selectedIndex == null) {
      DialogUtils.showTextDialog(context, "No variant selected. Not possible to swap", _getDialogOkActions());
      return;
    }

    if(_selectedIndex == _filteredVariants!.length - 1) return;

    setState(() {
      widget._item?.Variants.swap(_selectedIndex!, _selectedIndex! + 1);
      _selectedIndex = _selectedIndex! + 1;
      widget._changesController?.changed();
      _didChangeFilterText(_searchController.text);
    });
  }

  void _didTapAdd() {
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