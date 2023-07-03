import 'package:dayz_configurator_gui_tool/components/bordering/labeled_container.dart';
import 'package:dayz_configurator_gui_tool/components/inputtext/styled_text_field.dart';
import 'package:dayz_configurator_gui_tool/interfaces/changes_controller.dart';
import 'package:dayz_configurator_gui_tool/screens/children/markets/market_item_spawns_list.dart';
import 'package:dayz_configurator_gui_tool/screens/children/markets/market_item_variants_list.dart';
import 'package:dayz_configurator_gui_tool/serialization/models/market/profiles_market.dart';
import 'package:dayz_configurator_gui_tool/serialization/models/market/profiles_market_item.dart';
import 'package:dayz_configurator_gui_tool/utils/dialog_utils.dart';
import 'package:flutter/material.dart';

class MarketCategoryItemsScreen extends StatefulWidget {

  final ProfilesMarket? _category;
  final ChangesController _changesController;

  const MarketCategoryItemsScreen(this._category, this._changesController, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _MarketCategoryItemsScreenState();
  }
}

class _MarketCategoryItemsScreenState extends State<MarketCategoryItemsScreen> {
  ProfilesMarket? _attachedToCategory;
  ProfilesMarketItem? _selectedItem;
  int? _selectedItemIndex;
  List<ProfilesMarketItem> _filteredItems = [];

  final _searchController = TextEditingController();

