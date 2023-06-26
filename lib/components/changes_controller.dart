import 'package:flutter/material.dart';

class ChangesController extends StatefulWidget {
  const ChangesController({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ChangesControllerState();
  }

}

class _ChangesControllerState extends State<ChangesController> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        OutlinedButton(onPressed: () => {}, child: const Icon(Icons.category)),
      ]
    );
  }

}