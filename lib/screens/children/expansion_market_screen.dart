import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:dayz_configurator_gui_tool/components/changes_controller_header.dart';
import 'package:dayz_configurator_gui_tool/components/menu/menu_children_interfaces.dart';
import 'package:dayz_configurator_gui_tool/dataholders/expansion_market_data_holder.dart';
import 'package:dayz_configurator_gui_tool/interfaces/changes_controller_owner.dart';
import 'package:dayz_configurator_gui_tool/screens/children/markets/market_categories_screen.dart';
import 'package:flutter/material.dart';

class ExpansionMarketScreen extends StatefulWidget implements ChildrenMenuWidget, ChangesControllerOwner {
  ExpansionMarketScreen({super.key});

  final _ExpansionMarketScreenState _state = _ExpansionMarketScreenState();

  @override
  State<StatefulWidget> createState() {
    return _state;
  }

  @override
  Future<bool> isChildrenReadyToLeave() {
    return _state.isChildrenReadyToLeave();
  }

  @override
  Future<void> saveToDisk() {
    return _state.saveToDisk();
  }
}

class _ExpansionMarketScreenState extends State<ExpansionMarketScreen> implements ChangesControllerOwner{
  final ExpansionMarketDataHolder _dataHolder = ExpansionMarketDataHolder.loadFromDisk();

  late List<Widget> _childrenTabs;
  late final ChangesControllerHeader _changesControllerHeader;

  _ExpansionMarketScreenState() {
    _changesControllerHeader = ChangesControllerHeader(this);
    _childrenTabs = [
      MarketCategoriesScreen(_dataHolder, _changesControllerHeader)
    ];
  }

  Future<bool> isChildrenReadyToLeave() {
    // TODO: implement isChildrenReadyToLeave
    return Future.value(true);
  }

  @override
  Future<void> saveToDisk() {
    return _dataHolder.saveToDisk();
  }

  @override
  Widget build(BuildContext context) {
    if (_dataHolder.categories != null) {
      return _getBodyWhenLoaded();
    } else {
      _watchCategoriesLoading();
      return _getBodyNotLoadedYet();
    }
  }

  Widget _getBodyWhenLoaded() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(child: _changesControllerHeader),
        const Divider(height: 1),
        SizedBox(
          height: MediaQuery.of(context).size.height - 105,
          child: DefaultTabController(
            length: _childrenTabs.length,
            child: Column(
              children: <Widget>[
                ButtonsTabBar(
                  backgroundColor: Colors.red,
                  tabs: _getTabs(),
                ),
                Expanded(
                  child: TabBarView(
                    children: _childrenTabs,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _getBodyNotLoadedYet() {
    return const Text("Loading");
  }

  List<Widget> _getTabs() {
    return [
      const Tab(
        icon: Icon(Icons.category),
        text: "Categories",
      ),
    ];
  }


  // Actions
  void _watchCategoriesLoading() {
    debugPrint("Watching");
    // if(_dataHolder.marketCategoriesLoader)
    _dataHolder.promiseWhenFinishedLoading().then((categories) {
      debugPrint("cats finished");
      setState(() {});
    });
  }
}