import 'package:dayz_configurator_gui_tool/components/button/styled_button.dart';
import 'package:dayz_configurator_gui_tool/interfaces/changes_controller.dart';
import 'package:dayz_configurator_gui_tool/serialization/models/market/profiles_market_item.dart';
import 'package:dayz_configurator_gui_tool/utils/dialog_utils.dart';
import 'package:dayz_configurator_gui_tool/utils/extensions/swappable_list.dart';
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
      width: MediaQuery.of(context).size.width * 0.17,
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

      if (_selectedIndex != null && _selectedIndex! < _filteredAttachments!.length - 1) {
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


    String filteredItemClassName = _filteredAttachments?[_selectedIndex!] ?? "";

    int foundIndex = -1;
    for (int i = 0; i < widget._item!.SpawnAttachments.length; i++) {
      String spawnClassname = widget._item!.SpawnAttachments[i];

      if (spawnClassname == filteredItemClassName) {
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
    _filteredAttachments = [];

    widget._item?.SpawnAttachments.forEach((attachment) {
      if (newFilterText.isEmpty || attachment.toLowerCase().contains(newFilterText.toLowerCase())) _filteredAttachments?.add(attachment);
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
      DialogUtils.showTextDialog(context, "No attachment selected. Not possible to remove", _getDialogOkActions());
      return;
    }

    int translatedIndex = _translateFilteredIndexToList();
    if (translatedIndex < 0) return;

    widget._item?.SpawnAttachments.removeAt(translatedIndex);
    _selectedIndex = null;
    _searchController.text = "";
    _didChangeFilterText("");
    widget._changesController?.changed();
  }

  void _didTapSwapUp() {
    if (_selectedIndex == null) {
      DialogUtils.showTextDialog(context, "No spawn attachment selected. Not possible to swap", _getDialogOkActions());
      return;
    }

    if(_selectedIndex == 0) return;

    setState(() {
      widget._item?.SpawnAttachments.swap(_selectedIndex!, _selectedIndex! - 1);
      _selectedIndex = _selectedIndex! - 1;
      widget._changesController?.changed();
      _didChangeFilterText(_searchController.text);
    });
  }

  void _didTapSwapDown() {
    if (_selectedIndex == null) {
      DialogUtils.showTextDialog(context, "No spawn attachment selected. Not possible to swap", _getDialogOkActions());
      return;
    }

    if(_selectedIndex == _filteredAttachments!.length - 1) return;

    setState(() {
      widget._item?.SpawnAttachments.swap(_selectedIndex!, _selectedIndex! + 1);
      _selectedIndex = _selectedIndex! + 1;
      widget._changesController?.changed();
      _didChangeFilterText(_searchController.text);
    });
  }

  void _didTapAdd() {
    DialogUtils.showInputTextDialog(context, "Add new attachment", "Item Classname").then((typedSpawnAttachment) {
      if (typedSpawnAttachment != null) {
        setState(() {
          _selectedIndex = null;
          widget._item?.SpawnAttachments.add(typedSpawnAttachment);
          _searchController.text = "";
          _didChangeFilterText("");
          widget._changesController?.changed();
        });
      }
    });
  }
}