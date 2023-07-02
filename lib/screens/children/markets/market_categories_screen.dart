import 'package:dayz_configurator_gui_tool/components/autocomplete/styled_autocomplete.dart';
import 'package:dayz_configurator_gui_tool/components/bordering/labeled_container.dart';
import 'package:dayz_configurator_gui_tool/components/changes_controller_header.dart';
import 'package:dayz_configurator_gui_tool/components/inputtext/styled_text_field.dart';
import 'package:dayz_configurator_gui_tool/dataholders/expansion_market_data_holder.dart';
import 'package:dayz_configurator_gui_tool/expansion/expansion_defines.dart';
import 'package:dayz_configurator_gui_tool/interfaces/changes_controller.dart';
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
    return _MarketCategoriesScreenState(_dataHolder, _changesController);
  }

}

class _MarketCategoriesScreenState extends State<MarketCategoriesScreen> {
  final ExpansionMarketDataHolder _dataHolder;
  final ChangesController _changesController;

  bool firstLoaded = false;
  int categorySelectedIndex = -1;
  ProfilesMarket? _categorySelected;
  List<ProfilesMarket> _filteredCategories = [];

  final _categoryDisplayNameController = TextEditingController();


  _MarketCategoriesScreenState(this._dataHolder, this._changesController);

  @override
  Widget build(BuildContext context) {
    if (! firstLoaded) {
      firstLoaded = true;
      _dataHolder.promiseWhenFinishedLoading().then((_) {
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
          _buildCategoriesList(),
          const VerticalDivider(),
          _buildCategoryManagingContainer(),
        ]);
  }

  Widget _buildCategoriesList() {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.25,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SearchBar(
              leading: const Icon(Icons.search),
              onChanged: (value) => _didChangeCategoriesSearchText(value),
            ),
            const Spacer(),
            const Divider(),
            SizedBox(
              height: MediaQuery.of(context).size.height - 223,
                child: ListView.separated(
                  separatorBuilder: (BuildContext context, int index) => const Divider(),
                  scrollDirection: Axis.vertical,
                  itemCount: _filteredCategories.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      enableFeedback: true,
                      selectedTileColor: Colors.black12,
                      selected: categorySelectedIndex == index,
                      title: Text(_filteredCategories[index].DisplayName ?? ""),
                      dense: true,
                      onTap: () => {_didTapOnCategory(index)},
                    );
                  })),
          ],
        )
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
              width: MediaQuery.of(context).size.width * 0.15,
              labelText: "File on disk",
              controller: TextEditingController(text: _categorySelected!.diskFilename),
              readOnly: true,
            ),
            StyledTextField.get(
              width: MediaQuery.of(context).size.width * 0.25,
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
              width: 500,
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
              /*child: OutlinedButton(
                onPressed: () {},
                
                style: ButtonStyle(

                  minimumSize: MaterialStateProperty.all(const Size(50,20)),
                  maximumSize: MaterialStateProperty.all(const Size(50,20)),
                  backgroundColor: MaterialStateProperty.all(HexColor.fromHex(_categorySelected!.Color)),
                ),
                child: const Text(""),
              ),*/
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
        )
      ],
    );
  }

  // Category
  void _didChangeCategoriesSearchText(String newFilterText) {
    _filteredCategories = [];

    _dataHolder.categories?.forEach((category) {
      if (newFilterText.isEmpty || category.DisplayName.toLowerCase().contains(newFilterText.toLowerCase())) _filteredCategories.add(category);
    });

    setState(() {});
  }

  void _didTapOnCategory(int index) {
    debugPrint("index: $index");
    categorySelectedIndex = index;
    _categorySelected = _filteredCategories[index];
    // TFControllers
    //   _categoryDiskFilenameController.text = categorySelected!.diskFilename;
      _categoryDisplayNameController.text = _categorySelected!.DisplayName;
    //
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
      _changesController.changed();
    });
  }

  void _didChangeCategoryIcon(String newIcon) {
    setState(() {
      _categorySelected?.Icon = newIcon;
      _changesController.changed();
    });
  }

  void _didChangeCategoryInitStockPercent(double newValue) {
    setState(() {
      _changesController.changed();
      _categorySelected?.InitStockPercent = newValue;
    });
  }

  void _didChangeCategoryIsExchange(bool? newValue) {
    setState(() {
      _changesController.changed();
      _categorySelected?.IsExchange = (newValue ?? false) ? 1 : 0;
    });
  }

  void _didChangeCategoryColor(Color newColor) {
    setState(() {
      _changesController.changed();
      _categorySelected?.Color = newColor.toHex(leadingHashSign: false);
    });
  }
}