  final _itemMinStockController = TextEditingController();
  final _itemMaxStockController = TextEditingController();
  final _itemMinPriceController = TextEditingController();
  final _itemMaxPriceController = TextEditingController();
  final _itemSellingPricePercentageController = TextEditingController();
  final _itemQuantityPercentageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    debugPrint("Building managing for category: ${widget._category?.DisplayName}");
    if (_attachedToCategory == null || _attachedToCategory!.diskFilename != widget._category?.diskFilename) {
      _attachedToCategory = widget._category;
      _didChangeFilterText("");
      _selectedItem = null;
      _selectedItemIndex = null;
    }

    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.start,
      verticalDirection: VerticalDirection.up,
      children: [
        Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            _buildItemsList(),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.25,
              height: 20,
              child: const Divider(),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                OutlinedButton(
                  onPressed: _didTapAdd,
                  child: const Icon(Icons.add),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: _didTapRemove,
                  child: const Icon(Icons.delete),
                )
              ],
            )
          ],
        ),
        SizedBox(
          height: _getListDividerHeight(),
          child: const VerticalDivider(),
        ),
        _selectedItem != null ? _buildItemManaging() : const Text(""),

      ],
    );
  }

  Widget _buildItemsList() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.25,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SearchBar(
            hintText: "Filter items",
          leading: const Icon(Icons.search),
          controller: _searchController,
          onChanged: _didChangeFilterText,
        ),
          const Divider(),
          SizedBox(
            height: _getListHeight(),
            child: ListView.separated(
              separatorBuilder: (BuildContext context, int index) => const Divider(),
              scrollDirection: Axis.vertical,
              itemCount: _filteredItems?.length ?? 0,
              itemBuilder: (context, index) {
                return ListTile(
                  enableFeedback: true,
                  selectedTileColor: Colors.black12,
                  selected: _selectedItemIndex == index,
                  title: Text(_filteredItems?[index].ClassName ?? "N/A"),
                  dense: true,
                  onTap: () => {_didTapOnItem(index)},
                );
              }
            )
          ),
        ],
      )
    );
  }

  Widget _buildItemManaging() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          StyledTextField.get(
              width: MediaQuery.of(context).size.width * 0.25,
              labelText: "Class name",
              controller: TextEditingController(text: _selectedItem?.ClassName ?? "n/a"),
              readOnly: true
          ),
          StyledTextField.get(
            width: 150,
            labelText: "Min stock threshold",
            controller: _itemMinStockController,
            textFormatting: TextFormatting.NATURAL_NUMBERS,
            onChanged: _didChangeMinStockThreshold,
          ),
          StyledTextField.get(
            width: 150,
            labelText: "Max stock threshold",
            controller: _itemMaxStockController,
            textFormatting: TextFormatting.NATURAL_NUMBERS,
            onChanged: _didChangeMaxStockThreshold,
          ),
        ]),
        Row(
          children: [
            StyledTextField.get(
              width: 150,
              labelText: "Minimum price",
              controller: _itemMinPriceController,
              textFormatting: TextFormatting.NATURAL_NUMBERS,
              onChanged: _didChangeMinPrice,
            ),
            StyledTextField.get(
              width: 150,
              labelText: "Maximum price",
              controller: _itemMaxPriceController,
              textFormatting: TextFormatting.NATURAL_NUMBERS,
              onChanged: _didChangeMaxPrice,
            ),
            StyledTextField.get(
              width: 150,
              labelText: "Selling price %",
              controller: _itemSellingPricePercentageController,
              onChanged: _didChangeSellingPricePercentage,
              suffixIcon: const Tooltip(
                message: '-1 means use zone setting',
                child: Icon(Icons.info_outline),
              ),
              textFormatting: TextFormatting.DECIMALS
            ),
            StyledTextField.get(
              width: 150,
              labelText: "Quantity %",
              controller: _itemQuantityPercentageController,
              suffixIcon: const Tooltip(
                message: "It's applicable when is an item that has quantity (like gas can), it means the amount of the item. -1 defaults to 100%",
                child: Icon(Icons.info_outline),
              ),
              textFormatting: TextFormatting.INTEGERS,
              onChanged: _didChangeQuantityPercentage,
            ),
          ],
        ),
        SizedBox(
          width: _getManagingWidth(),
          height: 10,
          child: const Divider(),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            MarketItemsSpawnsList(_selectedItem, widget._changesController),
            const SizedBox(
              height: 100,
              width: 250,
              child: VerticalDivider(),
            ),

            MarketItemsVariantsList(_selectedItem, widget._changesController),
          ],
        )
      ],
    );
  }

  double _getListHeight() {
    var calculatedHeight = MediaQuery.of(context).size.height - 401;
    if (calculatedHeight < 0) calculatedHeight = 0;
    return calculatedHeight;
  }

  double _getManagingWidth() {
    var calculatedHeight = MediaQuery.of(context).size.width * 0.45;
    if (calculatedHeight < 0) calculatedHeight = 0;
    return calculatedHeight;
  }

  double _getListDividerHeight() {
    var calculatedHeight = MediaQuery.of(context).size.height - 271;
    if (calculatedHeight < 0) calculatedHeight = 0;
    return calculatedHeight;
  }

  ProfilesMarketItem _genNewDefaultWithClassname(String classname) {
    return ProfilesMarketItem(classname, 2, 1, -1, 100, 1, -1, [], []);
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

  void _didChangeFilterText(String newFilterText) {
    _filteredItems = [];

    widget._category?.Items.forEach((item) {
      if (newFilterText.isEmpty || item.ClassName.toLowerCase().contains(newFilterText.toLowerCase())) _filteredItems?.add(item);
    });

    setState(() {});
  }

  // Item
  void _didTapOnItem(int index) {
    _selectedItemIndex = index;
    _selectedItem = _filteredItems[index];

    // TFControllers
    _itemMinStockController.text = _selectedItem?.MinStockThreshold.toString() ?? "1";
    _itemMaxStockController.text = _selectedItem?.MaxStockThreshold.toString() ?? "1";
    _itemMinPriceController.text = _selectedItem?.MinPriceThreshold.toString() ?? "1";
    _itemMaxPriceController.text = _selectedItem?.MaxPriceThreshold.toString() ?? "1";
    _itemSellingPricePercentageController.text = _selectedItem?.SellPricePercent.toString() ?? "1";
    _itemQuantityPercentageController.text = _selectedItem?.QuantityPercent.toString() ?? "1";

    setState(() {});
  }

  void _didTapRemove() {
    if (_selectedItemIndex == null) {
      DialogUtils.showTextDialog(context, "No item selected. Not possible to remove", _getNotPossibleToRemoveActions());
      return;
    }

    widget._category?.Items.removeAt(_selectedItemIndex!);
    _selectedItemIndex = null;
    _selectedItem = null;
    _searchController.text = "";
    _didChangeFilterText("");
    widget._changesController.changed();
  }

  void _didTapAdd() {
    DialogUtils.showInputTextDialog(context, "Add new item", "Item Classname").then((typedClassname) {
      if (typedClassname != null) {
        setState(() {
          _selectedItemIndex = null;
          _selectedItem = null;
          widget._category?.Items.add(_genNewDefaultWithClassname(typedClassname));
          _searchController.text = "";
          _didChangeFilterText("");
          widget._changesController?.changed();
        });
      }
    });
  }

  void _didChangeMinStockThreshold(String newValue) {
    setState(() {
      try {
        widget._changesController.changed();
        _selectedItem?.MinStockThreshold = int.parse(newValue);
      } catch(error) {
        debugPrint("Error parsing int: $newValue");
      }
    });
  }

  void _didChangeMaxStockThreshold(String newValue) {
    setState(() {
      try {
        widget._changesController.changed();
        _selectedItem?.MaxStockThreshold = int.parse(newValue);
      } catch(error) {
        debugPrint("Error parsing int: $newValue");
      }
    });
  }

  void _didChangeMinPrice(String newValue) {
    setState(() {
      try {
        widget._changesController.changed();
        _selectedItem?.MinPriceThreshold = int.parse(newValue);
      } catch(error) {
        debugPrint("Error parsing int: $newValue");
      }
    });
  }

  void _didChangeMaxPrice(String newValue) {
    setState(() {
      try {
        _selectedItem?.MaxPriceThreshold = int.parse(newValue);
        widget._changesController.changed();
      } catch(error) {
        debugPrint("Error parsing int: $newValue");
      }
    });
  }

  void _didChangeSellingPricePercentage(String newValue) {
    setState(() {
      try {
        _selectedItem?.SellPricePercent = double.parse(newValue);
        widget._changesController.changed();
      } catch (error) {
        debugPrint("Error parsing double: $newValue");
      }
    });
  }

  void _didChangeQuantityPercentage(String newValue) {
    setState(() {
      try {
        _selectedItem?.QuantityPercent = int.parse(newValue);
        widget._changesController.changed();
      } catch (error) {
        debugPrint("Error parsing int: $newValue");
      }
    });
  }

}