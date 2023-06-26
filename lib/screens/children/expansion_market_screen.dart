import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:dayz_configurator_gui_tool/components/menu/menu_children_interfaces.dart';
import 'package:dayz_configurator_gui_tool/dataholders/expansion_market_data_holder.dart';
import 'package:dayz_configurator_gui_tool/screens/children/markets/MarketCategoriesScreen.dart';
import 'package:flutter/material.dart';

class ExpansionMarketScreen extends StatefulWidget implements ChildrenMenuWidget {
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
}

class _ExpansionMarketScreenState extends State<ExpansionMarketScreen> {
  ExpansionMarketDataHolder _dataHolder = ExpansionMarketDataHolder.loadFromDisk();

  late List<Widget> _childrenTabs;

  _ExpansionMarketScreenState() {
    _childrenTabs = [
      MarketCategoriesScreen(_dataHolder)
    ];
  }

  Future<bool> isChildrenReadyToLeave() {
    // TODO: implement isChildrenReadyToLeave
    return Future.value(true);
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
    return DefaultTabController(
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
    _dataHolder.marketCategoriesLoader.promiseWhenFinished().then((categories) {
      debugPrint("cats finished");
      setState(() {});
    });
  }
}