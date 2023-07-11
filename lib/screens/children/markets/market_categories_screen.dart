import 'package:dayz_configurator_gui_tool/components/autocomplete/styled_autocomplete.dart';
import 'package:dayz_configurator_gui_tool/components/bordering/labeled_container.dart';
import 'package:dayz_configurator_gui_tool/components/button/styled_button.dart';
import 'package:dayz_configurator_gui_tool/components/inputtext/styled_text_field.dart';
import 'package:dayz_configurator_gui_tool/dataholders/expansion_market_data_holder.dart';
import 'package:dayz_configurator_gui_tool/expansion/expansion_defines.dart';
import 'package:dayz_configurator_gui_tool/interfaces/changes_controller.dart';
import 'package:dayz_configurator_gui_tool/screens/children/markets/market_category_items_screen.dart';
import 'package:dayz_configurator_gui_tool/serialization/models/market/profiles_market.dart';
import 'package:dayz_configurator_gui_tool/utils/dialog_utils.dart';
import 'package:dayz_configurator_gui_tool/utils/extensions/hex_color.dart';
import 'package:flutter/material.dart';

class MarketCategoriesScreen extends StatefulWidget {
  final ExpansionMarketDataHolder _dataHolder;
  final ChangesController _changesController;


  const MarketCategoriesScreen(this._dataHolder, this._changesController, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _MarketCategoriesScreenState();
  }

}

class _MarketCategoriesScreenState extends State<MarketCategoriesScreen> {
  MarketCategoryItemsScreen? _itemsScreen;

  bool _firstLoaded = false;
  int? _categorySelectedIndex;
  ProfilesMarket? _categorySelected;
  List<ProfilesMarket> _filteredCategories = [];


  final _searchController = TextEditingController();

