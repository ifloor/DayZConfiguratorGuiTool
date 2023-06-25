import 'package:dayz_configurator_gui_tool/components/menu/menu_children_interfaces.dart';
import 'package:flutter/cupertino.dart';

class HomeScreen extends StatelessWidget implements ChildrenMenuWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Welcome to this tool")
    );
  }

  @override
  Future<bool> isChildrenReadyToLeave() {
    return Future.value(true);
  }

}