import 'package:dayz_configurator_gui_tool/screens/root_page.dart';
import 'package:dayz_configurator_gui_tool/utils/shared_prefferences_utils.dart';
import 'package:flutter/material.dart';

void main() {
  SharedPreferencesUtils.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "DayZ configurator GUI tool",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const RootPage(),
    );
  }
}