import 'package:dayz_configurator_gui_tool/components/autocomplete/styled_autocomplete.dart';
import 'package:dayz_configurator_gui_tool/components/changes_controller_header.dart';
import 'package:dayz_configurator_gui_tool/components/inputtext/styled_text_field.dart';
import 'package:dayz_configurator_gui_tool/dataholders/expansion_market_data_holder.dart';
import 'package:dayz_configurator_gui_tool/expansion/expansion_defines.dart';
import 'package:dayz_configurator_gui_tool/interfaces/changes_controller.dart';
import 'package:dayz_configurator_gui_tool/serialization/models/market/profiles_market.dart';
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
  ProfilesMarket? categorySelected;
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
    if (categorySelected == null) return const SizedBox(height: 1);

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            StyledTextField.get(
              width: MediaQuery.of(context).size.width * 0.15,
              labelText: "File on disk",
              controller: TextEditingController(text: categorySelected!.diskFilename),
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
              initialValue: categorySelected!.Icon,
              options: ExpansionDefines.availableIconNames,
              onSelected: _didChangeCategoryIcon
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
    categorySelected = _filteredCategories[index];
    // TFControllers
    //   _categoryDiskFilenameController.text = categorySelected!.diskFilename;
      _categoryDisplayNameController.text = categorySelected!.DisplayName;
    //
    setState(() {});
  }

  void _didChangeCategoryDisplayName(String newName) {
    categorySelected?.DisplayName = newName;
    _changesController.changed();
    setState(() {});
  }

  void _didChangeCategoryIcon(String newIcon) {
    categorySelected?.Icon = newIcon;
    _changesController.changed();
    setState(() {});
  }
}
