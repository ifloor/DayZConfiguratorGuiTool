import 'package:dayz_configurator_gui_tool/components/menu/menu_children_interfaces.dart';
import 'package:flutter/cupertino.dart';
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
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(onPressed: () {  },
    child: Text("data"),);
  }

  Future<bool> isChildrenReadyToLeave() {
    // TODO: implement isChildrenReadyToLeave
    return Future.value(false);
  }

}