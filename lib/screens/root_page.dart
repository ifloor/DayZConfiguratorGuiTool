import 'dart:ffi';

import 'package:dayz_configurator_gui_tool/components/menu/lateral_menu.dart';
import 'package:dayz_configurator_gui_tool/components/menu/menu_children_interfaces.dart';
import 'package:dayz_configurator_gui_tool/components/styled_text.dart';
import 'package:dayz_configurator_gui_tool/defines/style_colors.dart';
import 'package:dayz_configurator_gui_tool/screens/children/expansion_market_screen.dart';
import 'package:dayz_configurator_gui_tool/screens/children/home_screen.dart';
import 'package:dayz_configurator_gui_tool/services/project_selection.dart';
import 'package:dayz_configurator_gui_tool/utils/folder_selection.dart';
import 'package:flutter/material.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  final GlobalKey<SideMenuState> _sideMenuKey = GlobalKey<SideMenuState>();

  int _currentScreenIndex = 0;
  ChildrenMenuWidget _currentScreen = const HomeScreen();
  String _currentScreenName = "Home";
  final List<String> _screenNames = [
    "Home",
    "Expansion Market"
  ];

  @override
  Widget build(BuildContext context) {
    return SideMenu(
      closeIcon: null,
      key: _sideMenuKey,
      menu: _buildMenus(),
      type: SideMenuType.slide,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: StyleColors.primary,
          title: Row(children: [
            SizedBox(
              width: 48,
              child: RawMaterialButton(
                onPressed: () async {
                  await ProjectSelection.select();
                  setState(() {});
                },
                shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(3))),
                fillColor: StyleColors.primaryText,
                child: const Icon(Icons.folder, color: StyleColors.primary),
              ),
            ),
            const SizedBox(width: 16),
            StyledText(
              FolderSelection.getInstance().selectedFolder ?? "?",
            ),
          ]),
          leading: IconButton(
            icon: const Icon(Icons.menu),
            color: StyleColors.primaryText,
            onPressed: FolderSelection.getInstance().selectedFolder == null ? null : () => _toggleMenu(),
          ),
          actions: [
            StyledText(_currentScreenName),
            const SizedBox(width: 16),
          ],
        ),
        body: IgnorePointer(
          ignoring: _sideMenuKey.currentState?.isOpened ?? false,
          child: _currentScreen
        ),
      ),
    );
  }

  void _toggleMenu() {
    final state = _sideMenuKey.currentState!;
    if (state.isOpened) {
      state.closeSideMenu();
    } else {
      state.openSideMenu();
    }

    setState(() {});
  }

  Widget _buildMenus() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 50.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            onTap: () => _tappedOnMenu(0),
            title: const Text("Home"),
            textColor: Colors.white,
            dense: true,
          ),
          ListTile(
            onTap: () => _tappedOnMenu(1),
            title: const Text("Expansion Market"),
            textColor: Colors.white,
            dense: true,
          ),
        ],
      ),
    );
  }


  ChildrenMenuWidget _getScreen(int screenIndex) {
    switch (screenIndex) {
      case 1:
        return ExpansionMarketScreen();

      case 0:
      default:
        return const HomeScreen();
    }
  }

  // actions
  void _tappedOnMenu(int menuNumber) {
    if (_currentScreenIndex == menuNumber) {
      _toggleMenu();
      return;
    }

    _currentScreen.isChildrenReadyToLeave().then((isReady) {
      debugPrint("Is ready? : $isReady");
      if (isReady) {

        setState(() {
          _currentScreenIndex = menuNumber;
          _currentScreen = _getScreen(_currentScreenIndex);
          _currentScreenName = _screenNames[_currentScreenIndex];
        });

        _toggleMenu();
      } else {
        _toggleMenu();
      }
    });
  }

}