  final _categoryDisplayNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (! _firstLoaded) {
      _firstLoaded = true;
      widget._dataHolder.promiseWhenFinishedLoading().then((_) {
        debugPrint("Loaded");
        _didChangeCategoriesSearchText("");
        setState(() {});
      });
    }

    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      verticalDirection: VerticalDirection.up,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.25,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SearchBar(
                leading: const Icon(Icons.search),
                hintText: "Filter categories",
                controller: _searchController,
                onChanged: (value) => _didChangeCategoriesSearchText(value),
              ),
              const Divider(),
              _buildCategoriesList(),
              const Divider(),
              _buildCategoriesActions(),
            ],
          )
        ),
        const VerticalDivider(),
        _buildCategoryManagingContainer(),
      ]);
  }

  Widget _buildCategoriesList() {
    return SizedBox(
      height: _getListHeight(),
      child: ListView.separated(
        separatorBuilder: (BuildContext context, int index) =>
          const Divider(),
        scrollDirection: Axis.vertical,
        itemCount: _filteredCategories.length,
        itemBuilder: (context, index) {
          return ListTile(
            enableFeedback: true,
            selectedTileColor: Colors.black12,
            selected: _categorySelectedIndex == index,
            title: Text(_filteredCategories[index].diskFilename.replaceAll(".json", "")),
            dense: true,
            onTap: () => {_didTapOnCategory(index)},
          );
        }),
    );
  }

  Widget _buildCategoriesActions() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StyledButton.get(
          onPressed: _didTapAdd,
          child: const Icon(Icons.add),
        ),
        const SizedBox(width: 2),
        StyledButton.get(
          onPressed: _didTapRemove,
          child: const Icon(Icons.delete),
        )
      ],
    );
  }

  Widget _buildCategoryManagingContainer() {
    if (_categorySelected == null) return const SizedBox(height: 1);
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StyledTextField.get(
              width: MediaQuery.of(context).size.width * 0.20,
              labelText: "File on disk",
              controller: TextEditingController(text: _categorySelected!.diskFilename),
              readOnly: true,
            ),
            StyledTextField.get(
              width: MediaQuery.of(context).size.width * 0.30,
              labelText: "Display name",
              controller: _categoryDisplayNameController,
              onChanged: _didChangeCategoryDisplayName,
            ),
            StyledAutoComplete.get(
              width: 200,
              labelText: "Category icon",
              initialValue: _categorySelected!.Icon,
              options: ExpansionDefines.availableIconNames,
              onSelected: _didChangeCategoryIcon,
              onChanged: _didChangeCategoryIcon
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            LabeledContainer(
              label: "Initial stock %",
              width: MediaQuery.of(context).size.width * 0.521,
              height: 40,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Slider(
                      value: _categorySelected?.InitStockPercent ?? 0,
                      max: 100,
                      divisions: 100,
                      label: "${_categorySelected?.InitStockPercent.round().toString()}",
                      onChanged: _didChangeCategoryInitStockPercent,
                    )
                  ),
                  Text("${_categorySelected?.InitStockPercent.round().toString()}%"),
                ],
              )
            ),
            LabeledContainer(
                label: "Is exchange?",
                width: 100,
                height: 40,
              child: Checkbox(
                value: _categorySelected?.IsExchange == 1 ? true : false,
                onChanged: _didChangeCategoryIsExchange,
              ),
            ),
            LabeledContainer(
              label: "Color",
              width: 57,
              height: 40,
              child: InkWell(
                onTap: _didTapCategoryColor,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: HexColor.fromHex(_categorySelected?.Color ?? "FBFCFEFF"),
                  ),
                  child: const Text(""),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: const Divider(),
        ),
        _itemsScreen ?? const Text("Not loaded yet"),
      ],
    );
  }

  ProfilesMarket _genNewDefaultWithFilename(String filename) {
    var version = 1;
    var categories = widget._dataHolder.categories ?? [];
    if (categories.isNotEmpty) version = categories.first.m_Version;


    var newMarket = ProfilesMarket(
      version,
      filename.replaceAll(".json", ""),
      ExpansionDefines.availableIconNames.first,
      ExpansionDefines.defaultMarketMenuColor.toHex(leadingHashSign: false),
      0,
      75,
      []
    );
    newMarket.diskFilename = filename;

    return newMarket;
  }

  double _getListHeight() {
    var calculatedHeight = (MediaQuery.of(context).size.height - 279);
    if (calculatedHeight < 0) calculatedHeight = 0;
    return calculatedHeight;
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

  void _didTapRemove() {
    if (_categorySelectedIndex == null) {
      DialogUtils.showTextDialog(context, "No category selected. Not possible to remove", _getNotPossibleToRemoveActions());
      return;
    }

    widget._dataHolder.tagToDeletion(_categorySelected!);
    widget._dataHolder.categories?.removeAt(_categorySelectedIndex!);
    _categorySelectedIndex = null;
    _categorySelected = null;
    _searchController.text = "";
    _didChangeCategoriesSearchText("");
    widget._changesController.changed();
  }

  void _didTapAdd() {
    DialogUtils.showInputTextDialog(context, "Add new category", "file name: (something.json)").then((typedFilename) {
      if (typedFilename != null && typedFilename.trim().isNotEmpty) {
        setState(() {
          _categorySelectedIndex = null;
          _categorySelected = null;
          widget._dataHolder.categories?.add(_genNewDefaultWithFilename(typedFilename));
          _searchController.text = "";
          _didChangeCategoriesSearchText("");
          widget._changesController.changed();
        });
      }
    });
  }

  // Category
  void _didChangeCategoriesSearchText(String newFilterText) {
    _filteredCategories = [];

    widget._dataHolder.categories?.forEach((category) {
      if (newFilterText.isEmpty || category.DisplayName.toLowerCase().contains(newFilterText.toLowerCase())) _filteredCategories.add(category);
    });

    _categorySelectedIndex = null;
    _categorySelected = null;
    setState(() {});
  }

  void _didTapOnCategory(int index) {
    _categorySelectedIndex = index;
    _categorySelected = _filteredCategories[index];
    // TFControllers
      _categoryDisplayNameController.text = _categorySelected!.DisplayName;
    //
    // Children
    _itemsScreen = MarketCategoryItemsScreen(_categorySelected, widget._changesController);

    setState(() {});
  }

  void _didTapCategoryColor() {
    var currentColor = HexColor.fromHex(_categorySelected?.Color ?? "00000000");
    DialogUtils.showColorPickerDialog(context, currentColor).then((newColor) {
      if (newColor != null) _didChangeCategoryColor(newColor);
    });
  }

  void _didChangeCategoryDisplayName(String newName) {
    setState(() {
      _categorySelected?.DisplayName = newName;
      widget._changesController.changed();
    });
  }

  void _didChangeCategoryIcon(String newIcon) {
    setState(() {
      _categorySelected?.Icon = newIcon;
      widget._changesController.changed();
    });
  }

  void _didChangeCategoryInitStockPercent(double newValue) {
    setState(() {
      widget._changesController.changed();
      _categorySelected?.InitStockPercent = newValue;
    });
  }

  void _didChangeCategoryIsExchange(bool? newValue) {
    setState(() {
      widget._changesController.changed();
      _categorySelected?.IsExchange = (newValue ?? false) ? 1 : 0;
    });
  }

  void _didChangeCategoryColor(Color newColor) {
    setState(() {
      widget._changesController.changed();
      _categorySelected?.Color = newColor.toHex(leadingHashSign: false);
    });
  }
}
